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
        
        
        smallTargetVL               %small target visibility level; weighted average of all VL
        
        setTitle                    %title for this set
        
        contrastCalculationMethod   %can be STRONGEST, RP800, or other to be implemented methods
        
        FONTSIZE
        LINEWIDTH
        
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Set_Statistics( type, lengthOfSet, ageVL, tVL, kVL, setTitle, contrastCalculationMethod )
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
                obj.setTitle = setTitle;
                obj.contrastCalculationMethod = contrastCalculationMethod;
            end
            
            obj.FONTSIZE = 14;
            obj.LINEWIDTH = 1.1;
            
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
                distanceArray( currentIndex ) = currentStatistics.imageMetadata.rectPosition;
                visualisationImageArray{ currentIndex } = currentStatistics.imageMetadata.visualisationImagePhotopic;
                
                if ( strcmp( obj.contrastCalculationMethod, 'STRONGEST' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.strongestEdgeMeanTarget;
                elseif ( strcmp( obj.contrastCalculationMethod, 'RP800' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTarget;
                end
                
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
                deltaL_RP800 = calcDeltaL_RP800(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL);
                thresholdContrastArray( currentIndex ) = deltaL_RP800 / Lb;
                
                disp( sprintf( 'deltaLAdrian: %f deltaLRP800: %f', deltaL, deltaL_RP800 ) );
                
                %calc the same for fixed distance (we take the first distance in the measurement field, that's currently object 3)
                alphaMinutes = obj.alphaArray( 3 );
                deltaLFixedDistance = calcDeltaL_RP800(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL);
                thresholdContrastFixedDistanceArray( currentIndex ) = deltaLFixedDistance / Lb;
            end
            
            %calculate visibility level
            %VL is always positive (not in RP800) was abs()
            visibilityLevelArray = (weberContrastArray ./ thresholdContrastArray);
            visibilityLevelFixedDistanceArray = (weberContrastArray ./ thresholdContrastFixedDistanceArray);
            
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
        
        %% value = get.smallTargetVL(obj)
        function value = get.smallTargetVL( obj )
            if( isempty( obj.smallTargetVL ) )
                if ~( isempty( obj.visibilityLevelArray ) )
                    %ignore first / last 2
                    visibilityLevelArrayOfMeasurementField = obj.visibilityLevelArray( 3 : end - 2 );
                    stv = calcSTVfromArray( visibilityLevelArrayOfMeasurementField );
                    obj.smallTargetVL = stv;
                end
            end
            value = obj.smallTargetVL;
        end%lazy loading of smallTargetVL
        
        %% saveVisualisationImage
        function saveVisualisationImage( obj, savePath )
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            if( ~exist( [savePath, DELIMITER, 'visImages'], 'dir') )
                mkdir( [savePath, DELIMITER], 'visImages' );
            end
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
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
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_weberContrastPlot_%s', savePath, obj.type, lastPathComponent );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
        
        
        %% plotContrast
        function plotAbsContrast( obj, savePath, figHandle, color )
            
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %hax = axes('Parent',figHandle);
            p = plot( obj.distanceArray, obj.weberContrastAbsArray, color );
            
            %plot 0 contrast
            %hold on;
            %plot( obj.distanceArray, zeros( size( obj.distanceArray ) ), ':b' );
            %hold off;
            %legend('L_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('C');
            t = title( strcat( 'Weber Contrast Absolute' ) ) ;
            
            %adjust plot
            set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_weberContrastAbsPlot_%s', savePath, obj.type, lastPathComponent );
                
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
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
            
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_deltaLPlot_%s', savePath, obj.type, lastPathComponent  );
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
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
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_CthPlot_%s', savePath, obj.type, lastPathComponent  );
                
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %for better comparison we show the abs of the VL
            
            %plot visibility level
            p = plot( obj.distanceArray, abs( obj.visibilityLevelArray ), color );
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
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VLPlot_%s', savePath, obj.type, lastPathComponent  );
                
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
                figHandleWasGiven = 0;
            else
                figHandleWasGiven = 1;
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %for better comparison we show the abs of the VL
            
            %plot visibility level
            p = plot( obj.distanceArray, abs( obj.visibilityLevelFixedDistanceArray ), color );
            %legend('L_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('VL');
            t = title( strcat('Visibility Level (Fixed Distance)') );
            
            %set STV
            if( ~figHandleWasGiven )
                tx = text( 'units', 'normalized', 'position', [0.01 0.9], 'string', sprintf( 'STV = %3.1f', obj.smallTargetVL ) );
                set( tx, 'FontSize', 12 ); %'Interpreter','LaTeX',
            end
            
            %adjust plot
            set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VLFixedDistancePlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
          %% plotVLFixedDistanceScaled
        function plotVLFixedDistanceScaled( obj, savePath, figHandle, color )
            
            %set standard color
            if ( nargin < 4 )
                color = 'o-r';
            end
            
            if ( nargin < 3 )
                figHandle = figure();
                figHandleWasGiven = 0;
            else
                figHandleWasGiven = 1;
            end
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %for better comparison we show the abs of the VL
            
            %plot visibility level
            p = plot( obj.distanceArray, 10.^( -0.1 * abs( obj.visibilityLevelFixedDistanceArray ) ) , color );
            %legend('L_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('VL');
            t = title( strcat('Visibility Level Scaled (Fixed Distance)') );
            
            %set STV
            if( ~figHandleWasGiven )
                tx = text( 'units', 'normalized', 'position', [0.01 0.9], 'string', sprintf( 'STV = %3.1f', obj.smallTargetVL ) );
                set( tx, 'FontSize', 12 ); %'Interpreter','LaTeX',
            end
            
            %adjust plot
            set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VLFixedDistanceScaledPlot_%s', savePath, obj.type, lastPathComponent  );
                
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
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
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_LtPlot_%s', savePath, obj.type, lastPathComponent  );
                
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
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
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_LbPlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
        end
        
        %% plotLtLB
        function plotLtLB( obj, savePath )
            
            figHandle = figure();
            hold on;
            obj.plotLt( savePath, figHandle );
            obj.plotLB( savePath, figHandle );
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                filename = sprintf( '%s%splots%s%s_LtLBPlot_%s', savePath, DELIMITER, DELIMITER, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
        end
        
        %% plotLtLBWithImages
        function plotLtLBWithImages( obj, savePath )          
            
            len = length( obj.meanBackgroundArray );
            len = len - 1;
            
            figHandle = figure();
            
            %showLtLB
            subplot( 2, len, [1 : len] );
            hold on;
            obj.plotLt( savePath, figHandle );
            obj.plotLB( savePath, figHandle );
            hold off;
            
            axis('tight');
            l = legend('L_t','L_B');
            t = title( strcat(' mean L_t vs mean L_B ') );
            
            %show images
            for i = 1 : len
                subplot( 2, len, len + i );
                imshow( obj.visualisationImageArray{ i } );
                set( gca,'xtick',[],'ytick',[] );
            end
            
            %adjust plot
            set( l, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                filename = sprintf( '%s%splots%s%s_LtLBWithImagesPlot_%s', savePath, DELIMITER, DELIMITER, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
        end
        
        %% plotCthArea
        function plotCthArray( obj, savePath, figHandle, color )
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % cthresh over Lb for several alpha
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %set standard color
            if ( nargin < 4 )
                color = 'r';
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
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots', DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            
            Lt = 10000001;  %only necessary to indicate positive or negative delta (therefore higher or lower than max / min Lb
            Lb_continuous = logspace(-2,1,100);
            alphaMinutes = obj.alphaArray( 3 );
            
            %bad but we have it currently in that way
            len = length( Lb_continuous );
            deltaLpos = zeros( size( Lb_continuous ) );
            for i = 1 : len
                deltaLpos( i ) = calcDeltaL_RP800( Lb_continuous( i ), max( Lb_continuous + 1), alphaMinutes, obj.ageVL, obj.tVL , obj.kVL );
                deltaLneg( i ) = calcDeltaL_RP800( Lb_continuous( i ), min( Lb_continuous - min( Lb_continuous ) ), alphaMinutes, obj.ageVL, obj.tVL , obj.kVL );
            end
            
            contrastThresholdpos = deltaLpos ./ Lb_continuous;
            contrastThresholdneg = deltaLneg ./ Lb_continuous;
            
            minLb = min( obj.meanBackgroundArray );
            maxLb = max( obj.meanBackgroundArray );
            minCthpos = min( contrastThresholdpos );
            maxCthpos = max( contrastThresholdpos );
            minCthneg = min( contrastThresholdneg );
            maxCthneg = max( contrastThresholdneg );
            minC = min( obj.weberContrastAbsArray );
            maxC = max( obj.weberContrastAbsArray );
            mini = minCthpos;
            if ( minC < mini )
                mini = minC;
            end
            if ( minCthneg < mini )
                mini = minCthneg;
            end
            maxi = maxCthpos;
            if( maxC > maxi )
                maxi = maxC;
            end
            if( maxCthneg > maxi )
                maxi = maxCthneg;
            end
            verticalLine = [ mini; maxi ];
            
            posContrasts = obj.weberContrastAbsArray == obj.weberContrastArray;
            negContrasts = ~posContrasts;
            
            pP1 = loglog( Lb_continuous, contrastThresholdpos, color );
            hold on;
            pP1a = loglog( Lb_continuous, contrastThresholdneg, 'b' );
            %actual contrasts
            pP2 = loglog( obj.meanBackgroundArray( posContrasts ), obj.weberContrastAbsArray( posContrasts ), 'ro' );
            pP2a = loglog( obj.meanBackgroundArray( negContrasts ), obj.weberContrastAbsArray( negContrasts ), 'bo' );
            %vertical lines
            pP3 = loglog( [ minLb; minLb ], verticalLine, 'gr:' );
            pP4 = loglog( [ maxLb; maxLb ], verticalLine, 'gr:' );
            hold off;
            set( pP1, 'LineWidth', obj.LINEWIDTH );
            set( pP1a, 'LineWidth', obj.LINEWIDTH );
            set( pP2, 'LineWidth', obj.LINEWIDTH );
            set( pP3, 'LineWidth', obj.LINEWIDTH );
            set( pP4, 'LineWidth', obj.LINEWIDTH );
            
            pT = title(strcat('Contrast Threshold vs. Actual Contrast'));
            set(pT,'FontSize', obj.FONTSIZE);
            pX = xlabel('L_{B} in cd / m^2');
            set(pX, 'FontSize', obj.FONTSIZE);
            pY = ylabel('C');
            set(pY, 'FontSize', obj.FONTSIZE);
            
            
            %prepare legend
            %alphaStrings = cell(length(alphaDegrees),1);
            %for i = 1 : length(alphaDegrees)
            legendString{ 1 } = sprintf( 'C_{th, pos} for alpha (%s ^{''})', num2str( alphaMinutes ) );
            legendString{ 2 } = sprintf( 'C_{th, neg} for alpha (%s ^{''})', num2str( alphaMinutes ) );
            if( length( sum( posContrasts ) ) )
                legendString{ length( legendString ) + 1 } = 'actual pos contrasts';
            end
            if( length( sum( negContrasts ) ) )
                legendString{ length( legendString ) + 1 } = 'actual neg contrasts';
            end
            %end
            pL = legend( legendString, 'Location', 'Best' );
            %set(pL,'interpreter','LaTeX');
            %v = get( pL, 'title' );
            %set( v, 'string', 'alpha' );
            
            %adjust size:
%             mini = min( obj.meanBackgroundArray );
%             miniLog = log10( mini )
%             miniLog = floor( miniLog )
%             currentAxis = axis( figHandle );
%             axis( figHandle, [ 10^miniLog currentAxis(2) currentAxis(3) currentAxis(4) ] );
%             
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                
                filename = sprintf( '%s%s_CthvsCPlot_%s', savePath, obj.type, lastPathComponent );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
            end
            
        end
        
    end % methods
end