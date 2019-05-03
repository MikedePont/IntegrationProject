This folder contains two examples of system identification / parameter estimation implementation in Matlab:
1) linear input-output system identification using the output-error method (script linid.m)
2) parameter tuning in a nonlinear (Simulink) model using nonlinear least-squares optimization (script nonlinid.m)

NOTE: method 1) should always be tried first, as it is:
a) much easier to implement,
b) converges well to a global, or near-global, optimum,
c) runs very fast,
d) the resulting model gives quick insight into the properties of the system (stability, DC gain, poles locations, etc.).

Linear models are, of course, not always accurate enough, so one may need to resort to method 2) if method 1) fails.
Recent versions of Simulink have their own parameter tuning options which may be worth trying.
