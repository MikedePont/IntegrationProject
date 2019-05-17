function testmodel(mc,mp,g,L,h,Km,d_cart,d_pend)
[ ~,lin_pend] = nl_pend_dynamics2(mc,mp,g,L,d_cart,d_pend,Km);
tspan = 0:0.1:10;
x0 = [0.5,0,0.5,0];

eigs = 2*[-1.1,-1.2,-1.3,-1.4];


K = place(lin_pend.A,lin_pend.B,eigs);
Q = lin_pend.C'*lin_pend.C;
Q = [50, 0, 0, 0;...
     0, 25, 0, 0;...
     0, 0, 1, 0;...
     0,0,0,1]
R = 1;

[K2, S, e] = lqr(lin_pend,Q,R);
poles = eig(lin_pend.A-lin_pend.B*K2);
CL_lin_pend = ss(lin_pend.A-lin_pend.B*K2,lin_pend.B,lin_pend.C,lin_pend.D);

Y = lsim(CL_lin_pend,zeros(length(tspan),1),tspan,x0);

for k = 1:length(Y)
    pendulum_draw(Y(k,:),mc,mp,L);
    if k==1
        pause(1)
    else
        pause(h)
    end
    drawnow 
end

%% Using K for non linear function, position to 
x0 = [0;0;0.5;0];
[tout,yout] = ode45(@(t,y)nl_pend_dynamics(y,mc,mp,g,L,0,d_cart,d_pend,Km),tspan,x0);
for z = 1:length(yout)
    pendulum_draw(yout(z,[1,3]),mc,mp,L)
    if z==1
        pause(1)
    else
        pause(h)
    end
    drawnow
end

%% 
load('runs/run_11.mat','simout');
id_pend = sys_id(simout,h);

eigs = 2*[-1.1,-1.2,-1.3,-1.4];

K = place(id_pend.A,id_pend.B,eigs);

CL_id_pend = ss(id_pend.A-id_pend.B*K2,[0;0;0;0],id_pend.C,id_pend.D);

Y = lsim(CL_id_pend,zeros(length(tspan),1),tspan,x0);

for k = 1:length(Y)
    pendulum_draw(Y(k,:),mc,mp,L);
    if k==1
        pause(1)
    else
        pause(h)
    end
    drawnow 
end
