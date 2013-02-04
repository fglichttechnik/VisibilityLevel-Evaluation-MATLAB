
SAVE = 1;
FONTSIZE = 14;

%function [ Lmes, mFactor ] = mesopicLuminance_recommended( Lp, Ls, Lap, Las )
%M (m)Vmes (?) = m V (?) + (1? m)V '(?) for 0 ? m ?1!



L = [ 0.3, 0.5, 0.7, 1.0, 1.5 ];
numberOfLs = length( L );

%%Kaarst LED
load kaarst_11_direkt.mat;
m_LED = m;
SP_LED = 1.71;
%plotSP(m.colorimetricData, 'LED');


%%Neuss HS
load neuss_HPS_direkt.mat;
m_HS = m;
SP_HS = 0.6;
%plot(m_HS);


%V / V'
load V_CIE;
load V_strich_CIE;
lambda = [380 : 780];
V_i = interp1(lambda_CIE, V, lambda);
V_strich_i = interp1(lambda_CIE, V_strich, lambda);
V_strich_i = V_strich_i / max( V_strich_i );


Ls_ = zeros(1, 401);
V_mes_LED = zeros(numberOfLs, 401);
V_mes_HS = zeros(numberOfLs, 401);
mFactor_LED = zeros( numberOfLs, 1 );
mFactor_HS = zeros( numberOfLs, 1 );


for i = 1 : numberOfLs
    currentL = L( i );
    
    %LED
    [Lmes, currentM_LED] = mesopicLuminance_recommended( currentL, currentL * SP_LED, currentL, currentL * SP_LED );
    currentVmes_LED = currentM_LED * V_i + ( 1 - currentM_LED ) * V_strich_i;
    currentVmes_LED = currentVmes_LED / max( currentVmes_LED );
    V_mes_LED( i, : ) = currentVmes_LED;
    mFactor_LED( i ) = currentM_LED;
    
    %HS
    [Lmes, currentM_HS] = mesopicLuminance_recommended( currentL, currentL * SP_HS, currentL, currentL * SP_HS );
    currentVmes_HS = currentM_HS * V_i + ( 1 - currentM_HS ) * V_strich_i;
    currentVmes_HS = currentVmes_HS / max( currentVmes_HS );
    V_mes_HS( i, : ) = currentVmes_HS;
    mFactor_HS( i ) = currentM_HS;
end
V_mes_HS = V_mes_HS';
V_mes_LED = V_mes_LED';

LED_spectrum = m_LED.colorimetricData.spectralData / max( m_LED.colorimetricData.spectralData );
HS_spectrum = m_HS.colorimetricData.spectralData / max( m_HS.colorimetricData.spectralData );


LED_spectrum = LED_spectrum' .* V_mes_LED( :, 1 );
HS_spectrum = HS_spectrum' .* V_mes_HS( :, 1 );

LED_spectrum = LED_spectrum / max( LED_spectrum );
HS_spectrum = HS_spectrum / max( HS_spectrum );


% Vlambda / Vlambda'
fig = figure();
set( fig, 'Position', [ 134, 53, 725 + 400, 528 ] );
GRAY0 = 0.9;
GRAY1 = 0.4;
GRAY2 = 0.0;
ORANGE = [1 0.5 0.2];
area( lambda, V_i, 'FaceColor',[GRAY0 GRAY0 GRAY0], 'LineWidth', 3 );
hold on;
a1 = area( lambda, V_strich_i, 'FaceColor',[GRAY0 GRAY0 GRAY0], 'EdgeColor','k',...
    'LineWidth', 3, 'LineStyle', '--');%, 'facealpha',.1 );
%hold on;

alpha(  .15 );
area( lambda, V_mes_LED( :, 1 ), 'FaceColor',[GRAY1 GRAY1 GRAY1], 'EdgeColor','k',...
   'LineWidth', 3, 'LineStyle', ':' );
alpha(  1 );
%area( lambda, V_mes_HS( :, 1 ), 'FaceColor',[GRAY1 GRAY1 GRAY1], 'EdgeColor','k',...
   % 'LineWidth', 3, 'LineStyle', '-.' );
plot( lambda, LED_spectrum, '--');%, 'Color',[GRAY2 GRAY2 GRAY2] );
plot( lambda, HS_spectrum, '-', 'Color', ORANGE  );
hold off;

x = xlabel('\lambda in nm');
set(x,'FontSize',14);
%y = ylabel('$$\hspace{5pt} {L}_{e}(\lambda, rel)$$');
%y = ylabel('{L}_{e}(\lambda, rel)');
y = ylabel('Sensitivity_{rel}(\lambda), {L}_{e}(\lambda, rel)');
%set(y,'Interpreter','LaTeX','FontSize',14);
set(y,'FontSize',14);

t = title('Mesopic Efficacy\fontsize{18}');
set(t,'FontSize',14);

l = legend( 'V(\lambda)', 'V(\lambda)^{''}', 'V(\lambda)_{mes, S/P = 1.71, L_{a} = 0.3 cd / m^{2}}', 'LED_{weighted}', 'HS_{weighted}' );
set( l, 'FontSize', 14, 'Location','NorthEastOutside' );
%Sensitivity_{rel},
axis( [380, 780, 0, 1.1] )
%set( gca, 'XTick', [380, 450, 500, 550, 600, 650, 700, 780] );
%set( gca, 'XTickLabel', [380, 450, 500, 550, 600, 650, 700, 780] );
finetunePlot( gcf );

saveas( gcf, 'vLambda_mesopic_LED_HS_3.fig' );
saveas( gcf, 'vLambda_mesopic_LED_HS_3.eps', 'epsc' );
