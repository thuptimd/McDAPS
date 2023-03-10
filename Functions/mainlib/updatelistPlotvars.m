function updatelistPlotvars(hObject,handles,plotvarind)

if isfield(handles.DB,'hline') && ~isempty(handles.DB.hline)

    nvar = length(handles.DB.hline);
    strVarname = {['<html><font color="rgb(',num2str(255.*handles.DB.color{1}),')"><b>&#9608;</b></font>  ',handles.DB.varname{handles.DB.varindex(1)},'<html>']};
    for n=2:nvar
        strVarname = [strVarname; ['<html><font color="rgb(',num2str(255.*handles.DB.color{n}),')"><b>&#9608;</b></font>  ',handles.DB.varname{handles.DB.varindex(n)},'<html>']];
    end

    set(handles.listPlotvars,'String',strVarname,'Enable','on');
    if nargin==2
        set(handles.listPlotvars,'Value',plotvarind);
    else
        set(handles.listPlotvars,'Value',nvar);
    end

else
    
    set(handles.listPlotvars,'String','','Value',1','Enable','off');

end

guidata(hObject, handles); %update handles structure