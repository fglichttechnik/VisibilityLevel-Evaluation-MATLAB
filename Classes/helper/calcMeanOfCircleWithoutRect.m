function meanBackground = calcMeanOfCircleWithoutRect(img, LMK_Image_Metadata)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%calculates the mean within a given circle of an image
%without taking the pixels of the rect region into account


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NO ADJUSTMENTS NEED TO BE DONE BELOW

%save original values for later use
x1 = LMK_Image_Metadata.rect.upperLeft.x;
x2 = LMK_Image_Metadata.rect.lowerRight.x;
y1 = LMK_Image_Metadata.rect.upperLeft.y;
y2 = LMK_Image_Metadata.rect.lowerRight.y;

%calc background mean not within the border region of object
border = LMK_Image_Metadata.border;
x1 = x1 - border;
x2 = x2 + border;
y1 = y1 - border;
y2 = y2 + border;


centerX = round((x1 + x2) / 2);
centerY = round((y1 + y2) / 2);

radius = LMK_Image_Metadata.twoDegreeRadiusPix;
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




for i = 1 : height
    for j = 1 : width
        %circle criterion
        currentDistanceFromCenter = sqrt((i - height / 2)^2 + (j - width / 2)^2);
        if(currentDistanceFromCenter < radius)              
            %rect criterion
            if(((i < subY1) || (i > subY2)) || ((j < subX1) || (j > subX2)))
                meanVal = meanVal + subImage(i, j);
                numberOfVals = numberOfVals + 1;               
            end
        end
    end
end
meanBackground = meanVal / numberOfVals;


%prepare visualisation
colorChannel = 1;

[w, h] = size( img );
repX = repmat( ( 1 : w )', 1, h );
repY = repmat( 1 : h, w, 1 );
data = (repX - centerY).^2 + ( repY - centerX ).^2; 
circle = data <= radius ^ 2;
visImage = bwperim( circle, 8 ); 

%mark region 
alphaMask = zeros( size ( LMK_Image_Metadata.visualisationImagePhotopic ) );
alphaMask( : , : , colorChannel) = visImage;
alphaMask = logical( alphaMask );
LMK_Image_Metadata.visualisationImagePhotopic( alphaMask ) = 1;








