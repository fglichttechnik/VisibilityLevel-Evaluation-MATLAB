function writeDTD(dataset_name, dir_name)
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%
% Writes .dtd file especially fitting to the LMK XML files.
% 
% Input: dataset_name = name of current measurement series used for
%                       the XML name, too
%        dir_name     = directory where the XML file is located, too


myDTD{1}= ['<!ELEMENT ', dataset_name, ' (dataSetName, Description, StreetSurface, LMKData+)>'];
myDTD{2}= '<!ELEMENT dataSetName (#PCDATA)>';
myDTD{3}= '<!ATTLIST dataSetName';
myDTD{4}= '    src CDATA #REQUIRED';
myDTD{5}= '>';
myDTD{6}= '<!ELEMENT Desciption (SceneTitle, FocalLength, ViewPoint, Target, PhotopicToScotopicRatio)>';
myDTD{7}= '<!ELEMENT SceneTitle (#PCDATA)>';
myDTD{8}= '    Title CDATA #REQUIRED';
myDTD{9}= '>';
myDTD{10}= '<!ELEMENT FocalLength (#PCDATA)>';
myDTD{11}= '    FL CDATA #REQUIRED';
myDTD{12}= '>';
myDTD{13}= '<!ELEMENT ViewPoint (#PCDATA)>';
myDTD{14}= '    Disctance CDATA #REQUIRED';
myDTD{15}= '>';
myDTD{16}= '<!ELEMENT Target (#PCDATA)>';
myDTD{17}= '    Size CDATA #REQUIRED';
myDTD{18}= '>';
myDTD{19}= '<!ELEMENT PhotopicToScotopicRatio (#PCDATA)>';
myDTD{20}= '    SPRatio CDATA #REQUIRED';
myDTD{21}= '>';
myDTD{22}= '<!ELEMENT StreetSurface (QuadrangleObject)>';
myDTD{23}= '<!ELEMENT QuadrangleObject (upperLeft, upperRight, lowerLeft, lowerRight)>';
myDTD{24}= '<!ELEMENT upperLeft (#PCDATA)>';
myDTD{25}= '<!ATTLIST upperLeft ';
myDTD{26}= '    x CDATA #REQUIRED';
myDTD{27}= '    y CDATA #REQUIRED';
myDTD{28}= '>';
myDTD{29}= '<!ELEMENT upperRight (#PCDATA)>';
myDTD{30}= '<!ATTLIST upperRight ';
myDTD{31}= '    x CDATA #REQUIRED';
myDTD{32}= '    y CDATA #REQUIRED';
myDTD{33}= '>';
myDTD{34}= '<!ELEMENT lowerLeft (#PCDATA)>';
myDTD{35}= '<!ATTLIST lowerLeft';
myDTD{36}= '    x CDATA #REQUIRED';
myDTD{37}= '    y CDATA #REQUIRED';
myDTD{38}= '>';
myDTD{39}= '<!ELEMENT lowerRight (#PCDATA)>';
myDTD{40}= '<!ATTLIST lowerRight ';
myDTD{41}= '    x CDATA #REQUIRED';
myDTD{42}= '    y CDATA #REQUIRED';
myDTD{43}= '>';
myDTD{44}= '<!ELEMENT LMKData (dataSource+, RectObject)>';
myDTD{45}= '<!ELEMENT dataSource (#PCDATA)>';
myDTD{46}= '<!ATTLIST dataSource ';
myDTD{47}= '    src CDATA #REQUIRED';
myDTD{48}= '    type CDATA #REQUIRED';
myDTD{49}= '>';
myDTD{50}= '<!ELEMENT RectObject (upperLeft, lowerRight, border, position)>';
myDTD{51}= '<!ELEMENT upperLeft (#PCDATA)>';
myDTD{52}= '<!ATTLIST upperLeft ';
myDTD{53}= '    x CDATA #REQUIRED';
myDTD{54}= '    y CDATA #REQUIRED';
myDTD{55}= '>';
myDTD{56}= '<!ELEMENT lowerRight (#PCDATA)>';
myDTD{57}= '<!ATTLIST lowerRight ';
myDTD{58}= '    x CDATA #REQUIRED';
myDTD{59}= '    y CDATA #REQUIRED';
myDTD{60}= '>';
myDTD{61}= '<!ELEMENT border (#PCDATA)>';
myDTD{62}= '<!ATTLIST border';
myDTD{63}= '    pixel CDATA #REQUIRED';
myDTD{64}= '>';
myDTD{65}= '<!ELEMENT position (#PCDATA)>';
myDTD{66}= '<!ATTLIST position ';
myDTD{67}= '    p CDATA #REQUIRED';
myDTD{68}= '>';

file_name = [dir_name, '\', dataset_name, '.dtd'];
fid = fopen(file_name, 'a+');

for i = 1 : 52
    fprintf(fid, '%s\r\n', myDTD{i});
end
fclose(fid);

end