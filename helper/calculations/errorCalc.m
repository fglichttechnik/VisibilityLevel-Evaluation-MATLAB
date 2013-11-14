%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.
function errorCalc( PATH );

%PATH = '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Weefstr_Test_Plot';


XMLFILENAME = 'CompareSet.xml'; %best to name all sets the same

CONVERT_TO_PDF = 1; %set this to 0 if you don't have epstopdf


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%no changes have to be done below

%platform specific path delimiter
if(ispc)
    DELIMITER = '\';
elseif(isunix)
    DELIMITER = '/';
end

%we need the last path component for filename of plots
[ firstPath, lastPathComponent, fileExtension ] = fileparts( PATH );

%%READ XML
fileName = sprintf( '%s%s%s', PATH, DELIMITER, XMLFILENAME );
xDoc = xmlread( fileName );

allDataSetItems = xDoc.getElementsByTagName('DataSets');
allDataSetItemsLength = allDataSetItems.getLength;

if (~allDataSetItemsLength)
    disp('NO DATA FOUND, QUITTING');
end



for k = 0 : allDataSetItemsLength - 1
    thisDataSetsItem = allDataSetItems.item(k);
    
    
    % Get the label element. In this file, each
    % listitem contains only one label.
    thisDataSet = thisDataSetsItem.getElementsByTagName('DataSet');
    thisDataSetLength = thisDataSet.getLength;
    
    %prepare data
    pathesForDatasets = cell( thisDataSetLength, 1 );
    subPathesForDatasets = cell( thisDataSetLength, 1 );
    legendsForDatasets = cell( thisDataSetLength, 1 );
    colorArrayForPlots = cell( thisDataSetLength, 1 );
    typeArrayForPlots = cell( thisDataSetLength, 1 );
    evalTypeArrayForPlots = cell( thisDataSetLength, 1 );
    customCodeString = '';
    
    for elementsIndex = 0 : thisDataSetLength - 1
        
        thisElement = thisDataSet.item(elementsIndex);
        
        attributes = parseAttributes( thisElement );
        
        attributeslength = length(attributes);
        for attIndex = 1 : attributeslength
            currentAttribute = attributes( attIndex );
            if( strcmp( currentAttribute.Name, 'Path' ) )
                pathesForDatasets{ elementsIndex + 1 } = currentAttribute.Value;
            elseif( strcmp( currentAttribute.Name, 'Legend' ) )
                legendsForDatasets{ elementsIndex + 1 } = currentAttribute.Value;
            elseif( strcmp( currentAttribute.Name, 'Color' ) )
                colorArrayForPlots{ elementsIndex + 1 } = currentAttribute.Value;
            elseif( strcmp( currentAttribute.Name, 'SubPath' ) )
                subPathesForDatasets{ elementsIndex + 1 } = currentAttribute.Value;
            elseif( strcmp( currentAttribute.Name, 'Type' ) )
                typeArrayForPlots{ elementsIndex + 1 } = currentAttribute.Value;
            elseif( strcmp( currentAttribute.Name, 'EvaluationType' ) )
                evalTypeArrayForPlots{ elementsIndex + 1 } = currentAttribute.Value;
            end
        end
    end
end

%%PLOTTING
numberOfDatasets = length( pathesForDatasets );
numberOfColors = length( colorArrayForPlots );
arrayWithSetStatistics = cell( numberOfDatasets, 1 );

%load data
for currentDatasetIndex = 1 : numberOfDatasets
    
    currentPath = sprintf( '%s%s', pathesForDatasets{ currentDatasetIndex }, subPathesForDatasets{ currentDatasetIndex } );
    currentType = typeArrayForPlots{ currentDatasetIndex };
    currentEvalType = evalTypeArrayForPlots{ currentDatasetIndex };
    if( currentEvalType )
        filePath = sprintf( '%s%sphotopicSetStatistics_%s.mat', currentPath, DELIMITER, currentEvalType );
    else
        filePath = sprintf( '%s%sphotopicSetStatistics.mat', currentPath, DELIMITER );
    end
        load( filePath );
        arrayWithSetStatistics{ currentDatasetIndex } = photopicLMK_Image_Set_Statistics;
end

%we don't like too much data in memory
%shouldn't have been saved in the first place...
photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;

%load data LT and LB in an array
for currentDatasetIndex = 1 : numberOfDatasets
    
    currentSetStatistics = arrayWithSetStatistics{ currentDatasetIndex };
    LT{ currentDatasetIndex } = currentSetStatistics.meanTargetArray;
    LB{ currentDatasetIndex } = currentSetStatistics.meanBackgroundArray;

end

%##########################################################################
%
%
%                           Calculation
%
%
%##########################################################################

%save and show correlation from first and second DataSet
disp([' ']);
disp(['__________________________errorCalc.m_________________________']);
disp([PATH]);
disp([legendsForDatasets{1}, ' und ', legendsForDatasets{2}]);
disp(['______________________________________________________________']);


CorrLT = corrcoef(LT{1},LT{2});
disp(['Korrelation der Target Leuchtdichte: ', sprintf('%2.3f',CorrLT(2,1))]);

CorrLB = corrcoef(LB{1},LB{2});
disp(['Korrelation der Hintergrund Leuchtdichte: ', sprintf('%2.3f',CorrLB(2,1))]);

%absolute difference LB and LT (Messung - Simulation) 

absAbLB = LB{1} - LB{2};
absAbLT = LT{1} - LT{2};

%Varianz und Standardabweichung des relativen Fehlers 

disp(['Varianz der Hintergrundleuchtdichte: ', num2str(var(absAbLB))]);
disp(['Standardabweichung der Hintergrundleuchtdichte: ', num2str(std(absAbLB))]);

disp(['Varianz der Targetleuchtdichte: ', num2str(var(absAbLT))]);
disp(['Standardabweichung der Taregtleuchtdichte: ', num2str(std(absAbLT))]);
%relative difference LB and LT bezogen auf die Messung in procent positiv

relAbLB = abs((LB{1} - LB{2})*100 ./ LB{2}); 
relAbLT = abs((LT{1} - LT{2})*100 ./ LT{2});

%Ausgabe des Mittelwertes der relativen Abweichung

disp(['Mittelwert der relativen prozentualen Abweichung der Hintergrundleuchtdichte: ', sprintf('%3.1f',mean(relAbLB))]);
disp(['Mittelwert der relativen prozentualen Abweichung der Targetleuchtdichte: ', sprintf('%3.1f',mean(relAbLT))]);

%##########################################################################
%
%
%                           Plots und Design
%
%
%##########################################################################

%create folder for plot data
if ( ~exist( sprintf( '%s%sComparePlotError', PATH, DELIMITER ), 'dir' ) )
    mkdir( sprintf( '%s%sComparePlotError', PATH, DELIMITER ) );
end

%Plot für die absolute Abweichung des Hintergrunds
absLB = figure();

p = plot(currentSetStatistics.distanceArray, absAbLB);
%legend('L_t','L_B');

% Textbeschriftung der Plots mit Position  
str = ['Korrelation LB: ', sprintf('%2.2f',CorrLB(2,1))];
text(0.05,0.95,str,...
    'Interpreter', 'tex',...
    'Units', 'normalized',...
    'Color',[0.1 0.1 0.1],...
    'FontSize', 14,...
    'BackgroundColor',[1 1 1],...
    'EdgeColor',[0 0 0],...
    'LineWidth',1,...
    'LineStyle','-'); 

axis('tight');
x = xlabel('d in m');
y = ylabel('L in cd/m^2');
t = title(strcat('Plot für die absolute Abweichung des Hintergrunds') );
finetunePlot( absLB );

%save Plot
filename = sprintf( '%s%sComparePlotError%serrorAbsLB_%s', PATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(absLB, filename, 'epsc');
saveas(absLB, filename, 'fig');
fixPSlinestyle( sprintf( '%s.eps', filename ) );

%Plot für die absolute Abweichung des Targets
absLT = figure();

p = plot(currentSetStatistics.distanceArray, absAbLT);
%legend('L_t','L_B');

% Textbeschriftung der Plots mit Position
str = ['Korrelation LT: ', sprintf('%2.2f',CorrLT(2,1))];
text(0.05,0.95,str,...
    'Interpreter', 'tex',...
    'Units', 'normalized',...
    'Color',[0.1 0.1 0.1],...
    'FontSize', 14,...
    'BackgroundColor',[1 1 1],...
    'EdgeColor',[0 0 0],...
    'LineWidth',1,...
    'LineStyle','-'); 

axis('tight');
x = xlabel('d in m');
y = ylabel('L in cd/m^2');
t = title(strcat('Plot für die absolute Abweichung des Targets') );
finetunePlot( absLT );

%save Plot
filename = sprintf( '%s%sComparePlotError%serrorAbsLT_%s', PATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(absLT, filename, 'epsc');
saveas(absLT, filename, 'fig');
fixPSlinestyle( sprintf( '%s.eps', filename ) );

%Plot für die relative Abweichung des Hintergrunds 
relLB = figure();

p = bar(currentSetStatistics.distanceArray, relAbLB);
%legend('L_t','L_B');

% Textbeschriftung der Plots mit Position

str = ['Korrelation LB: ', sprintf('%2.2f',CorrLB(2,1)),'\newlineMittelwert LB: ', sprintf('%3.1f',mean(relAbLB)),' %']; 
text(0.05,0.9,str,...
    'Interpreter', 'tex',...
    'Units', 'normalized',...
    'Color',[0.1 0.1 0.1],...
    'FontSize', 14,...
    'BackgroundColor',[1 1 1],...
    'EdgeColor',[0 0 0],...
    'LineWidth',1,...
    'LineStyle','-'); 

axis('tight');
x = xlabel('d in m');
y = ylabel('L in %');
t = title(strcat('Plot für die relative Abweichung des Hintergrunds') );
finetunePlot( relLB );

%save Plot
filename = sprintf( '%s%sComparePlotError%serrorRelLB_%s', PATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(relLB, filename, 'epsc');
saveas(relLB, filename, 'fig');
fixPSlinestyle( sprintf( '%s.eps', filename ) );

%Plot für die absolute Abweichung des Targets
relLT = figure();

p = bar(currentSetStatistics.distanceArray, relAbLT);
%legend('L_t','L_B');

% Textbeschriftung der Plots mit Position

str = ['Korrelation LT: ',sprintf('%2.2f',CorrLT(2,1)),'\newlineMittelwert LT: ', sprintf('%3.1f',mean(relAbLT)),' %']; 
text(0.05,0.9,str,...
    'Interpreter', 'tex',...
    'Units', 'normalized',...
    'Color',[0.1 0.1 0.1],...
    'FontSize', 14,...
    'BackgroundColor',[1 1 1],...
    'EdgeColor',[0 0 0],...
    'LineWidth',1,...
    'LineStyle','-'); 

axis('tight');
x = xlabel('d in m');
y = ylabel('L in %');
t = title(strcat('Plot für die relative Abweichung des Targets') );
finetunePlot( relLT );

%save Plot
filename = sprintf( '%s%sComparePlotError%serrorRelLT_%s', PATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(relLT, filename, 'epsc');
saveas(relLT, filename, 'fig');
fixPSlinestyle( sprintf( '%s.eps', filename ) );

%convert to pdf
%convert all files to pdf
if( CONVERT_TO_PDF )
    pathToEPSFiles = sprintf( '%s%sComparePlotError%s', PATH, DELIMITER, DELIMITER );
    system( sprintf( 'apply /usr/texbin/epstopdf %s*.eps', pathToEPSFiles ) );
    system( sprintf( 'rm %s*.eps', pathToEPSFiles ) );
    
    %delete tmp plots
    if( currentEvalType )
        pathToTMPFiles = sprintf( '%s%splots_%s%s', PATH, DELIMITER, currentEvalType, DELIMITER );
    else
        pathToTMPFiles = sprintf( '%s%splots%s', PATH, DELIMITER, DELIMITER );
    end
    system( sprintf( 'rm -r %s', pathToTMPFiles ) );
end
disp([' ']);
