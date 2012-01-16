function [ Lmes, mFactor ] = mesopicLuminance_recommended( Lp, Ls, Lap, Las )
%author Jan Winter, Sandy Buschmann TU Berlin
%email j.winter@tu-berlin.de
%calculates the mesopic luminance according to the CIE RECOMMENDED SYSTEM
%FOR PERFORMANCE BASED MESOPIC PHOTOMETRY
%Lp, Ls might be single values or matrices
%Lp = photopic luminance
%Ls = scotopic luminance
%implemented regarding to CIE Report TC1-58
%Lap = photopic adaption luminance
%Las = scotopic adaption luminance
%mFactor = by iteration calcuted factor for mesopic luminance calculation

%hack: remove zero pixels
% Lp = Lp(1:end-2,1:end-2);
% Ls = Ls(1:end-2,1:end-2);

%preferences
STARTWERT = 0.5;

%nothing needs to be modified below
UPPER_VALUE_FOR_MESOPIC = 5;       %values above will be photopic luminances
LOWER_VALUE_FOR_MESOPIC = 0.005;    %values below will be scotopic luminances

if(size(Lp) ~= size(Ls))
    disp('mesopicLuminance: Lp and Ls must have the same size!');
    return;
end

%make calling without adaption luminance possible
if nargin < 3
    for currentIndex = 1 : size(Lp)
        Lap = mean( Lp );
        Las = mean( Ls );
    end   
end

%variables
a = 0.767;
b = 0.3334;
Kp = 683;
Ks = 1699;
V_strich_lambda0 = Kp / Ks;


%calc mesopic luminance
m_2n_1 = 0;
m_2n = STARTWERT;


for i = 1 : 100
    
    if abs( m_2n_1 - m_2n ) <= 0.001 
        break
    end
    
    m_2n_1 = m_2n;
    
    numerator = m_2n_1 * Lap + ( 1 - m_2n_1 ) * Las * V_strich_lambda0;
    denominator = m_2n_1 + (1 - m_2n_1) * V_strich_lambda0;
    Lmes_n = numerator / denominator;
    
    m_2n = a + b * log10(Lmes_n);
    
    %keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
    if Lmes_n >= UPPER_VALUE_FOR_MESOPIC
        m_2n = 1;
    end
    
    %keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
    if Lmes_n <= LOWER_VALUE_FOR_MESOPIC
        m_2n = 0;
    end
    
end

num = m_2n .* Lp + ( 1 - m_2n ) .* Ls * V_strich_lambda0;
denom = m_2n + (1 - m_2n) * V_strich_lambda0;
Lmes_n = num / denom;
Lmes = abs(Lmes_n);

%keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
valuesAbove = (Lmes >= UPPER_VALUE_FOR_MESOPIC);
Lp_keep = Lp .* valuesAbove;

%keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
valuesBelow = (Lmes <= LOWER_VALUE_FOR_MESOPIC);
Ls_keep = Ls .* valuesBelow;

%merge into mesopic values
Lmes(valuesAbove) = Lp_keep(valuesAbove);
Lmes(valuesBelow) = Ls_keep(valuesBelow);

mFactor = m_2n;




