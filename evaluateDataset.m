%function evaluateDataset
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%this script evaluates a set of images with a graycard corresponding to Adrians 1989
%model of contrast threshold

%clear all; %this will clear all breakpoints as well

%file path preferences
XMLNAME = 'keller_alle'; % name of the .xml-file for this dataset
%PATH = 'C:\Dokumente und Einstellungen\jaw\Desktop\LMK\LMK\LMK_data_evaluation\database';	%this is the path to the datasets xml file
PATH = '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Testmessung Keller 2010_12_21';
%C:\Dokumente und Einstellungen\admin\Eigene Dateien\MATLAB

%2� field for current lens (8mm)
RADIUS = 100;	%number of pixels which correspond to 2°

%adrian threshold model parameter
AGE = 24;		%age of observer for adrians model
T = 1;			%observing time of visual object
K = 2.6;		%k factor of adrians model

%visual object preferences
DISTANCE_TO_MEASUREMENT_FIELD = 11;	%distance between camera and first measurement position of visual object
SIZE_OF_OBJECT = 0.30;	%size of visual object


%these parameters control the method of calculation 
%for the target object and background luminances
%2 methods for calculating the background luminance
%'STREET' calculates the mean luminance on the whole stree
%'2DEGREE' calculates the mean luminance of 2° circle around the object
%2 methods for calculating the threshold difference luminance
%'OBJECT' calculates the difference luminance between mean of 
%object luminance and the background luminance
%'STRONGEST_EDGE' calculates the difference luminance on the strongest edge 
%of the object
%these two methods have been taken from diploma thesis Krenz2010

%either 'STREET' or '2DEGREE'
BACKGROUND_LUMINANCE_MODE = '2DEGREE';

%either 'OBJECT' or 'STRONGEST_EDGE'
CONTRAST_MODE = 'STRONGEST_EDGE';

%analyse either photopic luminances or photopic, scotopic and mesopic luminances
%either 'PHOTOPIC' or 'ALL'
ANALYSIS_MODE = 'ALL';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%no adjustments have to be done below

%platform specific path delimiter
if(ispc)
    DELIMITER = '\';
elseif(isunix)
    DELIMITER = '/';
end


%load data
if ~exist([PATH,DELIMITER,XMLNAME, '.mat'], 'file');
    %load xml file and read all pf images
    imageset = XMLtoMAT([PATH,DELIMITER,XMLNAME,'.xml']);
    save([PATH,DELIMITER,XMLNAME, '.mat'], 'imageset');
else
    %load image data set
    disp(['Loading dataset ', XMLNAME, '.mat ...']);
    load(XMLNAME);    
end

lengthOfSet = length(imageset);

%savepath for result images
savePath = which('evaluateDataset');
savePath = savePath(1 : end - 18);
savePath = strcat(savePath,'/resultImages');
if(~exist(savePath, 'dir'))
    mkdir(savePath)
end

disp('Calculating...');
%initialize result data
weberContrastPhotopic = zeros(lengthOfSet,1);
weberContrastScotopic = zeros(lengthOfSet,1);
weberContrastMesopic = zeros(lengthOfSet,1);
meanBackgroundPhotopic = zeros(lengthOfSet,1);
meanBackgroundScotopic = zeros(lengthOfSet,1);
meanBackgroundMesopic = zeros(lengthOfSet,1);
meanTargetPhotopic = zeros(lengthOfSet,1);
meanTargetScotopic = zeros(lengthOfSet,1);
meanTargetMesopic = zeros(lengthOfSet,1);
VLPhotopic = zeros(lengthOfSet,1);
VLScotopic = zeros(lengthOfSet,1);
VLMesopic = zeros(lengthOfSet,1);
alpha = zeros(lengthOfSet,1);
d = zeros(lengthOfSet,1);
currentDeltaLPhotopic = zeros(lengthOfSet,1);
currentDeltaLScotopic = zeros(lengthOfSet,1);
currentDeltaLMesopic = zeros(lengthOfSet,1);

%analyse each image
for i = 1 : lengthOfSet
    %get current element
    currentLMK_Image_Metadata = imageset{i};
    
    disp(currentLMK_Image_Metadata.dataSRCPhotopic);
    
    %current visual size of object
    d(i) = currentLMK_Image_Metadata.rectPosition;
    gammaRad = 2 * atan(SIZE_OF_OBJECT / 2 ./ (d(i) + DISTANCE_TO_MEASUREMENT_FIELD));
    alphaMinutes = (gammaRad / pi * 180 * 60);
    alpha(i) = alphaMinutes;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %calc values for photopic image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    currentPhotopic_LMK_Image_Statistics = statisticsOfCircleAndRect(currentLMK_Image_Metadata, RADIUS, savePath, 'PHOTOPIC');
    c = currentPhotopic_LMK_Image_Statistics;
    if(strmatch(BACKGROUND_LUMINANCE_MODE,'STREET'))
        if(strmatch(CONTRAST_MODE,'STRONGEST_EDGE'))
            strongestEdgeContrast = get(c,c.strongestEdge);
            weberContrastPhotopic(i) = strongestEdgeContrast;
            %
        elseif(strmatch(CONTRAST_MODE,'OBJECT'))
            weberContrastPhotopic(i) = (c.meanTarget - c.streetSurfaceLuminance) / c.streetSurfaceLuminance;
        end
        meanBackgroundPhotopic(i) = c.streetSurfaceLuminance;
        currentDeltaLPhotopic(i) = calcDeltaL(c.streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    elseif(strmatch(BACKGROUND_LUMINANCE_MODE,'2DEGREE'))
        if(strmatch(CONTRAST_MODE,'STRONGEST_EDGE'))
            strongestEdgeContrast = get(c,c.strongestEdge);
            weberContrastPhotopic(i) = strongestEdgeContrast;
            %
        elseif(strmatch(CONTRAST_MODE,'OBJECT'))
            weberContrastPhotopic(i) = (c.meanTarget - c.meanBackground) / c.meanBackground;
        end
        meanBackgroundPhotopic(i) = c.meanBackground;
        currentDeltaLPhotopic(i) = calcDeltaL(c.meanBackground, alphaMinutes, AGE, T, K);
    end 
    
    
    meanTargetPhotopic(i) = c.meanTarget;
    %VLPhotopic(i) = calcVisibilityLevelFromContrast(meanBackground, weberContrastPhotopic(i),alphaMinutes,AGE,T,K);
    VLPhotopic(i) = currentDeltaLPhotopic(i) / abs(meanTargetPhotopic(i) - meanBackgroundPhotopic(i));
    
    if(strmatch(ANALYSIS_MODE,'ALL'))
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %calc values for scotopic image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    currentScotopic_LMK_Image_Statistics = statisticsOfCircleAndRect(currentLMK_Image_Metadata, RADIUS, savePath, 'SCOTOPIC');
    c = currentScotopic_LMK_Image_Statistics;
    
    if(strmatch(BACKGROUND_LUMINANCE_MODE,'STREET'))
        if(strmatch(CONTRAST_MODE,'STRONGEST_EDGE'))
            strongestEdgeContrast = get(c,c.strongestEdge);
            weberContrastScotopic(i) = strongestEdgeContrast;
            %
        elseif(strmatch(CONTRAST_MODE,'OBJECT'))
            weberContrastScotopic(i) = (c.meanTarget - c.streetSurfaceLuminance) / c.streetSurfaceLuminance;
        end
        meanBackgroundScotopic(i) = c.streetSurfaceLuminance;
        currentDeltaLScotopic(i) = calcDeltaL(c.streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    elseif(strmatch(BACKGROUND_LUMINANCE_MODE,'2DEGREE'))
        if(strmatch(CONTRAST_MODE,'STRONGEST_EDGE'))
            strongestEdgeContrast = get(c,c.strongestEdge);
            weberContrastScotopic(i) = strongestEdgeContrast;
            %
        elseif(strmatch(CONTRAST_MODE,'OBJECT'))
            weberContrastScotopic(i) = (c.meanTarget - c.meanBackground) / c.meanBackground;
        end
        meanBackgroundScotopic(i) = c.meanBackground;
        currentDeltaLScotopic(i) = calcDeltaL(c.meanBackground, alphaMinutes, AGE, T, K);
    end
        
    
    meanTargetScotopic(i) = c.meanTarget;
    %VLScotopic(i) = calcVisibilityLevelFromContrast(meanBackground, weberContrastScotopic(i),alphaMinutes,AGE,T,K);
    VLScotopic(i) = currentDeltaLScotopic(i) / abs(meanTargetScotopic(i) - meanBackgroundScotopic(i));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %calc values for mesopic image
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [currentLMK_Image_Metadata.dataImageMesopic, imgVisualisation] = mesopicLuminance_intermediate(currentLMK_Image_Metadata.dataImagePhotopic, ...
                 currentLMK_Image_Metadata.dataImageScotopic);
    currentMesopic_LMK_Image_Statistics = statisticsOfCircleAndRect(currentLMK_Image_Metadata, RADIUS, savePath, 'MESOPIC');
    c = currentMesopic_LMK_Image_Statistics;
    
    if(strmatch(BACKGROUND_LUMINANCE_MODE,'STREET'))
        if(strmatch(CONTRAST_MODE,'STRONGEST_EDGE'))
            strongestEdgeContrast = get(c,c.strongestEdge);
            weberContrastMesopic(i) = strongestEdgeContrast;
            %
        elseif(strmatch(CONTRAST_MODE,'OBJECT'))
            weberContrastMesopic(i) = (c.meanTarget - c.streetSurfaceLuminance) / c.streetSurfaceLuminance;
        end
        meanBackgroundMesopic(i) = c.streetSurfaceLuminance;
        currentDeltaLMesopic(i) = calcDeltaL(c.streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    elseif(strmatch(BACKGROUND_LUMINANCE_MODE,'2DEGREE'))
        if(strmatch(CONTRAST_MODE,'STRONGEST_EDGE'))
            strongestEdgeContrast = get(c,c.strongestEdge);
            weberContrastMesopic(i) = strongestEdgeContrast;
            %
        elseif(strmatch(CONTRAST_MODE,'OBJECT'))
            weberContrastMesopic(i) = (c.meanTarget - c.meanBackground) / c.meanBackground;
        end
        meanBackgroundMesopic(i) = c.meanBackground;
        currentDeltaLMesopic(i) = calcDeltaL(c.meanBackground, alphaMinutes, AGE, T, K);
    end
        
    
    meanTargetMesopic(i) = c.meanTarget;
    %VLMesopic(i) = calcVisibilityLevelFromContrast(meanBackground, weberContrastMesopic(i),alphaMinutes,AGE,T,K);
    VLMesopic(i) = currentDeltaLMesopic(i) / abs(meanTargetMesopic(i) - meanBackgroundMesopic(i));
    end
    
    %
    %         %calc values for scotopic image
    %         currentScotopic_LMK_Image_Statistics = statisticsOfCircleAndRect(currentLMK_Image_Metadata, RADIUS, savePath, 'SCOTOPIC');
    %         c = currentScotopic_LMK_Image_Statistics;
    %         if(strmatch(BACKGROUND_LUMINANCE_MODE,'STREET'))
    %             weberContrastScotopic(i) = (meanTarget - streetSurfaceLuminance) / streetSurfaceLuminance;
    %             meanBackgroundScotopic(i) = streetSurfaceLuminance;
    %             currentDeltaLScotopic(i) = calcDeltaL(streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    %
    %         elseif(strmatch(BACKGROUND_LUMINANCE_MODE,'2DEGREE'))
    %             weberContrastScotopic(i) = (meanTarget - meanBackground) / meanBackground;
    %             meanBackgroundScotopic(i) = meanBackground;
    %             currentDeltaLScotopic(i) = calcDeltaL(streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    %         end
    %         meanTargetScotopic(i) = meanTarget;
    %         %VLScotopic(i) = calcVisibilityLevelFromContrast(meanBackground, weberContrastScotopic(i),alphaMinutes,AGE,T,K);
    %         VLScotopic(i) = currentDeltaLScotopic(i) / abs(meanTargetScotopic(i) - meanBackgroundScotopic(i));
    %
    %         %calc values for mesopic image
    %         currentLMK_Image_Metadata.dataImageMesopic = mesopicLuminance(currentLMK_Image_Metadata.dataImagePhotopic, ...
    %             currentLMK_Image_Metadata.dataImageScotopic);
    %         currentMesopic_LMK_Image_Statistics = statisticsOfCircleAndRect(currentLMK_Image_Metadata, RADIUS, savePath, 'MESOPIC');
    %         c = currentMesopic_LMK_Image_Statistics;
    %         if(strmatch(BACKGROUND_LUMINANCE_MODE,'STREET'))
    %             weberContrastMesopic(i) = (meanTarget - streetSurfaceLuminance) / streetSurfaceLuminance;
    %             meanBackgroundMesopic(i) = streetSurfaceLuminance;
    %             currentDeltaLMesopic(i) = calcDeltaL(streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    %         elseif(strmatch(BACKGROUND_LUMINANCE_MODE,'2DEGREE'))
    %             weberContrastMesopic(i) = (meanTarget - meanBackground) / meanBackground;
    %             meanBackgroundMesopic(i) = meanBackground;
    %             currentDeltaLMesopic(i) = calcDeltaL(streetSurfaceLuminance, alphaMinutes, AGE, T, K);
    %         end
    %         meanTargetMesopic(i) = meanTarget;
    %         %VLMesopic(i) = calcVisibilityLevelFromContrast(meanBackground,weberContrastMesopic(i),alphaMinutes,AGE,T,K);
    %         VLMesopic(i) = currentDeltaLMesopic(i) / abs(meanTargetMesopic(i) - meanBackgroundMesopic(i));
    %
    disp('-------------------------------')
end

figure
plot(d,weberContrastPhotopic,'r')
if(strmatch(ANALYSIS_MODE,'ALL'))
	hold on
	plot(d,weberContrastMesopic,'gr')
	plot(d,weberContrastScotopic,'b')
	hold off
	legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
else
	legend('L_{photopisch}');
end
axis('tight');
xlabel('d in m');
ylabel('C');
title(strcat('Weber Kontrast ',BACKGROUND_LUMINANCE_MODE,' ',CONTRAST_MODE));
saveas(gcf,strcat(savePath,DELIMITER,'WeberKontrast_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');


figure
plot(d,currentDeltaLPhotopic,'r')
if(strmatch(ANALYSIS_MODE,'ALL'))
	hold on
	plot(d,currentDeltaLMesopic,'gr')
	plot(d,currentDeltaLScotopic,'b')
	hold off
	legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
else
	legend('L_{photopisch}');
end
axis('tight');
xlabel('d in m');
ylabel('Delta L');
title(strcat('/Delta L ',BACKGROUND_LUMINANCE_MODE,' ',CONTRAST_MODE));
saveas(gcf,strcat(savePath,DELIMITER,'DeltaL_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');

figure
plot(d,VLPhotopic,'r')
if(strmatch(ANALYSIS_MODE,'ALL'))
	hold on
	plot(d,VLMesopic,'gr')
	plot(d,VLScotopic,'b')
	hold off
	legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
else
	legend('L_{photopisch}');
end
axis('tight');
xlabel('d in m');
ylabel('VL');
title(strcat('Visibility Level ',BACKGROUND_LUMINANCE_MODE,' ',CONTRAST_MODE));
saveas(gcf,strcat(savePath,DELIMITER,'VL_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');

% figure;
% plot(d,meanTargetPhotopic,'r');
% if(strmatch(ANALYSIS_MODE,'ALL'))
% 	hold on
% 	plot(d,meanTargetMesopic,'gr')
% 	plot(d,meanTargetScotopic,'b')
% 	hold off
% 	legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
% else
% 	legend('L_{photopisch}');
% end
% axis('tight');
% xlabel('d in m');
% ylabel('L');
% title(strcat('mean L_t ',BACKGROUND_LUMINANCE_MODE,' ',CONTRAST_MODE));
% saveas(gcf,strcat(savePath,DELIMITER,'meanLt_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');
% 
% figure;
% plot(d,meanBackgroundPhotopic,'r');
% if(strmatch(ANALYSIS_MODE,'ALL'))
% 	hold on
% 	plot(d,meanBackgroundMesopic,'gr')
% 	plot(d,meanBackgroundScotopic,'b')
% 	hold off
% 	legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
% else
% 	legend('L_{photopisch}');
% end
% axis('tight');
% xlabel('d in m');
% ylabel('L');
% title(strcat('mean L_B ',DELIMITER,' ',CONTRAST_MODE));
% saveas(gcf,strcat(savePath,DELIMINTER,'meanLB_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');

figure;
plot(d,meanTargetPhotopic,'r');
if(strmatch(ANALYSIS_MODE,'ALL'))
	hold on
	plot(d,meanTargetMesopic,'gr')
	plot(d,meanTargetScotopic,'b')
	plot(d,meanBackgroundPhotopic,'r:');
	plot(d,meanBackgroundMesopic,'gr:')
	plot(d,meanBackgroundScotopic,'b:')
	hold off
	legend('L_t_{photopisch}','L_t_{mesopisch}','L_t_{skotopisch}','L_B_{photopisch}','L_B_{mesopisch}','L_B_{skotopisch}');
else
	hold on
	plot(d,meanBackgroundPhotopic,'r:');
	hold off
	legend('L_t_{photopisch}','L_B_{photopisch}');
end
axis('tight');
xlabel('d in m');
ylabel('L');
title(strcat('mean L_t vs mean L_B ',BACKGROUND_LUMINANCE_MODE,' ',CONTRAST_MODE));
saveas(gcf,strcat(savePath,DELIMITER,'meanLtLB_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');

figure;
plot(d,alpha);
xlabel('d in m');
ylabel('alpha in min');
title(strcat('Sehobjektwinkel ',BACKGROUND_LUMINANCE_MODE,'',CONTRAST_MODE));

%certain ticks point outside
ax=copyobj(gca,gcf);
set(gca,'xtick',[]);
delete(findall(gcf,'parent',ax))
set(ax,'color','none','ytick',[],'tickdir','out','hittest','off')

saveas(gcf,strcat(savePath,DELIMITER,'Sehobjektwinkel_',BACKGROUND_LUMINANCE_MODE,'_',CONTRAST_MODE),'epsc');






