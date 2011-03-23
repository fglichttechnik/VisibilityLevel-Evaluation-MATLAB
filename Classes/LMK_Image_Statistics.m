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
        imgResult
        upperEdgeContrast
        lowerEdgeContrast
        leftEdgeContrast
        rightEdgeContrast
        strongestEdge
        radius
        savePath
        dataImage
        filename
        imageMetadata
    end % properties
    methods
        %constructor
        function obj = LMK_Image_Statistics(...
        meanTarget,...
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
        
        %lazy loading of target data
        function value = get.meanTarget(obj)
            if isempty(obj.meanTarget)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.meanTarget;
        end
        function value = get.minTarget(obj)
            if isempty(obj.minTarget)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.minTarget;
        end
        function value = get.maxTarget(obj)
            if isempty(obj.maxTarget)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.maxTarget;
        end
        function value = get.stdTarget(obj)
            if isempty(obj.stdTarget)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.stdTarget;
        end
        %lazy loading of background data
        function value = get.meanBackground(obj)
            if isempty(obj.meanBackground)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.meanBackground;
        end
        function value = get.minBackground(obj)
            if isempty(obj.minBackground)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.minBackground;
        end
        function value = get.maxBackground(obj)
            if isempty(obj.maxBackground)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.maxBackground;
        end
        function value = get.stdBackground(obj)
            if isempty(obj.stdBackground)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.stdBackground;
        end    
        %lazy loading of street surface data        
        function value = get.meanStreetSurface(obj)
            if (isempty(obj.imageMetadata.quadrangle))
                obj.meanStreetSurface = 1;
            else
                calcStatisticsOfStreetSurface(obj);
            end
            value = obj.meanStreetSurface;
        end
        function value = get.stdStreetSurface(obj)
            if (isempty(obj.imageMetadata.quadrangle))
                obj.stdStreetSurface = 1;
            else
                calcStatisticsOfStreetSurface(obj);
            end
            value = obj.stdStreetSurface;
        end
        %lazy loading of contrast data
        function value = get.upperEdgeContrast(obj)
            if isempty(obj.upperEdgeContrast)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.upperEdgeContrast;
        end   
        function value = get.lowerEdgeContrast(obj)
            if isempty(obj.lowerEdgeContrast)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.lowerEdgeContrast;
        end 
        function value = get.leftEdgeContrast(obj)
            if isempty(obj.leftEdgeContrast)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.leftEdgeContrast;
        end 
        function value = get.rightEdgeContrast(obj)
            if isempty(obj.rightEdgeContrast)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.rightEdgeContrast;
        end 
        function value = get.strongestEdge(obj)
            if isempty(obj.strongestEdge)
                statisticsOfCircleAndRectHack(obj);
            end
            value = obj.strongestEdge;
        end     
    end % methods
end