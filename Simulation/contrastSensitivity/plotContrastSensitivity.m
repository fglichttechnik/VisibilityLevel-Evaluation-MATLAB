
FONTSIZE = 14;

x = 0 : .1 : 16;

a = .8;
c = 8;

y = 1 ./ ( 1 + exp( -a * ( x - c ) ));

plot(x,y,'k')
xlabel('C', 'FontSize', FONTSIZE)
ylabel('p(C)', 'FontSize', FONTSIZE)
title('Detection Probability', 'FontSize', FONTSIZE)

set(gca, 'XTick', [8])
set(gca, 'XTickLabel', 'C_{th}')

finetuneplot(gcf)
