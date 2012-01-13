SAVEPATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_ComparisonLumenVsCMultiplier';

XMLFILENAME = 'CompareSet.xml'

CONVERT_TO_PDF = 1; %set this to 0 if you don't have epstopdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%no changes have to be done below


%platform specific path delimiter
if(ispc)
    DELIMITER = '\';
elseif(isunix)
    DELIMITER = '/';
end

%%READ XML
fileName = sprintf( '%s%s%s', SAVEPATH, DELIMITER, XMLFILENAME );
xDoc = xmlread( fileName );

allDataSetItems = xDoc.getElementsByTagName('DataSets');
allDataSetItemsLength = allDataSetItems.getLength;

if (~allDataSetItemsLength)
    disp('NO DATA FOUND, QUITTING');
end



for k = 0 : allDataSetItemsLength - 1
    thisDataSetItem = allDataSetItems.item(k);
    
    
    % Get the label element. In this file, each
    % listitem contains only one label.
    thisDataSet = thisDataSetItem.getElementsByTagName('DataSet');
    thisDataSetLength = thisDataSet.getLength;
    
    %prepare data
pathesForDatasets = cell( thisDataSetLength, 1 );
legendsForDatasets = cell( thisDataSetLength, 1 );
colorArrayForPlots = cell( thisDataSetLength, 1 );
    
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
            end
        end
    end
end

%%PLOTTING
numberOfDatasets = length( pathesForDatasets );
numberOfColors = length( colorArrayForPlots );

arrayWithSetStatistics = cell( numberOfDatasets, 1 );

figHandleContrast = figure();
figHandleVL = figure();
figHandleVLFixedDistance = figure();
figHandleLt = figure();
figHandleLB = figure();

%load data
for currentDatasetIndex = 1 : numberOfDatasets
    
    currentPath = pathesForDatasets{ currentDatasetIndex };
    filePath = sprintf( '%s%sphotopicSetStatistics.mat', currentPath, DELIMITER );
    load( filePath );
    
    arrayWithSetStatistics{ currentDatasetIndex } = photopicLMK_Image_Set_Statistics;
    
    %we don't like too much data in memory
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
    
    %VL
    set(0, 'CurrentFigure', figHandleVL);
    hold on;
    currentSetStatistics.plotVL( SAVEPATH, figHandleVL, colorArrayForPlots{ currentColorIndex } );
    hold off;
    
    %VL fixed distance
    set(0, 'CurrentFigure', figHandleVLFixedDistance);
    hold on;
    currentSetStatistics.plotVLFixedDistance( SAVEPATH, figHandleVLFixedDistance, colorArrayForPlots{ currentColorIndex } );
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
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleVL);
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleVLFixedDistance);
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleLt);
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleLB);
legend( legendsForDatasets, 'Location', 'Best' );

%save images
%plot data
if ( ~exist( sprintf( '%s%sComparePlot', SAVEPATH, DELIMITER ), 'dir' ) )
    mkdir( sprintf( '%s%sComparePlot', SAVEPATH, DELIMITER ) );
end

filename = sprintf( '%s%sComparePlot%sweberContrastPlot', SAVEPATH, DELIMITER, DELIMITER );
saveas(figHandleContrast, filename, 'epsc');
saveas(figHandleContrast, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sVLPlot', SAVEPATH, DELIMITER, DELIMITER );
saveas(figHandleVL, filename, 'epsc');
saveas(figHandleVL, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sVLFixedDistancePlot', SAVEPATH, DELIMITER, DELIMITER );
saveas(figHandleVLFixedDistance, filename, 'epsc');
saveas(figHandleVLFixedDistance, filename, 'fig');


filename = sprintf( '%s%sComparePlot%sLtPlot', SAVEPATH, DELIMITER, DELIMITER );
saveas(figHandleLt, filename, 'epsc');
saveas(figHandleLt, filename, 'fig');

filename = sprintf( '%s%sComparePlot%sLBPlot', SAVEPATH, DELIMITER, DELIMITER );
saveas(figHandleLB, filename, 'epsc');
saveas(figHandleLB, filename, 'fig');

%compare data
%plotDifferenceOfDatasets( arrayWithSetStatistics{ originalIndex }, arrayWithSetStatistics{ compareIndex } );

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

