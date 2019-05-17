function [objfun,y,out] = cart_par(x,mc,h)
d_cart  = x(1);
Km = x(2);
Pc = x(3);

g = 9.81;
load('runs/last_run.mat','Input_Voltage','Pos_Pendulum');

inpu = Input_Voltage.data;
out.pos = Pos_Pendulum.data;
out.vel = diff(out.pos);

x0 = [out.pos(1);out.vel(1)];

y(:,1) = x0;
dy = zeros(2,1);

for i = 1:length(out.pos)-2
    dy(1,1) = y(2,i);
    dy(2,1) = (Km*inpu(i) - d_cart*y(2,i) -mc*g*sin(atan(2*Pc*(y(1,i)-50))))/(mc);
    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm(y(1,i+1) - out.pos(i+1),2);
end
end
