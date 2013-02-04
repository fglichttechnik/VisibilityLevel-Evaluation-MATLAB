function [eQuadratic, eLinear, correlation2] = calcErrorForContrastThreshold( calculatedAlphaMinutes, calculatedLB, calculatedContrastThreshold, measuredAlphaMinutes, measuredLB, measuredContrastThreshold )
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
%function [eQuadratic, eLinear, correlation2] = calcErrorForContrastThreshold( calculatedAlphaMinutes, calculatedLB, calculatedContrastThreshold, measuredAlphaMinutes, measuredLB, measuredContrastThreshold )
%
% this function is intended for calculating the error of actual measured
% contrast threshold (in a subject experiment) and calculated contrast
% thresholds as seen in Adrian1989 / RP800

numberOfMeasurementValues = length( measuredContrastThreshold );

%find corresponding calculated contrastThresholds
thresholdContrastForAlphaAndLBArray = zeros( numberOfMeasurementValues, 1 );

for i = 1 : numberOfMeasurementValues
    
    %interpolate calculated contrashThreshold for required measured alpha / LB
    alpha = measuredAlphaMinutes( i );
    lb = measuredLB( i );
    ZI = interp2( calculatedAlphaMinutes, calculatedLB, calculatedContrastThreshold, alpha, lb );
    thresholdContrastForAlphaAndLBArray( i ) = ZI;
    
end

%calculate error
eQuadratic = sqrt( mean( abs( thresholdContrastForAlphaAndLBArray - measuredContrastThreshold ) .^2 ) );
eLinear = mean( abs( thresholdContrastForAlphaAndLBArray - measuredContrastThreshold ) );

%calculate correlation
alphaMin = min( measuredAlphaMinutes );
alphaMax = max( measuredAlphaMinutes );
LbMin = min( measuredLB );
LbMax = max( measuredLB );

alphaRange = linspace( alphaMin, alphaMax, 100 );
LbRange = linspace( LbMin, LbMax, 100 );
measuredCthValues = zeros( 100, 100 );
calculatedCthValues = zeros( 100, 100 );

meanOfValues = mean( measuredContrastThreshold( : ) );
meanCthValues = ones( 100, 100 ) * meanOfValues;
stdOfValues = std( measuredContrastThreshold );

for currentIndex = 1 : length( measuredContrastThreshold )
    
    alpha = measuredAlphaMinutes( currentIndex );
    lb = measuredLB( currentIndex );
    
    indices = find( alphaRange >= alpha );
    
    if( isempty(indices) )
        continue;
    end
    
    alphaIndex = indices( 1 );
    
    indices = find( LbRange >= lb );
    
    if( isempty(indices) )
        continue;
    end
    
    lBIndex = indices( 1 );
    
    measuredCthValues( alphaIndex, lBIndex ) = measuredContrastThreshold( currentIndex );
    calculatedCthValues( alphaIndex, lBIndex ) = thresholdContrastForAlphaAndLBArray( currentIndex );
end

correlation2 = corr2( measuredCthValues, calculatedCthValues );
correlationWithMean2 = corr2( measuredCthValues, meanCthValues );
disp('');

