%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

%this class needs to know it's dataSRCMat
%all other properties are set on demand

classdef LMK_Image_Metadata < handle
    properties
        dataSRCMat
        dataTypeMat
        dataSRCPhotopic
        dataTypePhotopic
        dataSRCScotopic
        dataTypeScotopic
        rect
        rectPosition
        quadrangle
        border
        dataImageScotopic
        dataImagePhotopic
        dataImageMesopic
        imageMetaData
        comments
        lightSource
        Name
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Metadata(dataSRCPhotopic, dataTypePhotopic, ...
                dataSRCScotopic, dataTypeScotopic, rect, ...
                rectPosition, border, dataImagePhotopic, dataImageScotopic)
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
            end
        end% constructor
        
        %lazy loading of image data
        function value = get.dataImagePhotopic(obj)
           if(isempty(obj.dataImagePhotopic))
               obj.dataImagePhotopic = 1;
           end
            value = obj.dataImagePhotopic;
%            disp(value)
        end%lazy loading of photopic data
    end % methods
end