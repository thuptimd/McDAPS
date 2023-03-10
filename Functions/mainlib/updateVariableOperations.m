function updateVariableOperations(hObject,handles,varind)
%% This function updates all the operation checkboxes below the list Workspace for the variable selected in the workspace

% varind
if ~isempty(varind)
    set(handles.listWrkspc,'String',handles.DB.varname,'Value',varind,'Enable','on'); %Set listWrkspc text to be list of variable names
    
    [pathstr,name,ext] = fileparts(handles.DB.filename{varind}); %Get the info of the update variable using the varind
    set(handles.txtFilename,'Enable','on');
    set(handles.editFilename,'String',[name,ext],'Enable','inactive'); %Show the current selected variable in the editbox
    
    [nrow,ncol] = size(handles.DB.signal{varind}); %Length of the variable basically = nrow
    set(handles.txtVarsize,'Enable','on');
    set(handles.editVarsize,'String',[num2str(nrow),' x ',num2str(ncol)],'Enable','inactive');
    
    %If the variable is updateable, update checkboxes
    if isvector(handles.DB.signal{varind}) && isnumeric(handles.DB.signal{varind}) && ~isscalar(handles.DB.signal{varind})
        
        if handles.DB.flagnorm(varind)>0 %normalized
            set(handles.chkNorm,'Value',1,'Enable','on');
        else
            set(handles.chkNorm,'Value',0,'Enable','on');
        end

        if handles.DB.flagdetrend(varind)>0
            set(handles.chkDetrend,'Value',1,'Enable','on');
            set(handles.editDetrend,'String',num2str(handles.DB.detrend(varind)),'Enable','on');
        else
            set(handles.chkDetrend,'Value',0,'Enable','on');
            set(handles.editDetrend,'String','','Enable','off');
        end

        if handles.DB.scale(varind)~=1
            set(handles.chkScale,'Value',1,'Enable','on');
            set(handles.editScale,'String',num2str(handles.DB.scale(varind)),'Enable','on');
        else
            set(handles.chkScale,'Value',0,'Enable','on');
            set(handles.editScale,'String','','Enable','off');
        end



        set(handles.chkFs,'Value',0,'Enable','on'); 
        set(handles.editFs,'String',num2str(handles.DB.fs(varind)),'Enable','off');
    
    else %selected variable is not numeric
        set(handles.chkNorm,'Value',0,'Enable','off');
        set(handles.chkDetrend,'Value',0,'Enable','off');
        set(handles.editDetrend,'String','','Enable','off');
        set(handles.chkScale,'Value',0,'Enable','off');
        set(handles.editScale,'String','','Enable','off');

     
        set(handles.chkFs,'Value',0,'Enable','off');
        set(handles.editFs,'String','','Enable','off');
    end
    
else
    set(handles.listWrkspc,'String','','Value',1,'Enable','off');
    set(handles.txtFilename,'Enable','off');
    set(handles.editFilename,'String','','Enable','off');
    set(handles.txtVarsize,'Enable','off');
    set(handles.editVarsize,'String','','Enable','off');
    set(handles.chkNorm,'Value',0,'Enable','off');
    set(handles.chkDetrend,'Value',0,'Enable','off');
    set(handles.editDetrend,'String','','Enable','off');
    set(handles.chkScale,'Value',0,'Enable','off');
    set(handles.editScale,'String','','Enable','off');


    set(handles.chkFs,'Value',0,'Enable','off');
    set(handles.editFs,'String','','Enable','off');
end

guidata(hObject, handles); %update handles structure