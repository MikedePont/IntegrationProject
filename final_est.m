function [objfun,y,angle_cut] = final_est(x,g,h,l)
load('runs/Sinus_good_2')
clear d_pend mp Km d_cart mc
d_pend  = x(1);
mp = x(2);
Km = x(3);
%d_cart = x(4);
%mc = x(5);
d_cart = 4.3726;
mc = 0.5477;



pos_x = states.data(:,1);
angle_w = states.data(:,3);

pos_cut = pos_x(1000:3000);
angle_cut = angle_w(1000:3000);

u = Voltage.data(1000:3000);
dangle = (angle_cut(2)-angle_cut(1))/h;
dpos = (pos_cut(2)-pos_cut(1))/h;
x0 = [pos_cut(1);dpos;angle_cut(1);dangle];

y(:,1) = x0;

for i = 1:length(angle)-2
    
    dy(1,1) = y(2,i);
    dy(2,1) = 1/((mc+mp)*(1-0.75*mp))*(Km*u(i) - d_cart*y(2,i) + 3/(2*l)*((l/2)*mp*g*y(3,i) - d_pend*y(4,i)) + mp*l*y(4,i)^2*y(3,i)/2);
    dy(3,1) = y(4,i);
    dy(4,1) = 3/(mp*l^2)*(l*mp*dy(2,1)/2 + l*mp*g*y(3,i)/2 - d_pend*y(4,i));

    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm([y(1,i+1);y(3,i+1)] - [pos_cut(i+1); angle_cut(i+1)],2);
end
end

