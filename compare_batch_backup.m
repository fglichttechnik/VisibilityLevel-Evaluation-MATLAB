
compareBatchSet = {
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_City',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_R2',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_R3',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Amb_T1',
    
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Dirt_0',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Dirt_4',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Dirt_26',
    
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_City',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_City_Grass',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_Lower',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_RP800',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_LED_Ori_Upper',
    
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Licht',
    
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Plastic',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_R2',
    
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_View_auto',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_View_auto_60',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_View_first',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_View_first_60',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_View_last',
    '/Users/robert/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_View_last_60',

    };


batchCount = length( compareBatchSet );

for currentIndex = 1 : batchCount
    close all;
    currentFolderPath = compareBatchSet{ currentIndex };
    compareEvaluatedDatasets( currentFolderPath );
    
    %separate error Berechnung 
    errorCalc( currentFolderPath );
end