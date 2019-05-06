function dy = nl_pend_dynamics(y,mc,mp,g,L,u,d_cart,d_pend)
dy(1,1) = y(2);
dy(2,1) = (1/(mp*sin(y(3))^2+mc))*(u-mp*L*y(4)^2*sin(y(3))-d_cart*y(2));
dy(3,1) = y(4);
dy(4,1) = (1/L)*(dy(2,1)*cos(y(3))+g*sin(y(3)))-d_pend*y(4);
