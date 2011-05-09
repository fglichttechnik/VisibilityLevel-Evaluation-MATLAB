function SP = calcSPFromSpectrum(spectrum)

load('V_CIE.mat');
load('V_strich_CIE.mat');

lambda_i = linspace(380,780,401);
V_i = interp1(lambda_CIE, V, lambda_i);
Lv_photopic = 683 * sum(V_i .* spectrum);

lambda_i = linspace(380,780,401);
V_strich_i = interp1(lambda_CIE, V_strich, lambda_i);
Lv_scotopic = 1758 * sum(V_strich_i .* spectrum);

SP = Lv_scotopic / Lv_photopic;
