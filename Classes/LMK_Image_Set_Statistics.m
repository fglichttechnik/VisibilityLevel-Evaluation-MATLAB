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
        weberContrastAbsArray          %array with weber contrasts of current set
        thresholdContrastArray      %array with threshold contrasts of current set
        visibilityLevelArray        %array with visibility levels of current set
        visibilityLevelFixedDistanceArray        %array with visibility levels of current set (distance is assumed to be the samefor all target positions)
        distanceArray               %array with distances of current set
        visualisationImageArray     %array with visualisation images of current set
        
        settitle                    %t = title for this set
        
        contrastCalculationMethod   %can be STRONGEST, RP800, or other to be implemented methods
        
        FONTSIZE
        LINEWIDTH
        
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Set_Statistics( type, lengthOfSet, ageVL, tVL, kVL, settitle, contrastCalculationMethod )
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
                obj.settitle = settitle;
                obj.contrastCalculationMethod = contrastCalculationMethod;
            end
            
            obj.FONTSIZE = 14
            obj.LINEWIDTH = 1.2
            
        end% constructor
        
        %% gatherData
        %fills data arrays from statistic array
        function gatherData( obj )
            currentStatisticsArray = obj.lmkImageStatisticsArray;
            
            meanTargetArray = zeros( size( currentStatisticsArray ) );
            meanBackgroundArray = zeros( size( currentStatisticsArray ) );
            thresholdContrastArray = zeros( size( currentStatisticsArray ) );
            thresholdContrastFixedDistanceArray = zeros( size( currentStatisticsArray ) );
            distanceArray = zeros( size( currentStatisticsArray ) );
            visualisationImageArray = cell( size( currentStatisticsArray ) );
            
            %create arrays with Lt , LB and d
            for currentIndex = 1 : length( meanTargetArray )
                currentStatistics = currentStatisticsArray{ currentIndex };
                meanTargetArray( currentIndex ) = currentStatistics.strongestEdgeMeanTarget;
                distanceArray( currentIndex ) = currentStatistics.imageMetadata.rectPosition;
                visualisationImageArray{ currentIndex } = currentStatistics.visualisationImage;
                
                if ( strcmp( obj.contrastCalculationMethod, 'STRONGEST' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.strongestEdgeMeanBackground;
                elseif ( strcmp( obj.contrastCalculationMethod, 'RP800' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackground_RP8_00;
                else
                    disp( sprintf( 'contrastCalculationMethod must be either STRONGEST or RP800' ) );
                    disp( sprintf( 'contrastCalculationMethod is currently %s', obj.contrastCalculationMethod ) );
                    disp( 'QUITTING' );
                    return;
                end
            end
            
            %calculate weber contrast
            weberContrastArray = meanTargetArray ./ meanBackgroundArray - 1;
            weberContrastAbsArray = abs( meanTargetArray - meanBackgroundArray ) ./ meanBackgroundArray;
            
            %calculate threshold contrast
            for currentIndex = 1 : length( meanTargetArray )
                Lb = meanBackgroundArray( currentIndex );
                Lt = meanTargetArray( currentIndex );
                alphaMinutes = obj.alphaArray( currentIndex );
                deltaL = calcDeltaL(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL);
                thresholdContrastArray( currentIndex ) = deltaL / Lb;
                
                %calc the same for fixed distance (we take the first index)
                alphaMinutes = obj.alphaArray( 1 );
                deltaLFixedDistance = calcDeltaL(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL);
                thresholdContrastFixedDistanceArray( currentIndex ) = deltaLFixedDistance / Lb;
            end
            
            %calculate visibility level
            %VL is always positive
            visibilityLevelArray = abs(weberContrastArray ./ thresholdContrastArray);
            visibilityLevelFixedDistanceArray = abs(weberContrastArray ./ thresholdContrastFixedDistanceArray);
            
            %set instance values
            obj.visualisationImageArray = visualisationImageArray;
            obj.distanceArray = distanceArray;
            obj.meanTargetArray = meanTargetArray;
            obj.meanBackgroundArray = meanBackgroundArray;
            obj.weberContrastArray = weberContrastArray;
            obj.weberContrastAbsArray = weberContrastAbsArray;
            obj.thresholdContrastArray = thresholdContrastArray;
            obj.visibilityLevelArray = visibilityLevelArray;
            obj.visibilityLevelFixedDistanceArray = visibilityLevelFixedDistanceArray;
        end
        
        %% saveVisualisationImage
        function saveVisualisationImage( obj, savePath )
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            mkdir( [savePath, DELIMITER], 'visImages' );
            for currentIndex = 1 : length( obj.visualisationImageArray )
                image = obj.visualisationImageArray{ currentIndex };
                filename = sprintf( '%s%svisImages%s%s_%d.png', savePath, DELIMITER, DELIMITER, obj.type, currentIndex );
                imwrite( image, filename );
            end
        end
        
        %% plotContrast
        function plotContrast( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o-r';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %hax = axes('Parent',figHandle);
            p = plot( obj.distanceArray, obj.weberContrastArray, color );
            
            %plot 0 contrast
            %hold on;
            %plot( obj.distanceArray, zeros( size( obj.distanceArray ) ), ':b' );
            %hold off;
            %legend('L_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('C');
            t = title( strcat( 'Weber Contrast' ) ) ;
			
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );

            filename = sprintf( '%s%s_weberContrastPlot', savePath, obj.type );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
        %% plotThresholdContrast
        function plotThresholdContrast( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o-gr';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot delta L thresh
            deltaLArray = obj.thresholdContrastArray .* obj.meanBackgroundArray;
            p = plot( obj.distanceArray, deltaLArray, color );
            %legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('\Delta L in cd/m^2');
            t = title(strcat('\Delta L_{th} '));
            
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            filename = sprintf( '%s%s_deltaLPlot', savePath, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
        %% plotThresholdDeltaL
        function plotThresholdDeltaL( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o-gr';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot C thresh
            p = plot( obj.distanceArray, obj.thresholdContrastArray, color );
            %legend('L_{photopisch}','L_{mesopisch}','L_{skotopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('C_{th}');
            t = title(strcat('Threshold Contrast '));
			
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            filename = sprintf( '%s%s_CthPlot', savePath, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
        %% plotVL
        function plotVL( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o-r';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot visibility level
            p = plot( obj.distanceArray, obj.visibilityLevelArray, color );
            %legend('L_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('VL');
            t = title( strcat('Visibility Level ') );           
            			
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            filename = sprintf( '%s%s_VLPlot', savePath, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
        %% plotVLFixedDistance
        function plotVLFixedDistance( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o-r';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot visibility level
            p = plot( obj.distanceArray, obj.visibilityLevelFixedDistanceArray, color );
            %legend('L_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('VL');
            t = title( strcat('Visibility Level (Fixed Distance)') );           
            			
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            filename = sprintf( '%s%s_VLFixedDistancePlot', savePath, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
        %% plotLt
        function plotLt( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o:b';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot Lt and Lb
            %'LineWidth', 1.2
            p = plot( obj.distanceArray, obj.meanTargetArray , color );
            %legend('L_t','L_B');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('L in cd/m^2');
            t = title(strcat('mean L_t') );
			
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            filename = sprintf( '%s%s_LtPlot', savePath, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
        end
        
        %% plotLB
        function plotLB( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o:r';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot Lt and Lb
            p = plot( obj.distanceArray, obj.meanBackgroundArray , color );
            %legend('L_t','L_B');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('L in cd/m^2');
            t = title(strcat('mean L_B ') );            
            			
			%adjust plot
			set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            filename = sprintf( '%s%s_LbPlot', savePath, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
        end
        
        %% plotLtLB
        function plotLtLB( obj, savePath )
            
            figHandle = figure();
            hold on;
            obj.plotLB( savePath, figHandle );
            obj.plotLt( savePath, figHandle );
            hold off;
            
            axis('tight');
            l = legend('L_t','L_B');
            t = title( strcat(' mean L_t vs mean L_B ') );
            			
			%adjust plot
			set( l, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            
            filename = sprintf( '%s%splots%s%s_LtPlot', savePath, DELIMITER, DELIMITER, obj.type  );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
        end
        
    end % methods
end