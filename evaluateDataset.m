%function evaluateDataset
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%this script evaluates a set of images with a graycard corresponding to Adrians 1989
%model of contrast threshold

%clear all; %this will clear all breakpoints as well

%file path preferences
%XMLNAME = 'FlurweglmkXML';
XMLNAME = 'Treskowstr_lmkXML';
%XMLNAME = 'pos';

%this is the path to the datasets xml file
%PATH = 'C:\Dokumente und
%Einstellungen\jaw\Desktop\LMK\LMK\LMK_data_evaluation\database';	
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3_newTarget';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert_R3_fixedDistance';
%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_simuliert';
PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_gemessen';

%PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/SebBremer/neu';
%PATH = 'Z:\Postfach\Transfer zu Winter\2010_10_07 - Treskowstr\Leuchtdichtebilder\pf';

%2° field for current lens (8mm)
%TODO: define 2° field for other lenses (25mm / 50mm)
%RADIUS = 100;	%number of pixels which correspond to 2°

%CURRENTLY NOT IMPLEMENTED!!!

%adrian threshold model parameter
%AGE = 24;		%age of observer for adrians model
%T = 1;			%observing time of visual object
%K = 2.6;		%k factor of adrians model
%as seen in (ANSI IESNA RP 8 00)
AGE = 60;		%age of observer for adrians model
T = 0.2;			%observing time of visual object
K = 2.6;		%k factor of adrians model
CONTRAST_CALCULATION_METHOD = 'RP800';   %can be STRONGEST, RP800

%visual object preferences
%%TODO: these values should be read from the xml file!!!
DISTANCE_TO_MEASUREMENT_FIELD = 11;	%distance between camera and first measurement position of visual object
SIZE_OF_OBJECT = 0.30;	%size of visual object
TITLE = '';

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
photopicLMK_Image_Set_Statistics = LMK_Image_Set_Statistics( 'Photopic', lengthOfSet, AGE, T, K, TITLE, CONTRAST_CALCULATION_METHOD );


%analyse each image
for currentIndex = 1 : lengthOfSet
    
    %get current element
    currentLMK_Image_Metadata = imageset{ currentIndex };
    
    %%TODO: move this calculation to class!
    %current visual size of object
    d = currentLMK_Image_Metadata.rectPosition;
    gammaRad = 2 * atan(SIZE_OF_OBJECT / 2 ./ (d + DISTANCE_TO_MEASUREMENT_FIELD));
    alphaMinutes = (gammaRad / pi * 180 * 60);
    
    %calculate all necessary values
    currentPhotopic_LMK_Image_Statistics = LMK_Image_Statistics( currentLMK_Image_Metadata, photopicLMK_Image_Set_Statistics.type );
    photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray{ currentIndex } = currentPhotopic_LMK_Image_Statistics;
    photopicLMK_Image_Set_Statistics.alphaArray( currentIndex ) = alphaMinutes;
end  

%prepare data for plotting and plot
photopicLMK_Image_Set_Statistics.gatherData();
photopicLMK_Image_Set_Statistics.plotVL( PATH );
photopicLMK_Image_Set_Statistics.plotVLFixedDistance( PATH );
photopicLMK_Image_Set_Statistics.plotThresholdContrast( PATH );
photopicLMK_Image_Set_Statistics.plotThresholdDeltaL( PATH );
photopicLMK_Image_Set_Statistics.plotContrast( PATH );
photopicLMK_Image_Set_Statistics.plotLtLB( PATH );

%save images
photopicLMK_Image_Set_Statistics.saveVisualisationImage( PATH );

%save dataset
%we don't want to save the visImages (makes the dataset too big...)
photopicLMK_Image_Set_Statistics.visualisationImageArray = 0;
photopicLMK_Image_Set_Statistics.lmkImageStatisticsArray = 0;
save( [ PATH, DELIMITER, 'photopicSetStatistics', '.mat' ], 'photopicLMK_Image_Set_Statistics' );

%disp('');



return;
