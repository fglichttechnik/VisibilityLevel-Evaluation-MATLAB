%%properties
NUMBER_OF_STEPS = 10;
STEPWIDTH = 1 / (NUMBER_OF_STEPS);% + 1);
WIDTH = 740;
HEIGHT = 560;
SAVE = 0;


%%load some stuff
load 'V_strich_CIE.mat'  %load V_strich and lambda_CIE
load 'V_CIE.mat'  %load V and lambda_CIE
lambda_i = linspace(380, 780, 401);
V_strich_i = interp1(lambda_CIE, V_strich, lambda_i);
V_i = interp1(lambda_CIE, V, lambda_i);


%%prepare
luminance = [0.3, 0.5, 0.75, 1.0, 1.5, 2.0, 5.0];
%luminance = logspace(-1, 1, 6);
len = length(luminance);
Lmes = zeros(NUMBER_OF_STEPS, len);
Lphot = zeros(NUMBER_OF_STEPS, len);
Lscot = zeros(NUMBER_OF_STEPS, len);
LmesByRadiance = zeros(NUMBER_OF_STEPS, len);
V_strich_2_V_ratio = zeros(NUMBER_OF_STEPS, len);
radiance = zeros(NUMBER_OF_STEPS, len);


for lumIndex = 1 : 1%len
    index = 1;
    for step = 1 : (NUMBER_OF_STEPS + 1)
        
        
        currentStepWidth = STEPWIDTH * (step - 1);
        V_strich_factor =  1 - currentStepWidth;
        V_factor = currentStepWidth;
        
        spectrum_V_strich = V_strich_i * V_strich_factor;
        spectrum_V = V_i * V_factor;
        spectrum = spectrum_V_strich + spectrum_V;
        %adjust spectrum to current luminance
        Lv_actual = 683 * sum(V_i .* spectrum);
        Lv_target = luminance(lumIndex);
        spectrum_adjustmentFactor_targetLv = Lv_target / Lv_actual;
        spectrum_adjusted = spectrum * spectrum_adjustmentFactor_targetLv;
        
        %test
        Lv_new = 683 * sum(V_i .* spectrum_adjusted);
        %spectrum_adjusted = spectrum;
        
        
        %create CS2000Measurement
        data = CS2000Measurement();
        data.initWithSpectrum(spectrum_adjusted);       
        
        currentRadiance = sum(spectrum_adjusted);
        currentLmes = data.colorimetricData.Lv_mesopic;
        currentLphot = data.colorimetricData.Lv;	%should be same as Lv_target
        currentLscot = data.colorimetricData.Lv_scotopic;
        currentLmesAdjustmentFactor = currentLphot / currentLmes;
        
        if(currentLphot != Lv_target)
        	disp('error: currentLphot != Lv_target');
        	exit
        end
        
        Lmes(index, lumIndex) = currentLmes;
        Lphot(index, lumIndex) = currentLphot;
        Lscot(index, lumIndex) = currentLscot;
        
        %radiance to generate Lmes at target level
        radiance(index, lumIndex) = currentRadiance * currentLmesAdjustmentFactor; 
        
        %Lmes(index, lumIndex) = currentLmesAdjustmentFactor;
        %Lmes(index, lumIndex) = currentLmes / currentLphot;
        %radiance(index, lumIndex) = currentRadiance * currentLmesAdjustmentFactor;
       % V_strich_2_V_ratio(index, lumIndex) = V_strich_factor;
        % LmesByRadiance(index, lumIndex) = data.colorimetricData.Lv_mesopic  ./ radiance(index, lumIndex);
       % LmesByRadiance(index, lumIndex) = radiance(index, lumIndex);
        
        
        if(lumIndex == 1)
            
            %     figure();
            %     plot(data);
            figure();
            plot(data.lambda, spectrum_V / currentLmesAdjustmentFactor, 'r', 'LineWidth', LINEWIDTH);
            hold on;
            plot(data.lambda, spectrum_V_strich / currentLmesAdjustmentFactor, 'LineWidth', LINEWIDTH);
            plot(data.lambda, spectrum / currentLmesAdjustmentFactor, 'gr:', 'LineWidth', LINEWIDTH');
            hold off;
            
            x = xlabel('\lambda in nm');
            set(x,'FontSize',FONTSIZE);
            y = ylabel('$$\mbox{L}_{e}(\lambda) \hspace{5pt} \mbox{in} \hspace{5pt}  \frac{\mbox{W}}{\mbox{m}^{2} \hspace{3pt} \mbox{sr} \hspace{3pt} \mbox{nm}}$$');
            set(y,'Interpreter','LaTeX','FontSize', FONTSIZE);
            t = title('Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)');
            set(t,'FontSize', FONTSIZE);
            legend('k * V(\lambda)', '(1- k) * V^{''}(\lambda)', 'k * V(\lambda) + (1- k) * V^{''}(\lambda)', 'Location', 'NorthEast');
            
            if(SAVE)
                saveas(gcf,'SyntheticSpectrum','fig');
                saveas(gcf,'SyntheticSpectrum','epsc');
            end
            
            
            
            
        end
        
        index = index + 1;
        
        
        % data.colorimetricData
    end
    [y, x] = max(Lmes(:, lumIndex));
    maxisX(lumIndex) = STEPWIDTH * (x - 1);
    maxisY(lumIndex) = y;
    
    [y, x] = max(LmesByRadiance(:, lumIndex));
    maxisXLbyR(lumIndex) = STEPWIDTH * (x - 1);
    maxisYLbyR(lumIndex) = y;
end


%%plots
FONTSIZE = 15;
LINEWIDTH = 1.2;
k = linspace(0, 1, NUMBER_OF_STEPS);

%%plot lMes, Lphot, Lscot
figure();
subplot(2, 1, 1);
plot(k, Lphot(:, 1));
hold on;
plot(k, Lmes(:, 1), '--');
plot(k, Lscot(:, 1), ':');
hold off;

x = xlabel('k');
set(x,'FontSize',FONTSIZE);
y = ylabel('L_{v}(k)');
set(y,'FontSize',FONTSIZE);
t = title('Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)');
set(t,'FontSize', FONTSIZE);
h = legend('photopic', 'mesopic', 'scotopic', 'Location', 'Best');
v = get(h,'title');
set(v,'string',sprintf('Target Luminance %1.1g cd/m^2', luminance(1)));

subplot(2, 1, 2);
plot(k, radiance(:, 1));
x = xlabel('k');
set(x,'FontSize',FONTSIZE);
y = ylabel('L_e(k)');
set(y,'FontSize',FONTSIZE);
t = title('Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)');
set(t,'FontSize', FONTSIZE);
h = legend('photopic', 'mesopic', 'scotopic', 'Location', 'Best');
v = get(h,'title');
set(v,'string',sprintf('Target Luminance %1.1g cd/m^2', luminance(1)));

%%plot Lmes
fig2 = figure();
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

plot(V_strich_2_V_ratio, Lmes);
%plot(V_strich_2_V_ratio, radiance);

hold on;
plot(maxisX, maxisY, 'o');
hold off;

x = xlabel('k');
set(x,'FontSize',FONTSIZE);
y = ylabel('L_{mes}(k)');
set(y,'FontSize',FONTSIZE);
t = title('Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)');
set(t,'FontSize', FONTSIZE);

legends = cell(len, 1);
for index = 1 : len
    legends{index} = sprintf('%3.3g cd/m^2', luminance(index));
    
    t = text(maxisX(index), maxisY(index), sprintf('%4.3G', maxisY(index)));
    
end
h = legend(legends, 'Location', 'NorthEastOutside');
v = get(h,'title');
set(v,'string','Photopic Luminance');

if(SAVE)
    saveas(gcf,'Lmes_SyntheticSpectrum','fig');
    saveas(gcf,'Lmes_SyntheticSpectrum','epsc');
end

%%plot Lmes divided by radiance
fig2 = figure();
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

plot(radiance);
%plot(V_strich_2_V_ratio, Lmes ./ radiance);
hold on;
%plot(maxisX, maxisY, 'o');
hold off;

x = xlabel('k');
set(x,'FontSize',FONTSIZE);
y = ylabel('$$\frac{L_{mes}}{Radiance}(k)$$ ');
set(y,'Interpreter','LaTeX','FontSize',FONTSIZE);
t = title('Synthetic Spectrum: ((1 - k) * V^{''}(\lambda) + k * V(\lambda)) / Radiance');
set(t,'FontSize', FONTSIZE)

legends = cell(len, 1);
for index = 1 : len
    legends{index} = sprintf('%3.3g cd/m^2', luminance(index));
    
    %t = text(maxisX(index), maxisY(index), sprintf('%4.3d', maxisY(index)));
    
end
h = legend(legends, 'Location', 'NorthEastOutside');
v = get(h,'title');
set(v,'string','Photopic Luminance');

if(SAVE)
    saveas(gcf,'Lmes_SyntheticSpectrum','fig');
    saveas(gcf,'Lmes_SyntheticSpectrum','epsc');
end


