function calib
% calibration pendulum angle
%hwinit;

h = 0.01;

disp('Press enter when pendulum is vertical...');
pause;
disp('Calibrating pendulum ...');


tfinal = 0.5;
td = (0:h:tfinal)';
[t,x,out] = sim('pendmove2', td,[],[td zeros(size(td)) ones(size(td))]);
cart = out(:,3);
adinoffcart = -mean(cart);
angle = out(:,4);           % 1 and 2 are calibrated sensor signals, 3 and 4 raw
adinoffangle = -mean(angle);

f=fopen('hwinit.m','a');
% pendulum 1
%fprintf(f,'adinoffs = [0.033;%3.4f]; \n', adinoff);
% pendulum 2
fprintf(f,'\nadinoffs = [%3.4f;%3.4f];', adinoffcart, adinoffangle);
fclose(f);


