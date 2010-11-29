%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

classdef LMK_Image_Metadata
    properties
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
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Metadata(dataSRCPhotopic, dataTypePhotopic,...
                dataSRCScotopic, dataTypeScotopic, rect, rectPosition,...
                border, dataImagePhotopic, dataImageScotopic)
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
    end % methods
end