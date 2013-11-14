function deltaL_RP800 = calcDeltaL_RP800(Lb, Lt, alpha, age, T, k)
%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
% function deltaL_RP800 = calcDeltaL_RP800(Lb, Lt, alpha, age, t, k)
%	This function calculates the contrast threshold as published in ANSI IESNA RP 800.
%	Lb: background luminance in cd/m^2
%   Lt: target luminance, this values is needed to check if we have a
%   positive or a negative delta only
%	alpha: object size as percepted by a test person in minutes '
%	age: age of test person
%	t: presentation time of object in s
%	k: correction factor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First step: determine background luminance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to do ???
% Lb = ( Lb1 + Lb2 ) / 2
% Lb1: Lb at a point on the pavement adjacent to the center of the bottom
% of the target
% Lb2: Lb at a point on the pavement 11.77 meters beyond the target, at a
% point on the line projected from the observer's point of view through the
% point at the center of the top of the target

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Second step: determine adaption luminance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% to do ???
% La = Lb + Lv
% Lv: Veiling luminance
La = Lb;
LLa = log10( La );
%A = arctan( targetSize / distanceOfObserverToTarget ) * 60;
A = alpha;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Third step: determine sensivity of visual system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if La >= 0.6
    F = ( log10( 4.2841 * La^0.1556 ) + ( 0.1684 * La^0.5867 ) )^2;
    L = ( 0.05946 * La^0.466)^2;
elseif La < 0.00418
    F = 10^( 0.346 * LLa + 0.056 );
    L = 10^( ( 0.0454 * LLa^2 ) + ( 1.055 * LLa ) - 1.782 );
else
    F = 10^( 2 * ( ( 0.0866 * LLa^2 ) + ( 0.3372 * LLa ) - 0.072 )  );
    L = 10^( 2 * ( 0.319 * LLa - 1.256 ) );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fourth step: calc intermediate functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
B = log10( A ) + 0.523;
C = LLa + 6;
AA = 0.360 - ( ( 0.0972 * B^2 ) / ( B^2 - ( 2.513 * B ) + 2.789 ) );
AL = 0.355 - ( 0.1217 * ( C^2 / ( C^2 - ( 10.40 * C ) + 52.28 ) ) );
%AZ = sqrt( ( AA^2 + AL^2 ) / 2.1 );
AZ = sqrt(  AA^2 + AL^2 ) / 2.1 ; % corrected according to RP800 Errata
DL1 = k * ( ( sqrt( F ) / A ) + sqrt( L ) )^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fifth step: calc M factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TGB = -0.6 * La^( -0.1488 );
if LLa >= -1
    M = 10^( -10^( -( ( 0.125 * ( LLa + 1 )^2 ) + 0.0245 ) ) );
    FCP = 1 - ( ( M * A^TGB ) / ( 2.4 * DL1 * ( AZ + 2 ) / 2 ) );
elseif LLa <= -2.4
    FCP = 0.5;
else
    M = 10^( -10^( -( ( 0.075 * ( LLa + 1 )^2 ) + 0.0245 ) ) );
    FCP = 1 - ( ( M * A^TGB ) / ( 2.4 * DL1 * ( AZ + 2 ) / 2 ) );    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sixth step: adjust DL with observation time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DL2 = DL1 * ( ( AZ + T ) / T );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seventh step: adjust DL with age of observer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TA = age;
if TA <= 64
    FA = ( ( TA - 19 )^2 / 2160 ) + 0.99;
else
    FA = ( ( TA - 56.5 )^2 / 116.3 ) + 1.43;
end

DL3 = DL2 * FA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Eighth step: adjust DL in case of negative contrast
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Lt < Lb
    DL4 = DL3 * FCP;
else
    DL4 = DL3;
end

deltaL_RP800 = DL4;



end
