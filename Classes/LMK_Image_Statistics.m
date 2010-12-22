%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

classdef LMK_Image_Statistics < hgsetget
    properties
        
        meanTarget
        minTarget
        maxTarget
        stdTarget
        meanBackground
        minBackground
        maxBackground
        stdBackground
        meanStreetSurface
        stdStreetSurface
        upperEdgeContrast
        lowerEdgeContrast
        leftEdgeContrast
        rightEdgeContrast
        strongestEdge

    end % properties
    methods
        %constructor
        function obj = LMK_Image_Statistics(meanTarget,...
        minTarget,...
        maxTarget,...
        stdTarget,...
        meanBackground,...
        minBackground,...
        maxBackground,...
        stdBackground,...
        meanStreetSurface,... 
        stdStreetSurface,...
        upperEdgeContrast,...
        lowerEdgeContrast,...
        leftEdgeContrast,...
        rightEdgeContrast,...
        strongestEdge)
            if nargin > 0 % Support calling with 0 arguments
                obj.meanTarget = meanTarget;
                obj.minTarget = minTarget;
                obj.maxTarget = maxTarget;
                obj.stdTarget = stdTarget;
                obj.meanBackground = meanBackground;
                obj.minBackground = minBackground;
                obj.maxBackground = maxBackground;
                obj.stdBackground = stdBackground;
                obj.meanStreetSurface = meanStreetSurface;
                obj.stdStreetSurface = stdStreetSurface;
                obj.upperEdgeContrast = upperEdgeContrast;
                obj.lowerEdgeContrast = lowerEdgeContrast;
                obj.leftEdgeContrast = leftEdgeContrast;
                obj.rightEdgeContrast = rightEdgeContrast;
                obj.strongestEdge = strongestEdge;
            end
        end% constructor
    end % methods
end