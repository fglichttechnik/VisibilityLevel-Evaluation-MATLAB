function I = plancksLaw(lambda, T)
%function I = planckRadiation(lambda, T)

c = 3 * 10^8;   %speed of light [m/s]
h = 6.62606957 * 10^(-34);  %planck'sches Wirkungsquantum [Js]
k = 1.3806504 * 10^(-23); %Blotzmannkonstante [J/K]

f = c ./ lambda * 10^9;


I = zeros(length(f), length(T));
for i = 1 : length(T)
    T_ = T(i);    
    nominator = 2 * h * f.^3;
    denominator1 = c^2;    
    expNominator = h * f;
    expDenominator = k * T_;    
    denominator2 = exp(expNominator ./ expDenominator) - 1;
    I(:, i) = nominator ./  denominator1  .* 1 ./ denominator2;
end

