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

%plot data in close to street luminances or in a broader range
%'YES' or 'NO'
FOCUS_ON_STREET = 'NO';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over alpha for several Lb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

if (strcmp(FOCUS_ON_STREET,'YES'))
    alpha = logspace(1,3,100);
else
    alpha = logspace(-1,4,100);
end
%
Lb = [0.01; 0.1; 0.3; 1; 3; 10; 100];
Lt = 1;
deltaL = zeros(length(Lb), length(alpha));

for i = 1 : length(Lb)
    deltaL(i,:) = calcDeltaL(Lb(i), Lt, alpha, AGE, T ,K);
end
pP = loglog(alpha,deltaL,'LineWidth',1.2);

pT = title(strcat('\Delta L, K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Target size $$\alpha \hspace{5pt}[min]$$');
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

%set ticks at 1� 2� and 10�
%xTicks = get(gca,'XTick');

mini = min(min(deltaL));

text(60,mini,'1�');
text(120,mini,'2�');
text(600,mini,'10�');


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
pP = loglog(alpha,contrastThreshold,'LineWidth',1.2);

pT = title(strcat('\Delta L, K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Target size $$\alpha \hspace{5pt}[min]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);

%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$Contrast_{thresh}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
LbStrings = cell(length(Lb),1);
for i = 1 : length(Lb)
    LbStrings{i} = strcat(num2str(Lb(i)),' $$\frac{cd}{m^2}$$');
end
pL = legend(LbStrings,'Location','NorthEast');
set(pL,'interpreter','LaTeX');

%set ticks at 1� 2� and 10�
%xTicks = get(gca,'XTick');

mini = min(min(deltaL));

text(60,mini,'1�');
text(120,mini,'2�');
text(600,mini,'10�');


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


alpha = [1; 2; 10; 20];
Lt = 1;


if (strcmp(FOCUS_ON_STREET,'YES'))
    Lb = logspace(-1,1,100);
else
    Lb = logspace(-2,3,100);
end

deltaL = zeros(length(alpha),length(Lb));

for i = 1 : length(alpha)
    deltaL(i,:) = calcDeltaL(Lb, Lt, alpha(i) / 60, AGE, T ,K);
end
pP = loglog(Lb,deltaL,'LineWidth',1.2);

pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
alphaStrings = cell(length(alpha),1);
for i = 1 : length(alpha)
    alphaStrings{i} = strcat(num2str(alpha(i)),'$$ [^{\circ}]$$');
end
pL = legend(alphaStrings,'Location','NorthWest');
set(pL,'interpreter','LaTeX');

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
for i = 1 : length(alpha)
    contrastThreshold(i, :) = deltaL(i, :) ./ Lb;
end

pP = loglog(Lb,contrastThreshold,'LineWidth',1.2);

pT = title(strcat('\Delta L K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$C_{thresh}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
alphaStrings = cell(length(alpha),1);
for i = 1 : length(alpha)
    alphaStrings{i} = strcat(num2str(alpha(i)),'$$ [^{\circ}]$$');
end
pL = legend(alphaStrings,'Location','NorthWest');
set(pL,'interpreter','LaTeX');

if (strcmp(FOCUS_ON_STREET,'YES'))
    saveas(gcf,'contrast_LB_STREET','epsc');
    saveas(gcf,'contrast_LB_STREET','fig');
else
    saveas(gcf,'contrast_LB','epsc');
    saveas(gcf,'contrast_LB','fig');
end



