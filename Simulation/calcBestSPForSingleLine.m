load V_CIE;
load V_strich_CIE;
SAVE = 1;
FONTSIZE = 14;

lambda = [380 : 780];
Ls_ = zeros(6, 401);
SP = zeros(1, 401);
Lv_mes = zeros(6, 401);
Lv_phot = zeros(6, 401);
Lv_scot = zeros(6, 401);
V_i = interp1(lambda_CIE, V, lambda);
V_strich_i = interp1(lambda_CIE, V_strich, lambda);
   
%%calc stuff

for i = 1 : length(lambda)
    Ls = Ls_;
    Ls(:, i) = 1;
    Ls(1, :) = Ls(1, :) * 0.3 / 683;
    Ls(2, :) = Ls(2, :) * 0.5 / 683;
    Ls(3, :) = Ls(3, :) * 0.75 / 683;
    Ls(4, :) = Ls(4, :) * 1.0 / 683;
    Ls(5, :) = Ls(5, :) * 1.5 / 683;
    Ls(6, :) = Ls(6, :) * 2.0 / 683;   

    Ls_V = zeros(6, 401);
    Ls_Vs = zeros(6,401);
    
    for j = 1 : 6
        Ls_V(j, :) = 683 * V_i .* Ls(j, :);
        Ls_Vs(j, :) = 1699 * V_strich_i .* Ls(j, :);        
        Lv_phot(j, i) = sum(Ls_V(j, :));
        Lv_scot(j, i) = sum(Ls_Vs(j, :));
    end
end

SP = Lv_scot(1, :) ./ Lv_phot(1, :);
SP = SP / max(SP);
[Lv_mes, image] = mesopicLuminance_recommended(Lv_phot, Lv_scot);


[ySP, iSP] = max(SP);
[yPhot, iPhot] = max(Lv_phot(1, :));
[yScot, iScot] = max(Lv_scot(1, :));
[yMes03, iMes03] = max(Lv_mes(1, :));
[yMes05, iMes05] = max(Lv_mes(2, :));
[yMes075, iMes075] = max(Lv_mes(3, :));
[yMes10, iMes10] = max(Lv_mes(4, :));
[yMes15, iMes15] = max(Lv_mes(5, :));
[yMes20, iMes20] = max(Lv_mes(6, :));

%%plot SP ( lambda)
figure();
plot(lambda, SP);
hold on;
stem(lambda(iSP), ySP);
t = text(lambda(iSP), ySP, sprintf('%4.0d', lambda(iSP)));
hold off;

pT = title('S/P Ratio of Line Spectrum Source');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('\lambda in nm');
set(pX,'FontSize',FONTSIZE);
pY = ylabel('S/P Ratio (\lambda)');
set(pY,'FontSize',FONTSIZE);

if(SAVE)
    saveas(gcf,'lineSpectrumSP','epsc');
    saveas(gcf,'lineSpectrumSP','fig');
end

%%plot Lv ( lambda)
figure();
plot(lambda, Lv_phot(1, :),'r');
hold on;
plot(lambda, Lv_mes(1, :),'gr');
plot(lambda, Lv_mes(2, :),'gr');
plot(lambda, Lv_mes(3, :),'gr');
plot(lambda, Lv_mes(4, :),'gr');
plot(lambda, Lv_mes(5, :),'gr');
plot(lambda, Lv_mes(6, :),'gr');
plot(lambda, Lv_scot(1, :),'b');
stem(lambda(iPhot), yPhot, 'r');
stem(lambda(iMes03), yMes03, 'gr');
stem(lambda(iMes05), yMes05, 'gr');
stem(lambda(iMes075), yMes075, 'gr');
stem(lambda(iMes10), yMes10, 'gr');
stem(lambda(iMes15), yMes15, 'gr');
stem(lambda(iMes20), yMes20, 'gr');
stem(lambda(iScot), yScot, 'b');
t = text(lambda(iPhot), yPhot, sprintf('%4.0d', lambda(iPhot)));
t = text(lambda(iMes03), yMes03, sprintf('%4.0d', lambda(iMes03)));
t = text(lambda(iMes05), yMes05, sprintf('%4.0d', lambda(iMes05)));
t = text(lambda(iMes075), yMes075, sprintf('%4.0d', lambda(iMes075)));
t = text(lambda(iMes10), yMes10, sprintf('%4.0d', lambda(iMes10)));
t = text(lambda(iMes15), yMes15, sprintf('%4.0d', lambda(iMes15)));
t = text(lambda(iMes20), yMes20, sprintf('%4.0d', lambda(iMes20)));
t = text(lambda(iScot), yScot, sprintf('%4.0d', lambda(iScot)));
hold off;
% legend(...
%     'photopic',...
%     'mesopic (L_{v,p} = 0.3 cd/m^2)',...
%     'mesopic (L_{v,p} = 0.5 cd/m^2)',...
%     'mesopic (L_{v,p} = 0.75 cd/m^2)',...
%     'mesopic (L_{v,p} = 1.0 cd/m^2)',...
%     'mesopic (L_{v,p} = 1.5 cd/m^2)',...
%     'mesopic (L_{v,p} = 2.0 cd/m^2)',...
%     'scotopic'...
%     'Location', 'NorthWest'...
%     );
legend(...
    'photopic',...
    'mesopic (ME6)',...
    'mesopic (ME5)',...
    'mesopic (ME4)',...
    'mesopic (ME3)',...
    'mesopic (ME2)',...
    'mesopic (ME1)',...
    'scotopic',...
    'Location', 'NorthEast'...
    );

pT = title('Luminance of Line Spectrum Source');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('\lambda in nm');
set(pX,'FontSize',FONTSIZE);
py = ylabel('$$\mbox{L}_{v}(\lambda) \hspace{5pt} \mbox{in} \hspace{5pt}  \frac{\mbox{cd}}{\mbox{m}^{2}}$$');
set(py,'Interpreter','LaTeX','FontSize',FONTSIZE);

if(SAVE)
    saveas(gcf,'lineSpectrumLuminance','epsc');
    saveas(gcf,'lineSpectrumLuminance','fig');
end


%%calc difference
indexCell = {...
    'Line Spectrum'...
    };

diffLmes_Of_ME6 = yMes03 ./ 0.3;
diffLmes_Of_ME5 = yMes05 ./ 0.5;
diffLmes_Of_ME4 = yMes075 ./ 0.75;
diffLmes_Of_ME3 = yMes10 ./ 1.0;
diffLmes_Of_ME2 = yMes15 ./ 1.5;
diffLmes_Of_ME1 = yMes20 ./ 2.0;

diffArray = [...
    diffLmes_Of_ME6;...
    diffLmes_Of_ME5;...
    diffLmes_Of_ME4;...
    diffLmes_Of_ME3;...   
    diffLmes_Of_ME2;...    
    diffLmes_Of_ME1;...
    ...
    ];
diffArray = (diffArray' - 1) * 100;

figure();
bar(diffArray);
legend(...
    sprintf('Line Source') ...
    );
pT = title('Difference L_{mes} to L_p');
set(pT,'FontSize',FONTSIZE);
pX = xlabel('Lighting Class');
set(pX,'FontSize',FONTSIZE);
pY = ylabel('Difference in %');
set(pY,'FontSize',FONTSIZE);
set(gca, 'XTickLabel', indexCell);

if(SAVE)
    saveas(gcf,'diff_mesopic_lineSource','epsc');
    saveas(gcf,'diff_mesopic_lineSource','fig');
end



