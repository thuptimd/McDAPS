function renameWorkspaceVariable(hObject, eventdata, handles)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Get old variable name
varlist = cellstr(get(handles.listWrkspc,'String'));
varind = get(handles.listWrkspc,'Value');
oldvarname = varlist{varind};

%Update shared data
hfigmain = getappdata(0, 'hfigmain');
setappdata(hfigmain,'SDvarname',handles.DB.varname);
setappdata(hfigmain,'renamevar',handles.DB.varname{varind});

%Call GUI function in new window to update variable name
sub_RenameVariable;
uiwait(gcf);
hfigmain = getappdata(0,'hfigmain');
newvarname = getappdata(hfigmain,'renamevar');

%Update variable name
varind = get(handles.listWrkspc,'Value'); %index of the currently selected variable in Workspace
handles.DB.varname{varind} = newvarname;

%Update Workspace listbox
set(handles.listWrkspc,'String',handles.DB.varname);

%Update plot title
varind = get(handles.listWrkspc,'Value');
if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex)
    plotvarind = find(handles.DB.varindex==varind);
    if ~isempty(plotvarind)
        for k=1:length(plotvarind)
            strTitle = get(get(handles.DB.haxes(handles.DB.axesnum(plotvarind(k))),'Title'),'String');
            indvar = strfind(strTitle,oldvarname);
            strTitle(indvar:indvar+length(oldvarname)-1) = ''; %delete old variable name
            strTitle = [strTitle(1:indvar-1), newvarname, strTitle(indvar:end)]; %update with new variable name
            title(handles.DB.haxes(handles.DB.axesnum(plotvarind(k))),strTitle,'FontSize',10,'FontWeight','bold');
            
            updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
            handles = guidata(hObject);
        end
    end
end

%Clear renamevar
setappdata(hfigmain,'renamevar','');

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure