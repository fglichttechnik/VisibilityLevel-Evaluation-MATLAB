
%possible evaluation methods:
% RP800, LOWER_EDGE, LEFT_EDGE, RIGHT_EDGE, UPPER_EDGE, STRONGEST_EDGE, STRONGEST_CORNER, 2DEGREE_BACKGROUND

evaluateBatchSet = {
    
%'d:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_Evaluation/database/dataset/PseudoTest', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/CELEST_55W/CELEST_55W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/CIVIC_100W/CIVIC_100W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/DECOSTREET_70W/DECOSTREET_70W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/INDRA_33W/INDRA_33W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/JET_42W/JET_42W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/LEMNIS_70W/LEMNIS_70W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/ORACLES_100W/ORACLES_100W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/RIGA_70W/RIGA_70W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/C2W3/VICTOR_40W/VICTOR_40W', 'RP800';

'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/CELEST_55W/CELEST_55W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/CIVIC_100W/CIVIC_100W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/DECOSTREET_70W/DECOSTREET_70W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/INDRA_33W/INDRA_33W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/JET_42W/JET_42W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/LEMNIS_70W/LEMNIS_70W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/ORACLES_100W/ORACLES_100W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/RIGA_70W/RIGA_70W', 'RP800';
'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/R3/VICTOR_40W/VICTOR_40W', 'RP800';

%'/Users/Robert/Desktop/Development/LMK/LMK_Data_Evaluation/database/datasets/DYANA_150W_DEFEKT/DYANA_150W', 'RP800';


%'/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'LEFT_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'RIGHT_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'UPPER_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'STRONGEST_EDGE';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', 'STRONGEST_CORNER';
% '/Users/sandy/Desktop/Development/LMK_Data_evaluation/database/StreetXY/StreetXY', '2DEGREE_BACKGROUND'

};


evaluateCount = size( evaluateBatchSet );
evaluateCount = evaluateCount(1);

for currentIndex = 1 : evaluateCount
    close all;
    currentFolderPath = evaluateBatchSet{ currentIndex, 1 };
    currentEvaluationMethod = evaluateBatchSet{ currentIndex, 2 };
    evaluateDataset( currentFolderPath, currentEvaluationMethod );
end
