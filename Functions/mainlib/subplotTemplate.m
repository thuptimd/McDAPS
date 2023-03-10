function subplotTemplate(hObject, eventdata, handles, template)
%% Modified 5Jan2019
%Plot a template
%A template assumes that variables come from the same mat file -> make restriction
%Clear workspace/plots if there is at least one var from the template to be plotted


%Get a list of variables in the current file
matvars = cellstr(get(handles.listMatvars,'String'));
ISFOUND = false; %Is at least one var found?

%Do not change these values, if it does not generate new plots
varindex = []; %Add with plot

novars = {};
second_template = template;
%% Download all variables in the template = add without plot
for n=1:size(template,1) %Loop = no. variables in the template
    
               
    chkmatvar = strcmp(matvars,template{n,1});
    if any(chkmatvar)
        
        %Download the variable and check if it's empty
        load(fullfile(handles.DB.inputpath,handles.DB.inputfile),template{n,1});
        eval(['y = ',template{n,1},';']);
        
        if isempty(y) %The variable is empty, go to the loop (next variable)
            novars = [novars;template{n,1}];
            second_template(n,:) = [];
            continue;
        end
        
        %If the variable is not empty
        %% At this point, a variable in the template is loaded
        if ~ISFOUND
            ISFOUND = true;
            %% CLEAR AXES FOR THE FIRST TIME
            set(handles.DB.vertguide.hl,'Visible','off');
            
            child_handles = allchild(handles.axespanel);
            temp = findobj(child_handles,'Type','axes','-not', 'Tag','hmask'); %Clear all axes
            delete(temp);
            
            %% RESET all variables regarding load
            %File & Subject info
            handles.DB.varname     = template(n,1);
            handles.DB.varnameorig = template(n,1);
            handles.DB.filename    = {fullfile(handles.DB.inputpath,handles.DB.inputfile)};
            handles.DB.exptdate    = {handles.DB.inputexptdate};
            handles.DB.expttime    = {'-'};
            handles.DB.acrostic = {handles.DB.inputfile(1:5)};
            handles.DB.subjnum = {'-'};
            
            %Signal info
            handles.DB.signal = {y};
            handles.DB.meanstd = {[mean(y),std(y)]};
            handles.DB.fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,template{n,1});
            handles.DB.flagnorm    = -1;
            handles.DB.flagdetrend = -1;
            handles.DB.detrend     =  1;
            handles.DB.scale       =  1;
  
            handles.DB.flagtivpsd  =  0;
                      
            
            %% CLEAR VARIABLES regarding the PLOTS            
            handles.DB.varindex = length(handles.DB.varname);
            handles.DB.axesnum  = [];
            handles.DB.color    = [];
            handles.DB.style    = {};
            handles.DB.ylimit   = [];
            handles.DB.haxes = [];
        else
            %File & Subj info
            handles.DB.varname = [handles.DB.varname;template{n,1}];
            handles.DB.varnameorig = [handles.DB.varnameorig;template{n,1}];
            handles.DB.filename = [handles.DB.filename;fullfile(handles.DB.inputpath,handles.DB.inputfile)];
            handles.DB.exptdate = [handles.DB.exptdate; handles.DB.inputexptdate];
            handles.DB.expttime = [handles.DB.expttime; '-'];
            handles.DB.acrostic = [handles.DB.acrostic; handles.DB.inputfile(1:5)];
            handles.DB.subjnum = [handles.DB.subjnum; '-'];
            
            
            %Signal
            handles.DB.signal = [handles.DB.signal; y];
            handles.DB.meanstd = [handles.DB.meanstd; [mean(y),std(y)]];
            
            %Get sampling frequency
            fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,template{n,1});
            handles.DB.fs          = [handles.DB.fs; fs];
            handles.DB.flagnorm    = [handles.DB.flagnorm; -1];
            handles.DB.flagdetrend = [handles.DB.flagdetrend; -1];
            handles.DB.detrend     = [handles.DB.detrend; 1];
            handles.DB.scale       = [handles.DB.scale; 1];

            handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];                    
            handles.DB.varindex    = [handles.DB.varindex;length(handles.DB.varname)];
            
        end
        
        
    else
        novars = [novars;template{n,1}];      
    end

end %end LOOP

%Correct template
template = second_template;

%% Plot variables in the template
if ~isempty(handles.DB.varindex) %Plot a template
    
    nvar = size(handles.DB.varindex,1);
    handles.DB.axesnum = (1:nvar)';
    handles.DB.style   = repmat({'-'},nvar,1);
    
    ncolor = size(handles.DB.colorcode,1);
    nround = floor(nvar/ncolor);
    r = rem(nvar,ncolor);
    handles.DB.color = [repmat(handles.DB.colorcode,nround,1); handles.DB.colorcode(1:r)];
    handles.DB.flagcolor = r;

    %Compute x-limit for the first time of loading a variable    
    maxtime = max((cellfun(@length,handles.DB.signal(handles.DB.varindex)) - 1)./handles.DB.fs(handles.DB.varindex));
    handles.DB.window = maxtime;
    handles.DB.xlimit = [0, maxtime]; %default x-limit = [0, max. time]
    handles.DB.sliderstep = 0;
    
    %Set y-limit of each plot    
    handles.DB.ylimit = zeros(nvar,2); %initialize all y-limits to auto-adjust mode
    
    for n=1:nvar
        
        %I probably don't need sigOp, modified 6Jan2019
        y = signalOperations(handles,handles.DB.varindex(n)); %apply any signal operations to the current signal
        
        
        ymin = template{n,2}; %col2 in template = ymin
        ymax = template{n,3}; %col3 in template = ymax
        
        %Check if ymin and ymax are specified
        if isempty(ymin) && ~isempty(ymax)            
            ymin = min(y) - 0.03*range(y); %only ymax is specified
        elseif ~isempty(ymin) && isempty(ymax)          
            ymax = max(y) + 0.03*range(y); %only ymin is specified
        end
        
        %Check if specified ymin and ymax are valid
        %If yes --> assign ylimit to the specified values
        if ~isempty(ymin) && ~isempty(ymax)
            if ymin<ymax
                handles.DB.ylimit(n,:) = [ymin,ymax];
            end
        end
        
        clear y ymin ymax;
    end
    
    %Plot signals
    subplotSignals(hObject,handles);
    handles = guidata(hObject);
    
    %Set popWindow and xslider
    set(handles.popWindow,'Value',1,'Enable','on');
    set(handles.xslider,'Enable','off','Min',0,'Max',maxtime,'SliderStep',[handles.DB.sliderstep/maxtime, 0.1]);
    set(handles.xslider,'Value',0);
    
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
    
    %Update Workspace
    varind = length(handles.DB.varname);
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

    %Enable tools in the toolbar
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolSelectRegion,'Enable','on');
    set(handles.toolVerticalGuide_push,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');
    
end %end if ~isempty(handles.DB.varindex)

%Set context menus
setContextMenus(gcf,handles);
handles = guidata(gcf);

if ~isempty(novars)
    warnstr = {['Under ',handles.DB.inputfile,' ,'];...
                'the following variables cannot be found:'};
    for n=1:size(novars,1)
        warnstr = [warnstr; [' - ',novars{n}]];
    end
    warndlg(warnstr,'Warning!','modal');
end

guidata(gcf, handles); %update handles structure