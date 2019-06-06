%% MAIN for initializing and control with an LQR controller

close all
clc
warning off

parameters
%% Initialize cart
T_final = 1;

d_pend = 0.01;
d_cart = 1;
Km = 1;
ub_mtr_threshold = 0.16;
lb_mtr_threshold = 0.02;

u_time = linspace(0,h,2);
u_out = 0.*u_time;
amp_out = 0;
x_init = zeros(4,1);

sim('pend_init_cart')
T_final = 30;

x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
u_time = 0:h:T_final;
% u_out = 0.4*sin(2*u_time);
u_out = 0.5*sin(u_time.^2);%+0.05*sin(0.5*u_time);
amp_out = 0.5;
% u_out = 0.01*u_time;

sim('pend_init_cart')
save('cart_init')

%% Fit cart model
[X,RESNORM,RESIDUAL,flag] = lsqnonlin(@(x)cart_par(x,h),[10;10;0.49],[0;0;0.4],[100;100;0.55]);
d_cart = X(1);
Km = X(2);
mc = X(3);

[~, y,out] = cart_par(X,h);
plot(y(1,:))
hold on
plot(out.pos)
legend('Estimated','Measured')
hold off 


VAF.pos = VaF(out.pos(1:end-1), y(1,:)');


%% Fit (BROWN)Pendulum fall
X_2 = lsqnonlin(@(x)pend_par(x,mc,Km,d_cart,g,l),[0.01;0.085],[0;0.075],[5;0.1]);
d_pend = X_2(1);
mp = X_2(2);

[~, y,angle] = pend_par(X_2,mc,Km,d_cart,g,l);
plot(y(3,:))
hold on
plot(angle)
legend('Estimated','Measured')
hold off



%% Make state space
h = 0.001;
[dsys,sys] = nl_pend_dynamics(mc,mp,g,l,d_cart,d_pend,Km,h);

bode(sys);
nyquist(dsys);


%% Find LQR gains

Q = eye(4);
Q(1,1) = 500;
R = 1;
[K,S,E] = dlqr(dsys.A,dsys.B,Q,R,[]);

dsys_cl = ss((dsys.A - dsys.B*K), zeros(4,1), dsys.C,dsys.D); 

bode(dsys_cl);
%nyquist(dsys_cl);



%%

T_final = 0.1;
x_init = zeros(4,1);
kalman.R = 0.001;
kalman.Q = 100;
option = 0;
sim('pend_LQR')


x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
T_final = 40;
option=1;
sim('pend_LQR')
%% Find RMSE

ref_pos = reference.data;
pos = states.data(:,1);
ref_angle = zeros(size(ref_pos,1),1);
angle = states.data(:,3);

RMSE.pos = rmse(pos, ref_pos);
RMSE.angle = rmse(angle, ref_angle);
disp(RMSE)

%% 

save('last_run')
