%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%make plots similar to adrian 89 (based on ANSI IESNA RP 8 00)

AGE = 27;
T = 0.2;
K = 2.6;

%plot preferences
WIDTH = 740;
HEIGHT = 560;
FONTSIZE = 15;

%plot data close to street luminances or in a broader range
%'YES' or 'NO'
FOCUS_ON_STREET = 'NO';

%'RP800' or 'Adrian89'
CALCULATION_METHOD = 'RP800';

%analyze fahrradKeller plots range
%focus on street = NO
%pP =
%mesh(alphaMinutes(21:36),Lb(9:21),contrastThreshold(9:21,21:36),'LineWidth',1.2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over alpha for several Lb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

if (strcmp(FOCUS_ON_STREET,'YES'))
    alphaMinutes = logspace(1,3,100);
    Lb = logspace(-1,1,100);
else
    alphaMinutes = logspace(1,3,100);
    Lb = logspace(-3,1,100);
end

%

Lt = 10000.001;
deltaL = zeros(length(Lb), length(alphaMinutes));

for i = 1 : length(Lb)
    if( strcmp( CALCULATION_METHOD, 'Adrian89' ) )
        deltaL(i,:) = calcDeltaL(Lb(i), Lt, alphaMinutes, AGE, T ,K);
    elseif( strcmp( CALCULATION_METHOD, 'RP800' ) )
        for j = 1 : length( alphaMinutes )
            deltaL(i,j) = calcDeltaL_RP800(Lb(i), Lt, alphaMinutes(j), AGE, T ,K);
        end
    end
end

contrastThreshold = zeros(size(deltaL));
for i = 1 : length(deltaL)
    contrastThreshold(:, i) = deltaL(i, :) ./ Lb(i);
end

pP = mesh(alphaMinutes,Lb,contrastThreshold,'LineWidth',1.2);
%pP = mesh(alphaMinutes,Lb,deltaL,'LineWidth',1.2);
set(gca,'View',[70,26])

set(get(pP,'Parent'),'XScale','log','YScale','log');

pT = title(strcat('Contrast Threshold, K=',num2str(K),' T=',num2str(T),' AGE=',num2str(AGE)));
set(pT,'FontSize',FONTSIZE);

pX = xlabel('\alpha  [min]');
%set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
set(pX,'FontSize',FONTSIZE);

pY = ylabel('L_B [cd/m^2]');
%set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);
%set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
set(pY,'FontSize',FONTSIZE);

pZ = zlabel('C_{th}');
%set(pZ,'interpreter','LaTeX','FontSize',FONTSIZE);
%set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
set(pZ,'FontSize',FONTSIZE);

if (strcmp(FOCUS_ON_STREET,'YES'))
    set(gca, 'XTickLabel', {'10''', '100''', '16.67°'});
    set(gca, 'YTickLabel', [0.1, 1, 10]);
else
    set(gca, 'XTickLabel', {'10''', '100''', '16.67°'});
    set(gca, 'YTickLabel', [0.001, 0.01, 0.1, 1, 10]);
end

%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
%pY = ylabel('$$\Delta L = L_t - L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
%set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);


%prepare legend
% LbStrings = cell(length(Lb),1);
% for i = 1 : length(Lb)
%     LbStrings{i} = strcat(num2str(Lb(i)),' $$\frac{cd}{m^2}$$');
% end
% pL = legend(LbStrings,'Location','NorthEast');
% set(pL,'interpreter','LaTeX');
% v = get(pL,'title');
% set(v,'string','L_B');


%set ticks at 1° 2° and 10°
%xTicks = get(gca,'XTick');

% mini = min(min(deltaL));
%
% text(60,mini,'1°');
% text(120,mini,'2°');
% text(600,mini,'10°');

colorbar();

if (strcmp(FOCUS_ON_STREET,'YES'))
    saveas(gcf,'c_thresh_3D_street','epsc');
    saveas(gcf,'c_thresh_3D_street','fig');
else
    saveas(gcf,'c_thresh_3D','epsc');
    saveas(gcf,'c_thresh_3D','fig');
end