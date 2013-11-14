function [ stv ] = calcSTVfromArray( visibilityLevelArray )
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
% function stv = calcSTVfromArray( visibilityLevelArray )
%	This function calculates the small target visibility as published in .
%	visibilityLevelArray: array with target Visibility Levels for every image
%                         pixel
%   stv: weighted average of the values of the target Visibility Level

%make sure we have a one dimensional array
visibilityLevelArray = visibilityLevelArray( : );

% calc relative weighted visibility level for all grid points:
relativeWeightedVL = 10.^( -0.1 .* abs( visibilityLevelArray ) );

% calc the average relative weighted visibility level:
averageRWVL = mean( relativeWeightedVL );

% calc the weighted average visibility level, also known as Small Target
% Visibility:
logSTV = log10( averageRWVL );
stv = -10 * logSTV;

end
