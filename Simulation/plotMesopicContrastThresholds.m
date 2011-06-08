%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%make plots similar to adrian 89
%adjusted to mesopic luminances

SAVE = 1;

AGE = 67;
T = 2;
K = 2.6;


%plot preferences
WIDTH = 740;
HEIGHT = 560;
FONTSIZE = 15;
LINEWIDTH = 1.2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over Lb for several alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alphaDegrees = 1;
Lt = 10000.001; %hack to make contrastThreshold think of positive contrast
Lb_continuous_photopic = logspace(-3,1,100);

%S/P ratios:
SP_Gas = 1.37;
SP_LM1 = 1.26;
SP_LM2 = 0.97;
SP_HM = 1.44;
SP_HS = 0.6;
SP_LED = 1.71;

%S/P ratios:
%incandescence: 0.38 (HOW DID I CALC THAT VALUE???)
%Lb_continuous_scotopic_incandescence = Lb_continuous_photopic * 0.38;
%[Lb_continuous_mesopic_incandescence, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_incandescence);
%LED
Lb_continuous_scotopic_LED = Lb_continuous_photopic * SP_LED;
[Lb_continuous_mesopic_LED, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_LED);
%HPS
Lb_continuous_scotopic_HS = Lb_continuous_photopic * SP_HS;
[Lb_continuous_mesopic_HS, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_HS);
%Gas
Lb_continuous_scotopic_Gas = Lb_continuous_photopic * SP_Gas;
[Lb_continuous_mesopic_Gas, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_Gas);
%LM1
Lb_continuous_scotopic_LM1 = Lb_continuous_photopic * SP_LM1;
[Lb_continuous_mesopic_LM1, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_LM1);
%LM2
Lb_continuous_scotopic_LM2 = Lb_continuous_photopic * SP_LM2;
[Lb_continuous_mesopic_LM2, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_LM2);
%HM
Lb_continuous_scotopic_HM = Lb_continuous_photopic * SP_HM;
[Lb_continuous_mesopic_HM, imgVisualization] = mesopicLuminance_recommended(Lb_continuous_photopic, Lb_continuous_scotopic_HM);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot ratio
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_incandescence ./ Lb_continuous_photopic, 'r');
% hold on;
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_LED ./ Lb_continuous_photopic, 'b');
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_HPS ./ Lb_continuous_photopic, 'y');
% hold off;
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

%loglog(Lb_continuous_photopic, Lb_continuous_mesopic_incandescence, 'r','LineWidth',1.2);
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_LED, 'b', 'LineWidth', LINEWIDTH);
% hold on;
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_HM, 'gr', 'LineWidth', LINEWIDTH);
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_Gas, 'k', 'LineWidth', LINEWIDTH);
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_LM1, 'c', 'LineWidth', LINEWIDTH);
% loglog(Lb_continuous_photopic, Lb_continuous_photopic, 'k--', 'LineWidth', LINEWIDTH);
% 
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_LM2, 'm', 'LineWidth', LINEWIDTH);
% loglog(Lb_continuous_photopic, Lb_continuous_mesopic_HS, 'y', 'LineWidth', LINEWIDTH);
% hold off;
LINEWIDTH = 1;
loglog(Lb_continuous_photopic, (Lb_continuous_mesopic_LED), 'b', 'LineWidth', LINEWIDTH);
hold on;
loglog(Lb_continuous_photopic, (Lb_continuous_mesopic_HM), 'gr', 'LineWidth', LINEWIDTH);
loglog(Lb_continuous_photopic, (Lb_continuous_mesopic_Gas), 'k', 'LineWidth', LINEWIDTH);
loglog(Lb_continuous_photopic, (Lb_continuous_mesopic_LM1), 'c', 'LineWidth', LINEWIDTH);
loglog(Lb_continuous_photopic, (Lb_continuous_photopic), 'k--', 'LineWidth', LINEWIDTH);

loglog(Lb_continuous_photopic, (Lb_continuous_mesopic_LM2), 'm', 'LineWidth', LINEWIDTH);
loglog(Lb_continuous_photopic, (Lb_continuous_mesopic_HS), 'y', 'LineWidth', LINEWIDTH);
hold off;
axis([0.5 3 0.1 3]);
pT = title('L_{mes} vs. L_{p}');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('L_{p}');
set(pX,'FontSize',FONTSIZE);
pY = ylabel('L_{mes}');
set(pY,'FontSize',FONTSIZE);
pL = legend(...
    sprintf('LED S/P: %1.3g',SP_LED), ...
    sprintf('HM  S/P: %1.3g',SP_HM), ...
    sprintf('Gas S/P: %1.3g',SP_Gas), ...
    sprintf('LM1 S/P: %1.3g',SP_LM1), ...
    'm=1', ...
    sprintf('LM2 S/P: %1.3g',SP_LM2), ...
    sprintf('HS  S/P: %1.3g',SP_HS), ...
    'Location','SouthEast');
v = get(pL,'title');
set(v,'string','Light Source');

if(SAVE)
    saveas(gcf,'Lmes_LB_mesopic','epsc');
    saveas(gcf,'Lmes_LB_mesopic','fig');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%interesting points
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 0,3
% 0,5
% 0,75
% 1
% 1,5
% 2
index03 = find(Lb_continuous_photopic > 0.3, 1, 'first');
index05 = find(Lb_continuous_photopic > 0.5, 1, 'first');
index075 = find(Lb_continuous_photopic > 0.75, 1, 'first');
index10 = find(Lb_continuous_photopic > 1.0, 1, 'first');
index15 = find(Lb_continuous_photopic > 1.5, 1, 'first');
index20 = find(Lb_continuous_photopic > 2.0, 1, 'first');

% indexCell = {...
%     'ME6 (0.3 cd/m^2)',...
%     'ME5 (0.5 cd/m^2)',...
%     'ME4 (0.75 cd/m^2)',...
%     'ME3 (1.0 cd/m^2)',...
%     'ME2 (1.5 cd/m^2)',...
%     'ME1 (2.0 cd/m^2)'...
%     };

indexCell = {...
    'ME6',...
    'ME5',...
    'ME4',...
    'ME3',...
    'ME2',...
    'ME1'...
    };

photopicL = [...
    Lb_continuous_photopic(index03),...
    Lb_continuous_photopic(index05),...
    Lb_continuous_photopic(index075),...
    Lb_continuous_photopic(index10),...
    Lb_continuous_photopic(index15),...
    Lb_continuous_photopic(index20),...
    ];
mesopicL_LED = [...
    Lb_continuous_mesopic_LED(index03),...
    Lb_continuous_mesopic_LED(index05),...
    Lb_continuous_mesopic_LED(index075),...
    Lb_continuous_mesopic_LED(index10),...
    Lb_continuous_mesopic_LED(index15),...
    Lb_continuous_mesopic_LED(index20),...
    ];
mesopicL_Gas = [...
    Lb_continuous_mesopic_Gas(index03),...
    Lb_continuous_mesopic_Gas(index05),...
    Lb_continuous_mesopic_Gas(index075),...
    Lb_continuous_mesopic_Gas(index10),...
    Lb_continuous_mesopic_Gas(index15),...
    Lb_continuous_mesopic_Gas(index20),...
    ];
mesopicL_LM1 = [...
    Lb_continuous_mesopic_LM1(index03),...
    Lb_continuous_mesopic_LM1(index05),...
    Lb_continuous_mesopic_LM1(index075),...
    Lb_continuous_mesopic_LM1(index10),...
    Lb_continuous_mesopic_LM1(index15),...
    Lb_continuous_mesopic_LM1(index20),...
    ];
mesopicL_LM2 = [...
    Lb_continuous_mesopic_LM2(index03),...
    Lb_continuous_mesopic_LM2(index05),...
    Lb_continuous_mesopic_LM2(index075),...
    Lb_continuous_mesopic_LM2(index10),...
    Lb_continuous_mesopic_LM2(index15),...
    Lb_continuous_mesopic_LM2(index20),...
    ];
mesopicL_HM = [...
    Lb_continuous_mesopic_HM(index03),...
    Lb_continuous_mesopic_HM(index05),...
    Lb_continuous_mesopic_HM(index075),...
    Lb_continuous_mesopic_HM(index10),...
    Lb_continuous_mesopic_HM(index15),...
    Lb_continuous_mesopic_HM(index20),...
    ];
mesopicL_HS = [...
    Lb_continuous_mesopic_HS(index03),...
    Lb_continuous_mesopic_HS(index05),...
    Lb_continuous_mesopic_HS(index075),...
    Lb_continuous_mesopic_HS(index10),...
    Lb_continuous_mesopic_HS(index15),...
    Lb_continuous_mesopic_HS(index20),...
    ];


%%Abweichung Lmes von Lp
diffLmes_Of_LP_LED = mesopicL_LED ./ photopicL;
diffLmes_Of_LP_Gas = mesopicL_Gas ./ photopicL;
diffLmes_Of_LP_LM1 = mesopicL_LM1 ./ photopicL;
diffLmes_Of_LP_LM2 = mesopicL_LM2 ./ photopicL;
diffLmes_Of_LP_HM = mesopicL_HM ./ photopicL;
diffLmes_Of_LP_HS = mesopicL_HS ./ photopicL;

diffArray = [...
    diffLmes_Of_LP_LED;...
    diffLmes_Of_LP_HM;...
    diffLmes_Of_LP_Gas;...
    diffLmes_Of_LP_LM1;...   
    diffLmes_Of_LP_LM2;...    
    diffLmes_Of_LP_HS;...
    ...
    ];
diffArray = (diffArray' - 1) * 100;

figure();
bar(diffArray);
legend(...
    sprintf('LED S/P: %1.3g',SP_LED), ...
    sprintf('HM  S/P: %1.3g',SP_HM), ...
    sprintf('Gas S/P: %1.3g',SP_Gas), ...
    sprintf('LM1 S/P: %1.3g',SP_LM1), ...
    sprintf('LM2 S/P: %1.3g',SP_LM2), ...
    sprintf('HS  S/P: %1.3g',SP_HS) ...
    );
pT = title('Difference L_{mes} to L_p');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Lighting Class');
set(pX,'FontSize',FONTSIZE);
pY = ylabel('Difference in %');
set(pY,'FontSize',FONTSIZE);
set(gca, 'XTickLabel', indexCell);

if(SAVE)
    saveas(gcf,'diff_mesopic','epsc');
    saveas(gcf,'diff_mesopic','fig');
end

%%Potential Aufrüstung von X auf LED
diffLmes_Gas_To_LED = mesopicL_LED ./ mesopicL_Gas;
diffLmes_LM1_To_LED = mesopicL_LED ./ mesopicL_LM1;
diffLmes_LM2_To_LED = mesopicL_LED ./ mesopicL_LM2;
diffLmes_HM_To_LED = mesopicL_LED ./ mesopicL_HM;
diffLmes_HS_To_LED = mesopicL_LED ./ mesopicL_HS;

upgradeArray = [...
    diffLmes_HM_To_LED;...
    diffLmes_Gas_To_LED;...
    diffLmes_LM1_To_LED;...
    diffLmes_LM2_To_LED;...    
    diffLmes_HS_To_LED;...
    ...
    ];
upgradeArray = (upgradeArray' - 1) * 100;

figure();
bar(upgradeArray);
legend(...
    sprintf('HM  S/P: %1.3g',SP_HM), ...
    sprintf('Gas S/P: %1.3g',SP_Gas), ...
    sprintf('LM1 S/P: %1.3g',SP_LM1), ...
    sprintf('LM2 S/P: %1.3g',SP_LM2), ...
    sprintf('HS  S/P: %1.3g',SP_HS) ...
    );
pT = title('Potential Savings when Upgrading to LED');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Lighting Class');
set(pX,'FontSize',FONTSIZE);
pY = ylabel('Savings in %');
set(pY,'FontSize',FONTSIZE);
set(gca, 'XTickLabel', indexCell);
set(gcf,'DefaultAxesColorOrder',[...
    0 1 0;...
    0 0 0;...
    0 1 1;...
    1 0 1;...
    1 1 0 ...
    ]);

if(SAVE)
    saveas(gcf,'potential_mesopic','epsc');
    saveas(gcf,'potential_mesopic','fig');
end

%axis([10^-1, 3, 10^-1 3]);
% h(1) = text('units','data', 'position',[.001 1], ...
%     'fontsize',14, 'interpreter','latex', 'string',...
%     ['$$L_p \left\{ {\matrix{ \cr'...
%     ' \cr  \cr \cr \cr \cr \cr \cr \cr} } \right.$$']);
% h(1) = text('units','data', 'position',[.001 0.1], ...
%     'fontsize',14, 'interpreter','latex', 'string',...
%     ['$$L_{mes} \left\{ {\matrix{ \cr'...
%     ' \cr  \cr \cr \cr \cr \cr \cr \cr} } \right.$$']);
% h(1) = text('units','data', 'position',[.0001 0.01], ...
%     'fontsize',14, 'interpreter','latex', 'string',...
%     ['$$L_s \left\{ {\matrix{ \cr'...
%     ' \cr  \cr \cr \cr \cr \cr \cr \cr} } \right.$$']);




% %luminance threshold
% fig2 = figure;
% frame = get(fig2, 'Position');
% set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])
% 
% deltaL = calcDeltaL(Lb_continuous_photopic, Lt, alphaDegrees * 60, AGE, T ,K);
% deltaLmesopic_incandesence = calcDeltaL(Lb_continuous_mesopic_incandescence, Lt, alphaDegrees * 60, AGE, T ,K);
% deltaLmesopic_LED = calcDeltaL(Lb_continuous_mesopic_LED, Lt, alphaDegrees * 60, AGE, T ,K);
% deltaLmesopic_HPS = calcDeltaL(Lb_continuous_mesopic_HPS, Lt, alphaDegrees * 60, AGE, T ,K);
% 
% % pP = loglog(Lb_continuous_mesopic_incandescence, deltaLmesopic_incandesence, 'o-r','LineWidth',1.2);
% % hold on;
% % pP = loglog(Lb_continuous_mesopic_LED ,deltaLmesopic_LED, 'o-b','LineWidth',1.2);
% % pP = loglog(Lb_continuous_mesopic_HPS, deltaLmesopic_HPS, 'o-y','LineWidth',1.2);
% % pP = loglog(Lb_continuous_photopic,deltaL, 'o-k','LineWidth',1.2);
% % hold off;
% 
% pP = loglog(Lb_continuous_photopic, deltaLmesopic_incandesence, 'r','LineWidth',1.2);
% hold on;
% pP = loglog(Lb_continuous_photopic, deltaLmesopic_LED, 'b','LineWidth',1.2);
% pP = loglog(Lb_continuous_photopic, deltaLmesopic_HPS, 'y','LineWidth',1.2);
% pP = loglog(Lb_continuous_photopic, deltaL, 'k','LineWidth',1.2);
% hold off;
% 
% pT = title(strcat('\Delta L_{thresh} K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(alphaDegrees),'^\circ'));
% set(pT,'FontSize',FONTSIZE);
% pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
% set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
% %pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
% pY = ylabel('$$\Delta L_{thresh} = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
% set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);
% 
% 
% %prepare legend
% pL = legend('Mesopic Incandescence','Mesopic LED','Mesopic HPS','Photopic','Location','SouthEast');
% set(pL,'interpreter','LaTeX');
% v = get(pL,'title');
% set(v,'string','Light Source');
% 
% if(SAVE)
% saveas(gcf,'deltaL_LB_mesopic','epsc');
% saveas(gcf,'deltaL_LB_mesopic','fig');
% end
% 
% 
% 
% %%same but for contrast threshold
% fig2 = figure;
% frame = get(fig2, 'Position');
% set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])
% 
% % contrastThreshold = deltaL ./ Lb_continuous_photopic;
% % contrastThreshold_mesopic_incandescence = deltaLmesopic_incandesence ./ Lb_continuous_photopic;
% % contrastThreshold_mesopic_LED = deltaLmesopic_LED ./ Lb_continuous_photopic;
% % contrastThreshold_mesopic_HPS = deltaLmesopic_HPS ./ Lb_continuous_photopic;
% 
% contrastThreshold = deltaL ./ Lb_continuous_photopic;
% contrastThreshold_mesopic_incandescence = deltaLmesopic_incandesence ./ Lb_continuous_mesopic_incandescence;
% contrastThreshold_mesopic_LED = deltaLmesopic_LED ./ Lb_continuous_mesopic_LED;
% contrastThreshold_mesopic_HPS = deltaLmesopic_HPS ./ Lb_continuous_mesopic_HPS;
% 
% % pP = loglog(Lb_continuous_mesopic_incandescence, contrastThreshold_mesopic_incandescence, 'r','LineWidth',1.2);
% % hold on;
% % pP = loglog(Lb_continuous_mesopic_LED, contrastThreshold_mesopic_LED, 'b','LineWidth',1.2);
% % pP = loglog(Lb_continuous_mesopic_HPS, contrastThreshold_mesopic_HPS, 'y','LineWidth',1.2);
% % pP = loglog(Lb_continuous_photopic, contrastThreshold, 'k','LineWidth',1.2);
% % hold off;
% 
% pP = loglog(Lb_continuous_photopic, contrastThreshold_mesopic_incandescence, 'r','LineWidth',1.2);
% hold on;
% pP = loglog(Lb_continuous_photopic, contrastThreshold_mesopic_LED, 'b','LineWidth',1.2);
% pP = loglog(Lb_continuous_photopic, contrastThreshold_mesopic_HPS, 'y','LineWidth',1.2);
% pP = loglog(Lb_continuous_photopic, contrastThreshold, 'k','LineWidth',1.2);
% hold off;
% 
% pT = title(strcat('C_{thresh} K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(alphaDegrees),'^\circ'));
% set(pT,'FontSize',FONTSIZE);
% pX = xlabel('$$L_{B} \hspace{5pt}[\frac{cd}{m^2}]$$');
% set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
% %pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
% pY = ylabel('$$C_{thresh}$$');
% set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);
% 
% pL = legend('Mesopic Incandescence','Mesopic LED','Mesopic HPS','Photopic','Location','SouthWest');
% set(pL,'interpreter','LaTeX');
% v = get(pL,'title');
% set(v,'string','Light Source');
% if(SAVE)
% saveas(gcf,'C_LB_mesopic','epsc');
% saveas(gcf,'C_LB_mesopic','fig');
% end
% 
