function writeDTD(dataset_name, dir_name)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Writes .dtd file especially fitting to the LMK XML files.
% 
% Input: dataset_name = name of current measurement series used for
%                       the XML name, too
%        dir_name     = directory where the XML file is located, too


myDTD{1}= ['<!ELEMENT ', dataset_name, ' (Description, StreetSurface, LMKData+)>'];
myDTD{3}= '<!ELEMENT Description (SceneTitle, FocalLength, ViewPoint, Target, ScotopicToPhotopicRatio, Pole)>';
myDTD{4}= '<!ELEMENT SceneTitle (#PCDATA)>';
myDTD{5}= '<!ATTLIST SceneTitle ';
myDTD{6}= '    Title CDATA #REQUIRED';
myDTD{7}= '>';
myDTD{8}= '<!ELEMENT FocalLength (#PCDATA)>';
myDTD{9}= '<!ATTLIST FocalLength ';
myDTD{10}= '    FL CDATA #REQUIRED';
myDTD{11}= '>';
myDTD{12}= '<!ELEMENT ViewPoint (#PCDATA)>';
myDTD{13}= '<!ATTLIST ViewPoint ';
myDTD{14}= '    Disctance CDATA #REQUIRED';
myDTD{15}= '>';
myDTD{16}= '<!ELEMENT Target (#PCDATA)>';
myDTD{17}= '<!ATTLIST Target ';
myDTD{18}= '    Size CDATA #REQUIRED';
myDTD{19}= '>';
myDTD{20}= '<!ELEMENT ScotopicToPhotopicRatio (#PCDATA)>';
myDTD{21}= '<!ATTLIST ScotopicToPhotopicRatio ';
myDTD{22}= '    SPRatio CDATA #REQUIRED';
myDTD{23}= '>';
myDTD{24}= '<!ELEMENT Pole (#PCDATA)>';
myDTD{25}= '<!ATTLIST Pole ';
myDTD{26}= '    NumPoleFields CDATA #REQUIRED';
myDTD{27}= '>';
myDTD{28}= '<!ELEMENT StreetSurface (QuadrangleObject)>';
myDTD{29}= '<!ELEMENT QuadrangleObject (upperLeft, upperRight, lowerLeft, lowerRight)>';
myDTD{30}= '<!ELEMENT upperLeft (#PCDATA)>';
myDTD{31}= '<!ATTLIST upperLeft ';
myDTD{32}= '    x CDATA #REQUIRED';
myDTD{33}= '    y CDATA #REQUIRED';
myDTD{34}= '>';
myDTD{35}= '<!ELEMENT upperRight (#PCDATA)>';
myDTD{36}= '<!ATTLIST upperRight ';
myDTD{37}= '    x CDATA #REQUIRED';
myDTD{38}= '    y CDATA #REQUIRED';
myDTD{39}= '>';
myDTD{40}= '<!ELEMENT lowerLeft (#PCDATA)>';
myDTD{41}= '<!ATTLIST lowerLeft';
myDTD{42}= '    x CDATA #REQUIRED';
myDTD{43}= '    y CDATA #REQUIRED';
myDTD{44}= '>';
myDTD{45}= '<!ELEMENT lowerRight (#PCDATA)>';
myDTD{46}= '<!ATTLIST lowerRight ';
myDTD{47}= '    x CDATA #REQUIRED';
myDTD{48}= '    y CDATA #REQUIRED';
myDTD{49}= '>';
myDTD{50}= '<!ELEMENT LMKData (dataSource+, RectObject)>';
myDTD{51}= '<!ELEMENT dataSource (#PCDATA)>';
myDTD{52}= '<!ATTLIST dataSource ';
myDTD{53}= '    src CDATA #REQUIRED';
myDTD{54}= '    type CDATA #REQUIRED';
myDTD{55}= '>';
myDTD{56}= '<!ELEMENT RectObject (upperLeft, lowerRight, border, position)>';
myDTD{57}= '<!ELEMENT upperLeft (#PCDATA)>';
myDTD{58}= '<!ATTLIST upperLeft ';
myDTD{59}= '    x CDATA #REQUIRED';
myDTD{60}= '    y CDATA #REQUIRED';
myDTD{61}= '>';
myDTD{62}= '<!ELEMENT lowerRight (#PCDATA)>';
myDTD{63}= '<!ATTLIST lowerRight ';
myDTD{64}= '    x CDATA #REQUIRED';
myDTD{65}= '    y CDATA #REQUIRED';
myDTD{66}= '>';
myDTD{67}= '<!ELEMENT border (#PCDATA)>';
myDTD{68}= '<!ATTLIST border';
myDTD{69}= '    pixel CDATA #REQUIRED';
myDTD{70}= '>';
myDTD{71}= '<!ELEMENT position (#PCDATA)>';
myDTD{72}= '<!ATTLIST position ';
myDTD{73}= '    p CDATA #REQUIRED';
myDTD{74}= '>';

file_name = [dir_name, '\', dataset_name, '.dtd'];
fid = fopen(file_name, 'a+');

for i = 1 : 74
    fprintf(fid, '%s\r\n', myDTD{i});
end
fclose(fid);

end