%%properties
NUMBER_OF_STEPS = 10;
STEPWIDTH = 1 / (NUMBER_OF_STEPS);% + 1);
WIDTH = 740;
HEIGHT = 560;
SAVE = 0;
FONTSIZE = 15;
LINEWIDTH = 1.2;

%%load some stuff
load 'V_strich_CIE.mat'  %load V_strich and lambda_CIE
load 'V_CIE.mat'  %load V and lambda_CIE
lambda_i = linspace(380, 780, 401);
V_strich_i = interp1(lambda_CIE, V_strich, lambda_i);
V_i = interp1(lambda_CIE, V, lambda_i);
k = linspace(0, 1, NUMBER_OF_STEPS + 1);

%%prepare
luminance = [0.3, 0.5, 0.75, 1.0, 1.5, 2.0, 5.0];
%luminance = [0.03, 0.05, 0.07, 0.08, 0.09, 0.1, 0.12];
%luminance = linspace(0.03, 0.3, 100);
labels = {...
    'ME6',...
    'ME5',...
    'ME4',...
    'ME3',...
    'ME2',...
    'ME1',...
    '',...
    };
%luminance = logspace(-1, 1, 6);
len = length(luminance);
Lmes = zeros(NUMBER_OF_STEPS, len);
Lphot = zeros(NUMBER_OF_STEPS, len);
Lscot = zeros(NUMBER_OF_STEPS, len);
LmesByRadiance = zeros(NUMBER_OF_STEPS, len);
V_strich_2_V_ratio = zeros(NUMBER_OF_STEPS, len);
radiance = zeros(NUMBER_OF_STEPS, len);

%len=1;
for lumIndex = 1 : len
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
        %maxiSpectrumAdjusted = max(spectrum_adjusted);
        
        %create CS2000Measurement
        data = CS2000Measurement();
        data.initWithSpectrum(spectrum_adjusted);
        
        %first adjustment to photopic luminance
        %currentRadiance = sum(spectrum_adjusted);
        currentLmes = data.colorimetricData.Lv_mesopic;
        currentLphot = data.colorimetricData.Lv;	%should be same as Lv_target
        currentLscot = data.colorimetricData.Lv_scotopic;
        currentLmesAdjustmentFactor = currentLphot / currentLmes;
        
        %if(currentLphot ~= Lv_target)
        %	disp('error: currentLphot != Lv_target');
        %exit();
        % end
        
        
        
        
        %second adjustment to mesopic luminance
        %find currentLmesAdjustmentFactor
        %optimum: Lv_mesopic = Lv_target
        spectrum_adjusted2 = spectrum_adjusted * currentLmesAdjustmentFactor;
        data2 = CS2000Measurement();
        data2.initWithSpectrum(spectrum_adjusted * currentLmesAdjustmentFactor);
        currentLphot = data2.colorimetricData.Lv;
        currentLmes = data2.colorimetricData.Lv_mesopic;
        currentLscot = data2.colorimetricData.Lv_scotopic;
        currentAdjustmentFactor = Lv_target / currentLmes;
        
        OPTIMUM_THRESH = 0.0001;
        currentWhileCriterion = 2 * OPTIMUM_THRESH; %we shall do this at least once
        count = 0;
        while (currentWhileCriterion > OPTIMUM_THRESH)
            
            spectrum_adjusted2 = spectrum_adjusted2 * currentAdjustmentFactor;
            data2 = CS2000Measurement();
            data2.initWithSpectrum(spectrum_adjusted2);
            currentLphot = data2.colorimetricData.Lv;
            currentLmes = data2.colorimetricData.Lv_mesopic;
            currentLscot = data2.colorimetricData.Lv_scotopic;
            currentAdjustmentFactor = Lv_target / currentLmes;
            currentWhileCriterion = abs(1 - currentAdjustmentFactor);
            count = count + 1;
            if(count > 1000)
                break;
            end
            
        end
        %disp(sprintf('%d iterations', count));
        
        Lmes(index, lumIndex) = currentLmes;
        Lphot(index, lumIndex) = currentLphot;
        Lscot(index, lumIndex) = currentLscot;
        
        %Lmes(index, lumIndex) = currentLmesAdjustmentFactor;
        %Lmes(index, lumIndex) = currentLmes / currentLphot;
        %radiance(index, lumIndex) = currentRadiance * currentLmesAdjustmentFactor;
        % V_strich_2_V_ratio(index, lumIndex) = V_strich_factor;
        % LmesByRadiance(index, lumIndex) = data.colorimetricData.Lv_mesopic  ./ radiance(index, lumIndex);
        % LmesByRadiance(index, lumIndex) = radiance(index, lumIndex);
        
        %radiance to generate Lmes at target level
        currentRadiance = sum(spectrum_adjusted2);
        radiance(index, lumIndex) = currentRadiance;
        
        
        if(lumIndex == -1)
            
            %     figure();
            %     plot(data);
            figure();
            plot(data.lambda, spectrum_V, 'r', 'LineWidth', LINEWIDTH);
            hold on;
            plot(data.lambda, spectrum_V_strich, 'LineWidth', LINEWIDTH);
            plot(data.lambda, spectrum, 'gr:', 'LineWidth', LINEWIDTH');
            hold off;
            
            x = xlabel('\lambda in nm');
            set(x,'FontSize',FONTSIZE);
            y = ylabel('{L}_{e,rel}(\lambda)');
            set(y, 'FontSize', FONTSIZE);
            t = title(['Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)', sprintf(' %s', labels{lumIndex})]);
            set(t,'FontSize', FONTSIZE);
            legend('k * V(\lambda)', '(1- k) * V^{''}(\lambda)', 'k * V(\lambda) + (1- k) * V^{''}(\lambda)', 'Location', 'NorthEast');
            
            text('units', 'normalized', 'Position',[0.7 0.2],'String',sprintf('L_{v,phot} = %1.3g cd/m^2', currentLphot));
            text('units', 'normalized', 'Position',[0.7 0.3],'String',sprintf('L_{v,mes} = %1.3g cd/m^2', currentLmes));
            text('units', 'normalized', 'Position',[0.7 0.4],'String',sprintf('L_{e} = %1.7g W/(sr m^2)', currentRadiance));
            
            if(SAVE)
                filename = ['SyntheticSpectrum_', num2str(k(index)*10, '%2.0g')];
                saveas(gcf,filename,'fig');
                saveas(gcf,filename,'epsc');
            end
            
            
            
            
        end
        
        index = index + 1;
        
        
        % data.colorimetricData
    end
%     [y, x] = max(Lmes(:, lumIndex));
%     maxisX(lumIndex) = STEPWIDTH * (x - 1);
%     maxisY(lumIndex) = y;
%     
%     [y, x] = max(LmesByRadiance(:, lumIndex));
%     maxisXLbyR(lumIndex) = STEPWIDTH * (x - 1);
%     maxisYLbyR(lumIndex) = y;

    [y, x] = min(radiance(:, lumIndex));
    currentStepWidth = STEPWIDTH * (x - 1);
    Le_min(lumIndex) = y;
    Lv_min(lumIndex) = luminance(lumIndex);
    k_min(lumIndex) = currentStepWidth;
end


%%plots
figure
plot(Le_min, k_min);


%%plot lMes, Lphot, Lscot

for index = 1 : len
    figure();
    subplot(2, 1, 1);
    plot(k, Lphot(:, index), 'r');
    hold on;
    plot(k, Lmes(:, index), 'gr');
    plot(k, Lscot(:, index), 'b');
    hold off;
    
    x = xlabel('k');
    set(x,'FontSize',FONTSIZE);
    y = ylabel('L_{v}(k) [cd/m^2]');
    set(y,'FontSize',FONTSIZE);
    t = title(['Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)', sprintf(' %s', labels{index})]);
    set(t,'FontSize', FONTSIZE);
    h = legend('photopic', 'mesopic', 'scotopic', 'Location', 'NorthEast');
    v = get(h,'title');
    %set(v,'string',sprintf('Target Luminance %1.1g cd/m^2', luminance(index)));
    
    subplot(2, 1, 2);
    plot(k, radiance(:, index));
    x = xlabel('k');
    set(x,'FontSize',FONTSIZE);
    y = ylabel('L_e(k) [W/(sr m^2)]');
    set(y,'FontSize',FONTSIZE);
    
    if(SAVE)
        filename = sprintf('SyntheticSpectrumLuminance_%s', labels{index});
        saveas(gcf,filename,'fig');
        saveas(gcf,filename,'epsc');
    end
end

% %%plot Lmes
% fig2 = figure();
% frame = get(fig2, 'Position');
% set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])
%
% plot(V_strich_2_V_ratio, Lmes);
% %plot(V_strich_2_V_ratio, radiance);
%
% hold on;
% plot(maxisX, maxisY, 'o');
% hold off;
%
% x = xlabel('k');
% set(x,'FontSize',FONTSIZE);
% y = ylabel('L_{mes}(k)');
% set(y,'FontSize',FONTSIZE);
% t = title('Synthetic Spectrum: (1 - k) * V^{''}(\lambda) + k * V(\lambda)');
% set(t,'FontSize', FONTSIZE);
%
% legends = cell(len, 1);
% for index = 1 : len
%     legends{index} = sprintf('%3.3g cd/m^2', luminance(index));
%
%     t = text(maxisX(index), maxisY(index), sprintf('%4.3G', maxisY(index)));
%
% end
% h = legend(legends, 'Location', 'NorthEastOutside');
% v = get(h,'title');
% set(v,'string','Photopic Luminance');
%
% if(SAVE)
%     saveas(gcf,'Lmes_SyntheticSpectrum','fig');
%     saveas(gcf,'Lmes_SyntheticSpectrum','epsc');
% end
%
% %%plot Lmes divided by radiance
% fig2 = figure();
% frame = get(fig2, 'Position');
% set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])
%
% plot(radiance);
% %plot(V_strich_2_V_ratio, Lmes ./ radiance);
% hold on;
% %plot(maxisX, maxisY, 'o');
% hold off;
%
% x = xlabel('k');
% set(x,'FontSize',FONTSIZE);
% y = ylabel('$$\frac{L_{mes}}{Radiance}(k)$$ ');
% set(y,'Interpreter','LaTeX','FontSize',FONTSIZE);
% t = title('Synthetic Spectrum: ((1 - k) * V^{''}(\lambda) + k * V(\lambda)) / Radiance');
% set(t,'FontSize', FONTSIZE)
%
% legends = cell(len, 1);
% for index = 1 : len
%     legends{index} = sprintf('%3.3g cd/m^2', luminance(index));
%
%     %t = text(maxisX(index), maxisY(index), sprintf('%4.3d', maxisY(index)));
%
% end
% h = legend(legends, 'Location', 'NorthEastOutside');
% v = get(h,'title');
% set(v,'string','Photopic Luminance');
%
% if(SAVE)
%     saveas(gcf,'Lmes_SyntheticSpectrum','fig');
%     saveas(gcf,'Lmes_SyntheticSpectrum','epsc');
% end
%
%
