% function [Lmes, imgVisualization] = mesopicLuminance_move(Lp,Ls)
function Lmes = mesopicLuminance_move(Lp,Ls)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%calculates the mesopic luminance according to the MOVE MODEL
%Lp, Ls might be single values or matrices
%Lp = photopic luminance
%Ls = scotopic luminance

%hack: remove zero pixels
% Lp = Lp(1:end-2,1:end-2);
% Ls = Ls(1:end-2,1:end-2);

%preferences
STARTWERT = 0.5;
STOP_CRITERION = 0.01;  %deprecated
NUMBER_OF_ITERATIONS = 3;  %10 looks to be a good value, as it converges fast
% UPPER_VALUE_FOR_MESOPIC = 5;        %values above will be photopic luminances
% LOWER_VALUE_FOR_MESOPIC = 0.005;    %values below will be scotopic luminances


%nothing needs to be modified below
a = 1.49;
b = 0.282;

if(size(Lp) ~= size(Ls))
    disp('mesopicLuminance: Lp and Ls must have the same size!');
    return;
end

Kp = 683;
Ks = 1699;

V_strich_lambda0 = Kp / Ks;

x_20 = ones(size(Lp)) * STARTWERT;
Lmes_n = zeros(size(Lp));
Lmes_n_1 = Lmes_n;

%calc mesopic luminance
x_2n_1 = x_20;
for i = 1 : NUMBER_OF_ITERATIONS
    
    numerator = x_2n_1 .* Lp + (1 - x_2n_1) .* Ls .* V_strich_lambda0;
    denominator = x_2n_1 + (1 - x_2n_1) .* V_strich_lambda0;
    Lmes_n = numerator ./ denominator;
    
    x_numerator = (x_2n_1/Kp) .* Lp + ((1 - x_2n_1)/Ks) .* Ls;
    x_denominator = 1 - 0.65 .* x_2n_1 + 0.65 .* x_2n_1 .* x_2n_1;
    x_log = x_numerator ./ x_denominator;
    x_2n = a + b .* log10(x_log);
    x_2n_1 = x_2n;    
    
%     %keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
%     valuesAbove = (Lmes_n >= UPPER_VALUE_FOR_MESOPIC);
%     m_2n_1(valuesAbove) = 1;
%     
%     %keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
%     valuesBelow = (Lmes_n <= LOWER_VALUE_FOR_MESOPIC);
%     m_2n_1(valuesBelow) = 0;
    
%     sum(sum(imag(x_2n)));
   
end
Lmes = Lmes_n;

%hack:
Lmes = abs(Lmes_n);

% %keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
% valuesAbove = (Lmes >= UPPER_VALUE_FOR_MESOPIC);
% Lp_keep = Lp .* valuesAbove;

% %keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
% valuesBelow = (Lmes <= LOWER_VALUE_FOR_MESOPIC);
% Ls_keep = Ls .* valuesBelow;

% %merge into mesopic values
% Lmes(valuesAbove) = Lp_keep(valuesAbove);
% Lmes(valuesBelow) = Ls_keep(valuesBelow);
% 
% 
% %prepare visualization image
% imgVisualization = ones(size(Lp)) * 2;
% imgVisualization(valuesAbove) = imgVisualization(valuesAbove) * 1;
% imgVisualization(valuesBelow) = imgVisualization(valuesBelow) * 3;
% 
% %photopic luminances are red
% %mesopic luminances are green
% %scotopic luminances are blue
% map = [1.0,0,0;0,1.0,0;0,0,1.0];
% imgVisualization = ind2rgb(imgVisualization, map);
% imshow(imgVisualization);
% colorbar('YTick',[1;2;3],'YTickLabel',...
%     {'Photopic','Mesopic','Scotopic'});
% colormap(map);



