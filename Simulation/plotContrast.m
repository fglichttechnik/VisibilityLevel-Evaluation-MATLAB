%preferences 
WIDTH = 740;
HEIGHT = 560;
FONTSIZE = 15;
FROM = -1;
TO = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot contrast of Lb
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

%data
Lt = 1;%[0.01; 0.1; 1; 10; 100];
Lb = logspace(FROM,TO,100);
%Lb = linspace(FROM,TO,100);
contrast = zeros([length(Lt),length(Lb)]);
for i = 1 : length(Lt)
    contrast(i, :) = (Lt(i) - Lb) ./ Lb;
end


%plot
%division = Lt ./ Lb;
%plot(division, fliplr(contrast),'LineWidth',1.2);
plot(Lb,contrast,'LineWidth',1.2);
pT = title('Weber Contrast');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_B \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('$$C(L_B) = \frac{L_t - L_B}{L_B}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);
%prepare legend
legends = cell(length(Lt),1);
for i = 1 : length(Lt)
    legends{i} = strcat('$$L_t = ',num2str(Lt(i)),' \frac{cd}{m^2}$$');
end
pL = legend(legends,'Location','NorthEast');
set(pL,'interpreter','LaTeX');

%save
saveas(gcf,'contrast_LB','epsc');
saveas(gcf,'contrast_LB','fig');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot contrast of Lt
fig1 = figure;
frame = get(fig1, 'Position');
set(fig1, 'Position', [frame(1), frame(2), WIDTH, HEIGHT])

%data
Lt = logspace(FROM,TO,100);
%Lt = linspace(FROM,TO,100);
Lb = 1;%[0.01; 0.1; 1; 10; 100];
contrast = zeros([length(Lt),length(Lb)]);
for i = 1 : length(Lb)
    contrast(:, i) = (Lt - Lb(i)) ./ Lb(i);
end

%plot
%plot(Lt ./ Lb, contrast,'LineWidth',1.2);
plot(Lt, contrast,'LineWidth',1.2);
pT = title('Weber Contrast');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('$$L_t \hspace{5pt}[\frac{cd}{m^2}]$$');
set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
% pX = xlabel('$$\frac{L_t}{L_B}$$');
% set(pX,'interpreter','LaTeX','FontSize',FONTSIZE);
pY = ylabel('$$C(L_t) = \frac{L_t - L_B}{L_B}$$');
set(pY,'interpreter','LaTeX','FontSize',FONTSIZE);

%prepare legend
legends = cell(length(Lb),1);
for i = 1 : length(Lb)
    legends{i} = strcat('$$L_B = ',num2str(Lb(i)),' \frac{cd}{m^2}$$');
end
pL = legend(legends,'Location','NorthWest');
set(pL,'interpreter','LaTeX');

%save
saveas(gcf,'contrast_Lt','epsc');
saveas(gcf,'contrast_Lt','fig');

