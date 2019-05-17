%clear all 
close all
clc

%% Parameters
mc = 0.49;
mp = 0.085;
b = 0.1;
L = 0.3;
I = 1/3*mp*L^2;
g = 9.81;
h = 0.01;

%% Initialize x
T_final = 1;
% d_pend = 1;
% d_cart = 1;
% Km = 1;
% Pc = 0;
mtr_threshold = 0.15;

u_time = linspace(0,h,2);
u_out = 0.*u_time;
x_init = zeros(4,1);

sim('pendtemplate')
T_final = 30;

x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
u_time = 0:h:T_final;
% u_out = 0.4*sin(u_time);
u_out = 0.4*sin(0.1*u_time.^2);
% u_out = 0.01*u_time;

sim('pendtemplate')
save('runs/last_run')
% clear d_pend d_cart Km u_time
%%
[X,RESNORM,RESIDUAL,flag] = lsqnonlin(@(x)cart_par(x,mc,h),[10;10;0],[0;0;0],[]);
d_cart = X(1);
Km = X(2);
Pc = X(3);

[~, y,out] = cart_par(X,mc,h);
plot(y(1,:))
hold on
plot(out.pos)
legend('Estimated','Measured')
hold off
%%
X = lsqnonlin(@(x)pend_par(x,mp,mc,Km,L,d_cart,g,h),1,0,[]);
d_pend = X(1);
% angvel_factor = X(2);
%%
[~, y,angle] = pend_par(X,mp,mc,Km,L,d_cart,g,h);
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
