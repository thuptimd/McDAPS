function movePlotUp(hObject, ~, handles)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Get index of selected axes
ax = gca;
selaxes = find(handles.DB.haxes==ax); %index of selected axes
indupper = handles.DB.axesnum==(selaxes-1);
indlower = handles.DB.axesnum==selaxes;

%Update axes number
handles.DB.axesnum(indlower) = handles.DB.axesnum(indlower) - 1; %move up
handles.DB.axesnum(indupper) = handles.DB.axesnum(indupper) + 1; %move down

%Update y-limit of the moved axes
selylimit = handles.DB.ylimit(selaxes,:);
handles.DB.ylimit(selaxes,:) = handles.DB.ylimit(selaxes-1,:);
handles.DB.ylimit(selaxes-1,:) = selylimit;

%Plot signals
subplotSignals(hObject,handles);
handles = guidata(hObject);

axes(handles.hmask);

%Update UIcontrols
set(handles.listPlotorder,'Value',selaxes-1);

if (selaxes-1)==1
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end
if max(handles.DB.axesnum)>1 && (selaxes-1)<max(handles.DB.axesnum)
    set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
else
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end


%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure