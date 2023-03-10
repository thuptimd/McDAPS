function setYlimitAuto2(hObject, eventdata, handles)
%Note 3rd Jan 2019
%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Get index of selected axes
ax = gca;
selaxes = find(handles.DB.haxes==ax); %get the index of the selected axis

handles.DB.ylimit(selaxes,:) = [0,0]; %[0,0] designates auto-adjust mode of ylimit

%Auto-adjust y-limit of the current axes
z = find(handles.DB.axesnum==selaxes);
s = handles.DB.signal(handles.DB.varindex(z)); %signals in current axes
fs = handles.DB.fs(handles.DB.varindex(z)); %sampling frequencies of signals in current axes

ymin = [];
ymax = [];
for k=1:size(s,1)
    indxmin = floor(handles.DB.xlimit(1)*fs(k)); %min x-limit [no. of samples]
    indxmax = ceil(handles.DB.xlimit(2)*fs(k));  %max x-limit [no. of samples]
    if indxmin<1
        indxmin = 1;
    end
    if indxmax>length(s{k})
        indxmax = length(s{k});
    end

    %Apply any signal operations to the current signal
    y = signalOperations(handles,handles.DB.varindex(z(k)));

    ymin = min([ymin, min(y(indxmin:indxmax))]);
    ymax = max([ymax, max(y(indxmin:indxmax))]);
end
yrange = ymax - ymin;
ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];
if diff(ylimit)==0 %y is a constant
    ylimit(1) = ylimit(1) - 1;
    ylimit(2) = ylimit(2) + 1;
end

set(handles.DB.haxes(selaxes),'Ylim',ylimit);

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure