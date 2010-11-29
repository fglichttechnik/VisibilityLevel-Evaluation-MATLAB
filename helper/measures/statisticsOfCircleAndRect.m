function image_Statistics = statisticsOfCircleAndRect(currentLMK_Evaluation, radius, savePath, luminanceMode)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%calculates the mean within a given circle of an image
%without taking the pixels of the rect region into account

if(strmatch(luminanceMode,'PHOTOPIC'))
    img = currentLMK_Evaluation.dataImagePhotopic;
    filename = currentLMK_Evaluation.dataSRCPhotopic;
    
elseif(strmatch(luminanceMode,'SCOTOPIC'))
    img = currentLMK_Evaluation.dataImageScotopic;
    filename = currentLMK_Evaluation.dataSRCScotopic;
    
elseif(strmatch(luminanceMode,'MESOPIC'))
    img = currentLMK_Evaluation.dataImageMesopic;
    filename = currentLMK_Evaluation.dataSRCPhotopic;
end

x1 = currentLMK_Evaluation.rect.upperLeft.x;
y1 = currentLMK_Evaluation.rect.upperLeft.y;
x2 = currentLMK_Evaluation.rect.lowerRight.x;
y2 = currentLMK_Evaluation.rect.lowerRight.y;
border = currentLMK_Evaluation.border;

%preferences
%save image for visualisation purposes
SAVEIMAGE = 1;  %0 or 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NO ADJUSTMENTS NEED TO BE DONE BELOW

imgTarget = img(y1 : y2, x1 : x2);

meanTarget = mean2(imgTarget);
minTarget = min(min(imgTarget));
maxTarget = max(max(imgTarget));
stdTarget = std2(imgTarget);

%save original values for later use
originalX1 = x1;
originalX2 = x2;
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
minBackground = -1;
maxBackground = 0;

%prepare border image
subImageMeasurementBorder = zeros(size(subImage));

%calc mean, min, max
for i = 1 : height
    for j = 1 : width
        %circle criterion
        currentDistanceFromCenter = sqrt((i - height / 2)^2 + (j - width / 2)^2);
        if(currentDistanceFromCenter < radius)
            %rect criterion
            if(((i < subY1) || (i > subY2)) || ((j < subX1) || (j > subX2)))
                
                currentPixelValue = subImage(i, j);
                %min
                if((currentPixelValue < minBackground) || (minBackground == -1))
                    minBackground = currentPixelValue;
                end
                %max
                if(currentPixelValue > maxBackground)
                    maxBackground = currentPixelValue;
                end
                %mean
                meanVal = meanVal + currentPixelValue;
                numberOfVals = numberOfVals + 1;
                if(SAVEIMAGE)
                    subImageMeasurementBorder(i,j) = 1;
                end
            end
        end
    end
end
meanBackground = meanVal / numberOfVals;

%calc std
stdVal = 0;
numberOfVals = 0;
for i = 1 : height
    for j = 1 : width
        %circle criterion
        currentDistanceFromCenter = sqrt((i - height / 2)^2 + (j - width / 2)^2);
        if(currentDistanceFromCenter < radius)
            %rect criterion
            if(((i < subY1) || (i > subY2)) || ((j < subX1) || (j > subX2)))
                stdVal = stdVal + (meanBackground - subImage(i, j))^2;
                numberOfVals = numberOfVals + 1;
            end
        end
    end
end
stdBackground = sqrt(stdVal / numberOfVals);
% minBackground
% maxBackground
% stdBackground
% meanBackground


%%calc adaptation luminance
[streetSurfaceLuminance, resultImg] = calcStatisticsOfStreetSurface(img, currentLMK_Evaluation.quadrangle);


%calc edge contrasts

TARGET_SIZE_PERCENTAGE_FOR_REGION = 0.3;

x1 = originalX1;
x2 = originalX2;
y1 = originalY1;
y2 = originalY2;

targetWidth = x2 - x1;
targetHeight = y2 - y1;
targetRegionWidth = round(targetWidth * TARGET_SIZE_PERCENTAGE_FOR_REGION);
targetRegionHeight = round(targetHeight * TARGET_SIZE_PERCENTAGE_FOR_REGION);

upperTargetX1 = x1;
upperTargetX2 = x2;
upperTargetY1 = y1;
upperTargetY2 = y1 + targetRegionHeight;
upperBackgroundX1 = x1;
upperBackgroundX2 = x2;
upperBackgroundY1 = y1 - border - targetRegionHeight;
upperBackgroundY2 = y1 - border;
lowerTargetX1 = x1;
lowerTargetX2 = x2;
lowerTargetY1 = y2 - targetRegionHeight;
lowerTargetY2 = y2;
lowerBackgroundX1 = x1;
lowerBackgroundX2 = x2;
lowerBackgroundY1 = y2 + border;
lowerBackgroundY2 = y2 + border + targetRegionHeight;
leftTargetX1 = x1;
leftTargetX2 = x1 + targetRegionWidth;
leftTargetY1 = y1;
leftTargetY2 = y2;
leftBackgroundX1 = x1 - targetRegionWidth - border;
leftBackgroundX2 = x1 - border;
leftBackgroundY1 = y1;
leftBackgroundY2 = y2;
rightTargetX1 = x2 - targetRegionWidth;
rightTargetX2 = x2;
rightTargetY1 = y1;
rightTargetY2 = y2;
rightBackgroundX1 = x2 + border;
rightBackgroundX2 = x2 + targetRegionWidth + border;
rightBackgroundY1 = y1;
rightBackgroundY2 = y2;

upperTargetMean = calcMeanOfRectInImage(img, upperTargetX1, upperTargetX2, upperTargetY1, upperTargetY2);
upperBackgroundMean = calcMeanOfRectInImage(img, upperBackgroundX1, upperBackgroundX2, upperBackgroundY1, upperBackgroundY2);
lowerTargetMean = calcMeanOfRectInImage(img, lowerTargetX1, lowerTargetX2, lowerTargetY1, lowerTargetY2);
lowerBackgroundMean = calcMeanOfRectInImage(img, lowerBackgroundX1, lowerBackgroundX2, lowerBackgroundY1, lowerBackgroundY2);
leftTargetMean = calcMeanOfRectInImage(img, leftTargetX1, leftTargetX2, leftTargetY1, leftTargetY2);
leftBackgroundMean = calcMeanOfRectInImage(img, leftBackgroundX1, leftBackgroundX2, leftBackgroundY1, leftBackgroundY2);
rightTargetMean = calcMeanOfRectInImage(img, rightTargetX1, rightTargetX2, rightTargetY1, rightTargetY2);
rightBackgroundMean = calcMeanOfRectInImage(img, rightBackgroundX1, rightBackgroundX2, rightBackgroundY1, rightBackgroundY2);

%visual output
edgeContrastAlphaMask = zeros(size(img));
edgeContrastAlphaMask(upperTargetY1 : upperTargetY2, upperTargetX1 : upperTargetX2) = 1;
edgeContrastAlphaMask(lowerTargetY1 : lowerTargetY2, lowerTargetX1 : lowerTargetX2) = 1;
edgeContrastAlphaMask(leftTargetY1 : leftTargetY2, leftTargetX1 : leftTargetX2) = 1;
edgeContrastAlphaMask(rightTargetY1 : rightTargetY2, rightTargetX1 : rightTargetX2) = 1;
edgeContrastAlphaMask(upperBackgroundY1 : upperBackgroundY2, upperBackgroundX1 : upperBackgroundX2) = 1;
edgeContrastAlphaMask(lowerBackgroundY1 : lowerBackgroundY2, lowerBackgroundX1 : lowerBackgroundX2) = 1;
edgeContrastAlphaMask(leftBackgroundY1 : leftBackgroundY2, leftBackgroundX1 : leftBackgroundX2) = 1;
edgeContrastAlphaMask(rightBackgroundY1 : rightBackgroundY2, rightBackgroundX1 : rightBackgroundX2) = 1;
%imshow(edgeContrastAlphaMask)
edgeContrastAlphaMask = bwperim(edgeContrastAlphaMask);


%contrasts
upperEdgeContrast = upperTargetMean / upperBackgroundMean - 1;
lowerEdgeContrast = lowerTargetMean / lowerBackgroundMean - 1;
leftEdgeContrast = leftTargetMean / leftBackgroundMean - 1;
rightEdgeContrast = rightTargetMean / rightBackgroundMean - 1;

if ((abs(upperEdgeContrast) >= abs(lowerEdgeContrast)) && (abs(upperEdgeContrast) >= abs(leftEdgeContrast)) && (abs(upperEdgeContrast) >= abs(rightEdgeContrast)))
    strongestEdge = 'upperEdgeContrast';
elseif ((abs(lowerEdgeContrast) >= abs(upperEdgeContrast)) && (abs(lowerEdgeContrast) >= abs(leftEdgeContrast)) && (abs(lowerEdgeContrast) >= abs(rightEdgeContrast)))
    strongestEdge = 'lowerEdgeContrast';
elseif ((abs(leftEdgeContrast) >= abs(upperEdgeContrast)) && (abs(leftEdgeContrast) >= abs(lowerEdgeContrast)) && (abs(leftEdgeContrast) >= abs(rightEdgeContrast)))
    strongestEdge = 'leftEdgeContrast';
else
    strongestEdge = 'rightEdgeContrast';
end


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
    imgGray(resultImg) = 1;
    imgGray(edgeContrastAlphaMask) = 1;
    
    %filename = currentLMK_Evaluation.dataSRC;
    
    %add mode
    filename = strcat(luminanceMode,'_',filename);
    
    %remove .pf
    filename = filename(1:end-3);
    filename = strcat(filename,'.png');
    
    imwrite(imgGray,strcat(savePath,'/',filename),'png');
    imshow(imgGray,[]);
end




%prepare output
image_Statistics = LMK_Image_Statistics(meanTarget,...
        minTarget,...
        maxTarget,...
        stdTarget,...
        meanBackground,...
        minBackground,...
        maxBackground,...
        stdBackground,...
        streetSurfaceLuminance,...        
        upperEdgeContrast,...
        lowerEdgeContrast,...
        leftEdgeContrast,...
        rightEdgeContrast,...
        strongestEdge);

end


