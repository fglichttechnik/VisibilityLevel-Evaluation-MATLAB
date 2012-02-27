function calcMeanOfTarget( image, LMK_Image_Statistics )
%calculates the mean of a target
%function calcMeanOfTarget( image, imageMetadata )
%   image                  imageData (photopic, scotopic, mesopic)
%   LMK_Image_Statistics   instance of LMK_Image_Statistics class

k = 0;%k = 100;    %debug: should be 0 in normal operation
x1 = LMK_Image_Statistics.imageMetadata.rect.upperLeft.x - k;
y1 = LMK_Image_Statistics.imageMetadata.rect.upperLeft.y - k;
x2 = LMK_Image_Statistics.imageMetadata.rect.lowerRight.x + k;
y2 = LMK_Image_Statistics.imageMetadata.rect.lowerRight.y + k;

%calc mean
%targetImage = image(y1 : y2, x1 : x2);
%meanTarget = mean2(targetImage);
colorChannel = 2;
[ meanTarget ] = calcMeanOfRectInImage(image, x1, x2, y1, y2, LMK_Image_Statistics, colorChannel);

%save to class
LMK_Image_Statistics.meanTarget = meanTarget;