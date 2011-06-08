SAVE = 1;
FONTSIZE = 15;

%%putenweg Gas
figure();
data = readJetiExcelFile('Putenweg.xls');
m = CS2000Measurement();
m.colorimetricData.spectralData = data;
m.colorimetricData.T = 2983;
m.spectralData = data;
m_Gas = m;
plotSP(m.colorimetricData, 'Gas');
if(SAVE)
    saveas(gcf(), 'gas_putenweg_SP', 'fig');
    saveas(gcf(), 'gas_putenweg_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('Gas','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'gas_putenweg_Spectrum', 'fig');
    saveas(gcf(), 'gas_putenweg_Spectrum', 'epsc');
end

%%JustusVonLiebig Leuchtstoff
figure();
data = readJetiExcelFile('Justus-von-Liebig-Str.xls');
m = CS2000Measurement();
m.colorimetricData.spectralData = data;
m.spectralData = data;
m.colorimetricData.T = 3454;
m_LM2 = m;
plotSP(m.colorimetricData, 'LM');
if(SAVE)
    saveas(gcf(), 'LM_JustusVonLiebig_SP', 'fig');
    saveas(gcf(), 'LM_JustusVonLiebig_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('LM','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'LM_JustusVonLiebig_Spectrum', 'fig');
    saveas(gcf(), 'LM_JustusVonLiebig_Spectrum', 'epsc');
end

%%Riesestr Leuchtstoff
figure();
data = readJetiExcelFile('Riesestr.xls');
m = CS2000Measurement();
m.colorimetricData.spectralData = data;
m.spectralData = data;
m.colorimetricData.T = 3433;
m_LM1 = m;
plotSP(m.colorimetricData, 'LM');
if(SAVE)
    saveas(gcf(), 'LM_Riesestr_SP', 'fig');
    saveas(gcf(), 'LM_Riesestr_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('LM','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'LM_Riesestr_Spectrum', 'fig');
    saveas(gcf(), 'LM_Riesestr_Spectrum', 'epsc');
end

%%Rue Montesquieu HQL
figure();
data = readJetiExcelFile('Rue Montesquieu Spektrum.xls');
m = CS2000Measurement();
m.colorimetricData.spectralData = data;
m.spectralData = data;
m.colorimetricData.T = 3669;
m_HM = m;
plotSP(m.colorimetricData, 'HM');
if(SAVE)
    saveas(gcf(), 'HM_RueMontesquieu_SP', 'fig');
    saveas(gcf(), 'HM_RueMontesquieu_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('HM','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'HM_RueMontesquieu_Spectrum', 'fig');
    saveas(gcf(), 'HM_RueMontesquieu_Spectrum', 'epsc');
end

%%Kaarst LED
figure();
load kaarst_11_direkt.mat;
m_LED = m;
plotSP(m.colorimetricData, 'LED');
if(SAVE)
    saveas(gcf(), 'LED_Kaarst_SP', 'fig');
    saveas(gcf(), 'LED_Kaarst_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('LED','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'LED_Kaarst_Spectrum', 'fig');
    saveas(gcf(), 'LED_Kaarst_Spectrum', 'epsc');
end

%%Neuss HS
figure();
load neuss_HPS_direkt.mat;
m_HS = m;
plotSP(m.colorimetricData, 'HS');
if(SAVE)
    saveas(gcf(), 'HS_Neuss_SP', 'fig');
    saveas(gcf(), 'HS_Neuss_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('HS','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'HS_Neuss_Spectrum', 'fig');
    saveas(gcf(), 'HS_Neuss_Spectrum', 'epsc');
end

%%Labor HalogenGlühlampe
figure();
load halogenNormal_center_monitorOFF_apertureYES4_02.mat;
m = measurements{end};
m_I = m;
plotSP(m.colorimetricData, 'I');
if(SAVE)
    saveas(gcf(), 'I_Labor_SP', 'fig');
    saveas(gcf(), 'I_Labor_SP', 'epsc');
end
figure();
plot(m,'PLOTINFO');
legend('I','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'I_Labor_Spectrum', 'fig');
    saveas(gcf(), 'I_Labor_Spectrum', 'epsc');
end

%%plot all spectra
figure();
plot(m_I,'r');
hold on;
plot(m_LED,'b');
plot(m_Gas,'k');
plot(m_HM,'gr');
plot(m_LM1,'c');
plot(m_LM2,'m');
plot(m_HS,'m');
hold off;
legend('I', 'LED', 'Gas', 'HM', 'LM1', 'LM2', 'HS','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'all_Spectra', 'fig');
    saveas(gcf(), 'all_Spectra', 'epsc');
end

%%plot all spectra relative
figure();
maxiI = max(m_I.spectralData);
maxiGas = max(m_Gas.spectralData);
maxiLED = max(m_LED.spectralData);
maxiHM = max(m_HM.spectralData);
maxiLM1 = max(m_LM1.spectralData);
maxiLM2 = max(m_LM2.spectralData);
m_I_normalized = CS2000Measurement();
m_I_normalized.spectralData = m_I.spectralData / maxiI;
m_Gas_normalized = CS2000Measurement();
m_Gas_normalized.spectralData = m_Gas.spectralData / maxiGas;
m_LED_normalized = CS2000Measurement();
m_LED_normalized.spectralData = m_LED.spectralData / maxiLED;
m_HM_normalized = CS2000Measurement();
m_HM_normalized.spectralData = m_HM.spectralData / maxiHM;
m_LM1_normalized = CS2000Measurement();
m_LM1_normalized.spectralData = m_LM1.spectralData / maxiLM1;
m_LM2_normalized = CS2000Measurement();
m_LM2_normalized.spectralData = m_LM2.spectralData / maxiLM2;


plot(m_I_normalized,'r');
hold on;
plot(m_LED_normalized,'b');
plot(m_Gas_normalized,'k');
plot(m_HM_normalized,'gr');
plot(m_LM1_normalized,'c');
plot(m_LM2_normalized,'m');
hold off;
legend('I', 'LED', 'Gas', 'HM', 'LM1', 'LM2','Location','SouthEast');
t = title('Relative Spectral Radiance');
set(t ,'FontSize',FONTSIZE);
y = ylabel('$$\mbox{L}_{e,rel}(\lambda)$$');
set(y,'Interpreter','LaTeX','FontSize', FONTSIZE);
if(SAVE)
    saveas(gcf(), 'all_Spectra_relative', 'fig');
    saveas(gcf(), 'all_Spectra_relative', 'epsc');
end

%%plot all spectra ordered manually
figure();
maxiI = max(m_I.spectralData);
maxiGas = max(m_Gas.spectralData);
maxiLED = max(m_LED.spectralData);
maxiHM = max(m_HM.spectralData);
maxiLM1 = max(m_LM1.spectralData);
maxiLM2 = max(m_LM2.spectralData);
maxiHS = max(m_HS.spectralData);
maxiI = maxiI / 1;
maxiGas = maxiGas / 1.1;
maxiLED = maxiLED / 0.0000000003;
maxiHM = maxiHM / 0.00003;
maxiLM1 = maxiLM1 / 0.03;
maxiLM2 = maxiLM2 / 0.003;
maxiHS = maxiHS / 0.0000001;
m_I_normalized = CS2000Measurement();
m_I_normalized.spectralData = m_I.spectralData / maxiI;
m_Gas_normalized = CS2000Measurement();
m_Gas_normalized.spectralData = m_Gas.spectralData / maxiGas;
m_LED_normalized = CS2000Measurement();
m_LED_normalized.spectralData = m_LED.spectralData / maxiLED;
m_HM_normalized = CS2000Measurement();
m_HM_normalized.spectralData = m_HM.spectralData / maxiHM;
m_LM1_normalized = CS2000Measurement();
m_LM1_normalized.spectralData = m_LM1.spectralData / maxiLM1;
m_LM2_normalized = CS2000Measurement();
m_LM2_normalized.spectralData = m_LM2.spectralData / maxiLM2;
m_HS_normalized = CS2000Measurement();
m_HS_normalized.spectralData = m_HS.spectralData / maxiHS;

plot(m_Gas_normalized,'k');
hold on;
plot(m_I_normalized,'r');
plot(m_LM1_normalized,'c');
plot(m_LM2_normalized,'m');
plot(m_HM_normalized,'gr');
plot(m_HS_normalized,'y');
plot(m_LED_normalized,'b');
hold off;
legend('Gas', 'I','LM1', 'LM2', 'HM', 'HS',  'LED', 'Location','SouthEast');
t = title('Relative Spectral Radiance');
set(t ,'FontSize',FONTSIZE);
y = ylabel('$$\mbox{L}_{e,rel} \hspace{5pt}  (\lambda)$$');
set(y,'Interpreter','LaTeX','FontSize',FONTSIZE);
set(gca, 'YTickLabel', []);
axis([380, 780, 10^-15, 10^1]);
if(SAVE)
    saveas(gcf(), 'all_Spectra_relative_ordered', 'fig');
    saveas(gcf(), 'all_Spectra_relative_ordered', 'epsc');
end


%%plot I and Gas
figure();
maxiI = max(m_I.spectralData);
maxiGas = max(m_Gas.spectralData);
m_I_normalized = CS2000Measurement();
m_I_normalized.spectralData = m_I.spectralData / maxiI;
m_Gas_normalized = CS2000Measurement();
m_Gas_normalized.spectralData = m_Gas.spectralData / maxiGas;


plot(m_I_normalized,'r');
hold on;
plot(m_Gas_normalized,'k');
hold off;
legend('I', 'Gas','Location','SouthEast');
t = title('Relative Spectral Radiance');
set(t ,'FontSize',FONTSIZE);
y = ylabel('$$\mbox{L}_{e,rel} \hspace{5pt}  (\lambda)$$');
set(y,'Interpreter','LaTeX','FontSize',FONTSIZE);
set(gca, 'YScale', 'linear');
if(SAVE)
    saveas(gcf(), 'Gas_I_Spectra', 'fig');
    saveas(gcf(), 'Gas_I_Spectra', 'epsc');
end

%%plot both LM
figure();
plot(m_LM1,'c');
hold on;
plot(m_LM2,'m');
hold off;
legend('LM1', 'LM2','Location','SouthEast');
if(SAVE)
    saveas(gcf(), 'LM1_LM2_Spectra', 'fig');
    saveas(gcf(), 'LM1_LM2_Spectra', 'epsc');
end
