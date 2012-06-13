function evaluateDataset( PATH, CONTRAST_CALCULATION_METHOD )
%author Jan Winter, Sandy Buschmann TU Berlin
%email j.winter@tu-berlin.de
%this script evaluates a set of images with a graycard corresponding to Adrians 1989
%model of contrast threshold
%this shall be called by evaluateDataset_batch()

disp( sprintf( 'evaluating %s', PATH ) );

%clear all; %this will clear all breakpoints as well, so we don't like this

%% set tasks
CONVERT_TO_PDF = 1; %set this to 0 if you don't have epstopdf
ANALYZE_MESOPIC = 0; %set this to 0 if you don't like mesopic shit
ANALYZE_SCOTOPIC = 0; %set this to 0 if you don't like scotopic shit

%% set xml name
%file path preferences
XMLNAME = 'LMKSetMat';  %best if you name all xmls like that

%% set offset
%typically 0 for RoadMeasurements
%if 0 the relative position within the measurement field will be plotted,
%else OFFSET is the distance from view point to meas field in order to show absolute values
OFFSET = 0;

%% set STV calculation indices
%STV is calculated for images within this range only
%e.g. if you have 2 measurements before and 2 after the meas field, you'll
%want to use 3 and 12
%indices start at 1
STV_START_INDEX = 3;    %set this to 0 if you don't need this
STV_END_INDEX = 12;     %set this to 0 if you don't need this

%% set VL parameters
%adrian threshold model parameter
%as seen in (ANSI IESNA RP 8 00)
AGE = 60;		%age of observer for adrians model & RP800 model
T = 0.2;		%observing time of visual object (0.2 for RP800 model)
K = 2.6;		%k factor of adrians model & of RP800 model

%% set contrast calculation method
%can be STRONGEST_EDGE, RP800, LOWER_EDGE, LEFT_EDGE, RIGHT_EDGE, UPPER_EDGE, STRONGEST_CORNER, 2DEGREE_BACKGROUND
%CONTRAST_CALCULATION_METHOD = 'STRONGEST_CORNER';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% no adjustments have to be done below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%platform specific path delimiter
if(ispc)
    DELIMITER = '\';
elseif(isunix)
    DELIMITER = '/';
end

%load data
%THIS CAUSES A LOT OF PROBLEMS!!! THERFORE WE DON'T LIKE IT
%if ~exist([PATH,DELIMITER,XMLNAME, '.mat'], 'file');
%load xml file and read all pf images

str = parseXML([PATH, DELIMITER, XMLNAME,'.xml']);
imageset = struct2mat(str, PATH);
%save([PATH,DELIMITER,XMLNAME, '.mat'], 'imageset');
%else
%load image data set
%    disp(['Loading dataset ', XMLNAME, '.mat ...']);
%   load(XMLNAME);
%end

lengthOfSet = length(imageset);

disp('Calculating...');
disp( sprintf( 'using contrast calculation method: %s', CONTRAST_CALCULATION_METHOD ) );

%prepare result instance of setStatistics class
title =  imageset{1,1}.sceneTitle;
photopicLMK_Image_Set_Statistics = LMK_Image_Set_Statistics( 'Photopic', lengthOfSet, AGE, T, K, title, CONTRAST_CALCULATION_METHOD, OFFSET, STV_START_INDEX, STV_END_INDEX );
mesopicLMK_Image_Set_Statistics = LMK_Image_Set_Statistics( 'Mesopic', lengthOfSet, AGE, T, K, title, CONTRAST_CALCULATION_METHOD, OFFSET, STV_START_INDEX, STV_END_INDEX );
scotopicLMK_Image_Set_Statistics = LMK_Image_Set_Statistics( 'Mesopic', lengthOfSet, AGE, T, K, title, CONTRAST_CALCULATION_METHOD, OFFSET, STV_START_INDEX, STV_END_INDEX );

%analyse each image
for currentIndex = 1 : lengthOfSet
    
    %get current element
    currentLMK_Image_Metadata = imageset{ currentIndex };
    
    %init with necessary values
    currentPhotopic_LMK_Image_Statistics = LMK_Image_Statistics( currentLMK_Image_Metadata, photopicLMK_Image_Set_Statistics.type );
    photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray{ currentIndex } = currentPhotopic_LMK_Image_Statistics;
    photopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentPhotopic_LMK_Image_Statistics.alphaMinutes;
    
    if( ANALYZE_MESOPIC )
        currentMesopic_LMK_Image_Statistics = LMK_Image_Statistics( currentLMK_Image_Metadata, mesopicLMK_Image_Set_Statistics.type );
        mesopicLMK_Image_Set_Statistics.lmkImageStatisticsArray{ currentIndex } = currentMesopic_LMK_Image_Statistics;
        mesopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentMesopic_LMK_Image_Statistics.alphaMinutes;
    end
    
    if( ANALYZE_SCOTOPIC )
        currentScotopic_LMK_Image_Statistics = LMK_Image_Statistics( currentLMK_Image_Metadata, scotopicLMK_Image_Set_Statistics.type );
        scotopicLMK_Image_Set_Statistics.lmkImageStatisticsArray{ currentIndex } = currentScotopic_LMK_Image_Statistics;
        scotopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentScotopic_LMK_Image_Statistics.alphaMinutes;
    end
    
end

%prepare data for plotting and plot
photopicLMK_Image_Set_Statistics.gatherData();
photopicLMK_Image_Set_Statistics.plotVL( PATH );
photopicLMK_Image_Set_Statistics.plotVLFixedDistance( PATH );
photopicLMK_Image_Set_Statistics.plotVLFixedDistanceScaled( PATH );
photopicLMK_Image_Set_Statistics.plotThresholdContrast( PATH );
photopicLMK_Image_Set_Statistics.plotThresholdDeltaL( PATH );
photopicLMK_Image_Set_Statistics.plotContrast( PATH );
photopicLMK_Image_Set_Statistics.plotAbsContrast( PATH );
photopicLMK_Image_Set_Statistics.plotLtLB( PATH );
figHandleCth = figure();
photopicLMK_Image_Set_Statistics.plotCthArrayContrastThresholds( figHandleCth );
photopicLMK_Image_Set_Statistics.plotCthArrayCurrentData( figHandleCth );
photopicLMK_Image_Set_Statistics.plotCthArrayLBBorderAndSave( PATH, figHandleCth );


%photopicLMK_Image_Set_Statistics.plotLtLBWithImages( PATH ) ;

%calculate mesopic values and plots if requested
if( ANALYZE_MESOPIC )
    mesopicLMK_Image_Set_Statistics.gatherData();
    mesopicLMK_Image_Set_Statistics.plotVL( PATH );
    mesopicLMK_Image_Set_Statistics.plotVLFixedDistance( PATH );
    mesopicLMK_Image_Set_Statistics.plotVLFixedDistanceScaled( PATH );
    mesopicLMK_Image_Set_Statistics.plotThresholdContrast( PATH );
    mesopicLMK_Image_Set_Statistics.plotThresholdDeltaL( PATH );
    mesopicLMK_Image_Set_Statistics.plotContrast( PATH );
    mesopicLMK_Image_Set_Statistics.plotAbsContrast( PATH );
    mesopicLMK_Image_Set_Statistics.plotLtLB( PATH );
    figHandleCth = figure();
    mesopicLMK_Image_Set_Statistics.plotCthArrayContrastThresholds( figHandleCth );
    mesopicLMK_Image_Set_Statistics.plotCthArrayCurrentData( figHandleCth );
    mesopicLMK_Image_Set_Statistics.plotCthArrayLBBorderAndSave( PATH, figHandleCth );
end

%calculate scotopic values and plots if requested
if( ANALYZE_SCOTOPIC )
    scotopicLMK_Image_Set_Statistics.gatherData();
    scotopicLMK_Image_Set_Statistics.plotVL( PATH );
    scotopicLMK_Image_Set_Statistics.plotVLFixedDistance( PATH );
    scotopicLMK_Image_Set_Statistics.plotVLFixedDistanceScaled( PATH );
    scotopicLMK_Image_Set_Statistics.plotThresholdContrast( PATH );
    scotopicLMK_Image_Set_Statistics.plotThresholdDeltaL( PATH );
    scotopicLMK_Image_Set_Statistics.plotContrast( PATH );
    scotopicLMK_Image_Set_Statistics.plotAbsContrast( PATH );
    scotopicLMK_Image_Set_Statistics.plotLtLB( PATH );
    figHandleCth = figure();
    scotopicLMK_Image_Set_Statistics.plotCthArrayContrastThresholds( figHandleCth );
    scotopicLMK_Image_Set_Statistics.plotCthArrayCurrentData( figHandleCth );
    scotopicLMK_Image_Set_Statistics.plotCthArrayLBBorderAndSave( PATH, figHandleCth );
end

%convert all files to pdf
if( CONVERT_TO_PDF )
    pathToEPSFiles = sprintf( '%s%splots_%s%s', PATH, DELIMITER, CONTRAST_CALCULATION_METHOD, DELIMITER );
    system( sprintf( 'apply /usr/texbin/epstopdf %s*.eps', pathToEPSFiles ) );
    system( sprintf( 'rm %s*.eps', pathToEPSFiles ) );
end

%save visualisation images
photopicLMK_Image_Set_Statistics.saveVisualisationImage( PATH );

%save dataset for compareEvaluatedDatasets
%we don't want to save the visImages (makes the dataset too big...)
photopicLMK_Image_Set_Statistics.visualisationImageArray = 0;
photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
mesopicLMK_Image_Set_Statistics.visualisationImageArray = 0;
mesopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
scotopicLMK_Image_Set_Statistics.visualisationImageArray = 0;
scotopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
save( [ PATH, DELIMITER, 'photopicSetStatistics_', CONTRAST_CALCULATION_METHOD, '.mat' ], 'photopicLMK_Image_Set_Statistics' );
if( ANALYZE_MESOPIC )
    save( [ PATH, DELIMITER, 'mesopicSetStatistics_', CONTRAST_CALCULATION_METHOD, '.mat' ], 'mesopicLMK_Image_Set_Statistics' );
end
if( ANALYZE_SCOTOPIC )
    save( [ PATH, DELIMITER, 'scotopicSetStatistics_', CONTRAST_CALCULATION_METHOD, '.mat' ], 'scotopicLMK_Image_Set_Statistics' );
end
disp('done');



return;
