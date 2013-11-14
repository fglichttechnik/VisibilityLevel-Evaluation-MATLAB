%AUTHOR: Jan Winter, Sandy Buschmann, Robert Franke TU Berlin, FG Lichttechnik,
%	j.winter@tu-berlin.de, www.li.tu-berlin.de
%LICENSE: free to use at your own risk. Kudos appreciated.

compareBatchSet = {
    
    '/Users/sandy/Desktop/Development/LMK_Data_Evaluation/database/StreetXY_CompareEvaluationMethods/StreetXY_LOWER_EDGE', ...
    '/Users/sandy/Desktop/Development/LMK_Data_Evaluation/database/StreetXY_CompareEvaluationMethods/StreetXY_RP800'
    
    };


batchCount = length( compareBatchSet );

for currentIndex = 1 : batchCount
    close all;
    currentFolderPath = compareBatchSet{ currentIndex };
    compareEvaluatedDatasets( currentFolderPath );
end