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
        meanBackgroundStreetSurface
        meanBackgroundTwoDegree
        meanBackgroundUpperEdge
        meanBackgroundLowerEdge
        meanBackgroundLeftEdge
        meanBackgroundRightEdge
        meanBackground_RP8_00
        
        %on demand calculated values
        strongestEdgeContrast
        strongestEdgeString         %upperEdge, lowerEdge, leftEdge, rightEdge
        strongestEdgeMeanTarget
        strongestEdgeMeanBackground
        
        
        %currently not necessary values
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
        
        
        %lazy loading of strongestEdgeContrast
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
        
        %lazy loading of strongestEdgeString
        function value = get.strongestEdgeString( obj )
            if( isempty( obj.strongestEdgeString ) )
                %trigger strongestEdgeContrast --> will calculate
                %strongestEdgeString
                obj.strongestEdgeContrast;
            end
            value = obj.strongestEdgeString;
        end
        
        %lazy loading of background luminance according to RP800
        function value = get.meanBackground_RP8_00( obj )
            if( isempty( obj.meanBackground_RP8_00 ) )
                meanBackground_RP8_00 = ( obj.meanBackgroundUpperEdge + obj.meanBackgroundLowerEdge ) / 2;
                obj.meanBackground_RP8_00 = meanBackground_RP8_00;
            end
            value = obj.meanBackground_RP8_00;
        end
        
        %lazy loading of strongestEdgeMeanTarget
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
                else
                    strongestEdgeMeanTarget = obj.meanTargetRightEdge;
                end
                
                obj.strongestEdgeMeanTarget = strongestEdgeMeanTarget;
            end
            
            value = obj.strongestEdgeMeanTarget;
        end
        
        %lazy loading of strongestEdgeString
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
                else
                    strongestEdgeMeanBackground = obj.meanBackgroundRightEdge;
                end
                
                obj.strongestEdgeMeanBackground = strongestEdgeMeanBackground;
            end
            
            value = obj.strongestEdgeMeanBackground;
            
        end
        
        %private methods
        %calculate all values
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
            
            %calc mean of cirlce
            calcMeanOfCircleWithoutRect( dataImage, obj.imageMetadata );
        end
        
    end % methods
end