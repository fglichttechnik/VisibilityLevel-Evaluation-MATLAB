function [ stv ] = calcSTVfromArray( visibilityLevelArray )
%author Jan Winter, Sandy Buschmann TU Berlin
%email j.winter@tu-berlin.de
% function stv = calcSTVfromArray( visibilityLevelArray )
%	This function calculates the small target visibility as published in .
%	visibilityLevelArray: array with target Visibility Levels for every image
%                         pixel
%   stv: weighted average of the values of the target Visibility Level

%make sure we have a one dimensional array
visibilityLevelArray = visibilityLevelArray( : );

% calc relative weighted visibility level for all grid points:
relativeWeightedVL = 10.^( -1 .* abs( visibilityLevelArray ) );

% calc the average relative weighted visibility level:
averageRWVL = mean( relativeWeightedVL );

% calc the weighted average visibility level, also known as Small Target
% Visibility:
logSTV = log10( averageRWVL );
stv = -10 * logSTV;

end
