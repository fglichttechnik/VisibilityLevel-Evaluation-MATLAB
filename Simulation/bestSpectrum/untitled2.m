


lambda = 380:780;

T = [2700; 4000; 8000; 12000];
Tlabels = {'2700', '4000', '8000', '12000'};

I = plancksLaw(lambda, T);

plot(lambda, I);
legend(Tlabels);


