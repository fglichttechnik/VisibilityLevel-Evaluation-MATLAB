

Lb0 = 0.3;

reduction = [0.1, 0.14, 0.23];

Lb10 = (1 - reduction(1)) * Lb0;
Lb14 = (1 - reduction(2)) * Lb0;
Lb23 = (1 - reduction(3)) * Lb0;

Lt = 10000.001;

Lb = [Lb0, Lb10, Lb14, Lb23];

%for 27 RP800
AGE = 27;
T = 0.2;
K = 2.6;
alphaMinutes = 7.35;

deltaL = calcDeltaL(Lb, Lt, alphaMinutes, AGE, T ,K);
contrast = deltaL ./ Lb;

values = length(Lb) - 1;
diffDeltaLPercent = zeros( values, 1 );
diffContrastPercent = zeros( values, 1 );
for index = 1 : values
    diffDeltaLPercent( index ) = (deltaL( index + 1 ) / deltaL( 1 ) - 1) * 100;
    diffContrastPercent( index ) = (contrast( index + 1 ) / contrast( 1 ) - 1) * 100;
end

disp( sprintf( 'AGE = 27 RP800\n' ) );
for index = 1 : length( diffDeltaLPercent ) 
    disp( sprintf( 'c_{th} = %1.4f', contrast( index ) ) );
    %disp( sprintf( 'diffDeltaL: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffDeltaLPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
    disp( sprintf( 'diffContrast: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffContrastPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
end
disp( sprintf( '\n\n' ) );

%for 60 RP800
AGE = 60;
T = 0.2;
K = 2.6;
alphaMinutes = 7.35;

deltaL = calcDeltaL(Lb, Lt, alphaMinutes, AGE, T ,K);
contrast = deltaL ./ Lb;

values = length(Lb) - 1;
diffDeltaLPercent = zeros( values, 1 );
diffContrastPercent = zeros( values, 1 );
for index = 1 : values
    diffDeltaLPercent( index ) = (deltaL( index + 1 ) / deltaL( 1 ) - 1) * 100;
    diffContrastPercent( index ) = (contrast( index + 1 ) / contrast( 1 ) - 1) * 100;
end

disp( sprintf( 'AGE = 60 RP800\n' ) );
for index = 1 : length( diffDeltaLPercent ) 
    disp( sprintf( 'c_{th} = %1.4f', contrast( index ) ) );
    %disp( sprintf( 'diffDeltaL: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffDeltaLPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
    disp( sprintf( 'diffContrast: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffContrastPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
end
disp( sprintf( '\n\n' ) );

%for 27 18m = 57' bei 0.3
AGE = 27;
T = 0.2;
K = 2.6;
alphaMinutes = 57;

deltaL = calcDeltaL(Lb, Lt, alphaMinutes, AGE, T ,K);
contrast = deltaL ./ Lb;

values = length(Lb) - 1;
diffDeltaLPercent = zeros( values, 1 );
diffContrastPercent = zeros( values, 1 );
for index = 1 : values
    diffDeltaLPercent( index ) = (deltaL( index + 1 ) / deltaL( 1 ) - 1) * 100;
    diffContrastPercent( index ) = (contrast( index + 1 ) / contrast( 1 ) - 1) * 100;
end

disp( sprintf( 'AGE = 27 18m = 57'' bei 0.3m\n' ) );
for index = 1 : length( diffDeltaLPercent ) 
    disp( sprintf( 'c_{th} = %1.4f', contrast( index ) ) );
    %disp( sprintf( 'diffDeltaL: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffDeltaLPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
    disp( sprintf( 'diffContrast: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffContrastPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
end
disp( sprintf( '\n\n' ) );

%for 60 18m = 57' bei 0.3
AGE = 60;
T = 0.2;
K = 2.6;
alphaMinutes = 57;

deltaL = calcDeltaL(Lb, Lt, alphaMinutes, AGE, T ,K);
contrast = deltaL ./ Lb;

values = length(Lb) - 1;
diffDeltaLPercent = zeros( values, 1 );
diffContrastPercent = zeros( values, 1 );
for index = 1 : values
    diffDeltaLPercent( index ) = (deltaL( index + 1 ) / deltaL( 1 ) - 1) * 100;
    diffContrastPercent( index ) = (contrast( index + 1 ) / contrast( 1 ) - 1) * 100;
end

disp( sprintf( 'AGE = 60 18m = 57'' bei 0.3m\n' ) );
for index = 1 : length( diffDeltaLPercent ) 
    disp( sprintf( 'c_{th} = %1.4f', contrast( index ) ) );
    %disp( sprintf( 'diffDeltaL: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffDeltaLPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
    disp( sprintf( 'diffContrast: %2.2f for Lb %1.2f (reduction %2.0f)\n', diffContrastPercent( index ), Lb( index + 1 ), reduction( index ) * 100 ) );
end
disp( sprintf( '\n\n' ) );