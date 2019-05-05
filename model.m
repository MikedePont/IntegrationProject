M = 0.5;
m = 0.2;
b = 0.1;
d = 1;
I = 0.006;
g = 9.8;
l = 0.3;
q = (M+m)*(I+m*l^2)-(m*l)^2;
s = tf('s');

P_cart = (((I+m*l^2)/q)*s^2 - (m*g*l/q))/(s^4 + (b*(I + m*l^2))*s^3/q - ((M + m)*m*g*l)*s^2/q - b*m*g*l*s/q);

P_pend = (m*l*s/q)/(s^3 + (b*(I + m*l^2))*s^2/q - ((M + m)*m*g*l)*s/q - b*m*g*l/q);

sys_tf = [P_cart ; P_pend];

inputs = {'u'};
outputs = {'x'; 'phi'};

set(sys_tf,'InputName',inputs)
set(sys_tf,'OutputName',outputs)

sys_tf = c2d(sys_tf,0.1);

%% Second system
h=0.1;
M = 0.5;
m = 0.2;
b = 0.1;
d = 1;
I = 0.006;
g = 9.8;
L = 0.3;

A = [0,1,0,0;0,-d/M, -m*g/M,0;0,0,0,1;0,-d/(M*L), (m+M)*g/(M*L),0];
B = [0;1/M;0;1/(M+L)];
C = [1,0,0,0;0,0,1,0];
D = 0;

sys = ss(A,B,C,D,h);
tspan = 0:0.1:10;

x0 = [0.5;0;0.05;0];
eigs = 5*[-1.1,-1.2,-1.3,-1.4];
K = place(A,B,eigs);

newsys = ss(A-B*K,[0;0;0;0],C,D);

Y = lsim(newsys,zeros(length(tspan),1),tspan,x0);

%%
for k = 1:length(Y)
    pendulum_draw(Y(k,:),M,m,L);
    if k==1
        pause(5)
    else
        pause(0.2)
    end
    drawnow 
end