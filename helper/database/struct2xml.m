function struct2xml(str, dir_name)

% ignore empty struct element
if isempty(str(1,1).Children) && ~isempty(str(1,2).Children)
    str = str(1,2);
end

xml_name = str.Name;   

xml_path = [dir_name, '\', xml_name, '.xml'];

xDoc = com.mathworks.xml.XMLUtils.createDocument(str.Name, str.Name,...
        'SYSTEM', [str.Name, '.dtd'] );
docRootNode = xDoc.getDocumentElement;  


% Write new data element in .xml file:
[~, n] = size(str.Children);
for i = 2 : 2 : n
    LMKData_node = xDoc.createElement(str.Children(1,2).Name);
    xDoc.getDocumentElement.appendChild(LMKData_node);

        dataSource_node = xDoc.createElement(str.Children(1,i).Children...
            (1,2).Name);    
                dataSource_attr1 = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,2).Attributes(1,1).Name);
                dataSource_attr1.setNodeValue(str.Children(1,i).Children...
                    (1,2).Attributes(1,1).Value);
                dataSource_node.setAttributeNode(dataSource_attr1);            
                dataSource_attr2 = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,2).Attributes(1,2).Name);
                dataSource_attr2.setNodeValue(str.Children(1,i).Children...
                    (1,2).Attributes(1,2).Value);
                dataSource_node.setAttributeNode(dataSource_attr2);
        LMKData_node.appendChild(dataSource_node);

        RectObject_node = xDoc.createElement(str.Children(1,i).Children...
            (1,4).Name);    
            upperLeft_node = xDoc.createElement(str.Children...
                (1,i).Children(1,4).Children(1,2).Name);
                upperLeft_attr1 = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,4).Children(1,2).Attributes(1,1).Name);
                upperLeft_attr1.setNodeValue(num2str(str.Children...
                    (1,i).Children(1,4).Children(1,2).Attributes(1,1).Value));
                upperLeft_node.setAttributeNode(upperLeft_attr1);
                upperLeft_attr2 = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,4).Children(1,2).Attributes(1,2).Name);
                upperLeft_attr2.setNodeValue(num2str(str.Children...
                    (1,i).Children(1,4).Children(1,2).Attributes(1,2).Value));
                upperLeft_node.setAttributeNode(upperLeft_attr2);    
            RectObject_node.appendChild(upperLeft_node);

            lowerRight_node = xDoc.createElement(str.Children...
                (1,i).Children(1,4).Children(1,4).Name);
                lowerRight_attr1 = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,4).Children(1,4).Attributes(1,1).Name);
                lowerRight_attr1.setNodeValue(num2str(str.Children...
                    (1,i).Children(1,4).Children(1,4).Attributes(1,1).Value));
                lowerRight_node.setAttributeNode(lowerRight_attr1);
                lowerRight_attr2 = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,4).Children(1,4).Attributes(1,2).Name);
                lowerRight_attr2.setNodeValue(num2str(str.Children...
                    (1,i).Children(1,4).Children(1,4).Attributes(1,2).Value));
                lowerRight_node.setAttributeNode(lowerRight_attr2); 
            RectObject_node.appendChild(lowerRight_node); 

            border_node = xDoc.createElement(str.Children(1,i).Children...
                (1,4).Children(1,6).Name);
                border_attr = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,4).Children(1,6).Attributes.Name);
                border_attr.setNodeValue(num2str(str.Children...
                    (1,i).Children(1,4).Children(1,6).Attributes.Value));
                border_node.setAttributeNode(border_attr); 
            RectObject_node.appendChild(border_node); 

            position_node = xDoc.createElement(str.Children...
                (1,i).Children(1,4).Children(1,8).Name); 
                position_attr = xDoc.createAttribute(str.Children...
                    (1,i).Children(1,4).Children(1,8).Attributes.Name);
                position_attr.setNodeValue(num2str(str.Children...
                    (1,i).Children(1,4).Children(1,8).Attributes.Value));
                position_node.setAttributeNode(position_attr); 
            RectObject_node.appendChild(position_node);         
        LMKData_node.appendChild(RectObject_node);
end
xmlwrite(xml_path, xDoc);

end