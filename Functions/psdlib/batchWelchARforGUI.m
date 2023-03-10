function [allresults,colname,missing_signal_matfiles,missing_tag_csvfiles,missing_csvfiles,rounds] = batchWelchARforGUI(inp)


obj = inp.editBResultDisplay;
set(obj,'String','Processing.....');
matpath = inp.matpath;
tagpath = inp.tagpath;
taskRegions = inp.taskRegions;
varlist = inp.varlist;
fsvar = inp.fsvar;
method = inp.method;
settingpath = inp.settingpath;

load(fullfile(settingpath,'psdsetting.mat'),'df');
load(fullfile(settingpath,'psdsetting.mat'),'fs');
load(fullfile(settingpath,'psdsetting.mat'),'isnorm');
load(fullfile(settingpath,'psdsetting.mat'),'detrendorder');
load(fullfile(settingpath,'psdsetting.mat'),'freqname');
load(fullfile(settingpath,'psdsetting.mat'),'freqreg');
load(fullfile(settingpath,'psdsetting.mat'),'selectedfreq');

fregion = freqreg(selectedfreq,:);
fname = freqname(selectedfreq);

listtag = dir(tagpath);
listtag = {listtag.name}; %List of the file
% Remove wrong elements (length(filename)<5)
cellind = strfind(listtag,'.csv');
ind = cellfun(@(x) ~isempty(x),cellind,'UniformOutput',1);
listtag = listtag(ind); listtag = listtag'; %Change to a column vector
acrtag = cellfun(@(x) [lower(x(1:5)),x(6:end-4)],listtag,'UniformOutput',0);

%% Load .mat & signal range from the file
%matpath = a path to a folder containing .mat variables
%tagpath = a path to a folder containing defined region tags for each subject
files=dir(fullfile(matpath,'*.mat'));
Ntask = length(taskRegions);
Nvar = length(fsvar);

rounds = length(files);
missing_signal_matfiles = cell(Nvar,1); %Missing variables
missing_tag_csvfiles = cell(Ntask,1);  
missing_csvfiles = {};

allresults = {};
colname = {'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'CSV';'Tag';'Operation';'OperationTag';'Value'};
ncol = length(colname);


h = waitbar(0,'Please wait...');
steps = Nvar*rounds;


try
%% LOOP VARIABLE
for nsig=1:Nvar
    %% LOOP MATFILE
    for n=1:rounds
        
        step = n+(nsig-1)*rounds;
        waitbar(step/steps);
        name = files(n).name;
        s =  load(fullfile(matpath,name));      
        cname = strsplit(name,'_'); 
        
        %Update result status
        set(obj,'String',{['Processing......',num2str(round((100*n)/rounds)),'%'],['Calculating the spectra from.....',varlist{nsig}],name});
        acrostic = name(1:5); %acrostic for an individual subj
        subjid = cname{1}; subjid = subjid(6:end);
        name = name(10:end);
        datei = strfind(name,'201'); %search for year
        exptdate = name(datei:datei+7);
        listtagfilenames = {};

        
        
        %% Search using acrostic first, if there are multiple files, use exptdate
        %Search for the tag file
        tagid = find(cellfun(@(x) ~isempty(regexpi(x,acrostic,'ONCE')),acrtag,'UniformOutput',1)); %Search .csv for .mat using acrostic
        
        if length(tagid)>1 %Use exptdate
           subacrtag = acrtag(tagid);
           sublisttag = listtag(tagid);
           tagid = find(cellfun(@(x) ~isempty(regexpi(x,exptdate,'ONCE')),subacrtag,'UniformOutput',1));
                   
           if length(tagid)~=1 %Fail to use exptdate, empty tagid or more than one tagid
               %% Ask for a user input
               %Show all .csv tags
               %Show matfile
               fig = figure('Name','Select .csv file','Position',[680 478 500 350],'Resize','off');
               txtbox = uicontrol(fig,'Style','edit',...
                   'String',['.CSV files for ', files(n).name],...
                   'Units','normalized',...
                   'FontSize',12,...
                   'FontWeight','bold',...
                   'Position',[0 0.75 1 0.2],...
                   'Enable','inactive');
               lb = uicontrol(fig,'Style','listbox',...
                   'String',listtag,...
                   'FontSize',14,...
                   'Units','normalized',...
                   'Max',2,...
                   'Position',[0.1 0.25 0.8 0.5],'Value',1);
               
               tb = uicontrol(fig,'Style','togglebutton',...
                   'String','Continue',...
                   'Units','normalized',...
                   'FontSize',14,...
                   'Value',0,'Position',[0.55 0.05 0.35 0.2]);
               tb_cancel = uicontrol(fig,'Style','togglebutton',...
                   'String','None',...
                   'Units','normalized',...
                   'FontSize',14,...
                   'Value',0,'Position',[0.1 0.05 0.35 0.2]);
               
               
               
               
               % Check which variable is a target
               while true
                   try
                       if get(tb,'Value')
                           tagid = get(lb,'Value');
                           close(fig)
                           break
                       elseif get(tb_cancel,'Value')
                           tagid = 0;
                           close(fig)
                           break
                       elseif ~ishandle(fig) %Check if the figure is closed
                           tagid = 0;
                           break
                       end
                   catch
                       return
                   end
                   drawnow %Feed the current event to update tb1/2/3 values
               end
               
               %.CSV is still missing
               if tagid==0
                   missing_csvfiles = [missing_csvfiles;{files(n).name;}];
                   set(obj,'String',['Cannot locate .CSV for ',files(n).name]);

                   continue;
               else %
                    listtagfilenames = listtag(tagid);
               end
           end
            
           
           
        elseif isempty(tagid)
            %.CSV is missing
            missing_csvfiles = [missing_csvfiles;{files(n).name}];
            continue;
        else
            filename = listtag{tagid};
            listtagfilenames = {filename};        

        end
        for nfilename=1:length(listtagfilenames)
            filename = listtagfilenames{nfilename};

            %% == Read Tags =====
            content = tagreader(fullfile(tagpath,filename));
            if ~isempty(content.tagcol)
                tagcol = content.tagcol;
                subjnum = content.subjnum;
                expttime = content.expttime;
                startTime = content.startTime;
                stopTime = content.stopTime;
            else
                continue;
            end
            
            %% =================Generate Output===========================         
            %% For each region, calculate psd
            %1. Downsample to 2Hz
            try
                y = eval(['s.',varlist{nsig}]);
                if isempty(y) %cannot calculate psd, newtag = [];
                    temp = missing_signal_matfiles{nsig};
                    if isempty(temp)
                        temp = {filename};
                    else
                        temp = [temp,{filename}];
                    end
                    missing_signal_matfiles{nsig} = temp;
                    %Empty variable
                    newtag = [];
                    continue;
                end               
            catch
                temp = missing_signal_matfiles{nsig};
                if isempty(temp)
                    temp = {filename};
                else
                    temp = [temp,{filename}];
                end
                missing_signal_matfiles{nsig} = temp;
                %Empty variable
                newtag = [];
                continue;
                
            end
            
            %Downsample to fs
            if ~rem(fsvar(nsig),fs) %fs is divisible by fresamp
                y = downsample(y, fsvar(nsig)/fs);
            else
                [p,q] = rat(fs/fsvar(nsig));
                y = resample(y,p,q, 0); %filter order = 0
            end
    
            %% LOOP TASK
            for nroi=1:Ntask 

                newtag = cell(1,ncol); %No. of freq bands + total power
                newtag{1,1} = acrostic;
                newtag{1,2} = subjnum;
                newtag{1,3} = exptdate;
                newtag{1,4} = expttime;
                newtag{1,5} = varlist{nsig};
                newtag{1,6} = filename;
                
                taskname = taskRegions{nroi};
                newtag{1,7} = taskname;
                
                indTask = strcmp(taskname,tagcol);
                %Update result status
                set(obj,'String',{['File = ',files(n).name],['Computing.....',varlist{nsig}],['Operation Tag = ',taskname]});
                if any(indTask)                                               
                    if sum(indTask)>1 %Same name on one file
                        set(obj,'String',[files(n).name, ' has repeated ROI tags, the first one was selected for the analysis']);

                        t1Task = startTime(indTask);
                        t2Task = stopTime(indTask);
                        t1Task = t1Task(1);
                        t2Task = t2Task(2);
                        
                    else
                        t1Task = startTime(indTask);
                        t2Task = stopTime(indTask);
                        
                    end
                    
                else
                    %ROI is missing
                    if nsig==1
                        temp = missing_tag_csvfiles{nroi};
                        if isempty(temp)
                            temp = {filename};
                        else
                            temp = [temp,{filename}];
                        end
                        missing_tag_csvfiles{nroi} = temp;
                    end
                   
                    continue;
                end
                
                
                
                
                %% 2. Compute Welch/AR PSD
                i1Task = round(t1Task*2)+1;
                i2Task = round(t2Task*2)+1;
                
                %Normalization
                if isnorm
                    y = y/prctile(y,95);
                end
                ytask = y(i1Task:i2Task);
             
                if strcmpi(method,'welch') %Welch      
                    newtag{1,8} = 'Welch';
                    
                    %% 2.1 Welch
                    out = TIVPSD(ytask,fs,'method','welch','df',df,'detrendorder',detrendorder);   

                elseif strcmpi(method,'ar') %AR
                    newtag{1,8} = 'AR';                  
                    out = TIVPSD(ytask,fs,'method','ar','df',df,'detrendorder',detrendorder);   
                    
                end
                
                %Loop frequency ranges
                nrow = length(fname); %No. of freq bands
                newtag = repmat(newtag,nrow+1,1); 
                for nf=1:nrow
                    z = out.f>=fregion(nf,1) & out.f<fregion(nf,2);
                    if ~isempty(z)
                        newtag{nf,ncol} = trapz(out.Sy(z))*df;
                    else
                        newtag{nf,ncol} = 0; %The frequency range is outside the spectra
                    end
                   newtag{nf,ncol-1} = fname{nf};
                    
                end
                newtag{nrow+1,ncol-1} = 'TotalPwr';                
                newtag{nrow+1,ncol} = trapz(out.f,out.Sy);


                if ~isempty(newtag) %if newtag is empty -> vars do not exist, else some tasks are calculated
                    try
                        allresults = [allresults;newtag];
                    catch
                        
                        set(obj,'String','Dimensions are not consistent');
                    end
                end
                
            end
        
        end
        
    end
end

close(h);


catch
   close(h);
   set(obj,'String','Oops, there is error during the batch processing');
end



end

