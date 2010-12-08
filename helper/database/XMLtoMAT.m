function elements = XMLtoMAT(filePath)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% preferences
COMMENTS = ' ';

% parse XML-Data into a struct
str = parseXML(filePath);

% get the number of children of the struct
[~, childSize] = size(str.Children);

% declare an element pointer
%elements = cell(childSize*2,1);
elements = cell(childSize,1);
currentElementPointer = 1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ StreetLuminance object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : childSize
    childMatch2 = strmatch('StreetSurface', str.Children(1,i).Name);
    if (childMatch2 == 1)
        % get the number of children of 'StreetSurface'
        [~, grandchildSize] = size(str.Children(1,i).Children);
        % browse the children of 'LMKData'
        for j = 1 : grandchildSize
            % search for children named 'QuadrangleObject'
            grandchildMatch1 = strmatch('QuadrangleObject', str.Children(1,i).Children(1,j).Name);
            if grandchildMatch1 == 1
                % get the number of children of 'QuadrangleObject'
                [~, greatgrandSize] = size(str.Children(1,i).Children(1,j).Children);
                % browse the children of 'RectObject' for children named
                % 'upperleft', 'lowerRight', 'upperRight', 'lowerLeft'
                for l = 1 : greatgrandSize
                    greatgrandMatch1 = strmatch('upperLeft', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch1 == 1
                        x1_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        y1_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,2).Value);
                    end
                    greatgrandMatch2 = strmatch('upperRight', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch2 == 1
                        x2_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        y2_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,2).Value);
                    end
                    greatgrandMatch3 = strmatch('lowerLeft', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch3 == 1
                        x3_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        y3_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,2).Value);
                    end
                    greatgrandMatch4 = strmatch('lowerRight', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch4 == 1
                        x4_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        y4_quad = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,2).Value);
                    end
                end
            end
        end
        
        % and quadrangle object
        point1 = struct('x',x1_quad,'y',y1_quad);
        point2 = struct('x',x2_quad,'y',y2_quad);
        point3 = struct('x',x3_quad,'y',y3_quad);
        point4 = struct('x',x4_quad,'y',y4_quad);
        quadrangle = struct('upperLeft',point1,'upperRight',point2,'lowerLeft',point3,'lowerRight',point4);
        
        
        %there should be only 1 StreetLuminance Object
        break;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ all LMKData objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% browse the children of the struct for children named 'LMKData'
for i = 1 : childSize
    childMatch1 = strmatch('LMKData', str.Children(1,i).Name);
    if childMatch1 == 1
        % get the number of children of 'LMKData'
        [~, grandchildSize] = size(str.Children(1,i).Children);
        % browse the children of 'LMKData'
        for j = 1 : grandchildSize
            % search for children named 'dataPhotopic'
            grandchildMatch1 = strmatch('dataPhotopic', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch1 == 1
                imageMetaData_VL = 'Photopic luminance image';
                % get the number of attributes of 'dataPhotopic'
                [~, grandchildAttributesSize1] = size(str.Children(1,i).Children(1,j).Attributes);
                % browse the attributes of 'dataPhotopic' for attributes
                % named 'src' and 'type'
                for k = 1 : grandchildAttributesSize1
                    grandchildAttributeMatch1 = strmatch('src', str.Children(1,i).Children(1,j).Attributes(1,k).Name);
                    if grandchildAttributeMatch1 == 1
                        dataSRC_VL = str.Children(1,i).Children(1,j).Attributes(1,k).Value;
                    end
                    grandchildAttributeMatch2 = strmatch('type', str.Children(1,i).Children(1,j).Attributes(1,k).Name);
                    if grandchildAttributeMatch2 == 1
                        dataType_VL = str.Children(1,i).Children(1,j).Attributes(1,k).Value;
                    end
                end
            end
            % search for children named 'dataScotopic'
            grandchildMatch2 = strmatch('dataScotopic', str.Children(1,i).Children(1,j).Name);
            if grandchildMatch2 == 1
                imageMetaData_VS = 'Scotopic luminance image';
                % get the number of attributes of 'dataScotopic'
                [~, grandchildAttributesSize2] = size(str.Children(1,i).Children(1,j).Attributes);
                % browse the attributes of 'dataPhotopic' for attributes
                % named 'src' and 'type'
                for k = 1 : grandchildAttributesSize2
                    grandchildAttributeMatch = strmatch('src', str.Children(1,i).Children(1,j).Attributes(1,k).Name);
                    if grandchildAttributeMatch == 1
                        dataSRC_VS = str.Children(1,i).Children(1,j).Attributes(1,k).Value;
                    end
                    grandchildAttributeMatch2 = strmatch('type', str.Children(1,i).Children(1,j).Attributes(1,k).Name);
                    if grandchildAttributeMatch2 == 1
                        dataType_VS = str.Children(1,i).Children(1,j).Attributes(1,k).Value;
                    end
                end
            end
            % search for children named 'RectObject'
            grandchildMatch3 = strmatch('RectObject', str.Children(1,i).Children(1,j).Name);
            if grandchildMatch3 == 1
                % get the number of children of 'RectObject'
                [~, greatgrandSize] = size(str.Children(1,i).Children(1,j).Children);
                % browse the children of 'RectObject' for children named
                % 'upperleft', 'lowerRight' and 'border'
                for l = 1 : greatgrandSize
                    greatgrandMatch1 = strmatch('upperLeft', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch1 == 1
                        x1 = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        y1 = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,2).Value);
                    end
                    greatgrandMatch2 = strmatch('lowerRight', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch2 == 1
                        x2 = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        y2 = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,2).Value);
                    end
                    greatgrandMatch3 = strmatch('border', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch3 == 1
                        border = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes.Value);
                    end
                    greatgrandMatch4 = strmatch('position', str.Children(1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch4 == 1
                        rectPosition = str2num(str.Children(1,i).Children(1,j).Children(1,l).Attributes(1,1).Value);
                        %jan: what was that for?
                        %                     else
                        %                         rectPosition = [];
                    end
                end
            end
        end % end of browsing children
        
        
        
        
        %TODO: error handling if certain variables aren't set...
        %TODO: delete values at the end: if a variable isn't set again
        %during the next loop, it will accidentally be set for the next
        %image...
        %TODO: make if else in such a manner, that there aren't
        %unnecessary if questions after a match has been found
        
        %create struct for rect object
        point1 = struct('x',x1,'y',y1);
        point2 = struct('x',x2,'y',y2);
        rect = struct('upperLeft',point1,'lowerRight',point2);
        
        % read Image
        dataImage_VL = LMK_readPfImage(dataSRC_VL);
        dataImage_VS = LMK_readPfImage(dataSRC_VS);
        
        %         % evaluate mean of target and background
        %         [meanTarget, meanBackground] = meanOfCircleWithoutRect(dataImage, radius, x1, x2, y1, y2, border);
        
        % create object and save as .mat
        evaluatedData = LMK_Image_Metadata(dataSRC_VL, dataType_VL,...
            dataSRC_VS, dataType_VS, rect, rectPosition,...
            border, dataImage_VL, dataImage_VS);
        
        if(exist('quadrangle'))
            evaluatedData.quadrangle = quadrangle;
        end
        
        evaluatedData.comments = COMMENTS;
        
        %         % create object and save as .mat
        %         evaluatedData_VL = LMK_Image_Metadata(dataSRC_VL, dataType_VL, rect, ...
        %             border, dataImage_VL, imageMetaData_VL);
        %         evaluatedData_VS = LMK_Image_Metadata(dataSRC_VS, dataType_VS, rect, ...
        %             border, dataImage_VS, imageMetaData_VS);
        %
        %         if(exist('quadrangle'))
        %             evaluatedData_VL.quadrangle = quadrangle;
        %             evaluatedData_VS.quadrangle = quadrangle;
        %         end
        %
        %         evaluatedData_VL.comments = COMMENTS;
        %         evaluatedData_VS.comments = COMMENTS;
        
        %dataName = [dataSRC(1:end-3), '.mat'];
        %save(dataName, 'evaluatedData')
        
        elements{currentElementPointer} = evaluatedData;
        currentElementPointer = currentElementPointer + 1;
        %elements{currentElementPointer} = evaluatedData_VS;
        %currentElementPointer = currentElementPointer + 1;
    end
    
    
end % end of parse the Children of struct

%remove potential empty cells
currentEnd = childSize;
for i = 1 : childSize
    if(~isa(elements{i},'LMK_Image_Metadata'))
        currentEnd = i - 1;
        break;
    end
end
elements = elements(1:currentEnd);

end


