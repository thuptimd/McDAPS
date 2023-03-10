function setYlimitRect(hObject, eventdata, handles)
try
    %Turn off any line selection highlight
    turnoffLinehighlight(hObject,handles);
    handles = guidata(hObject);
    
    %Highlight selected axes
    ax = gca;
    c = get(ax,'Color');
    set(ax,'Color',[1 0.93 0.93]);
    
    %Define area to be shaded
    rect = getrect(ax); %rect = [xmin ymin width height] (unit = unit of x-axis)
    
    %Restore axes color
    set(ax,'Color',c);
    
    %Adjust y-limit
    ymin = rect(2);
    ymax = ymin + rect(4);
    ind = find(handles.DB.haxes==ax); %index of selected axes
    set(handles.DB.haxes(ind),'Ylim',[ymin ymax]);
    handles.DB.ylimit(ind,1) = ymin;
    handles.DB.ylimit(ind,2) = ymax;
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
catch
    disp('setYlimitRect warning');
end
guidata(hObject, handles); %update handles structure