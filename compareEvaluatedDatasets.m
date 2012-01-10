%adjust this manually
pathesForDatasets = {
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_RP8_06',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_RP8_30',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_RP8_99'
    };

legendsForDatasets = {
    '6%',
    '30%',
    '99%'
    };


%can be any number of alternating colors
colorArrayForPlots = {
    'r',
    'g',
    'b'
    };

SAVEPATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_Comparison';


%%no changes have to be done below

%platform specific path delimiter
if(ispc)
    DELIMITER = '\';
elseif(isunix)
    DELIMITER = '/';
end

numberOfDatasets = length( pathesForDatasets );
numberOfColors = length( colorArrayForPlots );

arrayWithSetStatistics = cell( numberOfDatasets, 1 );

figHandleContrast = figure();
figHandleVL = figure();
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
    
    currentColorIndex = mod( currentDatasetIndex, numberOfColors ) + 1;    
    
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

set(0, 'CurrentFigure', figHandleLt);
legend( legendsForDatasets, 'Location', 'Best' );

set(0, 'CurrentFigure', figHandleLB);
legend( legendsForDatasets, 'Location', 'Best' );



