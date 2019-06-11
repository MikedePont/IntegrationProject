function [dsys,sys] = linmod(mc,mp,Km,d_cart,d_pend,g,l,h)
syms y1 y2 y3 y4 u
% 
% dy(1,1) = y2;
% dy(2,1) = (7/((mc+mp)*(7-3*mp)))*(Km*u-d_cart*y2 + 3*g*mp*y3/7 - 6*d_pend*y4/7*l + mp*l*y4^2*y3/2);
% dy(3,1) = y4;
% dy(4,1) = (1/(7/3*mp*l^2))*(l*mp*dy(2,1)/2 + l*y3*mp*g/2 - d_pend*y4);

dy(1,1) = y2;
dy(2,1) = (1/((mc+mp)*(1-0.75*mp)))*((Km*u-d_cart*y2 + 3/(2*l)*((l/2)*mp*g*y3) - d_pend*y4) + mp*l*y4^2*y3/2);
dy(3,1) = y4;
dy(4,1) = (3/(mp*l^2))*(l*mp*dy(2,1)/2 + l*y3*mp*g/2 - d_pend*y4);

Y = [y1, y2, y3, y4];
U = u;

A = double(subs(jacobian(dy,Y),[U,Y],zeros(1,5)));
B = double(subs(jacobian(dy,U),[U,Y],zeros(1,5)));
% C = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
C = [1,0,0,0;0,0,1,0];
D = 0;

sys = ss(A,B,C,D);
dsys = c2d(sys,h,'zoh');