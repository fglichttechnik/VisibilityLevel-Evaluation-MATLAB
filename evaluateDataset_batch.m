
evaluateBatchSet = {

    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_HS_RP8_1035',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_HS_RP8_1449',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_HS_RP8_2070',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_gemessen',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_R3_2070',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_6',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_10',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_20',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_30',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_40',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_50',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_60',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_70',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_80',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_90',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_100',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_dark',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_dim',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_dim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_ds',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_ds_nlbmf',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_undim',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_undim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_1035',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_1449',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_2070',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_dark',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_dim',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_dim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_ds',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_undim',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_undim_ns',
    '/Users/janwinter/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_test'
    
    };


evaluateCount = length( evaluateBatchSet );

for currentIndex = 1 : evaluateCount
    close all;
    currentFolderPath = evaluateBatchSet{ currentIndex };
    evaluateDataset( currentFolderPath );
end

