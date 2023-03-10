function addVartoWorkspace(hObject, ~, handles)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);



%Get the selected variable
varlist = cellstr(get(handles.listMatvars,'String'));
selvar = varlist{get(handles.listMatvars,'Value')};

%Collect selected variable info
if isfield(handles.DB,'varname') && all(~cellfun('isempty',handles.DB.varname)) %>=1 variables are in Workspace

    handles.DB.filename = [handles.DB.filename; fullfile(handles.DB.inputpath,handles.DB.inputfile)];
    handles.DB.exptdate = [handles.DB.exptdate; handles.DB.inputexptdate];
    handles.DB.expttime = [handles.DB.expttime; '-'];
    handles.DB.varnameorig = [handles.DB.varnameorig; selvar];
    
    %Check for repeated variable name
    newvarname = checkRepeatedVarname(selvar,handles.DB.varname);
    handles.DB.varname = [handles.DB.varname; newvarname];    
    
    %Load selected variable
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),selvar);
    eval(['y = ',selvar,';']);

    %Get Acrostic and Subject ID
    handles.DB.acrostic = [handles.DB.acrostic; handles.DB.inputfile(1:5)];
    allvars = who('-file',fullfile(handles.DB.inputpath,handles.DB.inputfile));
    temp = strfind(allvars,'SubjectNumber'); %search for 'SubjectNumber'
    if any(~cellfun(@isempty,temp))
        load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'SubjectNumber');
        handles.DB.subjnum = [handles.DB.subjnum; num2str(SubjectNumber)];
    else
        handles.DB.subjnum = [handles.DB.subjnum; '-'];
    end

    if isvector(y) && isnumeric(y) && ~isscalar(y)
        
        %Collect current signal
        handles.DB.signal = [handles.DB.signal; y];
        
        %Compute mean and standard deviation
        handles.DB.meanstd = [handles.DB.meanstd; [mean(y),std(y)]];
        
        %Get sampling frequency
        fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,selvar);
        handles.DB.fs = [handles.DB.fs; fs];
        handles.DB.flagnorm    = [handles.DB.flagnorm; -1];
        handles.DB.flagdetrend = [handles.DB.flagdetrend; -1];
        handles.DB.detrend     = [handles.DB.detrend; 1];
        handles.DB.scale       = [handles.DB.scale; 1];
        handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
        
        
    else %loaded variable is not numeric
        handles.DB.signal      = {y};
        handles.DB.meanstd     = [handles.DB.meanstd; [0,0]];
        handles.DB.fs          = [handles.DB.fs; 0];
        handles.DB.flagnorm    = [handles.DB.flagnorm; 0];
        handles.DB.flagdetrend = [handles.DB.flagdetrend; 0];
        handles.DB.detrend     = [handles.DB.detrend; 0];
        handles.DB.scale       = [handles.DB.scale; 0];
        handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
    end
    
else %first variable to be added to the Workspace
    
    handles.DB.varnameorig = {selvar};
    handles.DB.varname  = {selvar};
    handles.DB.filename = {fullfile(handles.DB.inputpath,handles.DB.inputfile)};
    handles.DB.exptdate = {handles.DB.inputexptdate};
    handles.DB.expttime = {'-'};
    
    %Load selected variable
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),selvar);
    eval(['y = ',selvar,';']);
    handles.DB.signal = {y};
    
    %Get Acrostic and Subject ID
    handles.DB.acrostic = {handles.DB.inputfile(1:5)};
    allvars = who('-file',fullfile(handles.DB.inputpath,handles.DB.inputfile));
    temp = strfind(allvars,'SubjectNumber'); %search for 'SubjectNumber'
    if any(~cellfun(@isempty,temp))
        load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'SubjectNumber');
        handles.DB.subjnum = {num2str(SubjectNumber)};
    else
        handles.DB.subjnum = {'-'};
    end
    
    if isvector(y) && isnumeric(y) && ~isscalar(y)
        handles.DB.meanstd = {[mean(y),std(y)]};
        handles.DB.fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,selvar);
        handles.DB.flagnorm    = -1;
        handles.DB.flagdetrend = -1;
        handles.DB.detrend     =  1;
        handles.DB.scale       =  1;
        handles.DB.flagtivpsd  =  0;
        
        
    else %loaded variable is not numeric
        handles.DB.meanstd = {[0,0]};
        handles.DB.fs = 0;
        handles.DB.flagnorm    = 0;
        handles.DB.flagdetrend = 0;
        handles.DB.detrend     = 0;
        handles.DB.scale       = 0;
        handles.DB.flagtivpsd  = 0;
    end

end

%Add selected variable to Workspace and plot if checkbox is checked
varind = length(handles.DB.varname);
set(handles.listWrkspc,'String',handles.DB.varname,'Value',varind,'Enable','on');
if get(handles.chkPlotmatvars,'Value') %checkbox is checked --> add new subplot
    
    if isvector(y) && isnumeric(y) && ~isscalar(y)
    
        handles.DB.flagcolor = mod(handles.DB.flagcolor,7) + 1; %update color flag

        if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex) %>=1 signals are being plotted
            handles.DB.varindex = [handles.DB.varindex; varind];
            handles.DB.axesnum  = [handles.DB.axesnum; max(handles.DB.axesnum)+1];
            handles.DB.color    = [handles.DB.color; handles.DB.colorcode(handles.DB.flagcolor)];
            handles.DB.style    = [handles.DB.style; '-'];  
        else %empty plot
            handles.DB.varindex = varind;
            handles.DB.axesnum  = 1;
            handles.DB.color    = handles.DB.colorcode(handles.DB.flagcolor);
            handles.DB.style    = {'-'};
            
            %Compute x-limit for the first time of loading a variable    
            validsignal = handles.DB.fs>0;
            maxtime = max((cellfun(@length,handles.DB.signal(validsignal)) - 1)./handles.DB.fs(validsignal));
            handles.DB.window = maxtime;
            handles.DB.xlimit = [0, maxtime]; %default x-limit = [0, max. time]
            handles.DB.sliderstep = 0;            
        end

        %Plot signals
        subplotSignals(hObject,handles);
        handles = guidata(hObject);
        
        axes(handles.hmask);
        
        %Update popWindow and xslider
        if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex) %>=1 signals are being plotted
            updateXslider(hObject,handles);
            handles = guidata(hObject);
        else %empty plot
            set(handles.popWindow,'Value',1);
            set(handles.xslider,'Enable','off','Min',0,'Max',maxtime,'SliderStep',[handles.DB.sliderstep/maxtime, 0.1]);
            set(handles.xslider,'Value',0);
        end

        %Update UI controls in Plot Editor
        plotvarind = length(handles.DB.varindex);
        nplot = max(handles.DB.axesnum);
        
        str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order        
        set(handles.listPlotorder,'String',str,'Value',nplot,'Enable','on');        
        if isfield(handles.DB,'axesnum') && max(handles.DB.axesnum)>1
            if nplot>1 && nplot<max(handles.DB.axesnum)
                set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
                set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
            elseif nplot==1
                set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
                set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
            elseif nplot==max(handles.DB.axesnum)
                set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
                set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
            end
        else
            set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
            set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
        end
        
        set(handles.butDeleteplot,'Enable','on');        
        updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
          handles = guidata(hObject);        
        set(handles.butDeleteplotvar,'Enable','on');
        set(handles.butColor,'Enable','on');
        set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
        set(handles.popLinestyle,'Value',1,'Enable','on');
        
        %Set context menus
        setContextMenus(hObject,handles);
        handles = guidata(hObject);        
        
    else
        
        %Set context menus
        setContextMenus(hObject,handles);
        handles = guidata(hObject);
                
        h = warndlg({'Selected variable is not numeric or is a scalar.';...
                      'The variable is added to Workspace but not plotted.'},...
                     'Warning','modal');
    end
    
else %plot checkbox is not checked
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
    
end

%Update UI controls in variable operations in Workspace
updateVariableOperations(hObject,handles,varind);
handles = guidata(hObject);

%Viewing window and toolbar
if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex)
    set(handles.popWindow,'Enable','on');
    
    %Enable tools in the toolbar
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolSelectRegion,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');
    set(handles.toolVerticalGuide_push,'Enable','on');
else
    set(handles.popWindow,'Enable','off');
    
    %Disable tools in the toolbar
    set(handles.toolScreenshot,'Enable','off');
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolSelectRegion,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');
    set(handles.toolVerticalGuide_push,'Enable','off');
end

guidata(hObject, handles); %update handles structure