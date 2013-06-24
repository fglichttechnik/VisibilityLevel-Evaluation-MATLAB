
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