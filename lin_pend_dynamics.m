function sys = lin_pend_dynamics(mc,mp,g,L,h,Km,d_cart,d_pend)
syms y1 y2 y3 y4 u

dy(1,1) = y2;
dy(2,1) = (1/(mp*sin(y3)^2+mc))*(Km*u-mp*L*y4^2*sin(y3)-d_cart*y2);
dy(3,1) = y4;
dy(4,1) = (1/L)*(dy(2,1)*cos(y3)+g*sin(y3))-d_pend*y4;

V = [y1,y2,y3,y4];
U = u;

A = double(subs(jacobian(dy,V),[U,V],zeros(1,5)));
B = double(subs(jacobian(dy,U),[U,V],zeros(1,5)));
C = [1,0,0,0;0,0,1,0];
D = 0;

sys = ss(A,B,C,D);
sys = c2d(sys,h);