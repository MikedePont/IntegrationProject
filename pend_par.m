function [objfun,y,angle] = pend_par(x,mc,Km,d_cart,g,h,l)
d_pend  = x(1);
mp = x(2);


load('runs/stokje_laten_vallen_goede_3.mat', "Angle_Pendulum")

angle = Angle_Pendulum.data(670:763);
u = zeros(size(angle,1),1);
%u = Voltage.data(670:763);
dangle = (Angle_Pendulum.data(670)-Angle_Pendulum.data(669))/h;
x0 = [0;0;angle(1);dangle];

y(:,1) = x0;

for i = 1:length(angle)-2
    
    dy(1,1) = y(2,i);
    dy(2,1) = 1/((mc+mp)*(1-0.75*mp))*(Km*u(i) - d_cart*y(2,i) + 3/(2*l)*((l/2)*mp*g*y(3,i) - d_pend*y(4,i)) + mp*l*y(4,i)^2*y(3,i)/2);
    dy(3,1) = y(4,i);
    dy(4,1) = 3/(mp*l^2)*(l*mp*dy(2,1)/2 + l*mp*g*y(3,i)/2 - d_pend*y(4,i));

    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm(y(3,i+1) - angle(i+1),2);
end
end

