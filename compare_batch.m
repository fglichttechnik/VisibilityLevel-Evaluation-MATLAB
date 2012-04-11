
compareBatchSet = {
%     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Comparison_TargetReflectancy',
%     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Comparison_TargetReflectancySmallMesopic',
     %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_Comparison_TargetReflectancySmallPhotopic',
     %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonDimVs2ndOff_4',
     %'/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonDimVs2ndOff_50',
%     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonHSvsLED_S5',
%     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonHSvsLED_S6',
 %    '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonMeasVsSim',
%     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonS5VsS6',
     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonHSvsLED_S5_MesPhot',
     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonHSvsLED_S5S6',
     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonHSvsLED_S6_MesPhot',
      '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonS5VsS6MesPhot',
%      '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonLED_S5_MesPhot',
%      '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonLED_S6_MesPhot',
%      '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonHS_S6_MesPhot',
 %     '/Users/jw/Desktop/Development/LMK/LMK_Data_evaluation/database/compare/Treskowstr_ComparisonLED_S5vsS6_Phot'
    };


batchCount = length( compareBatchSet );

for currentIndex = 1 : batchCount
    close all;
    currentFolderPath = compareBatchSet{ currentIndex };
    compareEvaluatedDatasets( currentFolderPath );
end