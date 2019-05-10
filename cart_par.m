function [objfun,y,out] = cart_par(x,mc,h)
d_cart  = x(1);
Km = x(2);
factor = x(3);

load('runs/run_without_rod_offset.mat','Input_Voltage','Pos_Pendulum');

inpu = Input_Voltage.data;
out.pos = Pos_Pendulum.data;
out.vel = diff(out.pos);

x0 = [out.pos(1);out.vel(1)];

y(:,1) = x0;

for i = 1:length(out.pos)-2
    dy(1,1) = y(2,i);
    dy(2,1) = (Km*inpu(i)-d_cart*y(2,i))/(mc) + factor;
    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm(y(1,i+1) - [out.pos(i+1)],2);
end
end
