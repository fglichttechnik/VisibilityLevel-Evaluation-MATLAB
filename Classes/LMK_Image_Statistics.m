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
        
        %on demand calculated values
        strongestEdgeContrast
        strongestEdgeString         %upperEdge, lowerEdge, leftEdge, rightEdge
        strongestEdgeMeanTarget
        strongestEdgeMeanBackground
        
        %visualisation (the areas for calculation are marked in that image)
        visualisationImage
        
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
                
                upperEdgeContrast = obj.meanTargetUpperEdge / obj.meanBackgroundUpperEdge - 1;
                lowerEdgeContrast = obj.meanTargetLowerEdge / obj.meanBackgroundLowerEdge - 1;
                leftEdgeContrast = obj.meanTargetLeftEdge / obj.meanBackgroundLeftEdge - 1;
                rightEdgeContrast = obj.meanTargetRightEdge / obj.meanBackgroundRightEdge - 1;
                
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
                dataImage = obj.imageMetadata.dataImagePhotopic;
            elseif( strcmp( obj.dataType, 'Mesopic') )
                dataImage = obj.imageMetadata.dataImagePhotopic;
            else
                disp( sprintf( 'unknown dataType:%s', obj.dataType ) );
                disp( 'dataType has to be Photopic, Scotopic or Mesopic' );
            end
            
            %set visualisation image as RGB image
            [ width, height ] = size( dataImage );
            visImagePrototype = zeros( width, height, 3 );
            %visImage = mat2gray( adapthisteq( dataImage ) );
            visImage = imadjust( dataImage, stretchlim(dataImage),[] ); %contrast stretch image for better viewing
            visImagePrototype(:, :, 1) = visImage;
            visImagePrototype(:, :, 2) = visImage;
            visImagePrototype(:, :, 3) = visImage;
            obj.visualisationImage = visImagePrototype;
            
            %calc mean of target
            calcMeanOfTarget( dataImage , obj );
            
            %calc mean of background
            calcMeanOfTargetEdges( dataImage , obj );
        end
        
    end % methods
end