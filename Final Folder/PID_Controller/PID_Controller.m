%% PID Controller 

clear 
close all
clc
warning off

load('../Parameter_Estimation/Parameter_est_brown_rod')
open('pend_PID')

%%
PID_Pos.P = 13; %13
PID_Pos.I = 0.75; %0.75
PID_Pos.D = 0.8;%0.8

PID_Ang.P = 30; %30
PID_Ang.I = 0; %0
PID_Ang.D = 0.015; %0.015


%%


T_final = 0.1;
x_init = zeros(4,1);
option = 0;
kalman.R = 0.01;
kalman.Q = 100;
sim('pend_PID')


T_final = 30;
x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
option = 1;
sim('pend_PID')

%%
ref_pos = reference.data;
pos = states.data(:,1);
ref_angle = zeros(size(ref_pos,1),1);
angle = states.data(:,3);

RMSE.pos = rmse(pos, ref_pos);
RMSE.angle = rmse(angle, ref_angle);
disp(RMSE)

