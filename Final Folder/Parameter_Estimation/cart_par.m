function [objfun,y,out,dy,dsys] = cart_par(x,h)
d_cart  = x(1);
Km = x(2);
mc = x(3);

g = 9.81;
load('cart_init.mat','Input_Voltage','Pos_Pendulum');

inpu = Input_Voltage.data;
out.pos = Pos_Pendulum.data;
out.vel = diff(out.pos)/h;

x0 = [out.pos(1);out.vel(1)];

y(:,1) = x0;
dy = zeros(2,1);

for i = 1:length(out.pos)-2
    dy(1,1) = y(2,i);
    dy(2,1) = (Km*inpu(i)- d_cart*y(2,i))/mc;
    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm(y(1,i+1) - out.pos(i+1),2);
end

syms y1 y2 u

cont_y(1,1) = y2;
cont_y(2,1) = (Km*u - d_cart*y2)/mc;

Y = [y1, y2];
U = u;

A = double(subs(jacobian(cont_y,Y),[U,Y],zeros(1,3)));
B = double(subs(jacobian(cont_y,U),[U,Y],zeros(1,3)));
C = [1,0];
D = 0;

dsys = c2d(ss(A,B,C,D),h);

end
