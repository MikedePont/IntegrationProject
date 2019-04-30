%% 
clear all
close all
clc
model

%%
t = linspace(0,30,301);
u = 30 - t;

lsim(sys_tf,u,t);