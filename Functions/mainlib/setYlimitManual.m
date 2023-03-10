function setYlimitManual(hObject, eventdata, handles)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

selaxes = get(handles.listPlotorder,'Value'); %selected axes

%Get old y-limit of the selected axes
oldylimit = get(handles.DB.haxes(selaxes),'Ylim');

%Update shared data
hfigmain = getappdata(0, 'hfigmain');
setappdata(hfigmain,'newylimit',oldylimit); 

%Call GUI function in new window to update the y-limit
sub_SetYlimit;
uiwait(gcf);
hfigmain = getappdata(0,'hfigmain');
newylimit = getappdata(hfigmain,'newylimit');

%Adjust y-limit for all subplots
set(handles.DB.haxes(selaxes),'Ylim',newylimit);
handles.DB.ylimit(selaxes,1) = newylimit(1); %ymin
handles.DB.ylimit(selaxes,2) = newylimit(2); %ymax



%Clear y-limit
setappdata(hfigmain,'newylimit',[]); 

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure