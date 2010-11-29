%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

age = 27;
t = 2;
k = 2.6;
%alpha = 0.01:.1:1000;

WIDTH = 740;
HEIGHT = 560;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over alpha for several Lb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

%alpha = logspace(-1,4,100);
alpha = logspace(1,3,100);
Lb = [0.01; 0.1; 0.3; 1; 3; 10; 100];
deltaL = zeros(length(Lb), length(alpha));

for i = 1 : length(Lb)
    deltaL(i,:) = calcDeltaL(Lb(i), alpha, age, t ,k);
end
pP = loglog(alpha,deltaL,'LineWidth',1.2);

pT = title(strcat('\Delta L, k=',num2str(k),' t=',num2str(t),' age=',num2str(age)));
set(pT,'FontSize',13);
pX = xlabel('Target size \alpha [min]');
set(pX,'FontSize',13);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L = L_t - L_B [\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX');
set(pY,'FontSize',13);
switch length(Lb)
    case 7
        legend1 = strcat(num2str(Lb(1)),' $$\frac{cd}{m^2}$$');
        legend2 = strcat(num2str(Lb(2)),' $$\frac{cd}{m^2}$$');
        legend3 = strcat(num2str(Lb(3)),' $$\frac{cd}{m^2}$$');
        legend4 = strcat(num2str(Lb(4)),' $$\frac{cd}{m^2}$$');
        legend5 = strcat(num2str(Lb(5)),' $$\frac{cd}{m^2}$$');
        legend6 = strcat(num2str(Lb(6)),' $$\frac{cd}{m^2}$$');
        legend7 = strcat(num2str(Lb(7)),' $$\frac{cd}{m^2}$$');
        pL = legend(legend1, legend2, legend3, legend4, legend5, legend6, legend7);
        set(pL,'interpreter','LaTeX');
end
%set(gca,'FontSize',13);

%set ticks at 1° 2° and 10°
%xTicks = get(gca,'XTick');

mini = min(min(deltaL));

text(60,mini,'1°');
text(120,mini,'2°');
text(600,mini,'10°');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cthresh over Lb for several alpha
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig2 = figure;
frame = get(fig2, 'Position');
set(fig2, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

alpha = [1; 2; 10; 20];
%Lb = logspace(-2,3,100);
Lb = logspace(-1,1,100);
deltaL = zeros(length(alpha),length(Lb));

for i = 1 : length(alpha)
    deltaL(i,:) = calcDeltaL(Lb, alpha(i) / 60, age, t ,k);
end
pP = loglog(Lb,deltaL,'LineWidth',1.2);

pT = title(strcat('\Delta L k=',num2str(k),' t=',num2str(t),' age=',num2str(age)));
set(pT,'FontSize',13);
pX = xlabel('$$L_B \frac{cd}{m^2}$$');
set(pX,'interpreter','LaTeX','FontSize',13);
%pY = ylabel('$$C_{th} = \frac{L_t - L_B}{L_t}$$');
pY = ylabel('$$\Delta L = L_t - L_B [\frac{cd}{m^2}]$$');
set(pY,'interpreter','LaTeX');
set(pY,'FontSize',13);
switch length(alpha)
    case 4
        legend1 = strcat(num2str(alpha(1)),' [°]');
        legend2 = strcat(num2str(alpha(2)),' [°]');
        legend3 = strcat(num2str(alpha(3)),' [°]');
        legend4 = strcat(num2str(alpha(4)),' [°]');
        pL = legend(legend1, legend2, legend3, legend4,'Location','NorthWest');
end




