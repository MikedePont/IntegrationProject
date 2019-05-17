function [dy, sys] = nl_pend_dynamics2(mc,mp,g,L,d_cart,d_pend,Km)
syms y1 y2 y3 y4 u

h = 0.01;

dy(1,1) = y2;
dy(2,1) = (-mp*g*sin(y3)*cos(y3) + mp*L*y4^2*sin(y3) + d_pend*mp*y4*cos(y3) + Km*u - d_cart*y2)/(mc + sin(y3)^2*mp);
dy(3,1) = y4;
dy(4,1) = (((mc+mp)*(g*sin(y3)-d_pend*y4))-(L*mp*y4^2*sin(y3)+ Km*u)*cos(y3))/(L*(mc+sin(y3)^2*mp));

V = [y1,y2,y3,y4];
U = u;

A = double(subs(jacobian(dy,V),[U,V],zeros(1,5)));
B = double(subs(jacobian(dy,U),[U,V],zeros(1,5)));
C = [1,0,0,0;0,0,1,0];
D = 0;

sys = ss(A,B,C,D,h);
% sys_nl = c2d(sys,h);