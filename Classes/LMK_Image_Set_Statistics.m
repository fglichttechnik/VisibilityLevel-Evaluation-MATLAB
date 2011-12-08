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
        
        alphaArray                  %array with target sizes
        meanTargetArray             %array with target means of current set
        meanBackgroundArray         %array with background means of current set
        weberContrastArray          %array with weber contrasts of current set
        thresholdContrastArray        %array with threshold contrasts of current set
        visibilityLevelArray        %array with visibility levels of current set
        
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
            
            %calculate values
            for currentValue = 1 : length( meanTargetArray )
                meanTargetArray( currentValue ) = currentStatisticsArray{ currentValue }.strongestEdgeMeanTarget;
                meanBackgroundArray( currentValue ) = currentStatisticsArray{ currentValue }.strongestEdgeMeanBackground;
            end
            weberContrastArray = meanTargetArray ./ meanBackgroundArray - 1;
             for currentValue = 1 : length( meanTargetArray )
                 Lb = meanBackgroundArray( currentValue );
                 Lt = meanTargetArray( currentValue );
                thresholdContrastArray( currentValue ) = calcDeltaL(Lb, Lt, obj.alphaArray( currentValue ), obj.ageVL, obj.tVL, obj.kVL)
            end
            visibilityLevelArray = weberContrastArray ./ thresholdContrastArray;
            
            %set instance values
            obj.meanTargetArray = meanTargetArray;
            obj.meanBackgroundArray = meanBackgroundArray;
            obj.weberContrastArray = weberContrastArray;
            obj.thresholdContrastArray = thresholdContrastArray;
            obj.visibilityLevelArray = visibilityLevelArray;
        end
        
        function plotStrongestEdgeContrast( obj )
            plot( obj.weberContrastArray );
        end
        
        
    end % methods
end