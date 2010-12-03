function [Lmes, imgVisualization] = mesopicLuminance_Sandy(Lp,Ls)
%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%calculates the mesopic luminance according to the INTERMEDIATE SYSTEM
%Lp, Ls might be single values or matrices
%Lp = photopic luminance
%Ls = scotopic luminance

%hack: remove zero pixels
Lp = Lp(1:end-2,1:end-2);
Ls = Ls(1:end-2,1:end-2);

%preferences
STARTWERT = 0.5;
STOP_CRITERION = 0.01;  %deprecated
NUMBER_OF_ITERATIONS = 10;  %10 looks to be a good value, as it converges fast
UPPER_VALUE_FOR_MESOPIC = 3;       %values above will be photopic luminances
LOWER_VALUE_FOR_MESOPIC = 0.01;    %values below will be scotopic luminances


%nothing needs to be modified below
%a = 1.49;
%b = 0.282;

if(size(Lp) ~= size(Ls))
    disp('mesopicLuminance: Lp and Ls must have the same size!');
    return;
end


%mes 2
a = 0.807;
b = 0.404;

Kp = 683;
Ks = 1699;

V_strich_lambda0 = Kp / Ks;



m_20 = ones(size(Lp)) * STARTWERT;
Lmes_n = zeros(size(Lp));
Lmes_n_1 = Lmes_n;

%calc mesopic luminance
m_2n_1 = m_20;
for i = 1 : NUMBER_OF_ITERATIONS
    numerator = m_2n_1 .* Lp + (1 - m_2n_1) .* Ls .* V_strich_lambda0;
    denominator = m_2n_1 + (1 - m_2n_1) .* V_strich_lambda0;
    Lmes_n = numerator ./ denominator;
    
    %%%%%%%%%%%%%%%%%%%%%%%%% NOTE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The INTERMEDIATE SYSTEM with upper and lower limits of 3 cd?m-2 and 
    % 0.01 cd?m-2, respectively, is denoted as the MES1-system and takes 
    % the form: M(m1) Vmes(?) = m1 V(?) + (1 – m1) V’(?) (13) where M(m1) 
    % is a normalizing function such that the mesopic spectral luminous 
    % efficiency function, Vmes(?), attains a maximum value of 1.
    % If Lmes ? 3.0 cd?m-2, then m1 = 1
    % If Lmes ? 0.01 cd?m-2, then m1 = 0
    % If 0.01 cd?m-2 < Lmes < 3.0 cd?m-2, then m1 = 0.404 log Lmes + 0.807
    % where L mes is the mesopic luminance.
%     [lines, columns] = size(Lmes_n);
%     m_2n = zeros(lines, columns);
%     for j = 1 : (lines*columns)
%         if (Lmes_n(j) < 3 && Lmes_n(j) > 0.01)
%             m_2n(j) = a + b * log10(Lmes_n(j));
%         else
%             if (Lmes_n(j) <= 0.01)
%             m_2n(j) = 0;
%             end 
%             if (Lmes_n(j) >= 3)
%             m_2n(j) = 1;
%             end
%         end
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    m_2n = a + b * log10(Lmes_n);
    m_2n_1 = m_2n;
    %keep photopic luminances above UPPER_VALUE_FOR_MESOPIC
    valuesAbove = (Lmes_n >= UPPER_VALUE_FOR_MESOPIC);
    m_2n_1(valuesAbove) = 1;
    
    %keep scotopic luminances below LOWER_VALUE_FOR_MESOPIC
    valuesBelow = (Lmes_n <= LOWER_VALUE_FOR_MESOPIC);
    m_2n_1(valuesBelow) = 0;
    
    save(['m_2n_1-', num2str(i)], 'm_2n_1');
    save(['Lmes_n-', num2str(i)], 'Lmes_n');
    sum(sum(imag(m_2n)));
    
    %     disp('max m2n')
    %     max(max(m_2n))
    %     disp('min m2n')
    %     min(min(m_2n))
    %     disp('--------------------------')
end
Lmes = Lmes_n;

%hack:
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


%prepare visualization image
imgVisualization = ones(size(Lp)) * 2;
imgVisualization(valuesAbove) = imgVisualization(valuesAbove) * 1;
imgVisualization(valuesBelow) = imgVisualization(valuesBelow) * 3;

%photopic luminances are red
%mesopic luminances are green
%scotopic luminances are blue
map = [1.0,0,0;0,1.0,0;0,0,1.0];
imgVisualization = ind2rgb(imgVisualization, map);
imshow(imgVisualization);
colorbar('YTick',[1;2;3],'YTickLabel',...
    {'Photopic','Mesopic','Scotopic'});
colormap(map);

% xn = STARTWERT;
% for i = 1 : NUMBER_OF_ITERATIONS
%     Mxn = 1 - 0.65 * xn + 0.65 * xn^2;
%     xn1 = a + b * log(1 / Mxn * (xn * Lp(1,1) / Kp + (1 - xn) * Ls(1,1) / Ks));
%
%     difference = abs(xn1 - xn);
%
%     xn = xn1;
% end
%
% x = xn1;
%
% Lmes = (x .* Lp + (1 - x) .* Ls .* V_strich_lambda0) ./ (x + (1 - x) * V_strich_lambda0);
%



