% clear all 
close all
clc

parameters
%% Initialize x
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

sim('pendtemplate')
T_final = 30;

x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
u_time = 0:h:T_final;
% u_out = 0.4*sin(2*u_time);
u_out = 0.5*sin(u_time.^2);%+0.05*sin(0.5*u_time);
amp_out = 0.5;
% u_out = 0.01*u_time;

sim('pendtemplate')
save('runs/last_run')

%%
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
%%
X_2 = lsqnonlin(@(x)pend_par(x,mc,Km,d_cart,g,h,l),[0.01;0.085],[0;0.075],[5;0.1]);
d_pend = X_2(1);
mp = X_2(2);

[~, y,angle] = pend_par(X_2,mc,Km,d_cart,g,h,l);
plot(y(3,:))
hold on
plot(angle)
legend('Estimated','Measured')
hold off

%%
T_final = 1;

u_time = linspace(0,h,2);
u_out = 0.*u_time;
amp_out = 0;
x_init = zeros(4,1);

sim('pendtemplate')

T_final = 30;

x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
u_time = 0:h:T_final;
% u_out = 0.4*sin(2*u_time);
u_out = 0.5*sin(u_time.^2);%+0.05*sin(0.5*u_time);
amp_out = 0.5;
% u_out = 0.01*u_time;

sim('pendtemplate')
save('runs/last_run')
%%
[dsys,sys] = nl_pend_dynamics(mc,mp,g,l,d_cart,d_pend,Km,h);

%%

Q = 0.00001*eye(4);
 Q(1,1) = 100;
% Q(1,1) = 100;
%  Q(3,3) = 100;
R = 1;
[K,S,E] = dlqr(dsys.A,dsys.B,Q,R,[]);


%%
T_final = 1;

u_time = linspace(0,h,2);
u_out = 0.*u_time;
amp_out = 0;
x_init = zeros(4,1);
kalman.R = 10;
kalman.Q = 0.001;
option = 0;
sim('pendtemplate')


x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
T_final = 40;
option=1;
sim('pendtemplate')


%%
X_2 = lsqnonlin(@(x)pend_par(x,mc,Km,d_cart,g,h),[0;0.085;0.6],[0;0.075;0.5],[5;0.1;0.7]);
d_pend = X_2(1);
mp = X_2(2);
l = X_2(3);

[~, y,angle] = pend_par(X_2,mc,Km,d_cart,g,h);
plot(y(3,:))
hold on
plot(angle)
legend('Estimated','Measured')
hold off

%%
x0 = x_init;
tspan = 0:h:30;
[tout,yout] = ode45(@(t,y)nl_pend_dynamics(y,mc,mp,g,L,0,d_cart,d_pend,Km),tspan,x0);
for z = 1:length(yout)
    pendulum_draw(yout(z,[1,3]),mc,mp,L)
    if z==1
        pause(1)
    else
        pause(h)
    end
    drawnow
end
