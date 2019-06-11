function dy = NL_model(y,u,mc,mp,Km,d_cart,d_pend,g,l)
%% This function time derivative dy of the nonlinear pendulum on a cart
% model. 
dy(1,1) = y(2);
dy(2,1) = 1/((mc+mp)*(1-0.75*mp))*(Km*u - d_cart*y(2) + 3/(2*l)*((l/2)*mp*g*y(3) - d_pend*y(4)) + mp*l*y(4)^2*y(3)/2);
dy(3,1) = y(4);
dy(4,1) = 3/(mp*l^2)*(l*mp*dy(2,1)/2 + l*mp*g*y(3)/2 - d_pend*y(4));
end