X_3 = lsqnonlin(@(x)final_est(x,g,h,l),[0.0167;0.0751;3.7228;4.3726;0.5477],[0.015;0.07;3.5;4.2;0.52],[0.018;0.085;3.9;4.5;0.56]);
d_pend = X_3(1);
mp = X_3(2);
Km = X_3(3);
d_cart = X_3(4);
mc = X_3(5);

[~, y,angle_cut] = final_est(X_3,g,h,l);
plot(y(3,:))
hold on
plot(angle_cut)
legend('Estimated','Measured')
hold off

%%

X_3 = lsqnonlin(@(x)final_est(x,g,h,l),[0.015;0.07;3.7],[0.01;0.06;3],[0.02;0.08;4]);
d_pend = X_3(1);
mp = X_3(2);
Km = X_3(3);


[~, y,angle_cut] = final_est(X_3,g,h,l);
plot(y(3,:))
hold on
plot(angle_cut)
legend('Estimated','Measured')
hold off