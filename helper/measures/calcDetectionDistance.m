function d = calcDetectionDistance(Lt,LB,x)
%function d = calcDetectionDistance(Lt,LB,x)
%   d = detection distance
%   Lt = mean Luminance target
%   LB = mean Luminance Background
%   x = size of quadratic target in m


y = 1:4000; %1 to 4000m

%calc target size for each distance
alpha_rad = 2 * atan(x ./ y);
alpha_deg = alpha_rad ./ pi * 180;
alpha_minute = alpha_deg * 60;

%calc VL for each distance until VL < 1
age = 27;
t = 2;
k = 2.6;
deltaL = abs(Lt - LB);
d = 0;
VL = zeros(size(y));
for i = 1 : length(y)
    deltaL_thresh = calcDeltaL(LB, Lt, alpha_minute(i), age, t, k);
    VL(i) = deltaL / deltaL_thresh;
   % i
   % deltaL_thresh
   % VL(i)
    
    if (VL(i) < 1)
        d = y(i);
        break;
    end
end

disp(sprintf('detection distance: %d m',d));

%plot 
from = 1;
to = round(d*1.1);
hold on;
plot(y(from : to),VL(from : to),'gr');
xlabel('y in m\fontsize{14}');
ylabel('VL\fontsize{14}');
titleString = sprintf('Visibility Level k=%2.1f, t=%d, age=%d',k,t,age);
legendString = sprintf('L_B=%3.2f, L_t=%3.2f',LB,Lt);
legendString = strcat(legendString, ' \frac{cd}{m^2}');
l = legend(legendString);
set(l,'interpreter','LaTeX');
title(titleString);
hold off;







