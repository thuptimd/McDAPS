function capturePlotTemplate(hObject, eventdata, handles)

if ~isfield(handles.DB,'haxes') || ~isfield(handles.DB,'varindex') || isempty(handles.DB.haxes) || isempty(handles.DB.varindex)
    h = warndlg('There must be at least one plot to capture','Warning!','modal');
    return
end

naxes = size(handles.DB.haxes,1);
template = cell(naxes,3);

for n=1:naxes
    ind = find(handles.DB.axesnum==n,1,'first');
    
    %Get variable name
    varname = handles.DB.varnameorig{handles.DB.varindex(ind)};
    
    %Get ylimit
    ylimit = get(handles.DB.haxes(n),'Ylim');
    
    %Store info into template
    template{n,1} = varname;
    template{n,2} = ylimit(1);
    template{n,3} = ylimit(2);
end

deftppath = fullfile(handles.codepath,'PlotTemplate',['tmplt_',handles.DB.inputfile]); %default template folder
[tpfile,tppath] = uiputfile('*.mat','Save plot template',deftppath);
if ~ischar(tpfile)
    return %return if choosing invalid file
end

save(fullfile(tppath,tpfile), 'template'); %save template

%Set context menus
setContextMenus(gcf,handles);
handles = guidata(gcf);

guidata(gcf, handles); %update handles structure