
evaluateBatchSet = {
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_HS_R3_2070'
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_1035',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_1449',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_2070',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_3519',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_4554',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_7245'
    };


evaluateCount = length( evaluateBatchSet );

for currentIndex = 1 : evaluateCount
    close all;
    currentFolderPath = evaluateBatchSet{ currentIndex };
    evaluateDataset( currentFolderPath );
end

