%%%%%%%%%%%Structure of elements%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S = load(filename)

S

S.elements

S.elements{1,1}.dataSRCPhotopic		'measurement01.mat'
               .dataTypePhotopic	'.mat'
	       .dataSRCScotopic		'measurement01.mat'
	       .dataTypeScotopic	'.mat'
	       .rect			<1x1 struct>		.upperLeft	<1x1 struct>	.x 726
												.y 367	
								.lowerRight	<1x1 struct>    .x 917
												.y 850
	       .rectPosition		2
	       .quadrangle		<1x1 struct>		.upperLeft	<1x1 struct>	.x 726
												.y 367	
								.lowerRight	<1x1 struct>    .x 917
												.y 850
	       .border			3
	       .dataImageScotopic	<1032x1379 single>
	       .dataImagePhotopic	<1032x1379 single>
               .dataImageMesopic	<1032x1379 single>
	       .imageMetaData
	       .comments		


%%%%%%%%%%%%Structure of struct from fcns parseXML, mat2struct%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

str

str(1,1).Name		'LMKSetMat'
	    .Attributes
	    .Data
	    .Children

str(1,2).Name		'LMKSetMat'
	    .Attributes
	    .Data
str(1,2).Children(1,2).Name 		'LMKData'
					  .Attributes
					  .Data
str(1,2).Children(1,2).Children(1,2).Name		'dataSource'
str(1,2).Children(1,2).Children(1,2).Attributes(1,1).Name	'src'
str(1,2).Children(1,2).Children(1,2).Attributes(1,1).Value 	'measurement01.mat'
str(1,2).Children(1,2).Children(1,2).Attributes(1,2).Name 	'type'
str(1,2).Children(1,2).Children(1,2).Attributes(1,2).Value	'.mat'
									.Data
									.Children
str(1,2).Children(1,2).Children(1,4).Name		'RectObject'
									.Attributes
 									.Data
str(1,2).Children(1,2).Children(1,4).Children(1,2).Name	  'upperLeft'	
str(1,2).Children(1,2).Children(1,4).Children(1,2).Attributes(1,1).Name 	'x'
str(1,2).Children(1,2).Children(1,4).Children(1,2).Attributes(1,1).Value 	'726'
str(1,2).Children(1,2).Children(1,4).Children(1,2).Attributes(1,2).Name	'y'
str(1,2).Children(1,2).Children(1,4).Children(1,2).Attributes(1,2).Value	'367'
												  .Data
												  .Children
str(1,2).Children(1,2).Children(1,4).Children(1,4).Name	  'lowerRight'	
str(1,2).Children(1,2).Children(1,4).Children(1,4).Attributes(1,1).Name 	'x'
str(1,2).Children(1,2).Children(1,4).Children(1,4).Attributes(1,1).Value 	'917'
str(1,2).Children(1,2).Children(1,4).Children(1,4).Attributes(1,2).Name	'y'
str(1,2).Children(1,2).Children(1,4).Children(1,4).Attributes(1,2).Value	'850'
												  .Data
												  .Children	
str(1,2).Children(1,2).Children(1,4).Children(1,6).Name	  'border'	
str(1,2).Children(1,2).Children(1,4).Children(1,6).Attributes.Name 	'pixel'
str(1,2).Children(1,2).Children(1,4).Children(1,6).Attributes.Value 	'3'
												  .Data
												  .Children	
str(1,2).Children(1,2).Children(1,4).Children(1,8).Name	  'position'	
str(1,2).Children(1,2).Children(1,4).Children(1,8).Attributes.Name 	'p'
str(1,2).Children(1,2).Children(1,4).Children(1,8).Attributes.Value 	'2'
												  .Data
												  .Children									 