%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%make plots similar to adrian 89
%adjusted to mesopic luminances

AGE = 27;
T = 2;
K = 2.6;

%plot preferences
WIDTH = 740;
HEIGHT = 560;
FONTSIZE = 15;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over Lb for several alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alphaDegrees = 1;
Lt = 10000.001; %hack to make contrastThreshold think of positive contrast

Lb_continuous = logspace(-2,3,100);

%S/P ratios:
%incandescence: 0.38
Lb_continuous_scotopic_incandescence = Lb_continuous * 0.38;
[Lb_continuous_mesopic_incandescence, imgVisualization] = mesopicLuminance_recommended(Lb_continuous, Lb_continuous_scotopic_incandescence);
%LED: 1.75
Lb_continuous_scotopic_LED = Lb_continuous * 1.75;
[Lb_continuous_mesopic_LED, imgVisualization] = mesopicLuminance_recommended(Lb_continuous, Lb_continuous_scotopic_LED);
%HPS: 0.61
Lb_continuous_scotopic_HPS = Lb_continuous * 0.61;
[Lb_continuous_mesopic_HPS, imgVisualization] = mesopicLuminance_recommended(Lb_continuous, Lb_continuous_scotopic_HPS);


%plot ratio
% figure
% loglog(Lb_continuous, Lb_continuous_mesopic_incandescence ./ Lb_continuous, 'r');
% hold on;
% loglog(Lb_continuous, Lb_continuous_mesopic_LED ./ Lb_continuous, 'b');
% loglog(Lb_continuous, Lb_continuous_mesopic_HPS ./ Lb_continuous, 'y');
% hold off;
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

loglog(Lb_continuous, Lb_continuous_mesopic_incandescence, 'r','LineWidth',1.2);
hold on;
loglog(Lb_continuous, Lb_continuous_mesopic_LED, 'b','LineWidth',1.2);
loglog(Lb_continuous, Lb_continuous_mesopic_HPS, 'y','LineWidth',1.2);
loglog(Lb_continuous, Lb_continuous, 'k','LineWidth',1.2);
hold off;
pT = title('L_{mes} vs. L_{p}');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('L_{p}');
set(pX,'FontSize',FONTSIZE);
pY = ylabel('L_{mes}');
set(pY,'FontSize',FONTSIZE);
pL = legend('Incandescence','LED','HPS','m=1','Location','SouthEast');
v = get(pL,'title');
set(v,'string','Light Source');

saveas(gcf,'Lmes_LB_mesopic','epsc');
saveas(gcf,'Lmes_LB_mesopic','fig');


%luminance threshold
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

deltaL = calcDeltaL(Lb_continuous, Lt, alphaDegrees * 60, AGE, T ,K);
deltaLmesopic_incandesence = calcDeltaL(Lb_continuous_mesopic_incandescence, Lt, alphaDegrees * 60, AGE, T ,K);
deltaLmesopic_LED = calcDeltaL(Lb_continuous_mesopic_LED, Lt, alphaDegrees * 60, AGE, T ,K);
deltaLmesopic_HPS = calcDeltaL(Lb_continuous_mesopic_HPS, Lt, alphaDegrees * 60, AGE, T ,K);

% pP = loglog(Lb_continuous_mesopic_incandescence, deltaLmesopic_incandesence, 'o-r','LineWidth',1.2);
% hold on;
% pP = loglog(Lb_continuous_mesopic_LED ,deltaLmesopic_LED, 'o-b','LineWidth',1.2);
% pP = loglog(Lb_continuous_mesopic_HPS, deltaLmesopic_HPS, 'o-y','LineWidth',1.2);
% pP = loglog(Lb_continuous,deltaL, 'o-k','LineWidth',1.2);
% hold off;

pP = loglog(Lb_continuous, deltaLmesopic_incandesence, 'r','LineWidth',1.2);
hold on;
pP = loglog(Lb_continuous, deltaLmesopic_LED, 'b','LineWidth',1.2);
pP = loglog(Lb_continuous, deltaLmesopic_HPS, 'y','LineWidth',1.2);
pP = loglog(Lb_continuous, deltaL, 'k','LineWidth',1.2);
hold off;

pT = title(strcat('\Delta L_{thresh} K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(alphaDegrees),'^\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L_{thresh} = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
pL = legend('Mesopic Incandescence','Mesopic LED','Mesopic HPS','Photopic','Location','SouthEast');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','Light Source');


saveas(gcf,'deltaL_LB_mesopic','epsc');
saveas(gcf,'deltaL_LB_mesopic','fig');




%%same but for contrast threshold
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

% contrastThreshold = deltaL ./ Lb_continuous;
% contrastThreshold_mesopic_incandescence = deltaLmesopic_incandesence ./ Lb_continuous;
% contrastThreshold_mesopic_LED = deltaLmesopic_LED ./ Lb_continuous;
% contrastThreshold_mesopic_HPS = deltaLmesopic_HPS ./ Lb_continuous;

contrastThreshold = deltaL ./ Lb_continuous;
contrastThreshold_mesopic_incandescence = deltaLmesopic_incandesence ./ Lb_continuous_mesopic_incandescence;
contrastThreshold_mesopic_LED = deltaLmesopic_LED ./ Lb_continuous_mesopic_LED;
contrastThreshold_mesopic_HPS = deltaLmesopic_HPS ./ Lb_continuous_mesopic_HPS;

% pP = loglog(Lb_continuous_mesopic_incandescence, contrastThreshold_mesopic_incandescence, 'r','LineWidth',1.2);
% hold on;
% pP = loglog(Lb_continuous_mesopic_LED, contrastThreshold_mesopic_LED, 'b','LineWidth',1.2);
% pP = loglog(Lb_continuous_mesopic_HPS, contrastThreshold_mesopic_HPS, 'y','LineWidth',1.2);
% pP = loglog(Lb_continuous, contrastThreshold, 'k','LineWidth',1.2);
% hold off;

pP = loglog(Lb_continuous, contrastThreshold_mesopic_incandescence, 'r','LineWidth',1.2);
hold on;
pP = loglog(Lb_continuous, contrastThreshold_mesopic_LED, 'b','LineWidth',1.2);
pP = loglog(Lb_continuous, contrastThreshold_mesopic_HPS, 'y','LineWidth',1.2);
pP = loglog(Lb_continuous, contrastThreshold, 'k','LineWidth',1.2);
hold off;

pT = title(strcat('C_{thresh} K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), ' Alpha=', num2str(alphaDegrees),'^\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_{B} \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$C_{thresh}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);

pL = legend('Mesopic Incandescence','Mesopic LED','Mesopic HPS','Photopic','Location','SouthWest');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','Light Source');

saveas(gcf,'C_LB_mesopic','epsc');
saveas(gcf,'C_LB_mesopic','fig');