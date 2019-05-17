function [objfun,y,angle] = pend_par(x,mp,mc,Km,L,d_cart,g,h)
d_pend  = x(1);

load('runs/stokje_vallen_1.mat','Angle_Pendulum');

angle = Angle_Pendulum.data(70:150);
inpu = zeros(length(angle),1);
dangle = (Angle_Pendulum.data(70)-Angle_Pendulum.data(69))/h;
x0 = [0;0;angle(1);dangle];

y(:,1) = x0;

for i = 1:length(angle)-2
    dy(1,1) = y(2,i);
    dy(2,1) = (-mp*g*sin(y(3,i))*cos(y(3,i)) + mp*L*y(4,i)^2*sin(y(3,i)) + d_pend*mp*y(4,i)*cos(y(3,i)) + Km*inpu(i) - d_cart*y(2,i))/(mc + sin(y(3,i))^2*mp);
    dy(3,1) = y(4,i);
    dy(4,1) = (((mc+mp)*(g*sin(y(3,i))-d_pend*y(4,i)))-(L*mp*y(4,i)^2*sin(y(3,i)) + Km*inpu(i))*cos(y(3,i)))/(L*(mc+sin(y(3,i))^2*mp));

    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm(y(3,i+1) - angle(i+1),2);
end
end
