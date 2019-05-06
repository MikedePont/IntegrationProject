function pendulum_draw(x,M,m,L)
% Dimensions
C_width = 0.2*sqrt(M);      %width of the cart
C_height = C_width;     %heigth of the cart

S_radius = 0.1*m^(1/3);     %radius of the sphere

wx = x(1,1) - C_width/2;
wy = C_height/2;

px = x(1,1) + L*sin(x(1,2));
py = C_height + L*cos(x(1,2));

plot([x(1,1) px],[C_height py],'k','linewidth',2);
hold on
rectangle('Position',[wx,wy,C_width,C_height],'Curvature',.1,'FaceColor',[1 0.1 0.1])

rectangle('Position',[px-S_radius,py-S_radius,S_radius*2,S_radius*2],'Curvature',1,'FaceColor',[.1 0.1 1])
xlim([-2 2]);
ylim([-1 1]);
pbaspect([2,1,1]);
hold off
end
