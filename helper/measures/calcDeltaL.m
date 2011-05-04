function deltaL = calcDeltaL(Lb, Lt, alpha, age, t, k)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% function deltaL = calcDeltaL(Lb, Lt, alpha, age, t, k)
%	This function calculates the contrast threshold as published in Adrian89.
%	Lb: background luminance in cd/m^2
%	alpha: object size as percepted by a test person in minutes '
%	age: age of test person
%	t: presentation time of object in s
%	k: correction factor

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate deltaL threshold for circumstances
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculate Ricco part
sqrt_phi = calcRiccoPhi(Lb);	%phi is sqrt(phi)
%calculate Weber part
sqrt_L = calcWeberL(Lb);		%L is sqrt(L)

%delta L uncorrected
deltaL = k .* (sqrt_phi ./ alpha  + sqrt_L).^2;

%correct data for negative contrast
if ((Lt - Lb) < 0)
    Fcp = calcNegativeContrastFcp(alpha, Lb, deltaL);
    deltaL = deltaL * Fcp;
end

%
%     %correct time factor
%     timeFactor = calcTimeFactor(alpha, Lb, t);
%
%     %correct age factor
%     AF = calcAgeFactor(age) ;
%
%     deltaL = deltaLneg;


%deltaL = Lt - Lb

%dit is quatsch!
%contrastThreshold = deltaL ./ Lb;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sqrt_phi = calcRiccoPhi(Lb)
% calculates the Ricco part
%Lb >= 0.6cd/m^2
if(Lb >= 0.6)
    sqrt_phi = log10(4.1925 .* Lb.^(0.1556)) + 0.1684 .* Lb.^(0.5867);
elseif(Lb <= 0.00418)
    log_sqrt_phi = 0.028 + 0.173 .* log10(Lb);
    sqrt_phi = 10.^log_sqrt_phi;
else
    log_sqrt_phi = -0.072 + 0.3372 .* log10(Lb) + 0.0866 .* (log10(Lb)).^2;
    sqrt_phi = 10.^log_sqrt_phi;
end
end

function sqrt_L = calcWeberL(Lb)
% calculates the Weber part

if(Lb >= 0.6)
    sqrt_L = 0.05946 .* Lb.^(0.466);
elseif(Lb <= 0.00418)
    log_sqrt_L = -0.891 + 0.5275 .* log10(Lb) + 0.0227 .* (log10(Lb))^2;
    sqrt_L = 10.^log_sqrt_L;
else
    log_sqrt_L = -1.256 + 0.319 .* log10(Lb);
    sqrt_L = 10.^log_sqrt_L;
end
end

function Fcp = calcNegativeContrastFcp (alpha, Lb, deltaLpos)
% calculates the negative to positive contrast conversion factor

assert(Lb > 0.004)
if(Lb >= 0.1)
    factor = 0.125;     %Lb >= 0.1 cd/m^2
elseif(Lb > 0.004)
    factor = 0.075;    %Lb > 0.004 cd/m^2
end
m = 10.^(- (factor .* (log10(Lb) + 1).^2 + 0.0245));
m = 10.^(-m)
beta = 0.6 .* Lb.^(-0.1488)
Fcp = 1 - (m * alpha^(-beta) / (2.4 * deltaLpos));
end

function timeFactor = calcTimeFactor (alpha, Lb, t)
% calculates the time factor

assert(alpha < 60);

logAlpha = log10(alpha) + 0523;
aAlpha = 0.36 - 0.0972 * logAlpha^2 / (logAlpha^2 - 2.513 * logAlpha + 2.7895)

logLb = log10(Lb) + 6;
aLb = 0.355 - 0.1217 * logLb^2 / (logLb^2 - 10.4 * logLb + 52.28)

%for alpha < 60'
aAlphaLb = sqrt(aAlpha^2 + aLb^2) / 2.1

timeFactor = (aAlphaLb + t) / t;



end

function AF = calcAgeFactor(age)
% calculates the age factor

assert((age > 23) && (age < 75))

if(age < 64)
    %23 < age < 64
    AF = (age - 19)^2 / 2160 + 0.99;
else
    %64 <= age < 75
    AF = (age - 56.6)^2 / 116.3 + 1.43;
end
end
