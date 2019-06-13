%% LQR controller
clear 
close all
clc
warning off

cd('H:\My Documents\Integration Project\Final Folder\LQR_Controller')
load('../Parameter_Estimation/Parameter_est_brown_rod_7')
open('pend_LQR')
%% Find LQR gains

Q = 0.00001*eye(4);
Q(1,1) = 500;
R = 1;
[K,S,E] = dlqr(dsys.A,dsys.B,Q,R,[]);


dsys_cl = ss((dsys.A - dsys.B*K), zeros(4,1), dsys.C,dsys.D); 


%% Run pendulum

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

%%  Generate plots

figure(1);
plot(reference)
hold on
plot(states.time, states.data(:,1))
axis([0 40 0 1])
xlabel('time (s)')
ylabel('x position (m)')
title('Position tracking LQR controller')
legend('Reference', 'Positon cart')
hold off

figure(2);
plot(states.time, states.data(:,3))
axis([0 40 -0.3 0.3])
xlabel('time (s)')
ylabel('angle rod (rad)')
title('Angle tracking LQR controller')

figure(3);
plot(states.time, Voltage.data)
axis([0 40 -1 1])
xlabel('time (s)')
ylabel('voltage (V)')
title('Input voltage LQR controller')

figure(4);
plot(states.time, states.data)
axis([0 40 -1 1])
xlabel('time (s)')
ylabel('state values')
title('States by Kalman filter')
legend('x pos', 'xdot', 'angle', 'thetadot')

%%

save('last_run_LQR')
