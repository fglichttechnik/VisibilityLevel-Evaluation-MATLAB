function elements = XMLtoMAT(filePath)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
% preferences
COMMENTS = ' ';

% parse XML-Data into a struct
stru = parseXML(filePath);
str = stru(1,2);

% get the number of children of the struct
[~, childSize] = size(str.Children);

% declare an element pointer
%elements = cell(childSize*2,1);
elements = cell(childSize,1);
currentElementPointer = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ dataset name
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : childSize
    childMatch = strmatch('dataSetName', str.Children(1,i).Name);
    if childMatch == 1
        dataSetName = str.Children(1,i).Attributes.Value;
        break
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ StreetLuminance object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : childSize    
    % browse children
    childMatch2 = strmatch('StreetSurface', str.Children(1,i).Name);
    if (childMatch2 == 1)
        % get the number of children of 'StreetSurface'
        [~, grandchildSize] = size(str.Children(1,i).Children);
        % browse the children of 'LMKData'
        for j = 1 : grandchildSize
            % search for children named 'QuadrangleObject'
            grandchildMatch1 = strmatch('QuadrangleObject', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch1 == 1
                % get the number of children of 'QuadrangleObject'
                [~, greatgrandSize] = size(str.Children(1,i).Children...
                    (1,j).Children);
                % browse the children of 'RectObject' 
                for l = 1 : greatgrandSize
                    greatgrandMatch1 = strmatch('upperLeft', ...
                        str.Children(1,i).Children(1,j).Children...
                        (1,l).Name);
                    if greatgrandMatch1 == 1
                        x1_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,1).Value);
                        y1_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,2).Value);
                        continue
                    end
                    greatgrandMatch2 = strmatch('upperRight', ...
                        str.Children(1,i).Children(1,j).Children...
                        (1,l).Name);
                    if greatgrandMatch2 == 1
                        x2_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,1).Value);
                        y2_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,2).Value);
                        continue
                    end
                    greatgrandMatch3 = strmatch('lowerLeft', ...
                        str.Children(1,i).Children(1,j).Children...
                        (1,l).Name);
                    if greatgrandMatch3 == 1
                        x3_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,1).Value);
                        y3_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,2).Value);
                        continue
                    end
                    greatgrandMatch4 = strmatch('lowerRight', ...
                        str.Children(1,i).Children(1,j).Children...
                        (1,l).Name);
                    if greatgrandMatch4 == 1
                        x4_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,1).Value);
                        y4_quad = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,2).Value);
                    end
                end
            end
        end
        
        % and quadrangle object
        point1 = struct('x',x1_quad,'y',y1_quad);
        point2 = struct('x',x2_quad,'y',y2_quad);
        point3 = struct('x',x3_quad,'y',y3_quad);
        point4 = struct('x',x4_quad,'y',y4_quad);
        quadrangle = struct('upperLeft',point1,'upperRight',point2,...
            'lowerLeft',point3,'lowerRight',point4);        
        
        %there should be only 1 StreetLuminance Object
        break;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ all LMKData objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% browse the children of the struct for children named 'LMKData'
for i = 1 : childSize
    % clear object from current loop
    if i > 1
        clear evaluatedData
    end
    % create new object 
    evaluatedData = LMK_Image_Metadata;
    
    % browse the children
    childMatch1 = strmatch('LMKData', str.Children(1,i).Name);
    if childMatch1 == 1
        % get the number of children of 'LMKData'
        [~, grandchildSize] = size(str.Children(1,i).Children);
        % browse the children of 'LMKData'
        for j = 1 : grandchildSize
            % search for children
            grandchildMatch1 = strmatch('dataPhotopic', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch1 == 1
                % get the number of attributes of 'dataPhotopic'
                [~, grandchildAttributesSize1] = size(str.Children...
                    (1,i).Children(1,j).Attributes);
                % browse the attributes of 'dataPhotopic'
                for k = 1 : grandchildAttributesSize1 
                    grandchildAttributeMatch1 = strmatch('src', ...
                        str.Children(1,i).Children(1,j).Attributes...
                        (1,k).Name);                      
                    if grandchildAttributeMatch1 == 1
                        evaluatedData.dataSRCPhotopic = str.Children...
                            (1,i).Children(1,j).Attributes(1,k).Value;
                        continue
                    end
                    grandchildAttributeMatch2 = strmatch('type', ...
                        str.Children(1,i).Children(1,j).Attributes...
                        (1,k).Name);
                    if grandchildAttributeMatch2 == 1
                        evaluatedData.dataTypePhotopic = str.Children...
                            (1,i).Children(1,j).Attributes(1,k).Value;
                    end
                end  
                continue
            end
            grandchildMatch2 = strmatch('dataScotopic', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch2 == 1
                % get the number of attributes of 'dataScotopic'
                [~, grandchildAttributesSize2] = size(str.Children...
                    (1,i).Children(1,j).Attributes);
                % browse the attributes of 'dataPhotopic'
                for k = 1 : grandchildAttributesSize2
                    grandchildAttributeMatch1 = strmatch('src', ...
                        str.Children(1,i).Children(1,j).Attributes...
                        (1,k).Name);                    
                    if grandchildAttributeMatch1 == 1
                        evaluatedData.dataSRCScotopic = str.Children...
                            (1,i).Children(1,j).Attributes(1,k).Value;
                        continue
                    end
                    grandchildAttributeMatch2 = strmatch('type', ...
                        str.Children(1,i).Children(1,j).Attributes...
                        (1,k).Name);
                    if grandchildAttributeMatch2 == 1
                        evaluatedData.dataTypeScotopic = str.Children...
                            (1,i).Children(1,j).Attributes(1,k).Value;
                    end
                end
                continue
            end
            grandchildMatch3 = strmatch('RectObject', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch3 == 1
                % get the number of children of 'RectObject'
                [~, greatgrandSize] = size(str.Children(1,i).Children...
                    (1,j).Children);
                % browse the children of 'RectObject'
                for l = 1 : greatgrandSize
                    greatgrandMatch1 = strmatch('upperLeft', ...
                        str.Children(1,i).Children(1,j).Children...
                        (1,l).Name); 
                    if greatgrandMatch1 == 1
                        x1 = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,1).Value);
                        y1 = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,2).Value);
                        continue
                    end
                    greatgrandMatch2 = strmatch('lowerRight', ...
                        str.Children(1,i).Children(1,j).Children...
                        (1,l).Name);
                    if greatgrandMatch2 == 1
                        x2 = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,1).Value);
                        y2 = str2double(str.Children(1,i).Children...
                            (1,j).Children(1,l).Attributes(1,2).Value);
                        continue
                    end
                    greatgrandMatch3 = strmatch('border', str.Children...
                        (1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch3 == 1
                        evaluatedData.border = str2double(str.Children...
                            (1,i).Children(1,j).Children...
                            (1,l).Attributes.Value);
                        continue
                    end
                    greatgrandMatch4 = strmatch('position', str.Children...
                        (1,i).Children(1,j).Children(1,l).Name);
                    if greatgrandMatch4 == 1
                        evaluatedData.rectPosition = str2double...
                            (str.Children(1,i).Children(1,j).Children...
                            (1,l).Attributes(1,1).Value);
                    end
                end
            end
        end % end of browsing children
        
        % create struct for rect object
        point1 = struct('x',x1,'y',y1);
        point2 = struct('x',x2,'y',y2);
        evaluatedData.rect = struct('upperLeft',point1,'lowerRight',point2);
        
        % read Image
        evaluatedData.dataImagePhotopic = LMK_readPfImage...
            (evaluatedData.dataSRCPhotopic);
        evaluatedData.dataImageScotopic= LMK_readPfImage...
            (evaluatedData.dataSRCScotopic);
        
        % put quadrangle into obj
        if(exist('quadrangle','var'))
            evaluatedData.quadrangle = quadrangle;
        end        
        evaluatedData.comments = COMMENTS;
        
        % evaluate mesopic luminance image
        [evaluatedData.dataImageMesopic, ~] = ...
            mesopicLuminance_intermediate(evaluatedData.dataImagePhotopic,...
            evaluatedData.dataImageScotopic);        
        
        % save obj in output struct
        elements{currentElementPointer} = evaluatedData;
        currentElementPointer = currentElementPointer + 1;
        
    end % end of browsing for 'LMKData'    
end % end of parse the Children of struct

% remove potential empty cells
currentEnd = childSize;
for i = 1 : childSize
    if(~isa(elements{i},'LMK_Image_Metadata'))
        currentEnd = i - 1;
        break;
    end
end
elements = elements(1:currentEnd);

% save dataset as .mat
imageset = elements;
save(dataSetName, 'imageset');

end


