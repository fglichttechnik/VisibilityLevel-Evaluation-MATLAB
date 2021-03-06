%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.

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
        weberContrastAbsArray       %array with weber contrasts of current set
        thresholdContrastArray      %array with threshold contrasts of current set
        visibilityLevelArray        %array with visibility levels of current set
        visibilityLevelFixedDistanceArray        %array with visibility levels of current set (distance is assumed to be the samefor all target positions)
        distanceArray               %array with distances of current set
        visualisationImageArray     %array with visualisation images of current set
        visualisationMeasArray
        
        veilLumStreetLightArray       %array with all fixed veiling luminance streetlight
        veilLumVariableHeadlightArray %array with only fixed veiling luminance headlight
        veilLumFixedHeadlightArray    %array with only variable veiling luminance headlight
        
        
        stvStartIndex               %index to start STV calculation from
        stvEndIndex                 %index to end STV calculation with
        smallTargetVL               %small target visibility level; weighted average of all VL
        
        setTitle                    %title for this set
        
        contrastCalculationMethod   %can be STRONGEST_EDGE, RP800, LOWER_EDGE, LEFT_EDGE, RIGHT_EDGE, UPPER_EDGE, STRONGEST_CORNER, 2DEGREE_BACKGROUND or other to be implemented methods
        
        offset                      % if 0 the relative position within the meas field is plotted, else offset is the distance from the VP to the meas field for absolute values
        
        FONTSIZE
        LINEWIDTH
        
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Set_Statistics( type, lengthOfSet, ageVL, tVL, kVL, setTitle, contrastCalculationMethod, offset, stvStartIndex, stvEndIndex )
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
                obj.offset = offset;
                obj.stvStartIndex = stvStartIndex;
                obj.stvEndIndex = stvEndIndex;
            end
            
            obj.FONTSIZE = 14;
            obj.LINEWIDTH = 3.0;
            
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
            visualisationMeasArray = cell( size( currentStatisticsArray ) );
            veilingLumArrayFixed = zeros( size( currentStatisticsArray ) );
            veilingLumArrayVariableHead = cell( size( currentStatisticsArray ) );
            veilingLumArrayFixedHead = cell( size( currentStatisticsArray ) );
            
            for currentIndex = 1 : length( veilingLumArrayFixed )
                currentStatistics = currentStatisticsArray{ currentIndex };
                currentVeilingLumArray = currentStatistics.imageMetadata.veilingLuminance ;
                
                findFailure = 0 ;
                fixedSize = 0 ;
                variableSize = 0 ;
                veilingLumArrayFixedHelp =  cell( size ( currentVeilingLumArray ) );
                veilingLumArrayVariableHelp = cell( size ( currentVeilingLumArray ) );
                
                for arrayCrawler = 1 : length( currentVeilingLumArray ) 
                    currentVeilingLum = currentVeilingLumArray{ arrayCrawler };
                    if( strcmp( currentVeilingLum.type , 'streetlight') )
                        oneValueFixedVeilingLum = currentVeilingLum.veilingLuminance ;
                        findFailure = findFailure + 1 ;
                    end
                    %% HACK
                    if( strcmp( currentVeilingLum.type , 'noValue') )
                        oneValueFixedVeilingLum = currentVeilingLum.veilingLuminance ;
                        findFailure = findFailure + 1 ;
                    end
                    if( strcmp( currentVeilingLum.type , 'fixedHeadlight' ) )
                        fixedSize = fixedSize + 1 ;
                        veilingLumArrayFixedHelp{ fixedSize } = currentVeilingLum ;
                    end
                    if( strcmp( currentVeilingLum.type , 'variableHeadlight' ) )
                        variableSize = variableSize + 1 ;
                        veilingLumArrayVariableHelp{ variableSize } = currentVeilingLum ;    
%                     else
%                         disp( sprintf( 'something wrong with veiling luminance array, type must be streetlight, fixedHeadlight or variableHeadlight' ) );
%                         disp( 'QUITTING' );
%                         return;
                    end
                end
                
                veilingLumArrayFixed( currentIndex ) = oneValueFixedVeilingLum ;
                veilingLumArrayVariableHead{ currentIndex } =  cleanEmptyCells( veilingLumArrayVariableHelp );
                veilingLumArrayFixedHead{ currentIndex } = cleanEmptyCells( veilingLumArrayFixedHelp ) ;
                
                if( findFailure ~= 1 )
                    disp( 'Problem: more values then one streetlight per measpoint' );
                    return;
                end                 
            end
            
            obj.veilLumStreetLightArray = veilingLumArrayFixed ;
            
            if(~isempty( veilingLumArrayVariableHead ))
                obj.veilLumVariableHeadlightArray = cleanEmptyCells( veilingLumArrayVariableHead );
            end
            
            if(~isempty( veilingLumArrayFixedHead ))
                obj.veilLumFixedHeadlightArray = cleanEmptyCells( veilingLumArrayFixedHead );
            end
            
            %create arrays with Lt , LB and d
            for currentIndex = 1 : length( meanTargetArray )
                currentStatistics = currentStatisticsArray{ currentIndex };
                distanceArray( currentIndex ) = currentStatistics.imageMetadata.rectPosition + obj.offset;
                visualisationImageArray{ currentIndex } = currentStatistics.imageMetadata.visualisationImagePhotopic;
                visualisationMeasArray{ currentIndex } = currentStatistics.imageMetadata.visualisationMeasRegions;
                
                if ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_EDGE' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.strongestEdgeMeanTarget;
                elseif ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_CORNER' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.strongestCornerMeanTarget;
                elseif ( strcmp( obj.contrastCalculationMethod, 'RP800' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTarget;
                    
                elseif ( strcmp( obj.contrastCalculationMethod, 'LOWER_EDGE' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTargetLowerEdge;
                elseif ( strcmp( obj.contrastCalculationMethod, 'LEFT_EDGE' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTargetLeftEdge;
                elseif ( strcmp( obj.contrastCalculationMethod, 'RIGHT_EDGE' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTargetRightEdge;
                elseif ( strcmp( obj.contrastCalculationMethod, 'UPPER_EDGE' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTargetUpperEdge;
                    
                elseif ( strcmp( obj.contrastCalculationMethod, '2DEGREE_BACKGROUND' ) )
                    meanTargetArray( currentIndex ) = currentStatistics.meanTarget;
                end
                
                if ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_EDGE' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.strongestEdgeMeanBackground;
                elseif ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_CORNER' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.strongestCornerMeanBackground;
                elseif ( strcmp( obj.contrastCalculationMethod, 'RP800' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackground_RP8_00;
                    
                elseif ( strcmp( obj.contrastCalculationMethod, 'LOWER_EDGE' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackgroundLowerEdge;
                elseif ( strcmp( obj.contrastCalculationMethod, 'LEFT_EDGE' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackgroundLeftEdge;
                elseif ( strcmp( obj.contrastCalculationMethod, 'RIGHT_EDGE' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackgroundRightEdge;
                elseif ( strcmp( obj.contrastCalculationMethod, 'UPPER_EDGE' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackgroundUpperEdge;
                    
                elseif ( strcmp( obj.contrastCalculationMethod, '2DEGREE_BACKGROUND' ) )
                    meanBackgroundArray( currentIndex ) = currentStatistics.meanBackgroundTwoDegree;
                else
                    disp( sprintf( 'contrastCalculationMethod must be either STRONGEST_EDGE, STRONGEST_CORNER, LOWER_EDGE, LEFT_EDGE, RIGHT_EDGE, UPPER_EDGE, 2DEGREE_BACKGROUND or RP800' ) );
                    disp( sprintf( 'contrastCalculationMethod is currently %s', obj.contrastCalculationMethod ) );
                    disp( 'QUITTING' );
                    return;
                end
                
            end
            
            %calculate weber contrast
            weberContrastArray = ( meanTargetArray - meanBackgroundArray ) ./ meanBackgroundArray;
            weberContrastAbsArray = abs( weberContrastArray );
            
            %get alpha in minutes of target
            
            % this is to simulate a fixed  target distance for a fixed view point
            % measurement
            % any metadata instance should suffice ( viewPointDistance and targetSize should be the same for
            % all)
            viewPointDistance = currentStatisticsArray{ 1 }.imageMetadata.viewPointDistance;
            targetSize = currentStatisticsArray{ 1 }.imageMetadata.targetSize;
            fixedAlphaMinutes = currentStatisticsArray{ 1 }.calcAlphaMinutesForRectAndDistance( targetSize, viewPointDistance );
            
            %calculate threshold contrast
            for currentIndex = 1 : length( meanTargetArray )
                
                Lb = meanBackgroundArray( currentIndex );
                Lt = meanTargetArray( currentIndex );
                alphaMinutes = currentStatisticsArray{ currentIndex }.alphaMinutes;
                deltaL = calcDeltaL(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL);     % as shown in Adrian1989
                deltaL_RP800 = calcDeltaL_RP800(Lb, Lt, alphaMinutes, obj.ageVL, obj.tVL, obj.kVL); % as shown in RP 8 00 (WE LIKE THIS)
                thresholdContrastArray( currentIndex ) = deltaL_RP800 / Lb;
                
                disp( sprintf( 'deltaLAdrian: %f deltaLRP800: %f', deltaL, deltaL_RP800 ) );
                
                %calc the same for fixed distance (we take the first distance in the measurement field, that's currently object 3)
                deltaLFixedDistance = calcDeltaL_RP800(Lb, Lt, fixedAlphaMinutes, obj.ageVL, obj.tVL, obj.kVL);
                thresholdContrastFixedDistanceArray( currentIndex ) = deltaLFixedDistance / Lb;
                
            end
            
            %calculate visibility level
            %VL is always positive (not in RP800) was abs()
            visibilityLevelArray = (weberContrastArray ./ thresholdContrastArray);
            visibilityLevelFixedDistanceArray = (weberContrastArray ./ thresholdContrastFixedDistanceArray);
            %             signPos = ( weberContrastArray >= 0 );
            %             signNeg = ~signPos;
            %             signPosNeg = zeros( length(signPos), 1);
            %             signPosNeg( signPos ) = 1;
            %             signPosNeg( signNeg ) = -1;
            %             visibilityLevelArray = visibilityLevelArray .* signPosNeg;
            %             visibilityLevelFixedDistanceArray = visibilityLevelFixedDistanceArray .* signPosNeg;
            
            %set instance values
            obj.visualisationImageArray = visualisationImageArray;
            obj.visualisationMeasArray = visualisationMeasArray;
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
                    %ignore certain values for STV calculation
                    startIndex = 1;
                    endIndex = length( obj.visibilityLevelFixedDistanceArray );
                    
                    if( obj.stvStartIndex )
                        if( obj.stvStartIndex <= endIndex )
                            startIndex = obj.stvStartIndex;
                        else
                            error(sprintf('stvStartIndex is out of range (%d length is %d)', obj.stvStartIndex, endIndex));
                        end
                    end
                    if( obj.stvEndIndex )
                        if( obj.stvEndIndex <= endIndex )
                            endIndex = obj.stvEndIndex;
                        else
                            error(sprintf('stvEndIndex is out of range (%d length is %d)', obj.stvEndIndex, endIndex));
                        end
                    end
                    
                    visibilityLevelArrayOfMeasurementField = obj.visibilityLevelFixedDistanceArray( startIndex : endIndex );
                    disp( sprintf( 'calculating STV from index %d to index %d of image array', startIndex, endIndex) );
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
            
            if( ~exist( [savePath, DELIMITER, 'visImages_', obj.contrastCalculationMethod], 'dir') )
                mkdir( [savePath, DELIMITER, 'visImages_', obj.contrastCalculationMethod] );
            end
            for currentIndex = 1 : length( obj.visualisationImageArray )
                image = obj.visualisationImageArray{ currentIndex };
                
                %save strongest edge / corner decision to saveImage
                currentStatisticsArray = obj.lmkImageStatisticsArray;
                currentStatistics = currentStatisticsArray{ currentIndex };
                if ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_EDGE' )  )
                    filename = sprintf( '%s%svisImages_%s%s%s_%s_%d.png', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, currentStatistics.strongestEdgeString, currentIndex );
                elseif ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_CORNER' ) )
                    filename = sprintf( '%s%svisImages_%s%s%s_%s_%d.png', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, currentStatistics.strongestCornerString, currentIndex );
                else
                    filename = sprintf( '%s%svisImages_%s%s%s%d.png', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, currentIndex );
                end
                
                imwrite( image, filename );
            end
            for currentIndex = 1 : length( obj.visualisationMeasArray )
                image = obj.visualisationMeasArray{ currentIndex };
                
                %save strongest edge / corner decision to saveImage
                currentStatisticsArray = obj.lmkImageStatisticsArray;
                currentStatistics = currentStatisticsArray{ currentIndex };
                if ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_EDGE' )  )
                    filename = sprintf( '%s%svisImages_%s%sMeasRegions_%s_%s_%d.png', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, currentStatistics.strongestEdgeString, currentIndex );
                elseif ( strcmp( obj.contrastCalculationMethod, 'STRONGEST_CORNER' ) )
                    filename = sprintf( '%s%svisImages_%s%sMeasRegions_%s_%s_%d.png', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, currentStatistics.strongestCornerString, currentIndex );
                else
                    filename = sprintf( '%s%svisImages_%s%sMeasRegions_%s%d.png', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, currentIndex );
                end
                
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_weberContrastPlot_%s', savePath, obj.type, lastPathComponent );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
            end
            
        end
        
        
        
        %% plotAbsContrast
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_weberContrastAbsPlot_%s', savePath, obj.type, lastPathComponent );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_deltaLPlot_%s', savePath, obj.type, lastPathComponent  );
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_CthPlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VLPlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VLFixedDistancePlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VLFixedDistanceScaledPlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_LtPlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
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
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_LbPlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            
            finetunePlot( figHandle );
            
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
                filename = sprintf( '%s%splots_%s%s%s_LtLBPlot_%s', savePath, DELIMITER, obj.contrastCalculationMethod, DELIMITER, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
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
            
            finetunePlot( figHandle );
            
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
                filename = sprintf( '%s%splots_%s%s%s_LtLBWithImagesPlot_%s', savePath, obj.contrastCalculationMethod, DELIMITER, DELIMITER, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
            end
        end
        
        %% plotCthArrayContrastThresholds
        function plotCthArrayContrastThresholds( obj, figHandle )
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % cthresh over Lb for several alpha
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %THIS FUNCTION WORKS ONLY WITH THE CORRESPONDING 2 OTHERS
            
            Lt = 10000001;  %only necessary to indicate positive or negative delta (therefore higher or lower than max / min Lb
            Lb_continuous = logspace(-2,1,100);
            alphaMinutes = obj.alphaArray( 3 );
            
            %bad but we have it currently in that way
            len = length( Lb_continuous );
            deltaLpos = zeros( size( Lb_continuous ) );
            deltaLneg = zeros( size( Lb_continuous ) );
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
            
            posContrasts = obj.weberContrastArray >= 0;
            negContrasts = ~posContrasts;
            
            pP1 = semilogx( Lb_continuous, contrastThresholdpos, 'r' );
            hold on;
            pP1a = semilogx( Lb_continuous, contrastThresholdneg, 'b' );
            
            set( pP1, 'LineWidth', obj.LINEWIDTH );
            set( pP1a, 'LineWidth', obj.LINEWIDTH );
            
            pT = title(strcat('Contrast Threshold vs. Actual Contrast'));
            set(pT,'FontSize', obj.FONTSIZE);
            pX = xlabel('L_{B} in cd / m^2');
            set(pX, 'FontSize', obj.FONTSIZE);
            pY = ylabel('C');
            set(pY, 'FontSize', obj.FONTSIZE);
            
        end
        
        %% plotCthArrayCurrentData
        function [ legendString ] = plotCthArrayCurrentData( obj, figHandle, color, plotsign )
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % cthresh over Lb for several alpha
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %THIS FUNCTION WORKS ONLY WITH THE CORRESPONDING 2 OTHERS
            
            %set standard color
            if ( nargin < 4 )
                plotsign = 'o';
            end
            
            if ( nargin < 3 )
                color = 1;
            end
            
            %             if ( color == 1 )
            %                 color1 = sprintf( 'r%s', plotsign );
            %                 color2 = sprintf( 'k%s', plotsign );
            %             elseif ( color == 2 )
            %                 color1 = sprintf( 'gr%s', plotsign );
            %                 color2 = sprintf( 'b%s', plotsign );
            %             else
            color1 = sprintf( 'r%s', plotsign );
            color2 = sprintf( 'b%s', plotsign );
            %end
            
            posContrasts = obj.weberContrastArray >= 0;
            negContrasts = ~posContrasts;
            alphaMinutes = obj.alphaArray( 3 );
            
            %actual contrasts
            hold on;
            pP2 = semilogx( obj.meanBackgroundArray( posContrasts ), obj.weberContrastAbsArray( posContrasts ), color1 );
            pP2a = semilogx( obj.meanBackgroundArray( negContrasts ), obj.weberContrastAbsArray( negContrasts ), color2 );
            hold off;
            
            set( pP2, 'LineWidth', obj.LINEWIDTH );
            set( pP2a, 'LineWidth', obj.LINEWIDTH );
            
            pT = title(strcat('Contrast Threshold vs. Actual Contrast'));
            set(pT,'FontSize', obj.FONTSIZE);
            pX = xlabel('L_{B} in cd / m^2');
            set(pX, 'FontSize', obj.FONTSIZE);
            pY = ylabel('C');
            set(pY, 'FontSize', obj.FONTSIZE);
            
            
            %prepare legend
            %alphaStrings = cell(length(alphaDegrees),1);
            %for i = 1 : length(alphaDegrees)
            legendString{ 1 } = sprintf( 'C_{th, pos} for alpha %3.2f ^{''}', alphaMinutes );
            legendString{ 2 } = sprintf( 'C_{th, neg} for alpha %3.2f ^{''}', alphaMinutes );
            if( sum( posContrasts ) )
                legendString{ length( legendString ) + 1 } = 'actual pos contrasts';
            end
            if( sum( negContrasts ) )
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
            
        end
        
        %% plotCthArrayLBBorderAndSave
        function plotCthArrayLBBorderAndSave( obj, savePath, figHandle, minLb, maxLb )
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % cthresh over Lb for several alpha
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %platform specific path delimiter
            if(ispc)
                DELIMITER = '\';
            elseif(isunix)
                DELIMITER = '/';
            end
            
            if( strcmp( savePath, '' ) )
                savePath = 'DO_NOT_SAVE'
            end
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            
            Lt = 10000001;  %only necessary to indicate positive or negative delta (therefore higher or lower than max / min Lb
            Lb_continuous = logspace(-2,1,100);
            alphaMinutes = obj.alphaArray( 3 );
            disp( sprintf( 'calculating Cth with alpha: %f', alphaMinutes ) );
            
            %bad but we have it currently in that way
            len = length( Lb_continuous );
            deltaLpos = zeros( size( Lb_continuous ) );
            for i = 1 : len
                deltaLpos( i ) = calcDeltaL_RP800( Lb_continuous( i ), max( Lb_continuous + 1), alphaMinutes, obj.ageVL, obj.tVL , obj.kVL );
                deltaLneg( i ) = calcDeltaL_RP800( Lb_continuous( i ), min( Lb_continuous - min( Lb_continuous ) ), alphaMinutes, obj.ageVL, obj.tVL , obj.kVL );
            end
            
            contrastThresholdpos = deltaLpos ./ Lb_continuous;
            contrastThresholdneg = deltaLneg ./ Lb_continuous;
            
            if( nargin < 4 )
                minLb = min( obj.meanBackgroundArray );
                maxLb = max( obj.meanBackgroundArray );
            end
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
            
            posContrasts = obj.weberContrastArray >= 0;
            negContrasts = ~posContrasts;
            
            
            %vertical lines
            hold on;
            pP3 = semilogx( [ minLb; minLb ], verticalLine, 'gr:' );
            pP4 = semilogx( [ maxLb; maxLb ], verticalLine, 'gr:' );
            hold off;
            
            set( pP3, 'LineWidth', obj.LINEWIDTH );
            set( pP4, 'LineWidth', obj.LINEWIDTH );
            
            pT = title(strcat('Contrast Threshold vs. Actual Contrast'));
            set(pT,'FontSize', obj.FONTSIZE);
            pX = xlabel('L_{B} in cd / m^2');
            set(pX, 'FontSize', obj.FONTSIZE);
            pY = ylabel('C');
            set(pY, 'FontSize', obj.FONTSIZE);
            
            finetunePlot( figHandle );
            
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
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
            end
            
        end
        
        %% plotFixedVeilingLuminance
        function plotFixedVeilingLuminance( obj, savePath, figHandle, color )
            
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
            savePath = [savePath, DELIMITER, 'plots_', obj.contrastCalculationMethod, DELIMITER];
            if( ~exist( savePath, 'dir') && ~strcmp( savePath, 'DO_NOT_SAVE' ) )
                mkdir( savePath );
            end
            
            %activate corresponding figure
            set(0, 'CurrentFigure', figHandle);
            
            %plot veiling luminance
            p = plot( obj.distanceArray, obj.veilLumStreetLightArray, color );
            %legend('Lv_{photopisch}');
            axis('tight');
            x = xlabel('d in m');
            y = ylabel('L_v');
            t = title( strcat('Veiling Luminance Streetlight') );
            
            %adjust plot
            set( p, 'LineWidth', obj.LINEWIDTH );
            set( x, 'FontSize', obj.FONTSIZE );
            set( y, 'FontSize', obj.FONTSIZE );
            set( t, 'FontSize', obj.FONTSIZE );
            
            finetunePlot( figHandle );
            
            if( ~strcmp( savePath, 'DO_NOT_SAVE' ) )

                %we need the last path component for filename of plots
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( savePath );
                [ firstPath, lastPathComponent, fileExtension ] = fileparts( firstPath );
                filename = sprintf( '%s%s_VeilingLuminancePlot_%s', savePath, obj.type, lastPathComponent  );
                
                saveas(figHandle, filename, 'epsc');
                saveas(figHandle, filename, 'fig');
                fixPSlinestyle( sprintf( '%s.eps', filename ) );
            end
           
        end
        
    end % methods
end