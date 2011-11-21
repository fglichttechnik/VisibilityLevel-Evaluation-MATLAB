


lambda = 380:780;

T = [2700; 4000; 8000; 12000];
Tlabels = {'2700', '4000', '8000', '12000'};

I = plancksLaw(lambda, T);

semilogy(lambda, I);
legend(Tlabels);


c2700 = CS2000Measurement();
c2700.initWithSpectrum(I(:, 1)');
c4000 = CS2000Measurement();
c4000.initWithSpectrum(I(:, 2)');
c8000 = CS2000Measurement();
c8000.initWithSpectrum(I(:, 3)');
c12000 = CS2000Measurement();
c12000.initWithSpectrum(I(:, 4)');



c2700.colorimetricData.SP
c4000.colorimetricData.SP
c8000.colorimetricData.SP
c12000.colorimetricData.SP


