function sys = sys_id(simout,h)
U = simout.data(:,1);
Y = simout.data(:,2:3);

data = iddata(Y,U,h);
% M = oe(data,[2 1 1;2 1 1]);
M = n4sid(data,4);
sys = ss(M);

