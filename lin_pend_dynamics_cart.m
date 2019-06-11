function sys = lin_pend_dynamics_cart(Km,d_cart,mc,factor,h)
syms y1 y2 u
V = [y1,y2];
U = u;

dy(1,1) = y2;
dy(2,1) = (Km*u-d_cart*y2)/(mc) + factor;

A = double(subs(jacobian(dy,V),[U,V],zeros(1,3)));
B = double(subs(jacobian(dy,U),[U,V],zeros(1,3)));
C = [1,0;0,0];
D = 0;

sys = ss(A,B,C,D);
sys = c2d(sys,h);

load('runs/run_without_rod_offset.mat','Input_Voltage','Pos_Pendulum');

tspan = 0:0.01:70;
Y = lsim(sys,Input_Voltage.data(1:7001),tspan);

plot(Y)
figure(2)
plot(Pos_Pendulum)