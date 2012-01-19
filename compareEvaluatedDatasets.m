function compareEvaluatedDatasets( SAVEPATH )

%SAVEPATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonS5toS6';
%SAVEPATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Comparison_HS_vs_LED';
%SAVEPATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonDimVs2ndOff_4';

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
[ firstPath, lastPathComponent, fileExtension ] = fileparts( SAVEPATH );

%%READ XML
fileName = sprintf( '%s%s%s', SAVEPATH, DELIMITER, XMLFILENAME );
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
            end
        end
    end
end

%get custom code
allCustomCodeItems = xDoc.getElementsByTagName('CustomCode');
allCustomCodeItemsLength = allCustomCodeItems.getLength;

for k = 0 : allCustomCodeItemsLength - 1
    thisCustomCodeItem = allCustomCodeItems.item(k);
    %thisCustomCode = thisDataSetsItem.getElementsByTagName('CustomCode');
    thisElement = thisCustomCodeItem.item(0);
    customCodeString = char( thisElement.getData );
end

%%PLOTTING
numberOfDatasets = length( pathesForDatasets );
numberOfColors = length( colorArrayForPlots );

arrayWithSetStatistics = cell( numberOfDatasets, 1 );

figHandleContrast = figure();
figHandleAbsContrast = figure();
figHandleVL = figure();
figHandleVLFixedDistance = figure();
figHandleLt = figure();
figHandleLB = figure();

%load data
for currentDatasetIndex = 1 : numberOfDatasets
    
    currentPath = sprintf( '%s%s', pathesForDatasets{ currentDatasetIndex }, subPathesForDatasets{ currentDatasetIndex } );
    currentType = typeArrayForPlots{ currentDatasetIndex };
    if( strcmp(currentType, 'Mesopic') )
        filePath = sprintf( '%s%smesopicSetStatistics.mat', currentPath, DELIMITER );
        load( filePath );
        arrayWithSetStatistics{ currentDatasetIndex } = mesopicLMK_Image_Set_Statistics;
    else
        filePath = sprintf( '%s%sphotopicSetStatistics.mat', currentPath, DELIMITER );
        load( filePath );
        arrayWithSetStatistics{ currentDatasetIndex } = photopicLMK_Image_Set_Statistics;
    end

    %we don't like too much data in memory
    %shouldn't have been saved in the first place...
    photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
    
end

%plot data
if ( ~exist( SAVEPATH, 'dir' ) )
    mkdir( SAVEPATH );
end

for currentDatasetIndex = 1 : numberOfDatasets
    
    currentSetStatistics = arrayWithSetStatistics{ currentDatasetIndex };
    
    currentColorIndex = mod( currentDatasetIndex, numberOfColors );
    if ( currentColorIndex == 0 )
        currentColorIndex = numberOfColors;
    end
    
    %contrast
    set(0, 'CurrentFigure', figHandleContrast);
    hold on;
    currentSetStatistics.plotContrast( SAVEPATH, figHandleContrast, colorArrayForPlots{ currentColorIndex } );
    hold off;
    
    %abscontrast
    set(0, 'CurrentFigure', figHandleAbsContrast);
    hold on;
    currentSetStatistics.plotAbsContrast( SAVEPATH, figHandleAbsContrast, colorArrayForPlots{ currentColorIndex } );
    hold off;
    
    %VL
    set(0, 'CurrentFigure', figHandleVL);
    hold on;
    currentSetStatistics.plotVL( SAVEPATH, figHandleVL, colorArrayForPlots{ currentColorIndex } );
    hold off;
    
    %VL fixed distance
    set(0, 'CurrentFigure', figHandleVLFixedDistance);
    hold on;
    currentSetStatistics.plotVLFixedDistance( SAVEPATH, figHandleVLFixedDistance, colorArrayForPlots{ currentColorIndex } );
    tx = text( 'units', 'normalized', 'position', [0.01 1.0 - ( currentDatasetIndex / 10 )], 'string', ...
        sprintf( 'STV_{%s} = %3.1f', legendsForDatasets{ currentDatasetIndex }, currentSetStatistics.smallTargetVL ) );
    set( tx, 'FontSize', 12 ); %'Interpreter','LaTeX',
    hold off;
    
    %Lt
    set(0, 'CurrentFigure', figHandleLt);
    hold on;
    currentSetStatistics.plotLt( SAVEPATH, figHandleLt, colorArrayForPlots{ currentColorIndex } );
    hold off;
    
    %LB
    set(0, 'CurrentFigure', figHandleLB);
    hold on;
    currentSetStatistics.plotLB( SAVEPATH, figHandleLB, colorArrayForPlots{ currentColorIndex } );
    hold off;
end

set(0, 'CurrentFigure', figHandleContrast);
hold on;
plot( currentSetStatistics.distanceArray, zeros( length( currentSetStatistics.distanceArray ), 1 ), 'k--' );
hold off;
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleAbsContrast);
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleVL);
hold on;
plot( currentSetStatistics.distanceArray, zeros( length( currentSetStatistics.distanceArray ), 1 ), 'k--' );
hold off;
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleVLFixedDistance);
hold on;
plot( currentSetStatistics.distanceArray, ones( length( currentSetStatistics.distanceArray ), 1 ), 'k--' );
hold off;
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleLt);
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleLB);
legend( legendsForDatasets, 'Location', 'Best' );

%create folder for plot data
if ( ~exist( sprintf( '%s%sComparePlot', SAVEPATH, DELIMITER ), 'dir' ) )
    mkdir( sprintf( '%s%sComparePlot', SAVEPATH, DELIMITER ) );
end

%apply custom code
if( ~isempty( customCodeString ) )%~strcmp( customCodeString, '') )
    eval( customCodeString );
end

%save images
filename = sprintf( '%s%sComparePlot%sweberContrastPlot_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleContrast, filename, 'epsc');
saveas(figHandleContrast, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sAbsWeberContrastPlot_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleAbsContrast, filename, 'epsc');
saveas(figHandleAbsContrast, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sVLPlot_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleVL, filename, 'epsc');
saveas(figHandleVL, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sVLFixedDistancePlot_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleVLFixedDistance, filename, 'epsc');
saveas(figHandleVLFixedDistance, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sLtPlot_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleLt, filename, 'epsc');
saveas(figHandleLt, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sLBPlot_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleLB, filename, 'epsc');
saveas(figHandleLB, filename, 'fig');

%prepare extra plot: compare Cs to Cth
%compare data
figHandleCthCompare = figure();
currentSetStatistics.plotCthArrayContrastThresholds( figHandleCthCompare );

plotSignArray = { 'o', 'x', '.', '*', '+', 's', 'd' };
numberOfPlotsigns = length( plotSignArray );

alphaMinutes = currentSetStatistics.alphaArray( 3 );
legends{ 1 } = sprintf( 'C_{th, pos} for alpha %3.2f^{''}', alphaMinutes );
legends{ 2 } = sprintf( 'C_{th, neg} for alpha %3.2f^{''}', alphaMinutes );

minLb = 1000000000;
maxLb = 0;

for currentDatasetIndex = 1 : numberOfDatasets
    
    currentPlotsignIndex = mod( currentDatasetIndex, numberOfPlotsigns );
    if ( currentPlotsignIndex == 0 )
        currentPlotsignIndex = numberOfPlotsigns;
    end
    
    currentSetStatistics = arrayWithSetStatistics{ currentDatasetIndex };
    
    [ legendString ] = currentSetStatistics.plotCthArrayCurrentData( figHandleCthCompare, currentDatasetIndex, plotSignArray{ currentPlotsignIndex } );
    
    %adjust legends only for necessary data
    if( length( legendString ) >= 3)
        legends{ length( legends ) + 1 } = sprintf( 'C_{pos} for %s', legendsForDatasets{ currentDatasetIndex } );
    end
    if( length( legendString ) >= 4)
        legends{ length( legends ) + 1 } = sprintf( 'C_{neg} for %s', legendsForDatasets{ currentDatasetIndex } );
    end
    
    mini = min( currentSetStatistics.meanBackgroundArray );
    maxi = max( currentSetStatistics.meanBackgroundArray );
    if( mini < minLb )
        minLb = mini;
    end
    if( maxi > maxLb )
        maxLb = maxi;
    end
    
end

%adjust legends here:
%set(0, 'CurrentFigure', figHandleCthCompare);
legend( legends, 'Location', 'Best' );

currentSetStatistics.plotCthArrayLBBorderAndSave( 'DO_NOT_SAVE', figHandleCthCompare, minLb, maxLb );

filename = sprintf( '%s%sComparePlot%sCthComparison_%s', SAVEPATH, DELIMITER, DELIMITER, lastPathComponent );
saveas(figHandleCthCompare, filename, 'epsc');
saveas(figHandleCthCompare, filename, 'fig');


%convert to pdf
%convert all files to pdf
if( CONVERT_TO_PDF )
    pathToEPSFiles = sprintf( '%s%sComparePlot%s', SAVEPATH, DELIMITER, DELIMITER );
    system( sprintf( 'apply /usr/texbin/epstopdf %s*.eps', pathToEPSFiles ) );
    system( sprintf( 'rm %s*.eps', pathToEPSFiles ) );
    
    %delete tmp plots
    pathToTMPFiles = sprintf( '%s%splots%s', SAVEPATH, DELIMITER, DELIMITER );
    system( sprintf( 'rm -r %s', pathToTMPFiles ) );
end

