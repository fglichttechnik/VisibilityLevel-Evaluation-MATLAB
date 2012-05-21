function evaluateDataset( PATH )
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%this script evaluates a set of images with a graycard corresponding to Adrians 1989
%model of contrast threshold

disp( sprintf( 'evaluating %s', PATH ) );

%clear all; %this will clear all breakpoints as well

CONVERT_TO_PDF = 1; %set this to 0 if you don't have epstopdf
ANALYZE_MESOPIC = 0; %set this to 0 if you don't like mesopic shit

%file path preferences
XMLNAME = 'LMKSetMat';  %best if you name all xmls like that

%typically 0 for RoadMeasurements
OFFSET = 12.5; %if 0 the relative position within the measurement field will be plotted, else OFFSET is the distance from view point to meas field in order to show absolute values

%this is the path to the datasets xml file
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3_newTarget';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3_fixedDistance';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3';
%PATH = '/Volumes/server/Postfach/Transfer zu Winter/2010_10_07 - Treskowstr/Leuchtdichtebilder/pf';
%PATH = '/Users/sandy/Desktop/Development/RoadRad/RoadRad/scenes/sceneXY/LMKSetMat';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/SebBremer/neu';
%PATH = 'Z:\Postfach\Transfer zu Winter\2010_10_07 - Treskowstr\Leuchtdichtebilder\pf';
%PATH = '/Users/sandy/Desktop/Development/LMK/LMK_Data_evaluation/database/sceneXYZ';


%adrian threshold model parameter
%AGE = 24;		%age of observer for adrians model
%T = 1;			%observing time of visual object
%K = 2.6;		%k factor of adrians model
%as seen in (ANSI IESNA RP 8 00)
AGE = 60;		%age of observer for adrians model & RP800 model
T = 0.2;		%observing time of visual object (constant 0.2 for RP800 model)
K = 2.6;		%k factor of adrians model & of RP800 model
CONTRAST_CALCULATION_METHOD = 'STRONGEST_EDGE';   %can be STRONGEST_EDGE, RP800, LOWER_THIRD, STRONGEST_CORNER

%visual object preferences
%%TODO: these values should be read from the xml file!!!
%DISTANCE_TO_MEASUREMENT_FIELD = 11;	%distance between camera and first measurement position of visual object
%SIZE_OF_OBJECT = 0.30;	%size of visual object
%TITLE = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%no adjustments have to be done below

%platform specific path delimiter
if(ispc)
    DELIMITER = '\';
elseif(isunix)
    DELIMITER = '/';
end


%load data
%THIS CAUSES A LOT OF PROBLEMS!!!
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


%prepare result class
title =  imageset{1,1}.sceneTitle;
photopicLMK_Image_Set_Statistics = LMK_Image_Set_Statistics( 'Photopic', lengthOfSet, AGE, T, K, title, CONTRAST_CALCULATION_METHOD, OFFSET );
mesopicLMK_Image_Set_Statistics = LMK_Image_Set_Statistics( 'Mesopic', lengthOfSet, AGE, T, K, title, CONTRAST_CALCULATION_METHOD, OFFSET );


%analyse each image
for currentIndex = 1 : lengthOfSet
    
    %get current element
    currentLMK_Image_Metadata = imageset{ currentIndex };
    
    %calculate all necessary values
    currentPhotopic_LMK_Image_Statistics = LMK_Image_Statistics( currentLMK_Image_Metadata, photopicLMK_Image_Set_Statistics.type );
    photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray{ currentIndex } = currentPhotopic_LMK_Image_Statistics;
    %photopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentLMK_Image_Metadata.targetAlphaMinutes;
    photopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentPhotopic_LMK_Image_Statistics.alphaMinutes;
    
    currentMesopic_LMK_Image_Statistics = LMK_Image_Statistics( currentLMK_Image_Metadata, mesopicLMK_Image_Set_Statistics.type );
    mesopicLMK_Image_Set_Statistics.lmkImageStatisticsArray{ currentIndex } = currentMesopic_LMK_Image_Statistics;
    %mesopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentLMK_Image_Metadata.targetAlphaMinutes;
    mesopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = currentMesopic_LMK_Image_Statistics.alphaMinutes;
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

%convert all files to pdf
if( CONVERT_TO_PDF )
    pathToEPSFiles = sprintf( '%s%splots_%s%s', PATH, DELIMITER, CONTRAST_CALCULATION_METHOD, DELIMITER );
    system( sprintf( 'apply /usr/texbin/epstopdf %s*.eps', pathToEPSFiles ) );
    system( sprintf( 'rm %s*.eps', pathToEPSFiles ) );
end

%save images
photopicLMK_Image_Set_Statistics.saveVisualisationImage( PATH );

%save dataset for compareEvaluatedDatasets
%we don't want to save the visImages (makes the dataset too big...)
photopicLMK_Image_Set_Statistics.visualisationImageArray = 0;
photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
mesopicLMK_Image_Set_Statistics.visualisationImageArray = 0;
mesopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
save( [ PATH, DELIMITER, 'photopicSetStatistics_', CONTRAST_CALCULATION_METHOD, '.mat' ], 'photopicLMK_Image_Set_Statistics' );
save( [ PATH, DELIMITER, 'mesopicSetStatistics_', CONTRAST_CALCULATION_METHOD, '.mat' ], 'mesopicLMK_Image_Set_Statistics' );

disp('done');



return;
