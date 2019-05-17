function run_pendulum
T_final = 15;

x_init = [Pos_Pendulum.data(10),0,Angle_Pendulum.data(10),0];
u_time = 0:0.01:T_final;
u_out = 0.5*sin(5*u_time);

sim('pendtemplate')
save('runs/last_run')