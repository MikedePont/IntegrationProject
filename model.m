clear all
close all
clc
%% Parameters
mc = 0.5;
mp = 0.2;
b = 0.1;
d = 1;
I = 0.006;
g = 9.8;
L = 0.3;
h = 0.01;

%%
sys = pend_dynamics(mc,mp,g,L,h);
tspan = 0:0.1:10;

x0 = [0.5;0;0.5;0];
eigs = 2*[-1.1,-1.2,-1.3,-1.4];
K = place(sys.A,sys.B,eigs);

newsys = ss(sys.A-sys.B*K,[0;0;0;0],sys.C,sys.D);

Y = lsim(newsys,zeros(length(tspan),1),tspan,x0);

%%
for k = 1:length(Y)
    pendulum_draw(Y(k,:),mc,mp,L);
    if k==1
        pause(1)
    else
        pause(h)
    end
    drawnow 
end
