%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

classdef LMK_Image_Statistics < handle
    properties
        
        imageMetadata   %metadata information about image
        dataType        %photopic, mesopic, scotopic
        
        %values
        meanTarget
        meanTargetUpperEdge
        meanTargetLowerEdge
        meanTargetLeftEdge
        meanTargetRightEdge
        meanTargetUpperLeftCorner
        meanTargetUpperRightCorner
        meanTargetLowerLeftCorner
        meanTargetLowerRightCorner
        meanBackgroundStreetSurface
        meanBackgroundTwoDegree
        meanBackgroundUpperEdge
        meanBackgroundLowerEdge
        meanBackgroundLeftEdge
        meanBackgroundRightEdge
        meanBackground_RP8_00
        meanBackgroundUpperLeftCorner
        meanBackgroundUpperRightCorner
        meanBackgroundLowerLeftCorner
        meanBackgroundLowerRightCorner
        
        %on demand calculated values
        strongestEdgeContrast
        strongestEdgeString         %upperEdge, lowerEdge, leftEdge, rightEdge
        strongestEdgeMeanTarget
        strongestEdgeMeanBackground
        strongestCornerContrast
        strongestCornerString         %upperLeftCorner, upperRightCorner, lowerLeftCorner, lowerRightCorner
        strongestCornerMeanTarget
        strongestCornerMeanBackground
        alphaMinutes
        
        
        %currently not necessary values -> most probably deprecated
        minTarget
        maxTarget
        stdTarget
        imgResult
        radius
        savePath
        dataImage
        filename
        
        
        
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Statistics( imageMetadata, dataType )
            if nargin > 0 % Support calling with 0 arguments
                obj.imageMetadata = imageMetadata;
                obj.dataType = dataType;
                performCalculations( obj )
            end
        end% constructor
        
        
        %% lazy loading of strongestEdgeContrast
        function value = get.strongestEdgeContrast( obj )
            if( isempty( obj.strongestEdgeContrast ) )
                
                upperEdgeContrast = abs( obj.meanTargetUpperEdge - obj.meanBackgroundUpperEdge ) / obj.meanBackgroundUpperEdge;
                lowerEdgeContrast = abs( obj.meanTargetLowerEdge - obj.meanBackgroundLowerEdge ) / obj.meanBackgroundLowerEdge;
                leftEdgeContrast = abs( obj.meanTargetLeftEdge - obj.meanBackgroundLeftEdge ) / obj.meanBackgroundLeftEdge;
                rightEdgeContrast = abs( obj.meanTargetRightEdge - obj.meanBackgroundRightEdge ) / obj.meanBackgroundRightEdge;
                
                if ( ( upperEdgeContrast >= lowerEdgeContrast )...
                        && ( upperEdgeContrast >= leftEdgeContrast )...
                        && ( upperEdgeContrast >= rightEdgeContrast ) )
                    strongestEdge = 'upperEdge';
                    stringestEdgeContrast = upperEdgeContrast;
                elseif ( ( lowerEdgeContrast >= upperEdgeContrast )...
                        && ( lowerEdgeContrast >= leftEdgeContrast )...
                        && ( lowerEdgeContrast >= rightEdgeContrast ) )
                    strongestEdge = 'lowerEdge';
                    stringestEdgeContrast = lowerEdgeContrast;
                elseif ( ( leftEdgeContrast >= lowerEdgeContrast )...
                        && ( leftEdgeContrast >= upperEdgeContrast )...
                        && ( leftEdgeContrast >= rightEdgeContrast ) )
                    strongestEdge = 'leftEdge';
                    stringestEdgeContrast = leftEdgeContrast;
                else
                    strongestEdge = 'rightEdge';
                    stringestEdgeContrast = rightEdgeContrast;
                end
                
                %print info
                disp(sprintf('strongest edge: %s', strongestEdge));
                
                %assign values
                obj.strongestEdgeContrast = stringestEdgeContrast;
                obj.strongestEdgeString = strongestEdge;
            end
            value = obj.strongestEdgeContrast;
        end
        
        %% lazy loading of strongestEdgeString
        function value = get.strongestEdgeString( obj )
            if( isempty( obj.strongestEdgeString ) )
                %trigger strongestEdgeContrast --> will calculate
                %strongestEdgeString
                obj.strongestEdgeContrast;
            end
            value = obj.strongestEdgeString;
        end
        
        %% lazy loading of strongestEdgeMeanTarget
        function value = get.strongestEdgeMeanTarget( obj )
            if( isempty( obj.strongestEdgeMeanTarget ) )
                %trigger strongestEdgeContrast --> will calculate
                %strongestEdgeString
                obj.strongestEdgeContrast;
                
                if ( strcmp( obj.strongestEdgeString, 'upperEdge' ) )
                    strongestEdgeMeanTarget = obj.meanTargetUpperEdge;
                elseif ( strcmp( obj.strongestEdgeString, 'lowerEdge' ) )
                    strongestEdgeMeanTarget = obj.meanTargetLowerEdge;
                elseif ( strcmp( obj.strongestEdgeString, 'leftEdge' ) )
                    strongestEdgeMeanTarget = obj.meanTargetLeftEdge;
                elseif ( strcmp( obj.strongestEdgeString, 'rightEdge' ) )
                    strongestEdgeMeanTarget = obj.meanTargetRightEdge;
                else
                    error('no strongestEdgeString given!!!')
                end
                
                obj.strongestEdgeMeanTarget = strongestEdgeMeanTarget;
            end
            
            value = obj.strongestEdgeMeanTarget;
        end
        
        %% lazy loading of strongestEdgeString
        function value = get.strongestEdgeMeanBackground( obj )
            if( isempty( obj.strongestEdgeMeanBackground ) )
                %trigger strongestEdgeContrast --> will calculate
                %strongestEdgeString
                obj.strongestEdgeContrast;
                
                if ( strcmp( obj.strongestEdgeString, 'upperEdge' ) )
                    strongestEdgeMeanBackground = obj.meanBackgroundUpperEdge;
                elseif ( strcmp( obj.strongestEdgeString, 'lowerEdge' ) )
                    strongestEdgeMeanBackground = obj.meanBackgroundLowerEdge;
                elseif ( strcmp( obj.strongestEdgeString, 'leftEdge' ) )
                    strongestEdgeMeanBackground = obj.meanBackgroundLeftEdge;
                elseif ( strcmp( obj.strongestEdgeString, 'rightEdge' ) )
                    strongestEdgeMeanBackground = obj.meanBackgroundRightEdge;
                else
                    error('no strongestEdgeString given!!!')
                end
                
                obj.strongestEdgeMeanBackground = strongestEdgeMeanBackground;
            end
            
            value = obj.strongestEdgeMeanBackground;
            
        end
        
        %% lazy loading of strongestCornerContrast
        function value = get.strongestCornerContrast( obj )
            if( isempty( obj.strongestCornerContrast ) )
                
                upperLeftCornerContrast = abs( obj.meanTargetUpperLeftCorner - obj.meanBackgroundUpperLeftCorner ) / obj.meanBackgroundUpperLeftCorner;
                upperRightCornerContrast = abs( obj.meanTargetUpperRightCorner - obj.meanBackgroundUpperRightCorner ) / obj.meanBackgroundUpperRightCorner;
                lowerLeftCornerContrast = abs( obj.meanTargetLowerLeftCorner - obj.meanBackgroundLowerLeftCorner ) / obj.meanBackgroundLowerLeftCorner;
                lowerRightCornerContrast = abs( obj.meanTargetLowerRightCorner - obj.meanBackgroundLowerRightCorner ) / obj.meanBackgroundLowerRightCorner;
                
                if ( ( upperLeftCornerContrast >= upperRightCornerContrast )...
                        && ( upperLeftCornerContrast >= lowerLeftCornerContrast )...
                        && ( upperLeftCornerContrast >= lowerRightCornerContrast ) )
                    strongestCorner = 'upperLeftCorner';
                    strongestCornerContrast = upperLeftCornerContrast;
                elseif ( ( upperRightCornerContrast >= upperLeftCornerContrast )...
                        && ( upperRightCornerContrast >= lowerLeftCornerContrast )...
                        && ( upperRightCornerContrast >= lowerRightCornerContrast ) )
                    strongestCorner = 'upperRightCorner';
                    strongestCornerContrast = upperRightCornerContrast;
                elseif ( ( lowerLeftCornerContrast >= upperLeftCornerContrast )...
                        && ( lowerLeftCornerContrast >= upperRightCornerContrast )...
                        && ( lowerLeftCornerContrast >= lowerRightCornerContrast ) )
                    strongestCorner = 'lowerLeftCorner';
                    strongestCornerContrast = lowerLeftCornerContrast;
                else
                    strongestCorner = 'lowerRightCorner';
                    strongestCornerContrast = lowerRightCornerContrast;
                end
                
                %print info
                disp(sprintf('strongest corner: %s', strongestCorner));
                
                %assign values
                obj.strongestCornerContrast = strongestCornerContrast;
                obj.strongestCornerString = strongestCorner;
            end
            value = obj.strongestCornerContrast;
        end
        
        %% lazy loading of strongestCornerString
        function value = get.strongestCornerString( obj )
            if( isempty( obj.strongestCornerString ) )
                %trigger strongestCornerContrast --> will calculate
                %strongestCornerString
                obj.strongestCornerContrast;
            end
            value = obj.strongestCornerString;
        end
        
        %% lazy loading of strongestCornerMeanTarget
        function value = get.strongestCornerMeanTarget( obj )
            if( isempty( obj.strongestCornerMeanTarget ) )
                %trigger strongestCornerContrast --> will calculate
                %strongestCornerString
                obj.strongestCornerContrast;
                
                if ( strcmp( obj.strongestCornerString, 'upperLeftCorner' ) )
                    strongestCornerMeanTarget = obj.meanTargetUpperLeftCorner;
                elseif ( strcmp( obj.strongestCornerString, 'upperRightCorner' ) )
                    strongestCornerMeanTarget = obj.meanTargetUpperRightCorner;
                elseif ( strcmp( obj.strongestCornerString, 'lowerLeftCorner' ) )
                    strongestCornerMeanTarget = obj.meanTargetLowerLeftCorner;
                elseif ( strcmp( obj.strongestCornerString, 'lowerRightCorner' ) )
                    strongestCornerMeanTarget = obj.meanTargetLowerRightCorner;
                else
                    error('no strongestCornerString given!!!')
                end
                
                obj.strongestCornerMeanTarget = strongestCornerMeanTarget;
            end
            
            value = obj.strongestCornerMeanTarget;
        end
        
        %% lazy loading of strongestCornerMeanBackground
        function value = get.strongestCornerMeanBackground( obj )
            if( isempty( obj.strongestCornerMeanBackground ) )
                %trigger strongestCornerContrast --> will calculate
                %strongestCornerString
                obj.strongestCornerContrast;
                
                if ( strcmp( obj.strongestCornerString, 'upperLeftCorner' ) )
                    strongestCornerMeanBackground = obj.meanBackgroundUpperEdge;
                elseif ( strcmp( obj.strongestCornerString, 'upperRightCorner' ) )
                    strongestCornerMeanBackground = obj.meanBackgroundLowerEdge;
                elseif ( strcmp( obj.strongestCornerString, 'lowerLeftCorner' ) )
                    strongestCornerMeanBackground = obj.meanBackgroundLeftEdge;
                elseif ( strcmp( obj.strongestCornerString, 'lowerRightCorner' ) )
                    strongestCornerMeanBackground = obj.meanBackgroundRightEdge;
                else
                    error('no strongestCornerString given!!!')
                end
                
                obj.strongestCornerMeanBackground = strongestCornerMeanBackground;
            end
            
            value = obj.strongestCornerMeanBackground;
            
        end
        
        
        %% lazy loading of background luminance according to RP800
        function value = get.meanBackground_RP8_00( obj )
            if( isempty( obj.meanBackground_RP8_00 ) )
                meanBackground_RP8_00 = ( obj.meanBackgroundUpperEdge + obj.meanBackgroundLowerEdge ) / 2;
                obj.meanBackground_RP8_00 = meanBackground_RP8_00;
            end
            value = obj.meanBackground_RP8_00;
        end
        
        %% lazy loading of alphaMinutes
        function value = get.alphaMinutes( obj )
            if( isempty( obj.alphaMinutes ) )
                distanceToObject = obj.imageMetadata.distanceToObject;
                targetSize = obj.imageMetadata.targetSize;
%                 alphaRad = 2 * atan( targetSize / 2 ./ distanceToObject );
%                 targetAlphaMinutes = ( alphaRad / pi * 180 * 60 );
%                 obj.alphaMinutes = targetAlphaMinutes;
                  obj.alphaMinutes = obj.calcAlphaMinutesForRectAndDistance( targetSize, distanceToObject );
            end
            value = obj.alphaMinutes;
        end
        
        %% alpha minute calculation helper function
        function alphaMinutes = calcAlphaMinutesForRectAndDistance( obj, targetSize, distanceToObject )
                alphaRad = 2 * atan( ( targetSize / 2 ) ./ distanceToObject );
                alphaMinutes = ( alphaRad / pi * 180 * 60 );
                disp( sprintf( 'current alphaMinutes: %f for targetSize: %f and distanceToObject: %f', alphaMinutes, targetSize, distanceToObject ) );
        end
        
        %% private methods
        %% calculate all values
        function performCalculations(obj)
            
            if( strcmp( obj.dataType, 'Photopic') )
                dataImage = obj.imageMetadata.dataImagePhotopic;
            elseif( strcmp( obj.dataType, 'Scotopic') )
                dataImage = obj.imageMetadata.dataImageScotopic;
            elseif( strcmp( obj.dataType, 'Mesopic') )
                dataImage = obj.imageMetadata.dataImageMesopic;
            else
                disp( sprintf( 'unknown dataType:%s', obj.dataType ) );
                disp( 'dataType has to be Photopic, Scotopic or Mesopic' );
            end
            
            
            %calc mean of target
            calcMeanOfTarget( dataImage , obj );
            
            %calc mean of background
            calcMeanOfTargetEdges( dataImage , obj );
            
            %calc mean of circle
            calcMeanOfCircleWithoutRect( dataImage, obj );
        end
        
    end % methods
end