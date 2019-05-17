function [x_init,Pos_Pendulum, Angle_Pendulum] = xinitialize()

[Pos_Pendulum, Angle_Pendulum] = sim('pendtemplate');