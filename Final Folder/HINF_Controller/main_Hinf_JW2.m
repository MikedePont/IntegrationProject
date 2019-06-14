%% HINF Controller

clear 
close all
clc
warning off

% cd('H:\My Documents\Integration Project\Final Folder\HINF_Controller')
load('../Parameter_Estimation/Parameter_est_brown_rod_7')
%open('pend_HINF')

%%
G = sys(1,1);
load controller_LQG
s = tf('s');    

Ws = ss(blkdiag((0.526*s+60.8)/(s+0.00608), (0.526*s+10)/(s+0.1)));
Ws = ss(blkdiag((0.526*s+60.8*0.01)/(s+0.00608*0.01)/5));
%Ws = 10*ss(blkdiag((0.5*s+6000)/(10*s+0.6), 1));

Wu = 7*tf([1],[1])/100000;

P11 = [Ws;0];
P21 = eye(1);

P12 = [-Ws*G; Wu];
P22 = -G;
P = [P11,P12;P21,P22];
P_min = minreal(ss(P)); 

% [K,S,CLP] = dlqr(dsys.A,dsys.B,Q,R,[]);

[K, CL,GAM] = hinfsyn(P_min,2,1);
%K=canon(K); K.A(3,3)=-K.A(3,3);
K_d = c2d(K,h);

%% 
figure
bodemag(inv(Ws)); hold on; bodemag(minreal(inv(eye(1)-c2d(sys,h)*c2d(K,h))))
bodemag(minreal(inv(eye(1)-c2d(sys,h)*controller_LQG)))

figure
bodemag([inv(Wu) inv(Wu)]); hold on; bodemag(minreal(c2d(K,h)*inv(eye(1)-c2d(sys,h)*c2d(K,h))))
bodemag(minreal(controller_LQG*inv(eye(1)-c2d(sys,h)*controller_LQG)))

%% 
% MAKE SURE YOU HOLD THE PENDULUM IN UPRIGHT POSITION
T_final = 0.1;
x_init = zeros(4,1);
kalman.R = 0.01;
kalman.Q = 100;
option = 0;
sim('pend_HINF')



x_init = [Pos_Pendulum.data(1),0,Angle_Pendulum.data(1),0];
T_final = 40;
option=1;
sim('pend_HINF')
%% Find RMSE

ref_pos = reference.data;
pos = states.data(:,1);
ref_angle = zeros(size(ref_pos,1),1);
angle = states.data(:,3);

RMSE.pos = rmse(pos, ref_pos);
RMSE.angle = rmse(angle, ref_angle);
disp(RMSE)

%% Generate Plots

figure(1);
plot(reference)
hold on
plot(states.time, states.data(:,1))
axis([0 40 0 1])
xlabel('time (s)')
ylabel('x position (m)')
title('Position tracking Hinf controller')
legend('Reference', 'Positon cart')
hold off

figure(2);
plot(states.time, states.data(:,3))
axis([0 40 -0.3 0.3])
xlabel('time (s)')
ylabel('angle rod (rad)')
title('Angle tracking Hinf controller')

figure(3);
plot(states.time, Voltage.data)
axis([0 40 -1 1])
xlabel('time (s)')
ylabel('voltage (V)')
title('Input voltage Hinf controller')

figure(4);
plot(states.time, states.data)
axis([0 40 -1 1])
xlabel('time (s)')
ylabel('state values')
title('States by Kalman Observer')
legend('x pos', 'xdot', 'angle', 'thetadot')


%%
save('last_run_HINF_JW')

