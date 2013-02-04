function calcMeanOfTargetEdges( image, LMK_Image_Statistics )
%calculates the mean of the edge region of a target
%function calcMeanOfTargetEdges( image, imageMetadata )
%   image                  imageData (photopic, scotopic, mesopic)
%   LMK_Image_Statistics   instance of LMK_Image_Statistics class


%edges are 30% of the target size
TARGET_SIZE_PERCENTAGE_FOR_REGION = 0.3;    

k = 0;    %debug: should be 0 in normal operation
x1 = LMK_Image_Statistics.imageMetadata.rect.upperLeft.x - k;
y1 = LMK_Image_Statistics.imageMetadata.rect.upperLeft.y - k;
x2 = LMK_Image_Statistics.imageMetadata.rect.lowerRight.x + k;
y2 = LMK_Image_Statistics.imageMetadata.rect.lowerRight.y + k;
border = LMK_Image_Statistics.imageMetadata.border;

targetWidth = x2 - x1;
targetHeight = y2 - y1;
targetRegionWidth = round(targetWidth * TARGET_SIZE_PERCENTAGE_FOR_REGION);
targetRegionHeight = round(targetHeight * TARGET_SIZE_PERCENTAGE_FOR_REGION);

%calc edge region points
%calc means of corners: (LB = mean(o), Lt = mean(x9)
%      .---------.
%      |    o1   | 
%      .---------.
%   .-..---------..-.
%   | || |  x1 | || |
%   | ||-+-----+-|| |
%   | || |     | || |
%   | || |     | || | 
%   | || |     | || |
%   | ||-+-----+-|| |
%   | || |     | || |
%   .-..---------..-.
%      .---------.
%      |         | 
%      .---------.

upperTargetX1 = x1;
upperTargetX2 = x2;
upperTargetY1 = y1;
upperTargetY2 = y1 + targetRegionHeight;

upperBackgroundX1 = x1;
upperBackgroundX2 = x2;
upperBackgroundY1 = inImageVert(y1 - border - targetRegionHeight, image);
upperBackgroundY2 = inImageVert(y1 - border, image);

lowerTargetX1 = x1;
lowerTargetX2 = x2;
lowerTargetY1 = y2 - targetRegionHeight;
lowerTargetY2 = y2;

lowerBackgroundX1 = x1;
lowerBackgroundX2 = x2;
lowerBackgroundY1 = inImageVert(y2 + border, image);
lowerBackgroundY2 = inImageVert(y2 + border + targetRegionHeight, image);

leftTargetX1 = x1;
leftTargetX2 = x1 + targetRegionWidth;
leftTargetY1 = y1;
leftTargetY2 = y2;

leftBackgroundX1 = inImageHor(x1 - targetRegionWidth - border, image);
leftBackgroundX2 = inImageHor(x1 - border, image);
leftBackgroundY1 = y1;
leftBackgroundY2 = y2;

rightTargetX1 = x2 - targetRegionWidth;
rightTargetX2 = x2;
rightTargetY1 = y1;
rightTargetY2 = y2;

rightBackgroundX1 = inImageHor(x2 + border, image);
rightBackgroundX2 = inImageHor(x2 + targetRegionWidth + border, image);
rightBackgroundY1 = y1;
rightBackgroundY2 = y2;

%calc mean of regions
colorChannel = 3;
[upperTargetMean] = calcMeanOfRectInImage(image, upperTargetX1, upperTargetX2, upperTargetY1, upperTargetY2, LMK_Image_Statistics, colorChannel);
[upperBackgroundMean] = calcMeanOfRectInImage(image, upperBackgroundX1, upperBackgroundX2, upperBackgroundY1, upperBackgroundY2, LMK_Image_Statistics, colorChannel);
[lowerTargetMean] = calcMeanOfRectInImage(image, lowerTargetX1, lowerTargetX2, lowerTargetY1, lowerTargetY2, LMK_Image_Statistics, colorChannel);
[lowerBackgroundMean] = calcMeanOfRectInImage(image, lowerBackgroundX1, lowerBackgroundX2, lowerBackgroundY1, lowerBackgroundY2, LMK_Image_Statistics, colorChannel);
[leftTargetMean] = calcMeanOfRectInImage(image, leftTargetX1, leftTargetX2, leftTargetY1, leftTargetY2, LMK_Image_Statistics, colorChannel);
[leftBackgroundMean] = calcMeanOfRectInImage(image, leftBackgroundX1, leftBackgroundX2, leftBackgroundY1, leftBackgroundY2, LMK_Image_Statistics, colorChannel);
[rightTargetMean] = calcMeanOfRectInImage(image, rightTargetX1, rightTargetX2, rightTargetY1, rightTargetY2, LMK_Image_Statistics, colorChannel);
[rightBackgroundMean] = calcMeanOfRectInImage(image, rightBackgroundX1, rightBackgroundX2, rightBackgroundY1, rightBackgroundY2, LMK_Image_Statistics, colorChannel);

%calc means of corners: (LB = mean(o), Lt = x)
%      .-.     .-.
%    1 |o|     |o| 2
%      .-.     .-.
%   .-..---------..-.
%   |o||x|     |x||o|
%   .-.|-.     .-|.-.
%      |         |
%      |         |
%      |         |
%   .-.|-.     .-|.-.
%   |o||x|     |x||o|
%   .-..---------..-.
%      .-.     .-.
%    3 |o|     |o| 4
%      .-.     .-.

colorChannel = 2;
[upperLeftCornerTargetMean] = calcMeanOfRectInImage(image, upperTargetX1, upperTargetX1 + targetRegionWidth, upperTargetY1, upperTargetY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel);
[upperRightCornerTargetMean] = calcMeanOfRectInImage(image, upperTargetX2 - targetRegionWidth, upperTargetX2, upperTargetY1, upperTargetY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel);
[lowerLeftCornerTargetMean] = calcMeanOfRectInImage(image, lowerTargetX1, lowerTargetX1 + targetRegionWidth, lowerTargetY2 - targetRegionHeight, lowerTargetY2, LMK_Image_Statistics, colorChannel);
[lowerRightCornerTargetMean] = calcMeanOfRectInImage(image, lowerTargetX2 - targetRegionWidth, lowerTargetX2, lowerTargetY2 - targetRegionHeight, lowerTargetY2 , LMK_Image_Statistics, colorChannel);

[dummyMean, upperLeftUpperBackground] = calcMeanOfRectInImage(image, upperBackgroundX1, upperBackgroundX1 + targetRegionWidth, upperBackgroundY1, upperBackgroundY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel );
[dummyMean, upperLeftLeftBackground] = calcMeanOfRectInImage(image, leftBackgroundX1, leftBackgroundX1 + targetRegionWidth, leftBackgroundY1, leftBackgroundY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel );
combinedPixels = [ upperLeftUpperBackground(:); upperLeftLeftBackground(:) ];
upperLeftCornerBackgroundMean = mean( combinedPixels );

[dummyMean, upperRightUpperBackground] = calcMeanOfRectInImage(image, upperBackgroundX2 - targetRegionWidth, upperBackgroundX2, upperBackgroundY1, upperBackgroundY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel );
[dummyMean, upperRightRightBackground] = calcMeanOfRectInImage(image, rightBackgroundX1, rightBackgroundX1 + targetRegionWidth, rightBackgroundY1, rightBackgroundY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel );
combinedPixels = [ upperRightUpperBackground(:); upperRightRightBackground(:) ];
upperRightCornerBackgroundMean = mean( combinedPixels );

[dummyMean, lowerLeftLowerBackground] = calcMeanOfRectInImage(image, upperBackgroundX1, upperBackgroundX1 + targetRegionWidth, lowerBackgroundY1, lowerBackgroundY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel );
[dummyMean, lowerLeftLeftBackground] = calcMeanOfRectInImage(image, leftBackgroundX1, leftBackgroundX1 + targetRegionWidth, leftBackgroundY2 - targetRegionHeight, leftBackgroundY2, LMK_Image_Statistics, colorChannel );
combinedPixels = [ lowerLeftLowerBackground(:); lowerLeftLeftBackground(:) ];
lowerLeftCornerBackgroundMean = mean( combinedPixels );

[dummyMean, lowerRightLowerBackground] = calcMeanOfRectInImage(image, lowerBackgroundX2 - targetRegionWidth, lowerBackgroundX2, lowerBackgroundY1, lowerBackgroundY1 + targetRegionHeight, LMK_Image_Statistics, colorChannel );
[dummyMean, lowerRightRightBackground] = calcMeanOfRectInImage(image, rightBackgroundX1, rightBackgroundX1 + targetRegionWidth, rightBackgroundY2 - targetRegionHeight, rightBackgroundY2, LMK_Image_Statistics, colorChannel );
combinedPixels = [ lowerRightLowerBackground(:); lowerRightRightBackground(:) ];
lowerRightCornerBackgroundMean = mean( combinedPixels );

%save to class
LMK_Image_Statistics.meanTargetUpperEdge = upperTargetMean;
LMK_Image_Statistics.meanTargetLowerEdge = lowerTargetMean;
LMK_Image_Statistics.meanTargetLeftEdge = leftTargetMean;
LMK_Image_Statistics.meanTargetRightEdge = rightTargetMean;

LMK_Image_Statistics.meanTargetUpperLeftCorner = upperLeftCornerTargetMean;
LMK_Image_Statistics.meanTargetUpperRightCorner = upperRightCornerTargetMean;
LMK_Image_Statistics.meanTargetLowerLeftCorner = lowerLeftCornerTargetMean;
LMK_Image_Statistics.meanTargetLowerRightCorner = lowerRightCornerTargetMean;

LMK_Image_Statistics.meanBackgroundUpperEdge = upperBackgroundMean;
LMK_Image_Statistics.meanBackgroundLowerEdge = lowerBackgroundMean;
LMK_Image_Statistics.meanBackgroundLeftEdge = leftBackgroundMean;
LMK_Image_Statistics.meanBackgroundRightEdge = rightBackgroundMean;

LMK_Image_Statistics.meanBackgroundUpperLeftCorner = upperLeftCornerBackgroundMean;
LMK_Image_Statistics.meanBackgroundUpperRightCorner = upperRightCornerBackgroundMean;
LMK_Image_Statistics.meanBackgroundLowerLeftCorner = lowerLeftCornerBackgroundMean;
LMK_Image_Statistics.meanBackgroundLowerRightCorner = lowerRightCornerBackgroundMean;

end

%helper methods to check if region is within image
function outputValue = inImageHor(inputValue, img)
    [lines, columns] = size(img);
    if inputValue < 1
        outputValue = 1;
    elseif inputValue > columns
        outputValue = columns;
    else
        outputValue = inputValue;
    end
end

function outputValue = inImageVert(inputValue, img)
    [lines, columns] = size(img);
    if inputValue < 1
        outputValue = 1;
    elseif inputValue > lines
        outputValue = lines;
    else
        outputValue = inputValue;
    end
end