function [sys,x0, data] = getArmax(h)
load('runs/run_without_rod_offset.mat','Input_Voltage','Pos_Pendulum');
data = iddata(Pos_Pendulum.data(1:7000),Input_Voltage.data(1:7000),h);

x0 = [Pos_Pendulum.data(1),0];
sys = arx(data,[4 4 1]);