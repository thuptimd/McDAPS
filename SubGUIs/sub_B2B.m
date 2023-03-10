function fig = sub_B2B(varargin)
%UNTITLED Summary of this function goes here
% To-do list
% Export txt files...
%   Detailed explanation goes here
% Options = b2b values, sampling frequency, cut off, blah blah


% Check if hObject of the main_DataBrowser is passed in varargin
DataBrowserInput = find(strcmp(varargin, 'DataBrowser'));
if ~isempty(DataBrowserInput)
   hObject_databrowser = varargin{DataBrowserInput+1};
end
h = guidata(hObject_databrowser); %Get handles(struct) of DataBrowser

%% -- Extracted variables -- 
indmin = [];
indmax = [];
minhr = 50;
maxhr = 140;
fs_low = 30;
ecgwindow = 1.5;
pulsepressure_threshold = 10;

%ppgamp = [];

%% Check if there is no variable existing in workspace
if ~isfield(h.DB,'varname') || isempty(h.DB.varname) %Allow only batch processing
    
else

    try
        [indx,tf] = listdlg('PromptString',{'Select a signal.',...
            'Only one signal can be selected at a time.',''},...
            'SelectionMode','single','ListString',h.DB.varname);
    catch
        warning([wearpath,' must have at least one PPG .csv file']);
        return
    end
    if ~tf
        disp('Users did not select a file');
        return
    end
    
    filename = h.DB.filename{indx};
    signal = h.DB.signal{indx};
    signalname = h.DB.varname{indx};
    fs     = h.DB.fs(indx);
    time = (0:length(signal)-1)'; time = time/fs;
    signaltype = []; % ie. ecg==0,ppg==1, bp==2   
    h_indmin = [];
    h_indmax = [];
    
    
    %% -- Create a figure of time-series (e.g. PPG) --
    startindex = 0;
    endindex = time(end);
    
    if ispc
        fntsize = 10;
    else
        fntsize = 12;
    end
    
   
    
    fig = figure;
    set(fig,'Name','B2B detection','NumberTitle','off','Unit','normalized','Position',[0.1 0.1 0.8 0.8],'Resize','off','Tag','sub_b2b','MenuBar','none','ToolBar','none','HandleVisibility','on');    
    ax1 = axes(fig,'Unit','normalized','Position',[0.1 0.4 0.8 0.5]);
    plot(ax1,time,signal); title(ax1,signalname);
    hcmenu = uicontextmenu('Parent',fig);
    item1 = uimenu(hcmenu,'Label','Set y-limit...','Callback',@setB2BYlimit); %set y-limit to auto-adjust
    item2 = uimenu(hcmenu,'Label','Auto-adjust y-limit','Callback',@autosetB2BYlimit); %zoom
    set(ax1,'uicontextmenu',hcmenu);
    %% -- Menu options -- 
    m1 = uimenu(fig,'Text','Process');
    m1_item1 = uimenu(m1,'Text','PPG');
    m1_item1.Callback = {@butprocessppgCallback ax1};  
    
    m1_item2 = uimenu(m1,'Text','Blood pressure');
    m1_item2.Callback = {@butprocessbpCallback ax1};  
    
    m1_item3 = uimenu(m1,'Text','ECG');
    m1_item3.Callback = {@butprocessecgCallback ax1};  
    
    m2 = uimenu(fig,'Text','Setting');
    m2_item1 = uimenu(m2,'Text','Save beat-to-beat as .csv');
   % m2_item1.Callback = @savecsv;  
    



    
    %% -- Start edit box --
    uiedit_start = uicontrol(fig,'Style','edit','Unit','normalized','Position',[0.2 0.3 0.06 0.04],...
        'String',num2str(startindex),'UserData',startindex);
    uicontrol(uiedit_start);
    uiedit_start.Callback = {@buteditCallback_start ax1};
    
    %% -- Start text --
    uicontrol(fig,'Style','text','Unit','normalized','Position',[0.1 0.3 0.1 0.04],...
        'String','Start [sec]>');
    
    %% -- End edit box --
    uiedit_end = uicontrol(fig,'Style','edit','Unit','normalized','Position',[0.2 0.25 0.06 0.04],...
        'String',num2str(endindex),'UserData',endindex);
    uicontrol(uiedit_end);
    uiedit_end.Callback = {@buteditCallback_end ax1};
    
    %% -- End text --
    uicontrol(fig,'Style','text','Unit','normalized','Position',[0.1 0.25 0.1 0.04],...
        'String','End [sec]>');
    
    %% -- Button display data between start and end --
    uibutfull = uicontrol(fig,'Style','pushbutton','String','Display the whole signal','FontSize',fntsize,...
        'Unit','normalized','Position',[0.3 0.2 0.2 0.04]);
    uibutfull.Callback = {@butfullCallback uiedit_start uiedit_end 0 time(end)};
    
    %% -- Button previous --
    uibutprev = uicontrol(fig,'Style','pushbutton','String','<<Prev','FontSize',fntsize,...
        'Unit','normalized','Position',[0.1 0.2 0.1 0.04]);
    uibutprev.Callback = {@butprevCallback ax1 uiedit_start uiedit_end};
    %% -- Button Next --
    uibutnext = uicontrol(fig,'Style','pushbutton','String','Next>>','FontSize',fntsize,...
        'Unit','normalized','Position',[0.2 0.2 0.1 0.04]);
    
    uibutnext.Callback = {@butnextCallback ax1 uiedit_start uiedit_end time(end)};
    
    
    %% -- Button reject --
    uibutreject = uicontrol(fig,'Style','pushbutton','String','Reject beat','FontSize',fntsize,...
        'Unit','normalized','Position',[0.8 0.3 0.1 0.04]);
    uibutreject.Callback = @butrejectCallback;
    
    %% -- But Add --
    uibutadd = uicontrol(fig,'Style','pushbutton','String','Add beat','FontSize',fntsize,...
        'Unit','normalized','Position',[0.7 0.3 0.1 0.04]);
    uibutadd.Callback = @butaddCallback;
    
    %% -- Button Export --
    uibutexport = uicontrol(fig,'Style','pushbutton','String','Export B2B','FontSize',fntsize,...
        'Unit','normalized','Position',[0.7 0.2 0.2 0.04],'Tooltip','Export beat-to-beat signals to the main window.');
    uibutexport.Callback = {@butexportCallback h};
    
    %% -- Status edit box --
    uiedit_status = uicontrol(fig,'Style','edit','Unit','normalized','Position',[0.1 0.1 0.4 0.04],...
        'String','Status Bar','BackgroundColor',[1 1 1],'ForegroundColor',[1 0.4 0],'FontSize',fntsize,...
    'Enable','inactive');

    
    
end
    function autosetB2BYlimit(src,event)
        temp = signal(time>= ax1.XLim(1) & time<=ax1.XLim(2));
        ymin = min(temp); ymax = max(temp);
        yrange = max(temp) - min(temp);
        ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];

        if ylimit(2)>ylimit(1)
            set(ax1,'YLim',ylimit);
        end
    end
    function setB2BYlimit(src,event)
        
    c = get(ax1,'Color');
    set(ax1,'Color',[1 0.93 0.93]);
    
    %Define area to be shaded
    rect = getrect(ax1); %rect = [xmin ymin width height] (unit = unit of x-axis)
    
    %Restore axes color
    set(ax1,'Color',c);
    
    %Adjust y-limit
    ymin = rect(2);
    ymax = ymin + rect(4);      
    set(ax1,'YLim',[ymin ymax]);
       

        
    end

    function butprocessecgCallback(src,event,ax1)
       set(uiedit_status,'String','Detecting R-peaks......');
       drawnow;
       signaltype = 0;
       trend = getTrend(signal);
       indmax = getRpeaks(signal-trend,fs,ecgwindow);
       if isgraphics(h_indmax)
            delete(h_indmax);
       end
       
       hold(ax1,'on');
       h_indmax = plot(ax1,time(indmax),signal(indmax),'ms');
       hold(ax1,'off');
       
       set(uiedit_status,'String','Complete!......');
        
    end

   function butprocessbpCallback(src,event,ax1)
        signaltype = 2;
        if isgraphics(h_indmin)
            %Delete them first
            delete(h_indmin);
        end
        if isgraphics(h_indmax)
            delete(h_indmax);
        end
        
        [indmin,indmax] = detect_pulse_for_McDAPs(signal,fs,minhr,maxhr,uiedit_status);
        indmax(indmin<0) = [];
        indmin(indmin<0) = [];
        temp = signal(indmax)-signal(indmin);
        indmax(temp<pulsepressure_threshold) = [];
        indmin(temp<pulsepressure_threshold) = [];
        hold(ax1,'on');
        h_indmin = plot(ax1,time(indmin),signal(indmin),'r+');
        h_indmax = plot(ax1,time(indmax),signal(indmax),'bo');
        hold(ax1,'off');

        
    end

    function butprocessppgCallback(src,event,ax1)
        signaltype = 1;
        if isgraphics(h_indmin)
            %Delete them first
            delete(h_indmin);
        end
        if isgraphics(h_indmax)
            delete(h_indmax);
        end

        [indmin,indmax,~,~] = detect_pulse_for_McDAPs(signal,fs,minhr,maxhr,uiedit_status);
        hold(ax1,'on');
        h_indmin = plot(ax1,time(indmin),signal(indmin),'r+');
        h_indmax = plot(ax1,time(indmax),signal(indmax),'bo');
        hold(ax1,'off');


        
    end

    function savecsv(src,event)
        % h= h to databrowser fig
        %% -- Add new variables to DB --
        if signaltype == 1 && ~isempty(indmax) %PPG
            %Export PPGa
            ppga = signal(indmax)-signal(indmin);          
            % Pulse interval
            ppi = signal(indmax(2:end))-signal(indmax(1:end-1));
            ppi = [ppi;0]; %last beat isn't available

            varlist = {ppga,ppi};
            varname = {'ppga','ppi'};
            
        elseif signaltype == 2 && ~isempty(indmax)
            % SBP
            sbp = signal(indmax);
            
            % DBP
            dbp = signal(indmin);
             
            % MAP
            map = 1/3*(sbp)+2/3*(dbp);
            
            varlist = {sbp,dbp,map};
            varname = {'sbp','dbp','map'};
            
            
        elseif ~isempty(indmax) %ECG
            rri = signal(indmax(2:end))-signal(indmax(1:end-1));
            rri = [rri;0]; %No last pulse

            varlist = {rri};
            varname = {'rri'};
            
        end
        for v=1:length(varlist)
            h.DB.subjnum = [h.DB.subjnum; '-'];
            h.DB.filename    = [h.DB.filename; {'filename'}];
            h.DB.varnameorig = [h.DB.varnameorig; '-'];
            
            %Check for repeated variable name
            newvarname = checkRepeatedVarname(varname{v},h.DB.varname);
            h.DB.varname = [h.DB.varname; newvarname];
            
            
            y = varlist{v};
            
            % results don't have exptdate and expttime
            h.DB.exptdate = [h.DB.exptdate;'-'];
            h.DB.expttime = [h.DB.expttime;'-'];
            h.DB.signal      = [h.DB.signal; y];
            h.DB.meanstd     = [h.DB.meanstd; [mean(y),std(y)]];
            h.DB.fs          = [h.DB.fs; fs_low];
            h.DB.flagnorm    = [h.DB.flagnorm; -1];
            h.DB.flagdetrend = [h.DB.flagdetrend; -1];
            h.DB.detrend     = [h.DB.detrend; 1];
            h.DB.scale       = [h.DB.scale; 1];
            h.DB.flagtivpsd  = [h.DB.flagtivpsd; 0];
        end
        %Add new variables to Workspace
        varind = length(h.DB.varname);
        set(h.listWrkspc,'String',h.DB.varname,'Value',varind,'Enable','on');
        
        guidata(h.output, h); %update handles structure
        
        
    end

    function butexportCallback(~,~,h)   
        %% -- Add new variables to DB --  

        if signaltype == 1 && ~isempty(indmax) %PPG
           %Export PPGa
            temp = signal(indmax)-signal(indmin);

            time_low = (0:1/fs_low:time(end));
            % Amplitude
            ppga = interp1(time(indmax),temp,time_low,'previous');
            ppga(1:indmax(1)) = 0;
            
            % Pulse interval   
            temp = signal(indmax(2:end))-signal(indmax(1:end-1));
            temp = [temp;0]; %No last pulse
            temp = temp/fs;
            %Convert to seconds
            ppi = interp1(time(indmax),temp,time_low,'previous');
            ppi(1:indmax(1)) = 0; 
            varlist = {ppga,ppi,indmax,indmin};
            varname = {'ppga','ppi','ppgmaxind','ppgminind'};
           
        elseif signaltype == 2 && ~isempty(indmax)
             %Export blood pressure
            time_low = (0:1/fs_low:time(end));
            % SBP
            sbp = interp1(time(indmax),signal(indmax),time_low,'previous');
            sbp(1:indmax(1)) = 0;
            
            % DBP
            dbp = interp1(time(indmax),signal(indmin),time_low,'previous');
            dbp(1:indmax(1)) = 0;
            
            % MAP 
            map = 1/3*(sbp)+2/3*(dbp);

            varlist = {sbp,dbp,map,indmax,indmin};
            varname = {'sbp','dbp','map','bpmaxind','bpminind'};
           
            
        elseif ~isempty(indmax) %ECG
            time_low = (0:1/fs_low:time(end));
            temp = signal(indmax(2:end))-signal(indmax(1:end-1));
            temp = [temp;0]; %No last pulse
            temp = temp/fs;
            %Convert to seconds
            rri = interp1(time(indmax),temp,time_low,'previous');
            rri(1:indmax(1)) = 0; 
            varlist = {rri,indmax};
            varname = {'rri','rpeak_locs'};
            
        end
        for v=1:length(varlist)
            h.DB.subjnum = [h.DB.subjnum; '-'];
            h.DB.filename    = [h.DB.filename; {filename}];
            h.DB.acrostic = [h.DB.acrostic; filename(1:5)];
            h.DB.varnameorig = [h.DB.varnameorig; '-'];
            
            %Check for repeated variable name
            newvarname = checkRepeatedVarname(varname{v},h.DB.varname);
            h.DB.varname = [h.DB.varname; newvarname];
            
            
            y = varlist{v};
            
            % results don't have exptdate and expttime
            h.DB.exptdate = [h.DB.exptdate;'-'];
            h.DB.expttime = [h.DB.expttime;'-'];
            h.DB.signal      = [h.DB.signal; y];
            h.DB.meanstd     = [h.DB.meanstd; [mean(y),std(y)]];
            h.DB.fs          = [h.DB.fs; fs_low];
            h.DB.flagnorm    = [h.DB.flagnorm; -1];
            h.DB.flagdetrend = [h.DB.flagdetrend; -1];
            h.DB.detrend     = [h.DB.detrend; 1];
            h.DB.scale       = [h.DB.scale; 1];
            h.DB.flagtivpsd  = [h.DB.flagtivpsd; 0];
        end
        %Add new variables to Workspace
        varind = length(h.DB.varname);
        set(h.listWrkspc,'String',h.DB.varname,'Value',varind,'Enable','on');
        set(uiedit_status,'String','Beat-to-beat signals are exported!......');
        drawnow;
        guidata(h.output, h); %update handles structure
        
    end

    function butnextCallback(~,event,ax1,uiedit_start,uiedit_end,endtime)
        
        
        x2= uiedit_end.UserData;
        window = uiedit_end.UserData-uiedit_start.UserData;
        
        if x2< endtime && x2+window<endtime && window > 0
            set(ax1,'XLim',[x2 x2+window]);
            set(uiedit_start,'String',num2str(x2));
            buteditCallback_start(uiedit_start,[],ax1)
            set(uiedit_end,'String',num2str(x2+window));
            buteditCallback_end(uiedit_end,event,ax1)
            
        end
        
        
    end

    function butprevCallback(~,event,ax1,uiedit_start,uiedit_end)
        
        x1= uiedit_start.UserData;
        window = uiedit_end.UserData-uiedit_start.UserData;
        
        if x1-window>=0 && window>0
            set(ax1,'XLim',[x1-window x1]);
            set(uiedit_start,'String',num2str(x1-window));
            buteditCallback_start(uiedit_start,[],ax1)
            set(uiedit_end,'String',num2str(x1));
            buteditCallback_end(uiedit_end,event,ax1)
            
        end
        
        
    end

    function buteditCallback_start(src,~,ax1)
        
        if isnan(str2double(src.String)) || str2double(src.String)<0  || str2double(src.String)>=ax1.XLim(2)
            x1 = src.UserData;
            
        else
            x1 = str2double(src.String);
            src.UserData = x1;
        end
        %Reset the plot
        set(ax1,'XLim',[x1 ax1.XLim(2)]);
        
    end

    function buteditCallback_end(src,~,ax1)
        
        if isnan(str2double(src.String)) || str2double(src.String)<0 || str2double(src.String)<=ax1.XLim(1)
            x2 = src.UserData;
        else
            x2 = str2double(src.String);
            src.UserData = x2;
        end
        %Reset the plot
        set(ax1,'XLim',[ax1.XLim(1) x2]);
        
    end

    function butaddCallback(src,event)
        % Add one pair at a time
        if signaltype == 1 || signaltype == 2
             [x,~] = ginputax(ax1,2); %Select two locations (time unit)    
             x = round(sort(x)*fs+1);  
             if x(1)<1
                    x(1) = 1;
             end
                
             if x(2)>length(signal)
                   x(2) = length(signal);
             end
             
             %These locations must not overlap with existing beats
             indx = find(indmax>=x(1),1,'first');
             indy = find(indmax>=x(2),1,'first');
             if (x(1)>=indmin(indx) && x(1)<=indmax(indx)) || (x(2)>=indmin(indy) && x(2)<=indmax(indy))
                 return
             else
                 [~,new_indmax]= max(signal(x(1):x(2)));
                 new_indmax = new_indmax+x(1)-1;
                 [~,new_indmin] = min(signal(x(1):new_indmax));
                 new_indmin = new_indmin+x(1)-1;
 
                 indmin = sort([indmin;new_indmin]);
                 indmax = sort([indmax;new_indmax]);

                % -- Plotting -- 
                if isgraphics(h_indmin) || isgraphics(h_indmax)
                    delete(h_indmin);
                    delete(h_indmax);
                end
                
                hold(ax1,'on');
                h_indmin = plot(ax1,time(indmin),signal(indmin),'r+');
                h_indmax = plot(ax1,time(indmax),signal(indmax),'bo');
                hold(ax1,'off');

             end
        end
        
    end

    function butrejectCallback(src,event)
           if (signaltype == 1 || signaltype == 2) && ~isempty(indmin)%PPG or BP
                [x,~] = ginputax(ax1,2);
                x = sort(x)*fs+1;
                if x(1)<1
                    x(1) = 1;
                end
                
                if x(2)>length(signal)
                   x(2) = length(signal);
                end
                % -- Delete markers --
                indmax(indmin>=x(1) & indmin<=x(2)) = [];
                indmin(indmin>=x(1) & indmin<=x(2)) = [];
                delete(h_indmin);
                delete(h_indmax);
                
                hold(ax1,'on');
                h_indmin = plot(ax1,time(indmin),signal(indmin),'r+');
                h_indmax = plot(ax1,time(indmax),signal(indmax),'bo');
                hold(ax1,'off');
            
         elseif signaltype == 0 && ~isempty(indmax)%ECG
                [x,~] = ginputax(ax1,2);
                x = sort(x)*fs+1;
                if x(1)<1
                    x(1) = 1;
                end
                
                if x(2)>length(signal)
                   x(2) = length(signal);
                end
                % -- Delete markers --
                indmax(indmax>=x(1) & indmax<=x(2)) = [];
                delete(h_indmax);
                
                hold(ax1,'on');
                h_indmax = plot(ax1,time(indmax),signal(indmax),'ms');
                hold(ax1,'off');
                
            end
        end
        
    

    function butfullCallback(src,event,h_start,h_end,starttime,endtime)       
        set(ax1,'XLim',[starttime endtime]);
        %Set editbox start
        set(h_start,'String',num2str(starttime),'UserData',starttime);
        set(h_end,'String',num2str(endtime),'UserData',starttime);
        
    end


end

