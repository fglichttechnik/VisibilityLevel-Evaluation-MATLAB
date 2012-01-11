function [  ] = plotDifferenceOfDataset( originalSet, compareSet )

%figHandleArray
diffLtAbsoluteArray = originalSet.meanTargetArray - compareSet.meanTargetArray;
diffLBAbsoluteArray = originalSet.meanBackgroundArray - compareSet.meanBackgroundArray;

diffLtPercentualArray = diffLtAbsoluteArray ./ originalSet.meanTargetArray * 100;
diffLBPercentualArray = diffLBAbsoluteArray ./originalSet.meanBackgroundArray * 100;

%plot Lt and Lb
figure();
colorSettings = 'r';
plot( originalSet.distanceArray, diffLtAbsoluteArray , colorSettings );
%legend('L_t','L_B');
axis('tight');
xlabel('d in m');
ylabel('L Difference in cd/m^2');
title(strcat('Diff L_t Absolute') );

figure();
colorSettings = 'r';
plot( originalSet.distanceArray, diffLBAbsoluteArray , colorSettings );
%legend('L_t','L_B');
axis('tight');
xlabel('d in m');
ylabel('L Difference in cd/m^2');
title(strcat('Diff L_B Absolute') );

figure();
colorSettings = 'r';
plot( originalSet.distanceArray, diffLtPercentualArray , colorSettings );
%legend('L_t','L_B');
axis('tight');
xlabel('d in m');
ylabel('L Difference in %');
title(strcat('Diff L_t Percentual') );

figure();
colorSettings = 'r';
plot( originalSet.distanceArray, diffLBPercentualArray , colorSettings );
%legend('L_t','L_B');
axis('tight');
xlabel('d in m');
ylabel('L Difference in %');
title(strcat('Diff L_B Percentual') );

end

