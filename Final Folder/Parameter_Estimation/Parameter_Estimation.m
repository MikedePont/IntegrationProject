%% Load Parameters
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

VAF.angle = VaF(angle(1:end-1),y(3,:)');



%% Make state space
h = 0.001;
[dsys,sys] = nl_pend_dynamics(mc,mp,g,l,d_cart,d_pend,Km,h);

figure(1)
bode(sys);

figure(2)
nyquist(dsys);

