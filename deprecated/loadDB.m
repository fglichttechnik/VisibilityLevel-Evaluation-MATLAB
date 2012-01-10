%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Calculates mean and contrast for background of an image using XML meta
% data.

%read xml meta data
xml = parseXML('lmkXML.xml');
x1 = str2num(xml.Children(4).Children(2).Attributes(1).Value);
y1 = str2num(xml.Children(4).Children(2).Attributes(2).Value);
x2 = str2num(xml.Children(4).Children(4).Attributes(1).Value);
y2 = str2num(xml.Children(4).Children(4).Attributes(2).Value);
border = str2num(xml.Children(4).Children(6).Attributes.Value);

%correct values from lmk
X_CORRECTION_LMK = 7;
Y_CORRECTION_LMK = 11;
x1 = x1 - X_CORRECTION_LMK;
x2 = x2 - X_CORRECTION_LMK;
y1 = y1 - Y_CORRECTION_LMK;
y2 = y2 - Y_CORRECTION_LMK;

radius = 100;
centerX = (x1 + x2) / 2;
centerY = (y1 + y2) / 2;

%read image
img = LMK_readPfImage('test.pf');

%calc mean for target
%meanTarget = mean2(img(y1:y2, x1:x2))
%img(x1:x2, y1:y2) = 0;
%imshow(img, []);

%calc mean for background
[meanTarget, minTarget, maxTarget, stdTarget,...
    meanBackground, minBackground, maxBackground, stdBackground]...
    = statisticsOfCircleAndRect(img, 100, x1, x2, y1, y2, border);

%calc contrast
contrast = (meanTarget - meanBackground) / meanBackground
