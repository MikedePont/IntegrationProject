function [objfun,y,angle] = pend_par2(x,mc,Km,d_cart,g,h)
d_pend  = x(1);
mp = x(2);
l = x(3);

load('runs/stokjetest','Angle_Pendulum','inputcontroller');

angle = Angle_Pendulum.data(200:500);
u = inputcontroller.data(200:500);
dangle = (Angle_Pendulum.data(200)-Angle_Pendulum.data(199))/h;
x0 = [0;0;angle(1);dangle];

y(:,1) = x0;

for i = 1:length(angle)-2
    
    % % % Mike model l = hele stokje
    dy(1,1) = y(2,i);
    dy(2,1) = (1/(-l^2*mp^2/((mc+mp)*(4/3*mp*l^2+l^2*mp))+1))*((1/(mc+mp))...
        *(Km*u(i)-d_cart*y(2,i)+l^2*mp^2*g*y(3,i)/(4/3*mp*l^2+l^2*mp)-l*mp*d_pend*y(4,i)/(2/3*mp*l^2+l^2*mp/2)...
        +l*mp*y(4,i)^2*y(3,i)/2));
    dy(3,1) = y(4,i);
    dy(4,1) = 2*l*mp/(1/3*mp*l^2+l^2*mp)*(dy(2,1)+g*y(3,i))-4*d_pend*y(4,i)/(1/3*mp*l^2+l^2*mp);
    
% % %Daniel is fotomodel l = halve stokje
%     dy(1,1) = y(2,i);
%     dy(2,1) = (1/(mc+mp))*(Km*u(i) - d_cart*y(2,i) + 0.75*mp*g*y(3,i) + mp*l*y(3,i))*(1-0.75*mp/(mc+mp))^-1;
%     dy(3,1) = y(4,i);
%     dy(4,1) = (-mp*l*(dy(2,1)+g*y(3,i)) - d_pend*y(4,i))/(4/3*mp*l^2);

    y(:,i+1) = y(:,i) + h*dy;
    objfun(:,i) = norm(y(3,i+1) - angle(i+1),2);
    
end
end

