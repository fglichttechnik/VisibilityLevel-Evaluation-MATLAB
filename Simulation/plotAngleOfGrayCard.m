%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

%rect object
SIZE = 0.3; %size of object 0.3x0.3m

h_high = sqrt(2)*SIZE;
h = SIZE;
d = 10:80;  %distance in m

%calc alpha
alphaRad = 2 * atan(h ./ (2 .* d));
alphaRad_high = 2 * atan(h_high ./ (2 .* d));

alphaDeg = alphaRad / pi * 180;
alphaDeg_high = alphaRad_high / pi * 180;

plot(d,alphaDeg);
hold on;
plot(d,alphaDeg_high,'r');
hold off;
title(strcat('Sehobjektgröße ',num2str(h),' m'));
xlabel('d in m');
ylabel('alpha in °');
legend('Höhe','Diagonale');





