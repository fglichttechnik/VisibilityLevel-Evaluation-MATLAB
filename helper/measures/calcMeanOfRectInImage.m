function meanImg = calcMeanOfRectInImage(img, x1, x2, y1, y2)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
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

meanImg = mean2(img(y1 : y2, x1 : x2));
