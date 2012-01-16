function [ stv ] = calcSTVfromArray( visibilityLevelArray )
%author Jan Winter, Sandy Buschmann TU Berlin
%email j.winter@tu-berlin.de
% function stv = calcSTVfromArray( visibilityLevelArray )
%	This function calculates the small target visibility as published in .
%	visibilityLevelArray: array with target Visibility Levels for every image
%                         pixel
%   stv: weighted average of the values of the target Visibility Level


% calc relative weighted visibility level for all grid points:
relativeWeightedVL = 10.^(-1.*abs(visibilityLevelArray));

% calc the average relative weighted visibility level:
[sizeOfArray, ~] = size(relativeWeightedVL);
sumOfVL = 0;

for currentIndex = 1 : sizeOfArray
     sumOfVL = sumOfVL + visibilityLevelArray(currentIndex);
end

averageRWVL = sumOfVL/sizeOfArray;

% cal the weighted average visibility level, also known as Small Target
% Visibility:
logSTV = log10(averageRWVL)
stv = -10*logSTV
%stv = -10*log10(averageRWVL);





end

