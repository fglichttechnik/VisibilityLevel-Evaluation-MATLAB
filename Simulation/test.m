plot(randn(20,1))
xtl = {{'one';'two';'three'} '\alpha' {'\beta';'\gamma'}};
h = my_xticklabels(gca,[1 10 18],xtl);
% vertical
h = my_xticklabels([1 10 18],xtl, ...
    'Rotation',-90, ...
    'VerticalAlignment','middle', ...
    'HorizontalAlignment','left');



