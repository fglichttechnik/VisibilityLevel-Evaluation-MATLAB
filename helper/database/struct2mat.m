function elements = struct2mat(str, dirPath)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Converts struct resulting from function parseXML into a MATLAB object of
% class LMK_image_Metadata.


% preferences
COMMENTS = ' ';

%%%%%%%%%%%%%%%nothing needs to be adjusted below%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(str(1,1).Children) && ~isempty(str(1,2).Children)
    str = str(1,2);
end

% get the number of children of the struct
[~, childSize] = size(str.Children);

% declare an element pointer
%elements = cell(childSize*2,1);
elements = cell(childSize,1);
currentElementPointer = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ StreetLuminance object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
matchCounter = 0;
for i = 1 : childSize 
    % browse children
    childMatch = strmatch('StreetSurface', str.Children(1,i).Name);
    if (childMatch == 1)
        % get the number of children of 'StreetSurface'
        [~, grandchildSize] = size(str.Children(1,i).Children);
        % browse the children of 'LMKData'
        for j = 1 : grandchildSize
            % search for children named 'QuadrangleObject'
            grandchildMatch = strmatch('QuadrangleObject', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch == 1
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
                        matchCounter = matchCounter + 1;
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
                        matchCounter = matchCounter + 1;
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
                        matchCounter = matchCounter + 1;
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
                        matchCounter = matchCounter + 1;
                    end
                end
            end
        end
        
        % and quadrangle object
        if matchCounter == 4 
            point1 = struct('x',x1_quad,'y',y1_quad);
            point2 = struct('x',x2_quad,'y',y2_quad);
            point3 = struct('x',x3_quad,'y',y3_quad);
            point4 = struct('x',x4_quad,'y',y4_quad);
            quadrangle = struct('upperLeft',point1,'upperRight',point2,...
                'lowerLeft',point3,'lowerRight',point4);  
        else
            disp(['Warning: not enough coordinates for quadrangle',...
                    ' object found!']);
        end
        
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
    matSource = '';
    % create new object 
    evaluatedData = LMK_Image_Metadata();
    evaluatedData.dirPath = dirPath;
    
    % browse the children
    childMatch = strmatch('LMKData', str.Children(1,i).Name);
    if childMatch == 1
        % get the number of children of 'LMKData'
        [~, grandchildSize] = size(str.Children(1,i).Children);
        % browse the children of 'LMKData'
        rectMatch = 0;
        photMatch = 0;
%         scotMatch = 0;
        for j = 1 : grandchildSize
            % search for children
            grandchildMatch1 = strmatch('dataSource', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch1 == 1
                photMatch = 1;
                % get the number of attributes of 'dataSource'
                [~, grandchildAttributesSize1] = size(str.Children...
                    (1,i).Children(1,j).Attributes);
                % browse the attributes of 'dataSource'
                for k = 1 : grandchildAttributesSize1 
                    grandchildAttributeMatch1 = strmatch('src', ...
                        str.Children(1,i).Children(1,j).Attributes...
                        (1,k).Name);                      
                    if grandchildAttributeMatch1 == 1   
                        dataSRC = str.Children(1,i).Children(1,j).Attributes(1,k).Value;                                                
                        continue
                    end
                    grandchildAttributeMatch2 = strmatch('type', ...
                        str.Children(1,i).Children(1,j).Attributes...
                        (1,k).Name);
                    if grandchildAttributeMatch2 == 1
                        dataType = str.Children(1,i).Children(1,j).Attributes(1,k).Value;
                        typeMatch1 = strcmp(dataType, 'pf_photopic');
                        typeMatch2 = strcmp(dataType, 'pf_scotopic');
                        typeMatch3 = strcmp(dataType, '.mat');
                        if typeMatch1 == 1
                            evaluatedData.dataTypePhotopic = dataType;
                            evaluatedData.dataSRCPhotopic = dataSRC;
                        elseif typeMatch2 == 1
                            evaluatedData.dataTypeScotopic = dataType;
                            evaluatedData.dataSRCScotopic = dataSRC;
                        elseif typeMatch3 == 1
                            evaluatedData.dataSRCMat = dataSRC;
                            evaluatedData.dataTypeMat = dataType;
                            matSource = dataSRC;
                        end                                
                        disp(dataSRC)
                    end
                end                 
                continue
            end
            grandchildMatch3 = strmatch('RectObject', str.Children...
                (1,i).Children(1,j).Name);
            if grandchildMatch3 == 1
                rectMatch = 1;
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
               
        % error handling:
         if (photMatch == 1) && (isempty(evaluatedData.dataSRCPhotopic) && ...
                 (isempty(evaluatedData.dataSRCMat)))
            disp(['Warning: no src attributes for photopic data found!',...
                'Picture cannot be loaded!']);
         end
         if (photMatch == 1) && (isempty(evaluatedData.dataTypePhotopic) && ...
                 (isempty(evaluatedData.dataSRCMat)))
            disp(['Warning: no type attributes for photopic data found!',...
                'Picture cannot be loaded!']);           
         end 
         if (photMatch == 1) && (isempty(evaluatedData.dataSRCScotopic) && ...
                 (isempty(evaluatedData.dataSRCMat)))
            disp(['Warning: no src attributes for scotopic data found!',...
                'Picture cannot be loaded!']);           
         end
         if (photMatch) == 1 && (isempty(evaluatedData.dataTypeScotopic) && ...
                 (isempty(evaluatedData.dataSRCMat)))
            disp(['Warning: no type attributes for scotopic data found!',...
                'Picture cannot be loaded!']);
         end 
         if rectMatch == 0
             disp('Warning: no rectangle object found!');
         elseif ~(exist('x1', 'var')) || ~(exist('y1', 'var'))
             disp('Warning: no upper left coordinates for rectangle object found!');
         elseif ~(exist('x2', 'var')) || ~(exist('y2', 'var'))
             disp('Warning: no lower right coordinates for rectangle object found!');
         elseif (isempty(evaluatedData.border))
             disp('Warning: no border for rectangle object found!');
         elseif (isempty(evaluatedData.rectPosition))
             disp('Warning: no position for rectangle object found!');
         end   
         if ~(isempty(evaluatedData.dataSRCPhotopic)) ...
                 && ~(exist([evaluatedData.dataSRCPhotopic],'file'))
             disp(['Warning: File ', evaluatedData.dataSRCPhotopic, ' not found!']);
         end
         if ~(isempty(evaluatedData.dataSRCScotopic)) ...
                 && ~(exist([evaluatedData.dataSRCScotopic],'file'))
             disp(['Warning: File ', evaluatedData.dataSRCScotopic, ' not found!']);
         end
         if ~(isempty(evaluatedData.dataSRCMat)) ...
                 && ~(exist([evaluatedData.dataSRCMat],'file'))
             disp(['Warning: File ', evaluatedData.dataSRCMat, ' not found!']);
         end
                 
        
        % create struct for rect object
        point1 = struct('x',x1,'y',y1);
        point2 = struct('x',x2,'y',y2);
        evaluatedData.rect = struct('upperLeft',point1,'lowerRight',point2);
        
%         % read .pf-images   
%         if isempty(matSource)
%             if ~(isempty(evaluatedData.dataSRCPhotopic)) && (exist([evaluatedData.dataSRCPhotopic],'file'))
%                     evaluatedData.dataImagePhotopic= LMK_readPfImage...
%                         (evaluatedData.dataSRCPhotopic);
%             end
%             if ~(isempty(evaluatedData.dataSRCScotopic)) && (exist([evaluatedData.dataSRCScotopic],'file'))
%                     evaluatedData.dataImageScotopic= LMK_readPfImage...
%                         (evaluatedData.dataSRCScotopic);
%             end
%         end
%         % load .mat-image data
%         if (isempty(matSource)== 0) && (exist([matSource],'file')==2)
%                 matImage = load([matSource]);
%                 evaluatedData.dataImagePhotopic = ....
%                     matImage.LMK_measurements.dataImage.YL;
%                 evaluatedData.dataImageScotopic = ...
%                     matImage.LMK_measurements.dataImage.LS;
%         end
        
        
        % put quadrangle into obj
        if(exist('quadrangle','var'))
            evaluatedData.quadrangle = quadrangle;
        end        
        evaluatedData.comments = COMMENTS;
        
        % evaluate mesopic luminance image if photopic & scotopic image
        % data exists
%         if ~(isempty(evaluatedData.dataImagePhotopic)) ...
%                 && ~(isempty(evaluatedData.dataImageScotopic))
%             [evaluatedData.dataImageMesopic, ~] = ...
%                 mesopicLuminance_recommended(evaluatedData.dataImagePhotopic,...
%                 evaluatedData.dataImageScotopic);   
%         end
        
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

end