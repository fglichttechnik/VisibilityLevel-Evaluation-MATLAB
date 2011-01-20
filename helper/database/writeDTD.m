function writeDTD(dataset_name, dir_name)

myDTD{1}= '<!ELEMENT LMKSet (dataSetName, StreetSurface, LMKData+)>';
myDTD{2}= '<!ELEMENT dataSetName (#PCDATA)>';
myDTD{3}= '<!ATTLIST dataSetName';
myDTD{4}= '    src CDATA #REQUIRED';
myDTD{5}= '>';
myDTD{6}= '<!ELEMENT StreetSurface (QuadrangleObject)>';
myDTD{7}= '<!ELEMENT QuadrangleObject (upperLeft, upperRight, lowerLeft, lowerRight)>';
myDTD{8}= '<!ELEMENT upperLeft (#PCDATA)>';
myDTD{9}= '<!ATTLIST upperLeft ';
myDTD{10}= '    x CDATA #REQUIRED';
myDTD{11}= '    y CDATA #REQUIRED';
myDTD{12}= '>';
myDTD{13}= '<!ELEMENT upperRight (#PCDATA)>';
myDTD{14}= '<!ATTLIST upperRight ';
myDTD{15}= '    x CDATA #REQUIRED';
myDTD{16}= '    y CDATA #REQUIRED';
myDTD{17}= '>';
myDTD{18}= '<!ELEMENT lowerLeft (#PCDATA)>';
myDTD{19}= '<!ATTLIST lowerLeft';
myDTD{20}= '    x CDATA #REQUIRED';
myDTD{21}= '    y CDATA #REQUIRED';
myDTD{22}= '>';
myDTD{23}= '<!ELEMENT lowerRight (#PCDATA)>';
myDTD{24}= '<!ATTLIST lowerRight ';
myDTD{25}= '    x CDATA #REQUIRED';
myDTD{26}= '    y CDATA #REQUIRED';
myDTD{27}= '>';
myDTD{28}= '<!ELEMENT LMKData (dataSource+, RectObject)>';
myDTD{29}= '<!ELEMENT dataSource (#PCDATA)>';
myDTD{30}= '<!ATTLIST dataSource ';
myDTD{31}= '    src CDATA #REQUIRED';
myDTD{32}= '    type CDATA #REQUIRED';
myDTD{33}= '>';
myDTD{34}= '<!ELEMENT RectObject (upperLeft, lowerRight, border, position)>';
myDTD{35}= '<!ELEMENT upperLeft (#PCDATA)>';
myDTD{36}= '<!ATTLIST upperLeft ';
myDTD{37}= '    x CDATA #REQUIRED';
myDTD{38}= '    y CDATA #REQUIRED';
myDTD{39}= '>';
myDTD{40}= '<!ELEMENT lowerRight (#PCDATA)>';
myDTD{41}= '<!ATTLIST lowerRight ';
myDTD{42}= '    x CDATA #REQUIRED';
myDTD{43}= '    y CDATA #REQUIRED';
myDTD{44}= '>';
myDTD{45}= '<!ELEMENT border (#PCDATA)>';
myDTD{46}= '<!ATTLIST border';
myDTD{47}= '    pixel CDATA #REQUIRED';
myDTD{48}= '>';
myDTD{49}= '<!ELEMENT position (#PCDATA)>';
myDTD{50}= '<!ATTLIST position ';
myDTD{51}= '    p CDATA #REQUIRED';
myDTD{52}= '>';

file_name = [dir_name, '\', dataset_name, '.dtd'];
fid = fopen(file_name, 'a+');

for i = 1 : 52
    fprintf(fid, '%s\r\n', myDTD{i});
end
fclose(fid);

end