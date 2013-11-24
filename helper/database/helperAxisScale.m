%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
compareBatchSet = {
    
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_Left';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_Right';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_Upper';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_Lower';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_RP800';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_City';
                
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Licht_R2';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Licht';
    
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_City';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_R3';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_R2';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_T1';

     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_R1';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_R2';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_R3';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_R4';
     
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_BRDF';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Plastic';

     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Dirt_4';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Dirt_26';    
   
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_LED_Ori_Left';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_LED_Ori_Right';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_LED_Ori_Upper';
     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_LED_Ori_Lower';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_LED_Ori_RP800';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_LED_Ori_City';
    
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Amb_City';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Amb_R3';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Amb_R2';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Amb_T1';

     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_R1';
     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_R2';
     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_R4';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_BRDF';
     %'/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Plastic';

     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Dirt_4';
     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Dirt_26';

     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_R2_Dirt_2';
     '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_R2_Dirt_3';
     
    };
%('/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Plastic/ComparePlot/LtPlot_Treskowstr_Plastic.fig'

batchCount = length( compareBatchSet );

for currentIndex = 1 : batchCount
    close all;
    currentFolderPath = compareBatchSet{ currentIndex };
    
   %platform specific path delimiter
    if(ispc)
        DELIMITER = '\';
    elseif(isunix)
        DELIMITER = '/';
    end

    %we need the last path component for filename of plots
    [ firstPath, lastPathComponent, fileExtension ] = fileparts( currentFolderPath );

    %load the data from fig
    uiopen([currentFolderPath, DELIMITER,'ComparePlot', DELIMITER, 'LTPlot_',lastPathComponent,'.fig'],'-mat');
    %disp('Daten erfolgreich eingeladen'); 
    %Größtes Y-Element aus figure laden und im A Array speichern
    %obj = get(gca,'Children');
    %ycell = get(obj,'YData');
    ycell = get(findobj(get(gca,'Children'),'type','line'),'YData');
    ymax = max(max(cell2mat(ycell)));
    A(currentIndex) = ymax;
    disp(['Datensatz ', lastPathComponent, ' erfolgreich eingeladen']); 
end
ScaleFactorY = max(A);
disp(['Y-Skalierungsfaktor: ', num2str(ScaleFactorY) ]); 

for currentIndex2 = 1 : batchCount
    close all;
    currentFolderPath = compareBatchSet{ currentIndex2 };
    
     %platform specific path delimiter
    if(ispc)
        DELIMITER = '\';
    elseif(isunix)
        DELIMITER = '/';
    end

    %we need the last path component for filename of plots
    [ firstPath, lastPathComponent, fileExtension ] = fileparts( currentFolderPath );

    %load the data from fig
    %figLt = figure();
    uiopen([currentFolderPath, DELIMITER,'ComparePlot', DELIMITER, 'LTPlot_',lastPathComponent,'.fig'],'-mat');
    a=get(gca,'XLim'); 
    set(gca,'YLim',[0 ScaleFactorY]); % Neue Grenzen für den Y wert der Plots 
    set(gca,'XLim',a);
    
    %save Plots Again
    filename = sprintf( '%s%sComparePlot%sLTPlotAxis_%s', currentFolderPath, DELIMITER, DELIMITER, lastPathComponent );
    saveas(gca, filename, 'epsc');
    saveas(gca, filename, 'fig');
    fixPSlinestyle( sprintf( '%s.eps', filename ) );
    
    %convert to pdf
    pathToEPSFiles = sprintf( '%s%sComparePlot%s', currentFolderPath, DELIMITER, DELIMITER );
    system( sprintf( 'apply /usr/texbin/epstopdf %s*.eps', pathToEPSFiles ) );
    system( sprintf( 'rm %s*.eps', pathToEPSFiles ) );
    disp(['Datensatz ', lastPathComponent, ' erfolgreich neu gespeichert']);    
end

clearvars A ScaleFactorY;