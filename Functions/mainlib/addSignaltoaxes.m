function addSignaltoaxes(hObject, eventdata, handles, selaxes)

if ~isfield(handles.DB,'varname') || isempty(handles.DB.varname)
   return 
end

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

varind = get(handles.listWrkspc,'Value');
y = handles.DB.signal{varind};

if isvector(y) && isnumeric(y)
        
    %Plot selected variable
    handles.DB.flagcolor = mod(handles.DB.flagcolor,7) + 1; %update color flag

    if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex) %>=1 signals are being plotted
        handles.DB.varindex = [handles.DB.varindex; varind];
        handles.DB.axesnum  = [handles.DB.axesnum; selaxes];
        handles.DB.color    = [handles.DB.color; handles.DB.colorcode(handles.DB.flagcolor)];
        handles.DB.style    = [handles.DB.style; '-'];

        %Plot signals
        subplotSignals(hObject,handles);
        handles = guidata(hObject);
        
        axes(handles.hmask);

        %Update xslider and x-limit
        updateXslider(hObject,handles);
        handles = guidata(hObject);
    else %empty plot
        handles.DB.varindex = varind;
        handles.DB.axesnum  = 1;
        handles.DB.color    = handles.DB.colorcode(handles.DB.flagcolor);
        handles.DB.style    = {'-'};

        %Set popWindow selection to 'Full'
        set(handles.popWindow,'Value',7);
        validsignal = handles.DB.fs>0;
        maxtime = max((cellfun(@length,handles.DB.signal(validsignal)) - 1)./handles.DB.fs(validsignal));
        handles.DB.window = maxtime;

        %Compute x-limit for the first time of loading a variable    
        handles.DB.xlimit = [0, maxtime]; %default x-limit = [0, max. time]
        handles.DB.sliderstep = 0;
        set(handles.xslider,'Enable','off','Min',0,'Max',maxtime,'SliderStep',[handles.DB.sliderstep/maxtime, 0.1]);
        set(handles.xslider,'Value',0);
        
        %Plot signals
        subplotSignals(hObject,handles);
        handles = guidata(hObject);
    end

    %Update UI controls in Plot Editor
    plotvarind = length(handles.DB.varindex);
    nplot = max(handles.DB.axesnum);
    str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order
    set(handles.listPlotorder,'String',str,'Value',nplot,'Enable','on');
    if nplot>1
        set(handles.butUpplot,'Enable','on');
    else
        set(handles.butUpplot,'Enable','off');
    end
    set(handles.butDeleteplot,'Enable','on');
    updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
      handles = guidata(hObject);
    set(handles.butDeleteplotvar,'Enable','on');
    set(handles.butColor,'Enable','on');
    set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
    set(handles.popLinestyle,'Value',1,'Enable','on');

    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

    %Enable tools in the toolbar
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolSelectRegion,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');
    set(handles.popWindow,'Enable','on');
    set(handles.toolVerticalGuide_push,'Enable','on');

    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);

else
    h = warndlg('Selected variable is not numeric and cannot be plotted.','Warning','modal');
end

guidata(hObject, handles); %update handles structure