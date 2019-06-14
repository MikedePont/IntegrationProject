[~,L]=kalman(dsys,Kkalman.Q,Kkalman.R*eye(2));
Q = 0.00001*eye(4);
Q(1,1) = 500;
R = 1;
[KK,S,E] = dlqr(dsys.A,dsys.B,Q,R,[]);

controller_LQG=ss(dsys.A-dsys.B*KK-L*dsys.C, L, -KK, zeros(1,2),h);

save controller_LQG 'controller_LQG'