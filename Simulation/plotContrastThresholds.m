%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%make plots similar to adrian 89

AGE = 27;
T = 2;
K = 2.6;

%plot preferences
WIDTH = 740;
HEIGHT = 560;
FONTSIZE = 15;

%plot data close to street luminances or in a broader range
%'YES' or 'NO'
FOCUS_ON_STREET = 'NO';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over alpha for several Lb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

if (strcmp(FOCUS_ON_STREET,'YES'))
    alphaMinutes = logspace(1,3,100);
else
    alphaMinutes = logspace(-1,4,100);
end
%
Lb = [0.01; 0.1; 0.3; 1; 3; 10; 100];
Lt = 10000.001;
deltaL = zeros(length(Lb), length(alphaMinutes));

for i = 1 : length(Lb)
    deltaL(i,:) = calcDeltaL(Lb(i), Lt, alphaMinutes, AGE, T ,K);
end
pP = loglog(alphaMinutes,deltaL,'LineWidth',1.2);

pT = title(strcat('\Delta L, K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Target Size $$\alpha \hspace{5pt}[min]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);

%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
LbStrings = cell(length(Lb),1);
for i = 1 : length(Lb)
    LbStrings{i} = strcat(num2str(Lb(i)),' $$\frac{cd}{m^2}$$');
end
pL = legend(LbStrings,'Location','NorthEast');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','L_B');


%set ticks at 1° 2° and 10°
%xTicks = get(gca,'XTick');

mini = min(min(deltaL));

text(60,mini,'1°');
text(120,mini,'2°');
text(600,mini,'10°');


if (strcmp(FOCUS_ON_STREET,'YES'))
    saveas(gcf,'deltaL_alpha_STREET','epsc');
    saveas(gcf,'deltaL_alpha_STREET','fig');
else
    saveas(gcf,'deltaL_alpha','epsc');
    saveas(gcf,'deltaL_alpha','fig');
end

%%%%%%%%%%%%%%%%%%%%%%%%%
%same plot but contrast threshold
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

contrastThreshold = zeros(size(deltaL));
for i = 1 : length(deltaL)
    contrastThreshold(:, i) = deltaL(:, i) ./ Lb;
end
pP = loglog(alphaMinutes,contrastThreshold,'LineWidth',1.2);

pT = title(strcat('C_{thresh}, K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Target Size $$\alpha \hspace{5pt}[min]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);

%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$C_{thresh}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
LbStrings = cell(length(Lb),1);
for i = 1 : length(Lb)
    LbStrings{i} = strcat(num2str(Lb(i)),' $$\frac{cd}{m^2}$$');
end
pL = legend(LbStrings,'Location','NorthEast');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','L_B');

%set ticks at 1° 2° and 10°
%xTicks = get(gca,'XTick');

mini = min(min(deltaL));

text(60,mini,'1°');
text(120,mini,'2°');
text(600,mini,'10°');


if (strcmp(FOCUS_ON_STREET,'YES'))
    saveas(gcf,'contrast_alpha_STREET','epsc');
    saveas(gcf,'contrast_alpha_STREET','fig');
else
    saveas(gcf,'contrast_alpha','epsc');
    saveas(gcf,'contrast_alpha','fig');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over Lb for several alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])


alphaDegrees = [1; 2; 10; 20];
Lt = 10000.001;


if (strcmp(FOCUS_ON_STREET,'YES'))
    Lb_continuous = logspace(-1,1,100);
else
    Lb_continuous = logspace(-2,3,100);
end

deltaL = zeros(length(alphaDegrees),length(Lb_continuous));

for angleI = 1 : length(alphaDegrees)
    deltaL(angleI,:) = calcDeltaL(Lb_continuous, Lt, alphaDegrees(angleI) * 60, AGE, T ,K);
end
pP = loglog(Lb_continuous,deltaL,'LineWidth',1.2);

pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
alphaStrings = cell(length(alphaDegrees),1);
for i = 1 : length(alphaDegrees)
    alphaStrings{i} = strcat(num2str(alphaDegrees(i)),'$$ [^{\circ}]$$');
end
pL = legend(alphaStrings,'Location','NorthWest');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','alpha');

if (strcmp(FOCUS_ON_STREET,'YES'))
    saveas(gcf,'deltaL_LB_STREET','epsc');
    saveas(gcf,'deltaL_LB_STREET','fig');
else
    saveas(gcf,'deltaL_LB','epsc');
    saveas(gcf,'deltaL_LB','fig');
end


%%same but for contrast threshold
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

contrastThreshold = zeros(size(deltaL));
for i = 1 : length(alphaDegrees)
    contrastThreshold(i, :) = deltaL(i, :) ./ Lb_continuous;
end

pP = loglog(Lb_continuous,contrastThreshold,'LineWidth',1.2);

pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_{B} \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$C_{thresh}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
alphaStrings = cell(length(alphaDegrees),1);
for i = 1 : length(alphaDegrees)
    alphaStrings{i} = strcat(num2str(alphaDegrees(i)),'$$ [^{\circ}]$$');
end
pL = legend(alphaStrings,'Location','SouthWest');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','alpha');

if (strcmp(FOCUS_ON_STREET,'YES'))
    saveas(gcf,'contrast_LB_STREET','epsc');
    saveas(gcf,'contrast_LB_STREET','fig');
else
    saveas(gcf,'contrast_LB','epsc');
    saveas(gcf,'contrast_LB','fig');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% age  plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AGE_continuous = 27:74;
deltaLAge = zeros(1, length(AGE_continuous));
for i = 1 : length(AGE_continuous)
    deltaLAge(1,i) = calcDeltaL(1, Lt, 60, AGE_continuous(i), T ,K);
end
pP = plot(AGE_continuous,deltaLAge,'LineWidth',1.2);
pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$Age [Years]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


saveas(gcf,'deltaL_Age','epsc');
saveas(gcf,'deltaL_Age','fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% age comparison plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AGE2 = 60;
AGE3 = 70;
deltaLAge2 = calcDeltaL(Lb_continuous, Lt, 60, AGE2, T ,K);
deltaLAge3 = calcDeltaL(Lb_continuous, Lt, 60, AGE3, T ,K);
pP = loglog(Lb_continuous,deltaL(1,:),'LineWidth',1.2);
hold on;
pP = loglog(Lb_continuous,deltaLAge2(1,:), ':','LineWidth',1.2);
pP = loglog(Lb_continuous,deltaLAge3(1,:), '--','LineWidth',1.2);
hold off;
pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' alpha=1\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_{B} \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
ageStrings = cell(3,1);
ageStrings{1} = strcat(num2str(AGE));
ageStrings{2} = strcat(num2str(AGE2));
ageStrings{3} = strcat(num2str(AGE3));
pL = legend(ageStrings,'Location','NorthWest');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','Age');

saveas(gcf,'deltaL_AgeComp','epsc');
saveas(gcf,'deltaL_AgeComp','fig');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% negative contrast comparison plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lt_negativeC = 0.001;

Lb_continuous = logspace(-2,3,100);

alphaDegrees = alphaDegrees(1);

deltaL = zeros(length(alphaDegrees),length(Lb_continuous));
deltaLneg = zeros(length(alphaDegrees),length(Lb_continuous));

for angleI = 1 : length(alphaDegrees)
    deltaLneg(angleI,:) = calcDeltaL(Lb_continuous, Lt_negativeC, alphaDegrees(angleI) * 60, AGE, T ,K);
end
for angleI = 1 : length(alphaDegrees)
    deltaL(angleI,:) = calcDeltaL(Lb_continuous, Lt, alphaDegrees(angleI) * 60, AGE, T ,K);
end

pP = loglog(Lb_continuous,deltaL,'LineWidth',1.2);
hold on;
pP = loglog(Lb_continuous,deltaLneg, ':','LineWidth',1.2);
hold off;

pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE), 'Alpha=1\circ'));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);

%prepare legend
alphaStrings = cell(2,1);
alphaStrings{1} = strcat('Positive Contrast');
alphaStrings{2} = strcat('Negative Contrast');

pL = legend(alphaStrings,'Location','NorthWest');
set(pL,'interpreter','LaTeX');
v = get(pL,'title');
set(v,'string','alpha');
saveas(gcf,'deltaL_LB_neg','epsc');
saveas(gcf,'deltaL_LB_neg','fig');

