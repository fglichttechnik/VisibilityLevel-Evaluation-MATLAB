%author Jan Winter TU Berlin
%email j.winter@tu-berlin.de

classdef LMK_Image_Statistics < handle
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
        
        %lazy loading of street surface data        
        function value = get.meanStreetSurface(obj)
            if (isempty(obj.meanStreetSurface))
                obj.meanStreetSurface = 1;
            end
            value = obj.meanStreetSurface;
        end%lazy loading of mean of street surface
        
        function value = get.stdStreetSurface(obj)
            if (isempty(obj.stdStreetSurface))
                obj.stdStreetSurface = 1;
            end
            value = obj.stdStreetSurface;
        end%lazy loading of standard deviation of street surface
        
    end % methods
end