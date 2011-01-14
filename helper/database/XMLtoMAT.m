function elements = XMLtoMAT(xml_path)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de

disp('Loading xml file and read all images / data...');
str = parseXML(xml_path);
elements = struct2mat(str);

end


