function [dsys,sys] = nl_pend_dynamics(mc,mp,g,l,d_cart,d_pend,Km,h)
% % Mike model
% % dy(1,1) = y2;
% % dy(2,1) = (1/(-l^2*mp^2/((mc+mp)*(4*I+l^2*mp))+1))*((1/(mc+mp))...
% %     *(Km*u-d_cart*y2+l^2*mp^2*g*y3/(4*I+l^2*mp)-l*mp*d_pend*y4/(2*I+l^2*mp/2)...
% %     +l*mp*y4^2*y3/2));
% % dy(3,1) = y4;
% % dy(4,1) = 2*l*mp/(I+l^2*mp)*(dy(2,1)+g*y3)-4*d_pend*y4/(I+l^2*mp);

% % % Daniel model
% % % % dy(1,1) = y2;
% % % % dy(2,1) = (1/(mc+mp))*(Km*u - d_cart*y2 + 0.75*mp*g*y3 + mp*l*y3)*(1-0.75*mp/(mc+mp))^-1;
% % % % dy(3,1) = y4;
% % % % dy(4,1) = (-mp*l*(dy(2,1)+g*y3) - d_pend*y4)/(4/3*mp*l^2);


%% Daneil model
% cont_y(1,1) = y2;
% cont_y(2,1) = (1/(mc+mp))*(Km*u - d_cart*y2 + 0.75*mp*g*y3 + 1/l*d_pend*y4 + mp*l*y3)*(1-0.75*mp/(mc+mp))^-1;
% cont_y(3,1) = y4;
% cont_y(4,1) = (mp*l*(cont_y(2,1)+g*y3) - d_pend*y4)/(4/3*mp*l^2);

%% Mike model
syms y1 y2 y3 y4 u

cont_y(1,1) = y2;
cont_y(2,1) = (1/(-l^2*mp^2/((mc+mp)*(4/3*mp*l^2+l^2*mp))+1))*((1/(mc+mp))...
    *(Km*u-d_cart*y2+l^2*mp^2*g*y3/(4/3*mp*l^2+l^2*mp)-l*mp*d_pend*y4/(2/3*mp*l^2+l^2*mp/2)...
    +l*mp*y4^2*y3/2));
cont_y(3,1) = y4;
cont_y(4,1) = 2*l*mp/(1/3*mp*l^2+l^2*mp)*(cont_y(2,1)+g*y3)-4*d_pend*y4/(1/3*mp*l^2+l^2*mp);

Y = [y1, y2, y3, y4];
U = u;

A = double(subs(jacobian(cont_y,Y),[U,Y],zeros(1,5)));
B = double(subs(jacobian(cont_y,U),[U,Y],zeros(1,5)));
C = [1,0,0,0;0,0,1,0];
D = 0;

sys = ss(A,B,C,D);
dsys = c2d(ss(A,B,C,D),h,'zoh');
% dsys = ss(A,B,C,D,h);