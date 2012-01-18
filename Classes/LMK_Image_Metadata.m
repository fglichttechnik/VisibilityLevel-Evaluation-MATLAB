%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

%this class needs to know it's dataSRCMat
%all other properties are set on demand

classdef LMK_Image_Metadata < handle
    properties
        sceneTitle
        focalLength
        twoDegreeRadiusPix
        distanceToObject
        targetAlphaMinutes
        
        dataSRCMat
        dataTypeMat
        dataSRCPhotopic
        dataTypePhotopic
        dataSRCScotopic
        dataTypeScotopic
        
        rect
        rectPosition
        targetSize
        quadrangle
        border
        
        dataImageScotopic
        dataImagePhotopic
        dataImageMesopic
        factorForMesopicLumCalc
        
        visualisationImagePhotopic
        
        imageMetaData % currently not in use
        
        SPRatio
        comments
        lightSource
        Name
        dirPath
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Metadata(dataSRCPhotopic, dataTypePhotopic, ...
                dataSRCScotopic, dataTypeScotopic, rect, ...
                rectPosition, border, dataImagePhotopic, dataImageScotopic, distanceToObject, targetSize)
            if nargin > 0 % Support calling with 0 arguments
                obj.dataSRCPhotopic = dataSRCPhotopic;
                obj.dataTypePhotopic = dataTypePhotopic;
                obj.dataSRCScotopic = dataSRCScotopic;
                obj.dataTypeScotopic = dataTypeScotopic;
                obj.rect = rect;
                obj.rectPosition = rectPosition;
                obj.border = border;
                obj.dataImageScotopic = dataImageScotopic;
                obj.dataImagePhotopic = dataImagePhotopic;
                obj.distanceToObject = distanceToObject;
                obj.targetSize = targetSize;
            end
        end% constructor
        
        %lazy loading of image data
        
        %% get.dataImagePhotopic(obj)
        function value = get.dataImagePhotopic(obj)
            if(isempty(obj.dataImagePhotopic))
                if ~(isempty(obj.dataSRCPhotopic))
                    
                    if(ispc)
                        DELIMITER = '\';
                    elseif(isunix)
                        DELIMITER = '/';
                    end
                    
                    filePath = sprintf( '%s%s%s', obj.dirPath, DELIMITER, obj.dataSRCPhotopic );
                    obj.dataImagePhotopic= LMK_readPfImage...
                        ( filePath );
                elseif ~(isempty(obj.dataSRCMat))
                    matImage = load([obj.dataSRCMat]);
                    obj.dataImagePhotopic = ....
                        matImage.LMK_measurements.dataImage.YL;
                    obj.dataImageScotopic = ...
                        matImage.LMK_measurements.dataImage.LS;
                end
            end
            value = obj.dataImagePhotopic;
        end%lazy loading of photopic data
        
        %% value = get.dataImageScotopic(obj)
        function value = get.dataImageScotopic(obj)
            if(isempty(obj.dataImageScotopic))
                if ~(isempty(obj.dataSRCScotopic))
                    
                    if(ispc)
                        DELIMITER = '\';
                    elseif(isunix)
                        DELIMITER = '/';
                    end
                    
                    filePath = sprintf( '%s%s%s', dirPath, DELIMITER, obj.dataSRCScotopic );
                    obj.dataImageScotopic= LMK_readPfImage...
                        ( filePath );
                elseif ~(isempty(obj.dataSRCMat))
                    matImage = load([obj.dataSRCMat]);
                    obj.dataImagePhotopic = ....
                        matImage.LMK_measurements.dataImage.YL;
                    obj.dataImageScotopic = ...
                        matImage.LMK_measurements.dataImage.LS;
                end
            end
            value = obj.dataImageScotopic;
        end%lazy loading of scotopic data
        
        
        %% get.dataImageMesopic
        function value = get.dataImageMesopic( obj )
            if ( isempty( obj.dataImageMesopic ) )
                
                %calc background luminance
                LbPhotopic = calcMeanOfCircleWithoutRect( obj.dataImagePhotopic, obj );
                LbScotopic = calcMeanOfCircleWithoutRect( obj.dataImageScotopic, obj );
                
                %calc adaption luminance
                %To do: calculate with veiling luminance as published in
                %ANSI IESNA RP 8 0 0
                LaPhotopic = LbPhotopic;
                LaScotopic = LbScotopic;
                
                %calc mesopic luminances
                [ obj.dataImageMesopic, obj.factorForMesopicLumCalc ] = ...
                    mesopicLuminance_recommended( obj.dataImagePhotopic,...
                    obj.dataImageScotopic, LaPhotopic, LaScotopic );
            end
            value = obj.dataImageMesopic;
        end%lazy loading of mesopic data
        
        
        
        %% get.twoDegreeRadiusPix
        function value = get.twoDegreeRadiusPix(obj)
            if( isempty( obj.twoDegreeRadiusPix ) )
                %To do: calculate with focalLength
                obj.twoDegreeRadiusPix = 100; % 100 for focalLength of 25 mm
            end
            value = obj.twoDegreeRadiusPix;
        end
        
        
        %% get.comments
        function value = get.comments(obj)
            if (isempty(obj.comments))
                obj.comments = 'No comments';
            end
            value = obj.comments;
        end%lazy loading of comments
        
        %% get.lightSource
        function value = get.lightSource(obj)
            if (isempty(obj.lightSource))
                obj.lightSource = 'Unknown light source';
            end
            value = obj.lightSource;
        end%lazy loading of light source
        
        %% get.Name
        function value = get.Name(obj)
            if (isempty(obj.Name))
                obj.Name = 'LMKSet';
            end
            value = obj.Name;
        end%lazy loading of measurement series name
        
        %% calcAlpha
        function calcAlpha(obj)
            dis = obj.distanceToObject;
            objSize = obj.targetSize;
            alphaRad = 2 * atan(objSize / 2 ./ dis);
            alphaMinutes = (alphaRad / pi * 180 * 60);
            obj.targetAlphaMinutes = alphaMinutes;
        end
        
        %% get.visualisationImagePhotopic
        function value = get.visualisationImagePhotopic( obj )
            if (isempty( obj.visualisationImagePhotopic ) )
                
                dataImage = obj.dataImagePhotopic;
                
                %set visualisation image as RGB image
                [ width, height ] = size( dataImage );
                visImagePrototype = zeros( width, height, 3 );
                visImagePhotopic = imadjust( obj.dataImagePhotopic, stretchlim(dataImage),[] ); %contrast stretch image for better viewing
                visImagePrototype(:, :, 1) = visImagePhotopic;
                visImagePrototype(:, :, 2) = visImagePhotopic;
                visImagePrototype(:, :, 3) = visImagePhotopic;
                obj.visualisationImagePhotopic = visImagePrototype;
                
                %calc mean of target
                %calcMeanOfTarget( dataImage , obj );
                
                %calc mean of background
                %calcMeanOfTargetEdges( dataImage , obj );
                
                %calc mean of cirlce
                %calcMeanOfCircleWihtoutRect( dataImage, obj.imageMetadata );
            end
            value = obj.visualisationImagePhotopic;
            
        end
        
    end % methods
end