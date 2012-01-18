
evaluateBatchSet = {
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_HS_R3_2070'
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_1035_fd',
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_1449_fd',
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_2070_fd',
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_3519_fd',
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_4554_fd',
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_7245_fd'
    %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_R3_7245_fd'
    % '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_HS_RP8_1449',
    % '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_1449',
    %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_dim',
    %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_ds',
    %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_undim',
    %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_4_dim',
    %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_4_ds',
    %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/Treskowstr_LED_RP8_4_undim'
    %  '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_R3_2070',
    %  '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_gemessen'
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_HS_RP8_1035',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_HS_RP8_1449',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_HS_RP8_2070',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_1035',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_1449',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_2070',
    %
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_gemessen',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_R3_2070',
    %
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_6',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_10',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_20',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_30',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_40',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_50',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_60',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_70',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_80',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_90',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_100',
    %
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_dim',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_ds',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_4_undim',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_dim',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_ds',
    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/datasets/Treskowstr_LED_RP8_undim'
    
    };


evaluateCount = length( evaluateBatchSet );

for currentIndex = 1 : evaluateCount
    close all;
    currentFolderPath = evaluateBatchSet{ currentIndex };
    evaluateDataset( currentFolderPath );
end

