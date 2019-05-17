function dy = nl_pend_dynamics(y,mc,mp,g,L,u,d_cart,Km,Pc)
dy(1,1) = y(2);
dy(2,1) = (1/(mp*sin(y(3))^2+mc))*(Km*u-mp*L*y(4)^2*sin(y(3))-d_cart*y(2)-mc*g*sin(atan(2*Pc*(y(1)-50)))) ;
dy(3,1) = y(4);
dy(4,1) = (1/L)*(dy(2)*cos(y(3))+g*sin(y(3)))-d_pend*y(4) ;

% dy(1,1) = y(2);
% dy(2,1) = (1/mc+mp*(1-cos(y(3))^2))*(mp*g*cos(y(3))*sin(y(3)) + Km*u - d_cart*y(4) + mp*L*y(4)^2*sin(y(3)));
% dy(3,1) = y(4);
% dy(4,1) = (mc+mp)/(mp*L*(mc+mp*(1-cos(y(3))^2)))*(mp*g*sin(y(3))+(mp*cos(y(3)))/(mc+mp)*(Km*u-d_cart*y(4)+mp*L*y(4)^2*sin(y(3))))-d_pend*y(4)/mp;