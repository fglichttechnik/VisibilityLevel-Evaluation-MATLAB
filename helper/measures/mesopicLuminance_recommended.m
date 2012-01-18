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

BREAK_CRITERION = 0.001;    %we stop if m hasn't changed more than that value in one iteration
MAX_NUMBER_OF_ITERATIONS = 100;

if(size(Lp) ~= size(Ls))
    disp('mesopicLuminance: Lp and Ls must have the same size!');
    return;
end

%make calling without adaption luminance possible
if nargin < 3
    %for currentIndex = 1 : size(Lp)
        Lap = mean( Lp );
        Las = mean( Ls );
    %end   
end

%variables
a = 0.767;
b = 0.3334;
Kp = 683;
Ks = 1699;
V_strich_lambda0 = Kp / Ks;

%calc mesopic luminance
m_n_1 = 0;
m_n = STARTWERT;

for i = 1 : MAX_NUMBER_OF_ITERATIONS
    
    if abs( m_n_1 - m_n ) <= BREAK_CRITERION         
        break
    end
    
    m_n_1 = m_n;
    
    numerator = m_n_1 * Lap + ( 1 - m_n_1 ) * Las * V_strich_lambda0;
    denominator = m_n_1 + (1 - m_n_1) * V_strich_lambda0;
    Lmes_n = numerator / denominator;
    
    m_n = a + b * log10(Lmes_n);
    
    %keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
    if Lmes_n >= UPPER_VALUE_FOR_MESOPIC
        m_n = 1;
    end
    
    %keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
    if Lmes_n <= LOWER_VALUE_FOR_MESOPIC
        m_n = 0;
    end
    
end

disp( sprintf( '%d iterations needed, m is %f', i, m_n ) );

num = m_n .* Lp + ( 1 - m_n ) .* Ls * V_strich_lambda0;
denom = m_n + (1 - m_n) * V_strich_lambda0;
Lmes_n = num / denom;
Lmes = abs( Lmes_n );

%keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
valuesAbove = (Lmes >= UPPER_VALUE_FOR_MESOPIC);
%Lp_keep = Lp .* valuesAbove;

%keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
valuesBelow = (Lmes <= LOWER_VALUE_FOR_MESOPIC);
%Ls_keep = Ls .* valuesBelow;

%merge into mesopic values
Lmes(valuesAbove) = Lp(valuesAbove);
Lmes(valuesBelow) = Ls(valuesBelow);

mFactor = m_n;




