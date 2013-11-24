function [meanImg, rawImage] = calcMeanOfRectInImage(img, x1, x2, y1, y2, LMK_Image_Statistics, colorChannel)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
%calculates the mean of a rect region within an image
%eventually cropping parts, which are out of the image boundaries

x1 = uint16(x1);
x2 = uint16(x2);
y1 = uint16(y1);
y2 = uint16(y2);

[height,width] = size(img);

if (x1 < 1)
    x1 = 1;    
end

if (x2 > width)
    x2 = width;
end

if (y1 < 1)
    y1 = 1;
end

if (y2 > height)
    y2 = height;
end

%imshow(img(y1 : y2, x1 : x2))
%imshow(img(y1 : y2+1, x1 : x2+1))

rawImage = img( y1 : y2, x1 : x2);
meanImg = mean2( rawImage );

%visualize measurement region
visImage = logical( zeros( size( img ) ) );
visImage(y1 : y2, x1 : x2) = 1;

visImage2 = visImage;

visImage = bwperim( visImage, 8);

%mark region 
alphaMask = zeros( size ( img ) );
alphaMask( : , : , colorChannel) = visImage;
alphaMask = logical( alphaMask );

LMK_Image_Statistics.imageMetadata.visualisationImagePhotopic( alphaMask ) = 1;

alphaMask2 = logical( visImage2 );
LMK_Image_Statistics.imageMetadata.visualisationMeasRegions( alphaMask2 ) = img( alphaMask2 );
