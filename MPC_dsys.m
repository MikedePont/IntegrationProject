function [dsys_mpc] = MPC_dsys(mc,mp,g,l,d_cart,d_pend,Km,h)
%% Mike model
syms y1 y2 y3 y4 u

dy(1,1) = y2;
dy(2,1) = 1/((mc+mp)*(1-0.75*mp))*(Km*u - d_cart*y2 + 3/(2*l)*((l/2)*mp*g*y3 - d_pend*y4) + 0*mp*l*y4^2*y3/2);
dy(3,1) = y4;
dy(4,1) = 3/(mp*l^2)*(l*mp*dy(2,1)/2 + l*mp*g*y3/2 - d_pend*y4);

Y = [y1, y2, y3, y4];
U = u;

A = double(subs(jacobian(dy,Y),[U,Y],[0, 0, zeros(1,3)]));
B = double(subs(jacobian(dy,U),[U,Y],[0, 0, zeros(1,3)]));
C = [1,0,0,0;...
     0,1,0,0;...
     0,0,1,0;...
     0,0,0,1];
D = 0;

sys = ss(A,B,C,D);

dsys_mpc = c2d(ss(A,B,C,D),h,'zoh');