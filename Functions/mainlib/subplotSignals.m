function subplotSignals(hObject,handles)
fntsize = 16;
nvars = length(handles.DB.varindex); %How many variables to be plotted
naxes = max(handles.DB.axesnum);     %How many axes for the variables
ngap = naxes + 2;                    %How many gaps including the top and the bottom spaces
sploth = floor((handles.DB.panelh - (ngap*handles.DB.gaph))/naxes); %height of each subplot [pixel]
strPlotvar = cell(naxes,1);
colorPlotvar = cell(naxes,1);
flagplot = zeros(naxes,1);


%delete haxes objects
if isfield(handles.DB,'haxes') && ~isempty(handles.DB.haxes)
    delete(handles.DB.haxes(:));
end


handles.DB.hline = zeros(nvars,1);
handles.DB.haxes = zeros(naxes,1);

if ~isfield(handles.DB,'ylimit') || size(handles.DB.ylimit,1) ~= naxes  %If ylimit doesn't exist, assign one
    %Y-limit: col1=ymin, col2=ymax
    handles.DB.ylimit = zeros(naxes,2); %default [0,0] = auto-adjust y-limit    
end


%% Description
for n=1:nvars
    sploty = handles.DB.panelh - handles.DB.axesnum(n)*(handles.DB.gaph + sploth); %y-coordinate of subplot [pixel] 
    if flagplot(handles.DB.axesnum(n))==0 %axes were not called yet
        newaxes =  axes('Unit','normalized','XTickLabelMode','manual','XTickLabel',[],'FontSize',fntsize,'Box','on',...
        'Position',[handles.DB.splotx/handles.DB.panelw, sploty/handles.DB.panelh, handles.DB.splotw/handles.DB.panelw, sploth/handles.DB.panelh],'Parent',handles.axespanel);
        set(newaxes,'Tag','subaxeshobject');
        handles.DB.haxes(handles.DB.axesnum(n)) = newaxes;
        flagplot(handles.DB.axesnum(n)) = 1;
    else %make selected axes as the current axes
        newaxes = handles.DB.haxes(handles.DB.axesnum(n));
        hold(newaxes,'on');
    end
    
    %Perform any selected operations on the current signal
    varind = handles.DB.varindex(n);
    y = signalOperations(handles,varind); 
    x = (0:length(y)-1)/handles.DB.fs(varind); %time-axis [sec]
    
    %---------------------------------Plot signal--------------------
    handles.DB.hline(n) = plot(newaxes,x,y,'Color',handles.DB.color{n},'LineStyle',handles.DB.style{n});
    
    %Collect variable name and color info
    strPlotvar{handles.DB.axesnum(n)} = [strPlotvar{handles.DB.axesnum(n)}; {handles.DB.varname(varind)}];
    colorPlotvar{handles.DB.axesnum(n)} = [colorPlotvar{handles.DB.axesnum(n)}; handles.DB.color{n}];

    
end

%% Description goes here
%linkaxes(handles.DB.haxes,'x');
xlabel(handles.DB.haxes(naxes),'Time (sec)','FontSize',fntsize);
if get(handles.popWindow,'Value')==1 %full view is selected
    xmax = max((cellfun(@length,handles.DB.signal(handles.DB.varindex)) - 1)./handles.DB.fs(handles.DB.varindex)); %x-limit = [0, max. time of all plotted signals]
    if xmax ~= handles.DB.xlimit(2)
        handles.DB.xlimit = [0, xmax];
    end
end
set(handles.DB.haxes,'XTickLabelMode','auto','Xlim',handles.DB.xlimit); %Set all axes to the same range

%Add title (with color) to each subplot & set y-limit
for n=1:naxes   
    %Add title
    varname = strPlotvar{n}{1,:};
    colorcode = colorPlotvar{n}(1,:);
    strTitle = ['{\color[rgb]{',num2str(colorcode),'}',varname{1},'}'];
    for m=2:size(strPlotvar{n},1)
        varname = strPlotvar{n}{m,:};
        colorcode = colorPlotvar{n}(m,:);
        strTitle = [strTitle,', ','{\color[rgb]{',num2str(colorcode),'}',varname{1},'}'];
    end
    
    ylabel(handles.DB.haxes(n),strTitle,'FontSize',14,'FontWeight','bold'); %Add title
    set(handles.DB.haxes(n),'FontSize',fntsize); %Set all axes to the same range

end

%% Set xlimit of the hmask
set(handles.hmask,'Xlim',handles.DB.xlimit);
xrange = range(handles.DB.xlimit);
xval = min(handles.DB.xlimit) + xrange/2;
set(handles.DB.vertguide.hl,'XData',xval*ones(2,1));


guidata(hObject, handles); %update handles structure