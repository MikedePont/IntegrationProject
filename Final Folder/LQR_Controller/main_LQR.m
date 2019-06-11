%% LQR controller
clear 
close all
clc
warning off

load('../Parameter_Estimation/Parameter_est_brown_rod')
open('pend_LQR')
%% Find LQR gains

Q = 0.00001*eye(4);
Q(1,1) = 500;
R = 1;
[K,S,E] = dlqr(dsys.A,dsys.B,Q,R,[]);


dsys_cl = ss((dsys.A - dsys.B*K), zeros(4,1), dsys.C,dsys.D); 


%%

T_final = 0.1;
x_init = zeros(4,1);
kalman.R = 0.01;
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

save('last_run_LQR')
