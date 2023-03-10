function str = genlistPlotorder(axesnum)

%Generate list of plots for plot order listbox
nplot = max(axesnum);
str = cell(nplot,1);
for n=1:nplot
    str{n} = ['Plot ',num2str(n)];
end