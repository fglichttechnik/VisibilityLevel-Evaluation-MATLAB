function [meanStreet, stdStreet, imgResult] = calcStatisticsOfStreetSurface(img, quadrangle)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

%preferences
%return resultImage for visualisation purposes
SAVEIMAGE = 1;  %0 or 1




% % Polygon parameters: 
%     x1 = 593 -3;    x2 = 714 -3; 
%     y1 = 512 -7;    y2 = 512 -7;
% 
% x3 = 4 -3;
% y3 = 657 -7;            x4 = 1326 -3;
%                         y4 = 1037 -7;
% 
%                         
                        
                        
x1 = quadrangle.upperLeft.x;
y1 = quadrangle.upperLeft.y;
x2 = quadrangle.upperRight.x;
y2 = quadrangle.upperRight.y;
x3 = quadrangle.lowerLeft.x;
y3 = quadrangle.lowerLeft.y;
x4 = quadrangle.lowerRight.x;
y4 = quadrangle.lowerRight.y;
     
%memory allocation
if(SAVEIMAGE)
    imgResult = zeros(size(img));
    imgResult(y1, x1:x2) = 1;
    imgResult(y4, x3:x4) = 1;
end

% Gradients of the vertical lines:                        
gradLeft = x1 / (y3 - y1);
gradRight = x2 / (y4 - y2);
                        
pixelCounter = 0;
meanStreet = 0;
stdStreet = 0;
currentInsetLeft = 0;
currentInsetRight = 0;

%calc mean
for lines = y1 : y4   
    currentLeftX = x1 - currentInsetLeft;
    currentRightX = x2 + currentInsetRight;   
    
    roundedCurrentLeftX = round(currentLeftX);
    roundedCurrentRightX = round(currentRightX);
    
    if roundedCurrentLeftX < 1
        roundedCurrentLeftX = 1;
    end
    if roundedCurrentRightX > x4
        roundedCurrentRightX = x4;
    end
    
    meanStreet = meanStreet + sum(img(round(lines), roundedCurrentLeftX : roundedCurrentRightX));
    pixelCounter = pixelCounter + roundedCurrentRightX - roundedCurrentLeftX + 1;
    
    %prepare result image
    if(SAVEIMAGE)
          imgResult(lines, roundedCurrentLeftX) = 1;
          imgResult(lines, roundedCurrentRightX) = 1;
    end
    
    %adjust inset values
    currentInsetLeft = currentInsetLeft + gradLeft;
    currentInsetRight = currentInsetRight + gradRight;    
end 

%calc std
for lines = y1 : y4   
    currentLeftX = x1 - currentInsetLeft;
    currentRightX = x2 + currentInsetRight;   
    
    roundedCurrentLeftX = round(currentLeftX);
    roundedCurrentRightX = round(currentRightX);
    
    if roundedCurrentLeftX < 1
        roundedCurrentLeftX = 1;
    end
    if roundedCurrentRightX > x4
        roundedCurrentRightX = x4;
    end
    
    stdStreet = stdStreet + sum(img(round(lines), roundedCurrentLeftX : roundedCurrentRightX) - meanStreet).^2;
    pixelCounter = pixelCounter + roundedCurrentRightX - roundedCurrentLeftX + 1;

    %adjust inset values
    currentInsetLeft = currentInsetLeft + gradLeft;
    currentInsetRight = currentInsetRight + gradRight;    
end

if(SAVEIMAGE)
    imgResult = logical(imgResult);
end

stdStreet = sqrt(stdStreet / pixelCounter);
meanStreet = meanStreet / pixelCounter;

end