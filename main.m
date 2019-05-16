%% 
% clear all
% close all
% clc
% 
% load run_11.mat

U = simout.data(:,1);
pos = simout.data(:,2);
theta = simout.data(:,3);

s = 7;
n = 6;

[At,Bt,Ct,Dt,x0t,S] = mysubid(Y,U,s,n)

%%
real = [0.06,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.93];
pend = [-0.573,-0.5590,-0.4870,-0.4180,-0.3530,-0.29,-0.225,-0.16,-0.094,-0.0247,-0.0037];



%%
T_final = 1;

u_time = linspace(0,1,10);
u_out = 0.*u_time;
x_init = zeros(4,1);
sim('pendtemplate')

%%
T_final = 30;

x_init = [Pos_Pendulum.data(10),0,Angle_Pendulum.data(10),0];
u_time = linspace(0,30,1000);
u_out = 0.5*sin(8*u_time);

sim('pendtemplate')
%%
save('runs/run_no_rod_1')