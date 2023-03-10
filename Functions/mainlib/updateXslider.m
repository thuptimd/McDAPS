function updateXslider(hObject,handles)

%Update xslider and x-limit
validsignal = handles.DB.fs>0;
maxtime = max((cellfun(@length,handles.DB.signal(validsignal)) - 1)./handles.DB.fs(validsignal));
xmax = max(get(handles.DB.haxes(1),'Xlim'));
xmin = xmax - handles.DB.window;
set(handles.xslider,'Enable','off','Max',maxtime,'SliderStep',[handles.DB.sliderstep/maxtime, 0.1]);
if get(handles.popWindow,'Value')>1 %'Full' view was NOT selected
    if xmin<0
        xmin = 0;
        xmax = handles.DB.window;
    end
    if xmax>maxtime
        xmax = maxtime;
        xmin = maxtime - handles.DB.window;
    end
    handles.DB.xlimit = [xmin, xmax];
    set(handles.xslider,'Value',xmax);
    if xmin==0
        set(handles.xslider,'Value',0);
    end
    set(handles.xslider,'Enable','on');
else
    handles.DB.xlimit = [0, maxtime];
    set(handles.xslider,'Value',0);
    set(handles.xslider,'Enable','off');
end

guidata(hObject, handles); %update handles structure