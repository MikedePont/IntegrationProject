%% 
% clear all
% close all
% clc
% 
% load run_11.mat

U = simout.data(:,1);
pos = simout.data(:,2);
theta = simout.data(:,3);

s = 7;
n = 6;

[At,Bt,Ct,Dt,x0t,S] = mysubid(Y,U,s,n)