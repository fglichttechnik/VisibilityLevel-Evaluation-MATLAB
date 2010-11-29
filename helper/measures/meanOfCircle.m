function [meanTarget, meanBackground] = meanOfCircleWithoutRect(img, radius, x1, x2, y1, y2, border)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%DEPRECATED: superseeded by statisticsOfCircle...
%calculates the mean within a given circle of an image
%without taking the pixels of the rect region into account

%preferences
%save image for visualisation purposes
SAVEIMAGE = 1;  %0 or 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NO ADJUSTMENTS NEED TO BE DONE BELOW

meanTarget = mean2(img(x1 : x2, y1 : y2));

%save original values for later use
originalX1 = x1;
originalX2 = x2,
originalY1 = y1;
originalY2 = y2;

%calc background mean not within the border region of object
x1 = x1 - border;
x2 = x2 + border;
y1 = y1 - border;
y2 = y2 + border;


centerX = round((x1 + x2) / 2);
centerY = round((y1 + y2) / 2);

fromX = centerX - radius;
fromY = centerY - radius;
toX = centerX + radius;
toY = centerY + radius;

%TODO
%check if vals are within range.. of image

%calculations needs to be done only within subimage
subImage = img(fromY : toY, fromX : toX);
[width, height] = size(subImage);

%adjust values to subimage koordinates
subCenterX = round(width / 2);
subCenterY = round(height / 2);
subX1 = subCenterX - round((x2 - x1) / 2);
subY1 = subCenterY - round((y2 - y1) / 2);
subX2 = subCenterX + round((x2 - x1) / 2);
subY2 = subCenterY + round((y2 - y1) / 2);

%prepare mean 
meanVal = 0;
numberOfVals = 0;

%prepare border image
subImageMeasurementBorder = zeros(size(subImage));

for i = 1 : height
    for j = 1 : width
        %circle criterion
        currentDistanceFromCenter = sqrt((i - height / 2)^2 + (j - width / 2)^2);
        if(currentDistanceFromCenter < radius)
            %rect criterion
            if(((i < subY1) || (i > subY2)) || ((j < subX1) || (j > subX2)))
                meanVal = meanVal + subImage(i, j);
                numberOfVals = numberOfVals + 1;
                %subImage(i,j) = 1000;
                if(SAVEIMAGE)
                    subImageMeasurementBorder(i,j) = 1;
                end
            end
        end
    end
end
%imshow(subImage)
meanBackground = meanVal / numberOfVals;

if(SAVEIMAGE)
    imageMeasurementBorder = zeros(size(img));
    imageMeasurementBorder = im2bw(imageMeasurementBorder);
    
    %circle processing
    %    
    %fill rect region
    %subImageMeasurementBorder(subX1 : subX2, subY1 : subY2) = 1;
    %get perimeter
    subImageMeasurementBorder = bwperim(im2bw(subImageMeasurementBorder), 8);
    %set area in original image
    imageMeasurementBorder(fromY : toY, fromX : toX) = subImageMeasurementBorder;
    
    %rect processing
    %
    rectImage = ones(originalY2 - originalY1 + 1, originalX2 - originalX1 + 1);
    rectImage = im2bw(rectImage);
    %get perimeter
    rectImage = bwperim(rectImage);
    %set area in original image
    imageMeasurementBorder(originalY1 : originalY2, originalX1 : originalX2) = rectImage;
       
    imgGray = adapthisteq(img);
    imgGray(imageMeasurementBorder) = 1;
    
    imwrite(imgGray,'testImage.png','png');
    imshow(imgGray,[]);
end





