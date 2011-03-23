function d = calcDetectionDistance(Lt,LB,x)
%function d = calcDetectionDistance(Lt,LB,x)
%   d = detection distance
%   Lt = mean Luminance target
%   LB = mean Luminance Background
%   x = size of quadratic target in m


y = 1:4000;

alpha_rad = 2 * atan(x ./ y);
alpha_deg = alpha_rad ./ pi * 180;
alpha_minute = alpha_deg * 60;

age = 27;
t = 2;
k = 2.6;

deltaL = abs(Lt - LB);
d = 0;

VL = zeros(size(y));

for i = 1 : length(y)
    deltaL_thresh = calcDeltaL(LB, alpha_minute(i), age, t, k);
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


from = 1;
to = round(d*1.1);
hold on;
plot(y(from : to),VL(from : to),'gr');
xlabel('y in m\fontsize{14}');
ylabel('VL\fontsize{14}');
title('Detection Distance\fontsize{14}');
hold off;







