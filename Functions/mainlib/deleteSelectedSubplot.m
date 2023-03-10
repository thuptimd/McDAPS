function deleteSelectedSubplot(hObject, ~, handles)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Get index of selected axes
ax = gca;
selaxes = find(handles.DB.haxes==ax); %index of selected axes

plotvarind = handles.DB.axesnum==selaxes;

%Delete variables in the selected axes
handles.DB.varindex(plotvarind) = [];
handles.DB.axesnum(plotvarind)  = [];
handles.DB.color(plotvarind)    = [];
handles.DB.style(plotvarind)    = [];

%Delete y-limit of the selected axes
handles.DB.ylimit(selaxes,:) = [];

if ~isempty(handles.DB.varindex)
    
    %Update axes number
    z = handles.DB.axesnum>selaxes;
    if ~isempty(z)
        handles.DB.axesnum(z) = handles.DB.axesnum(z) - 1;
    end

    %Plot signals
    subplotSignals(hObject,handles);
    handles = guidata(hObject);
    
    axes(handles.hmask);

    %Update UI controls in Plot Editor
    plotvarind = 1;
    nplot = max(handles.DB.axesnum);
    str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order
    set(handles.listPlotorder,'String',str,'Value',handles.DB.axesnum(plotvarind),'Enable','on');

    if isfield(handles.DB,'axesnum') && max(handles.DB.axesnum)>1
        plotind = handles.DB.axesnum(plotvarind);
        if plotind>1 && plotind<max(handles.DB.axesnum)
            set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
            set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
        elseif plotind==1
            set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
            set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
        elseif plotind==max(handles.DB.axesnum)
            set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
            set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
        end
    else
        set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
        set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    end

    set(handles.butDeleteplot,'Enable','on');
    updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
    handles = guidata(hObject);
    set(handles.butDeleteplotvar,'Enable','on');
    set(handles.butColor,'Enable','on');
    set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
    val = getvalpopLinestyle(handles.DB.style{plotvarind});
    set(handles.popLinestyle,'Value',val,'Enable','on');
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);

else %all axes are deleted

    guidata(hObject,handles);
    %Clear markers
    handles = guidata(hObject);
    
    if isfield(handles,'DB') && isfield(handles.DB,'haxes') && ~isempty(handles.DB.haxes)
        delete(handles.DB.haxes);
        handles.DB.haxes = [];
    end
    
    %Make it invisible instead of delete - modified on 3 Jan 2019
    hguidestatus = get(handles.DB.vertguide.hl,'Visible');
    if strcmpi(hguidestatus,'on') 
        set(handles.DB.vertguide.hl,'Visible','off');
        axes(handles.hmask); 
    end

    %Plot Editor
    set(handles.listPlotorder,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplot,'Enable','off');
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
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