function [Lseq] = systemEqLuminance_sagawa(Lxy,Lp,Ls)
%DEPRECATED: function is not completed
%author Sandy Buschmann, Jan Winter TU Berlin
%email j.winter@tu-berlin.de
%calculates the system equivalent luminance according to the 
%SAGAWA-TAKEICHI SYSTEM (CIE 141-2001)
%Lxy, Ls, Lp might be single values or matrices
%Lxy = 2° x,y coordinates
%Lp = photopic luminance
%Ls = scotopic luminance

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%preferences%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%nothing needs to be modified below%%%%%%%%%%%%%%%%%%%%%
if(size(Lp) ~= size(Ls))
    disp('mesopicLuminance: Lp and Ls must have the same size!');
    return;
end

%%variables%%
%adaption coefficient a:
a = [1.00 
    0.87
    0.71
    0.54
    0.38
    0.26
    0.13
    0.05
    0.00];

%System equivalent luminance (log cd/m2):
Lseq_log = [-3.18 
    -2.68 
    -2.17 
    -1.17 
    -1.30 
    -0.83
    -0.31
    -0.28
    -0.84];

%%initialization%%
c = zeros(size(Lp));
Lseq_p = zeros(size(Lp));
Lseq_s = zeros(size(Ls));

%calculate system equivalent photopic lumaninance
x = Lxy.x;
y = Lxy.y;
c = 0.256 - 0.184 .* y - 2.527 .* x .* y + 4.656 .* x .* x .* x .* y...
    + 4.657 .* x .* y .* y .* y .* y;
c_strich = 2 .* (c + 0.047);
Lseq_p = Lp .* (10^c_strich);

%calculate system equivalent scotopic lumaninance
Lseq_s = 1.84 .* Ls;


%calculate system equivalent lumaninance









