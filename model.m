clear all
close all
clc
%% Parameters
mc = 0.5;
mp = 0.2;
b = 0.1;
d_cart = 1; %friction coefficient cart-track
d_pend = 1; %friction coefficient pend-cart
I = 0.006;
g = 9.8;
L = 0.3;
h = 0.01;

%%
lin_pend = lin_pend_dynamics(mc,mp,g,L,h,d_cart,d_pend);
tspan = 0:0.1:10;

x0 = [0.5;0;0.5;0];
eigs = 2*[-1.1,-1.2,-1.3,-1.4];
K = place(lin_pend.A,lin_pend.B,eigs);

CL_lin_pend = ss(lin_pend.A-lin_pend.B*K,[0;0;0;0],lin_pend.C,lin_pend.D);

Y = lsim(CL_lin_pend,zeros(length(tspan),1),tspan,x0);


for k = 1:length(Y)
    pendulum_draw(Y(k,:),mc,mp,L);
    if k==1
        pause(1)
    else
        pause(h)
    end
    drawnow 
end

%% Using K for non linear function, position to 
x0 = [0;0;0.5;0];
[tout,yout] = ode45(@(t,y)nl_pend_dynamics(y,mc,mp,g,L,0,d_cart,d_pend),tspan,x0);
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
load('run_11.mat','simout')
id_pend = sys_id(simout,h);

eigs = 5*[-1.1,-1.2,-1.3,-1.4];

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