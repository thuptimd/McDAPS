function turnoffLinehighlight(hObject,handles)

%Turn off line selection highlight
if isfield(handles.DB,'selline') && handles.DB.selline(1)==1
    set(handles.DB.selline(2),'Selected','off','SelectionHighlight','off');
    set(handles.DB.selline(2));
    handles.DB.selline = 0;
end

%Delete any shaded area being plotted
delete(findobj(0,'Type','patch'));

guidata(hObject, handles); %update handles structure