function deleteWorkspaceVariable(hObject, ~, handles)

if ~isfield(handles.DB,'varname') || isempty(handles.DB.varname)
   return 
end


varind = get(handles.listWrkspc,'Value');

%Delete variable
handles.DB.varnameorig(varind) = [];
handles.DB.varname(varind)     = [];
handles.DB.filename(varind)    = [];
handles.DB.acrostic(varind)    = [];
handles.DB.subjnum(varind)     = [];
handles.DB.exptdate(varind)    = [];
handles.DB.expttime(varind)    = [];
handles.DB.flagnorm(varind)    = [];
handles.DB.flagdetrend(varind) = [];
handles.DB.detrend(varind)     = [];
handles.DB.scale(varind)       = [];
handles.DB.signal(varind)      = [];
handles.DB.meanstd(varind)     = [];
handles.DB.fs(varind)          = [];
handles.DB.flagtivpsd(varind)  = [];

%Remove plot of the deleted variable
if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex)
    zdel = handles.DB.varindex==varind;
    if any(zdel)
        handles.DB.varindex(zdel) = [];
        handles.DB.axesnum(zdel)  = [];
        handles.DB.color(zdel)    = [];
        handles.DB.style(zdel)    = [];
    end
    
    %Update varindex
    z = handles.DB.varindex>varind;
    if any(z)
        handles.DB.varindex(z) = handles.DB.varindex(z) - 1;
    end
end

if ~isempty(handles.DB.varname)

    %Update UI controls in variable operations in Workspace
    if varind>length(handles.DB.varname)
        ind = varind - 1;
    else
        ind = varind;
    end
    updateVariableOperations(hObject,handles,ind);
    handles = guidata(hObject);
    
    %Remove any empty subplots
    if isfield(handles.DB,'axesnum') && ~isempty(handles.DB.axesnum)
        countaxes = zeros(max(handles.DB.axesnum),1);
        for n=1:length(handles.DB.axesnum)
            countaxes(handles.DB.axesnum(n)) = countaxes(handles.DB.axesnum(n)) + 1;
        end
        tally = 0;
        for n=1:length(countaxes)
            if countaxes(n)
                z = handles.DB.axesnum==n;
                handles.DB.axesnum(z) = handles.DB.axesnum(z) - tally;
            else
                tally = tally + 1;
                handles.DB.ylimit(n,:) = []; %remove y-limit of empty plot
            end
        end

        %Plot signals
        if any(zdel)
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
        
        axes(handles.hmask);
        
    else %no plotted variables

    %Clear axespanel
    guidata(hObject,handles);
        
    %Clear markers
    handles = guidata(hObject);
        
    delete(handles.DB.haxes);
    handles.DB.haxes = [];
    
    %Make the vertical guide invisible instead of delete - modified on 3 Jan 2019
    hguidestatus = get(handles.DB.vertguide.hl,'Visible');
    if strcmpi(hguidestatus,'on') 
        set(handles.DB.vertguide.hl,'Visible','off');
        axes(handles.hmask); 
    end
        
    handles.DB = rmfield(handles.DB,'ylimit');


    
    %Plot Editor
    set(handles.listPlotorder,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplot,'Enable','off');
    set(handles.butUpplot,'Enable','off');
    set(handles.butDownplot,'Enable','off');
    set(handles.listPlotvars,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplotvar,'Enable','off');
    set(handles.butColor,'Enable','off');
    set(handles.txtColor,'BackgroundColor',[0,0,0]);
    set(handles.popLinestyle,'Value',1,'Enable','off');
    
    %Viewing window and slider
    set(handles.popWindow,'Value',1,'Enable','off');
    set(handles.xslider,'Min',0,'Max',1,'Value',0,'Enable','off');
    
    %Reset color flag
    handles.DB.flagcolor = 0;
    
    %Tools
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolSelectRegion,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');
    
    end
    
else %no variable in Workspace
    
    %Clear axespanel
    if isfield(handles.DB,'haxes')
        delete(handles.DB.haxes);
        handles.DB.haxes = [];
    end

    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,[]);
    handles = guidata(hObject);
    
    %Plot Editor
    set(handles.listPlotorder,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplot,'Enable','off');
    set(handles.butUpplot,'Enable','off');
    set(handles.butDownplot,'Enable','off');
    set(handles.listPlotvars,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplotvar,'Enable','off');
    set(handles.butColor,'Enable','off');
    set(handles.txtColor,'BackgroundColor',[0,0,0]);
    set(handles.popLinestyle,'Value',1,'Enable','off');
    
    %Viewing window and slider
    set(handles.popWindow,'Value',1,'Enable','off');
    set(handles.xslider,'Min',0,'Max',1,'Value',0,'Enable','off');
    
    %Reset color flag
    handles.DB.flagcolor = 0;
    
    %Tools
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolSelectRegion,'Enable','off');
    set(handles.toolVerticalGuide_push,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');

end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure