%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

classdef LMK_Image_Set_Statistics < handle
    properties
        %input
        type                        %Photopic / Scotopic / Mesopic
        ageVL
        tVL
        kVL
        
        lmkImageStatisticsArray     %cell array with statistics of current set
        
        alphaArray                  %array with target sizes (in minutes)
        meanTargetArray             %array with target means of current set
        meanBackgroundArray         %array with background means of current set
        weberContrastArray          %array with weber contrasts of current set
        thresholdContrastArray      %array with threshold contrasts of current set
        visibilityLevelArray        %array with visibility levels of current set
        distanceArray               %array with distances of current set
        visualisationImageArray     %array with visualisation images of current set
        
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Set_Statistics( type, lengthOfSet, ageVL, tVL, kVL )
            if nargin > 0 % Support calling with 0 arguments
                
                %check if type is valid
                isPhotopic = strcmp( type, 'Photopic' );
                isScotopic = strcmp( type, 'Scotopic' );
                isMesopic = strcmp( type, 'Mesopic' );
                
                if ( ~(isPhotopic || isScotopic || isMesopic ) )
                    disp(sprintf( 'unkonwn type: %s', type ));
                    disp( 'type has to be Photopic, Scotopic or Mesopic!' );
                end
                
                obj.type = type;
                obj.ageVL = ageVL;
                obj.tVL = tVL;
                obj.kVL = kVL;
                obj.lmkImageStatisticsArray = cell( lengthOfSet, 1 );
            end
        end% constructor
        
        %fills data arrays from statistic array
        function gatherData( obj )
            currentStatisticsArray = obj.lmkImageStatisticsArray;
            
            meanTargetArray = zeros( size( currentStatisticsArray ) );
            meanBackgroundArray = zeros( size( currentStatisticsArray ) );
            thresholdContrastArray = zeros( size( currentStatisticsArray ) );
            distanceArray = zeros( size( currentStatisticsArray ) );
            visualisationImageArray = cell( size( currentStatisticsArray ) );
            
            %create arrays with Lt , LB and d
            for currentIndex = 1 : length( meanTargetArray )
                currentStatistics = currentStatisticsArray{ currentIndex };
                meanTargetArray( currentIndex ) = currentStatistics.strongestEdgeMeanTarget;
                meanBackgroundArray( currentIndex ) = currentStatistics.strongestEdgeMeanBackground;
                distanceArray( currentIndex ) = currentStatistics.imageMetadata.rectPosition;
                visualisationImageArray{ currentIndex } = currentStatistics.visualisationImage;
            end
            
            %calculate weber contrast
            weberContrastArray = meanTargetArray ./ meanBackgroundArray - 1;
            
            %calculate threshold contrast
            for currentIndex = 1 : length( meanTargetArray )
                Lb = meanBackgroundArray( currentIndex );
                Lt = meanTargetArray( currentIndex );
                alphaMinutes = obj.alphaArray( currentIndex );
                deltaL = calcDeltaL(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL);
                thresholdContrastArray( currentIndex ) = deltaL / Lb;
            end
            
            %calculate visibility level
            %VL is always positive
            visibilityLevelArray = abs(weberContrastArray ./ thresholdContrastArray);
            
            %set instance values
            obj.visualisationImageArray = visualisationImageArray;
            obj.distanceArray = distanceArray;
            obj.meanTargetArray = meanTargetArray;
            obj.meanBackgroundArray = meanBackgroundArray;
            obj.weberContrastArray = weberContrastArray;
            obj.thresholdContrastArray = thresholdContrastArray;
            obj.visibilityLevelArray = visibilityLevelArray;
        end
        
        function saveVisualisationImage( obj, savePath )
            mkdir( savePath, 'visImages' );
            for currentIndex = 1 : length( obj.visualisationImageArray )
                image = obj.visualisationImageArray{ currentIndex };                
                filename = sprintf( '%s/visImages/%d.png', savePath, currentIndex );
                imwrite( image, filename );
            end
        end
        
        function plotStrongestEdgeContrast( obj, savePath )
            
            mkdir( savePath, 'plots' );
            
            %plot weber contrast
            figure();
            plot( obj.distanceArray, obj.weberContrastArray, 'o-r' );
            %legend('L_{photopisch}');
            axis('tight');
            xlabel('d in m');
            ylabel('C');
            title( strcat( 'Weber Contrast' ) ) ;
            filename = sprintf( '%s/plots/weberContrastPlot', savePath );
            saveas(gcf, filename, 'epsc');
            saveas(gcf, filename, 'fig');
            
            %plot delta L thresh
            deltaLArray = obj.thresholdContrastArray .* obj.meanBackgroundArray;
            figure();
            hold on
            plot( obj.distanceArray, deltaLArray, 'o-gr' );
            hold off
            %legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
            axis('tight');
            xlabel('d in m');
            ylabel('\Delta L in cd/m^2');
            title(strcat('\Delta L_{th} '));
            filename = sprintf( '%s/plots/deltaLPlot', savePath );
            saveas(gcf, filename, 'epsc');
            saveas(gcf, filename, 'fig');
            
            %plot C thresh
            figure();
            hold on
            plot( obj.distanceArray, obj.thresholdContrastArray, 'o-gr' );
            hold off
            %legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
            axis('tight');
            xlabel('d in m');
            ylabel('C_{th}');
            title(strcat('Threshold Contrast '));
            filename = sprintf( '%s/plots/CthPlot', savePath );
            saveas(gcf, filename, 'epsc');
            saveas(gcf, filename, 'fig');
            
            %plot visibility level
            figure();
            plot( obj.distanceArray, obj.visibilityLevelArray,'o-r' );
            %legend('L_{photopisch}');
            axis('tight');
            xlabel('d in m');
            ylabel('VL');
            title( strcat('Visibility Level ') );
            filename = sprintf( '%s/plots/VLPlot', savePath );
            saveas(gcf, filename, 'epsc');
            saveas(gcf, filename, 'fig');
            
            %plot Lt and Lb
            figure();
            hold on
            plot( obj.distanceArray, obj.meanTargetArray ,'ob:' );
            plot( obj.distanceArray, obj.meanBackgroundArray ,'or:' );
            hold off
            legend('L_t','L_B');
            axis('tight');
            xlabel('d in m');
            ylabel('L in cd/m^2');
            title(strcat('mean L_t vs mean L_B ') );
            filename = sprintf( '%s/plots/LtLbPlot', savePath );
            saveas(gcf, filename, 'epsc');
            saveas(gcf, filename, 'fig');
            
        end   
        
    end % methods
end