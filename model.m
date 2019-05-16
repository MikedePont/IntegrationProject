%clear all 
close all
clc


%% Parameters
mc = 0.49;
mp = 0.085;
b = 0.1;
d_cart = 1; %friction coefficient cart-track
d_pend = 1; %friction coefficient pend-cart
L = 0.3;
I = 1/3*mp*L^2;
g = 9.8;
h = 0.01;
x0 = [0.5;0;-0.5;0];
Km = 1;

%%

lin_pend = lin_pend_dynamics(mc,mp,g,L,h,Km,d_cart,d_pend,vel_factor,angvel_factor);
tspan = 0:0.1:70;


eigs = 2*[-1.1,-1.2,-1.3,-1.4];
K = place(lin_pend.A,lin_pend.B,eigs);

CL_lin_pend = ss(lin_pend.A-lin_pend.B*K,[0;0;0;0],lin_pend.C,lin_pend.D);

Y = lsim(CL_lin_pend,zeros(length(tspan),1),tspan,x0);

%% Using K for non linear function, position to 
x0 = [0;0;0.5;0];
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

%% 
load('runs/run_11.mat','simout');
id_pend = sys_id(simout,h);

eigs = 2*[-1.1,-1.2,-1.3,-1.4];

K = place(id_pend.A,id_pend.B,eigs);

CL_id_pend = ss(id_pend.A-id_pend.B*K,[0;0;0;0],id_pend.C,id_pend.D);

Y = lsim(CL_id_pend,zeros(length(tspan),1),tspan,x0);

for k = 1:length(Y)
    pendulum_draw(Y(k,:),mc,mp,L);
    if k==1
        pause(1)
    else
        pause(h)
    end
    drawnow 
end

%%
[X,RESNORM,RESIDUAL,flag] = lsqnonlin(@(x)cart_par(x,mc,h),[1,1,1],[0;0;0],[]);
d_cart = X(1);
Km = X(2);
vel_factor = X(3);

[~, y,out] = cart_par(X,mc,h);
plot(y(1,:))
hold on
plot(out.pos)
legend('Estimated','Measured')
hold off
%%
X = lsqnonlin(@(x)pend_par(x,mp,mc,Km,L,d_cart,g,h),[1,1],[0;0],[]);
d_pend = X(1);
angvel_factor = X(2);
%%
[~, y,angle] = pend_par(X,mp,mc,Km,L,d_cart,g,h);
plot(y(3,:))
hold on
plot(angle)
legend('Estimated','Measured')
hold off

%%
x0 = x_init;
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
