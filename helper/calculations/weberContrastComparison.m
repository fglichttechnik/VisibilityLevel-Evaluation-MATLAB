weberPathArray = {
%       'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_H_T100/Treskowstr_R3_H_T100/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_H_T100.fig';
%       'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_H_T070/Treskowstr_R3_H_T070/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_H_T070.fig';
%       'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_H_T050/Treskowstr_R3_H_T050/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_H_T050.fig';
%       'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_H_T030/Treskowstr_R3_H_T030/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_H_T030.fig';
%       'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_H_T010/Treskowstr_R3_H_T010/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_H_T010.fig';
%       'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_H_T004/Treskowstr_R3_H_T004/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_H_T004.fig';
      
     'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_T100/Treskowstr_R3_T100/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_T100.fig';
     'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_T070/Treskowstr_R3_T070/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_T070.fig';
     'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_T050/Treskowstr_R3_T050/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_T050.fig';
     'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_T030/Treskowstr_R3_T030/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_T030.fig';
     'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_T010/Treskowstr_R3_T010/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_T010.fig';
     'd:/cygwin/home/Robert/GitUmgebung/LMK/LMK_Data_evaluation/database/dataset/Treskowstr_R3_T004/Treskowstr_R3_T004/plots_RP800/Photopic_weberContrastPlot_Treskowstr_R3_T004.fig';
                };
            
weberArrayCount = length( weberPathArray ) ;
outputWeberArray =  zeros( weberArrayCount, 14 );

for currentIndex = 1 : weberArrayCount
    currentFolderPath = weberPathArray{ currentIndex, 1 };
    openfig( currentFolderPath );
    yData = get( findobj( get( gca, 'Children' ), 'type', 'line' ), 'YData' );
    xData = get( findobj( get( gca, 'Children' ), 'type', 'line' ), 'XData' );
    xLim = get( gca, 'XLim' );
    outputWeberArray( currentIndex, : ) = yData ;
    close all;
end

weberFig = figure();
for currentIndex = 1 : weberArrayCount
    plot( xData, outputWeberArray( currentIndex, : ), 'Marker', 'o', 'LineWidth', 4, 'LineStyle', '--' )
    hold on
end

maxWeberArray = max( max( outputWeberArray ) );
minWeberArray = min( min( outputWeberArray ) );
%set( gca, 'XLim', xLim );
%set( gca, 'YLim', [ minWeberArray maxWeberArray ] );


axis('tight');
x = xlabel('d in m');
y = ylabel('C');
t = title(strcat('Weber Contrast - Treskowstr. - R3') );
finetunePlot( weberFig );

