function MATtoXML(dir_name, file_name, elements)

if nargin == 0
    dir_name = 'C:\Dokumente und Einstellungen\admin\Eigene Dateien\MATLAB\database\6,5';
    xml_name = 'lmkXMLmat';
    file_name = 'measurement01.mat';
else
    xml_name = 'lmkXMLmat';
end

xml_path = [dir_name, '\', xml_name, '.xml'];

% read struct
for a = 1 : length(elements)
    str = elements{a,1}; %write first data into struct
    assignin('base', 'str', str);
    parent_nodes = fieldnames(str); %get names of nodes  
    assignin('base', 'parent_nodes', parent_nodes);
    %names = cell2struct(names, names, 1);
    for b = 1 : length(parent_nodes)
        parent_node_value{b} = getfield(str, parent_nodes{b,1});
        assignin('base', 'parent_node_value', parent_node_value);
        for c = length(parent_node_value)
            if isstruct(parent_node_value{1,c})
                child_node = fieldnames(parent_node_value{1,c});
                for d = 1 : length(child_node)
                    child_node_value{d} = getfield(parent_node_value{1,c}, child_node{d,1})
                end
            end
        end
%         child_nodes{b,a} = fieldnames(['str.', parent_nodes{b,1}]);
%         child_names = cell2struct(child_names{b,a}, child_names{b,a}, 1);
    end
end

% % write new xml file 
% xDoc = com.mathworks.xml.XMLUtils.createDocument('LMKSetMat', 'LMKSetMat', 'SYSTEM', 'LMKSetMat.dtd' );
% docRootNode = xDoc.getDocumentElement;  
% 
% % write new data element in .xml file:
% LMKData_node = xDoc.createElement('LMKData');
% xDoc.getDocumentElement.appendChild(LMKData_node);
%     dataSource_node = xDoc.createElement('dataSource');    
%             dataSource_attr1 = xDoc.createAttribute('src');
%             dataSource_attr1.setNodeValue(file_name);
%             dataSource_node.setAttributeNode(dataSource_attr1);            
%             dataSource_attr2 = xDoc.createAttribute('type');
%             dataSource_attr2.setNodeValue('.mat');
%             dataSource_node.setAttributeNode(dataSource_attr2);
%     LMKData_node.appendChild(dataSource_node);
% 
%     RectObject_node = xDoc.createElement('RectObject');    
%         upperLeft_node = xDoc.createElement('upperLeft');
%             upperLeft_attr1 = xDoc.createAttribute('x');
%             upperLeft_attr1.setNodeValue(num2str(rect.upperLeft.x));
%             upperLeft_node.setAttributeNode(upperLeft_attr1);
%             upperLeft_attr2 = xDoc.createAttribute('y');
%             upperLeft_attr2.setNodeValue(num2str(rect.upperLeft.y));
%             upperLeft_node.setAttributeNode(upperLeft_attr2);    
%         RectObject_node.appendChild(upperLeft_node);
% 
%         lowerRight_node = xDoc.createElement('lowerRight');
%             lowerRight_attr1 = xDoc.createAttribute('x');
%             lowerRight_attr1.setNodeValue(num2str(rect.lowerRight.x));
%             lowerRight_node.setAttributeNode(lowerRight_attr1);
%             lowerRight_attr2 = xDoc.createAttribute('y');
%             lowerRight_attr2.setNodeValue(num2str(rect.lowerRight.y));
%             lowerRight_node.setAttributeNode(lowerRight_attr2); 
%         RectObject_node.appendChild(lowerRight_node); 
% 
%         border_node = xDoc.createElement('border');
%             border_attr = xDoc.createAttribute('pixel');
%             border_attr.setNodeValue(num2str(border));
%             border_node.setAttributeNode(border_attr); 
%         RectObject_node.appendChild(border_node); 
% 
%         position_node = xDoc.createElement('position'); 
%             position_attr = xDoc.createAttribute('p');
%             position_attr.setNodeValue(num2str(position));
%             position_node.setAttributeNode(position_attr); 
%         RectObject_node.appendChild(position_node);         
%     LMKData_node.appendChild(RectObject_node);
% 
% xmlwrite(xml_path, xDoc);

end