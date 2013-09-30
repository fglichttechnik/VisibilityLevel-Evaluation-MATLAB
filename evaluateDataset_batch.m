
%possible evaluation methods:
% RP800, LOWER_EDGE, LEFT_EDGE, RIGHT_EDGE, UPPER_EDGE, STRONGEST_EDGE, STRONGEST_CORNER, 2DEGREE_BACKGROUND

evaluateBatchSet = {

 'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_Evaluation/database/dataset/PseudoTest', 'RP800';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'LOWER_EDGE'
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'LEFT_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'RIGHT_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'UPPER_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'STRONGEST_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'STRONGEST_CORNER';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', '2DEGREE_BACKGROUND'
       
    };


evaluateCount = length( evaluateBatchSet );

for currentIndex = 1 : evaluateCount
    close all;
    currentFolderPath = evaluateBatchSet{ currentIndex, 1 };
    currentEvaluationMethod = evaluateBatchSet{ currentIndex, 2 };
    evaluateDataset( currentFolderPath, currentEvaluationMethod );
end

