FONTSIZE = 15;
LINEWIDTH = 1.2;
WIDTH = 740;
HEIGHT = 560;
SP_LED = 1.71;
SAVE = 1;

ALPHADEGREES = 1.0;
AGE = 27;
T = 2.0;
K = 2.7;

LB_LED_phot = logspace(-1, 1, 100);
LB_LED_scot = LB_LED_phot * SP_LED;
[LB_LED_mes, imgVisualization] = mesopicLuminance_recommended(LB_LED_phot, LB_LED_scot);
Lt_LED_phot = 0.3;
Lt_LED_scot = Lt_LED_phot * SP_LED;
[Lt_LED_mes, imgVisualization] = mesopicLuminance_recommended(Lt_LED_phot, Lt_LED_scot);
deltaL_LED_phot = calcDeltaL(LB_LED_phot, Lt_LED_phot, ALPHADEGREES * 60, AGE, T ,K);
deltaL_LED_mes = calcDeltaL(LB_LED_mes, Lt_LED_mes, ALPHADEGREES * 60, AGE, T ,K);


contrast_LED_mes = deltaL_LED_mes ./ LB_LED_phot;   % ./ phot or ./ mes???
contrast_LED_phot = deltaL_LED_phot ./ LB_LED_phot;
deltaL_diff_LED = deltaL_LED_mes ./ deltaL_LED_phot * 100 - 100;
contrast_diff_LED = contrast_LED_mes ./ contrast_LED_phot * 100 - 100;

%%delta L threshold
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

pP = loglog(LB_LED_phot, deltaL_LED_phot, 'r','LineWidth', LINEWIDTH);

hold on;
pP = loglog(LB_LED_phot, deltaL_LED_mes, 'gr','LineWidth', LINEWIDTH);
%pP = loglog(LB_LED_mes, deltaL_LED_mes, 'b:','LineWidth', LINEWIDTH);
hold off;
% 
% 
pT = title(strcat('\Delta L_{thresh} K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(ALPHADEGREES),'^\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_{B, phot} \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('$$\Delta L_{th} = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);
legend('LED photopic','LED mesopic S/P = 1.71', 'Location', 'SouthEast');

if(SAVE)
    saveas(gcf,'deltaL_th_mesopic','epsc');
    saveas(gcf,'deltaL_th_mesopic','fig');
end

%%contrast threshold
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

pP = loglog(LB_LED_phot, contrast_LED_phot, 'r','LineWidth', LINEWIDTH);

hold on;
pP = loglog(LB_LED_phot, contrast_LED_mes, 'gr','LineWidth', LINEWIDTH);
%pP = loglog(LB_LED_mes, deltaL_LED_mes, 'b:','LineWidth', LINEWIDTH);
hold off;
% 
% 
pT = title(strcat('C_{th} K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(ALPHADEGREES),'^\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_{B, phot} \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('C_{th}');
set(pY, 'FontSize',FONTSIZE);
legend('LED photopic','LED mesopic S/P = 1.71', 'Location', 'SouthEast');

if(SAVE)
    saveas(gcf,'C_th_mesopic','epsc');
    saveas(gcf,'C_th_mesopic','fig');
end

%%Abweichung in %
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

pP = semilogx(LB_LED_phot, deltaL_diff_LED, 'c','LineWidth', LINEWIDTH);
hold on;

pP = semilogx(LB_LED_phot, contrast_diff_LED, 'm','LineWidth', LINEWIDTH);

%pP = loglog(LB_LED_mes, deltaL_LED_mes, 'b:','LineWidth', LINEWIDTH);
hold off;
% 
% 
pT = title(strcat('Difference in % K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(ALPHADEGREES),'^\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_{B, phot} \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('Difference in %');
set(pY, 'FontSize',FONTSIZE);
legend('\Delta L','C_{th}', 'Location', 'SouthEast');

if(SAVE)
    saveas(gcf,'deltaL_th_diff_mesopic','epsc');
    saveas(gcf,'deltaL_th_diff_mesopic','fig');
end
