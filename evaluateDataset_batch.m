
evaluateBatchSet = {

    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_dim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_dark',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_undim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_dim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_dark',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_undim_ns'
    
    };


evaluateCount = length( evaluateBatchSet );

for currentIndex = 1 : evaluateCount
    close all;
    currentFolderPath = evaluateBatchSet{ currentIndex };
    evaluateDataset( currentFolderPath );
end

