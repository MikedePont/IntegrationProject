%% init
%         %clear all
close all
clc

parameters

%% Find linearized model
[dsys,sys] = linmod(mc,mp,Km,d_cart,d_pend,g,l,h);
G = sys;
%% Control loop
Q = eye(4);
Q(1,1) = 1;
Q(3,3) = 100;
R = 1;

s = tf('s');    

Ws = ss(blkdiag((0.526*s+60.8)/(s+0.00608), (0.526*s+10)/(s+0.1)));

Wu = 7;

P11 = [Ws;0,0];
P21 = eye(2);

P12 = [-Ws*G; Wu];
P22 = -G;
P = [P11,P12;P21,P22];
P_min = minreal(ss(P)); 

% [K,S,CLP] = dlqr(dsys.A,dsys.B,Q,R,[]);

[K, CL,GAM] = hinfsyn(P_min,2,1);
K_d = c2d(K,h);
%% ARX
T_final = 10;
u_time = 0:h:T_final;
w = u_time.^2+0.01;
simu = sim('model.slx');

position = simu.states(:,1);
angle = simu.states(:,3);
input = simu.input.data;

Data = iddata([position angle],simu.input.data,h);

% order = [blkdiag(4,3) 1*[1;1] 0*[1;1]];
% ARXmodel = d2c(tf(arx(Data,order)));
order = [[4;4], [4;4], [4;4]];
ARXmodel = d2c(oe(Data,order));

Y = lsim(ARXmodel,input,u_time);

figure(1)
subplot(2,1,1)
plot(Y(:,1),'b')
hold on
plot(position,'r')
legend('Estimated','Real')
title('Position')
hold off
subplot(2,1,2)
plot(Y(:,2),'b')
hold on
plot(angle,'r')
legend('Estimated','Real')
title('Angle')


%% Model predictive control
