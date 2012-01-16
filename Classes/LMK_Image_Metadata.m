%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

%this class needs to know it's dataSRCMat
%all other properties are set on demand

classdef LMK_Image_Metadata < handle
    properties
        sceneTitle
        focalLength
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
        
        function value = get.dataImageMesopic(obj)
            if (isempty(obj.dataImageMesopic))
                
                [obj.dataImageMesopic, ~] = ...
                    mesopicLuminance_recommended(obj.dataImagePhotopic,...
                    obj.dataImageScotopic);
            end
            value = obj.dataImageMesopic;
        end%lazy loading of mesopic data
        
        function value = get.comments(obj)
            if (isempty(obj.comments))
                obj.comments = 'No comments';
            end
            value = obj.comments;
        end%lazy loading of comments
        
        function value = get.lightSource(obj)
            if (isempty(obj.lightSource))
                obj.lightSource = 'Unknown light source';
            end
            value = obj.lightSource;
        end%lazy loading of light source
        
        function value = get.Name(obj)
            if (isempty(obj.Name))
                obj.Name = 'LMKSet';
            end
            value = obj.Name;
        end%lazy loading of measurement series name
        
        function calcAlpha(obj)
            dis = obj.distanceToObject;
            objSize = obj.targetSize;
            alphaRad = 2 * atan(objSize / 2 ./ dis);
            alphaMinutes = (alphaRad / pi * 180 * 60);
            obj.targetAlphaMinutes = alphaMinutes;
        end
        
    end % methods
end