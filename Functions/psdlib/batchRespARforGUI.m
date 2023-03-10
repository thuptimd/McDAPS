function [allresults,colname,missing_signal_matfiles,missing_tag_csvfiles,missing_csvfiles,rounds] = batchRespARforGUI(inp)


matpath = inp.matpath;
tagpath = inp.tagpath;
taskRegions = inp.taskRegions;
tagrespbase = inp.tagrespbase;
varlist = inp.varlist;
fsvar = inp.fsvar;
varresp = inp.varresp;
fsresp = inp.fsresp;
settingpath = inp.settingpath;
obj = inp.editBResultDisplay;


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
acrtag = cellfun(@(x) [lower(x(1:5)),x(6:end-4)],listtag,'UniformOutput',0); %only acrostic

%% Load .mat & signal range from the file
%matpath = a path to a folder containing .mat variables
%tagpath = a path to a folder containing defined region tags for each subject
files=dir(fullfile(matpath,'*.mat'));
Ntask = length(taskRegions);
Nvar = length(fsvar);

rounds = length(files);
missing_signal_matfiles = cell(Nvar+1,1); %Last signal is for resp
missing_tag_csvfiles = cell(Ntask+1,1); 
missing_csvfiles = {};


allresults = {};
set(obj,'String','Computing Batch Respiratory-Adjusted PSD.............');
drawnow; %Force matlab to display the string in the result editbox
colname = {'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'CSV';'Tag';'Operation';'OperationTag';'Value'};
ncol = length(colname);
try
for nsig=1:Nvar
    for n=1:rounds
        %Update result status
        name = files(n).name;
        s =  load(fullfile(matpath,name));
        
        cname = strsplit(name,'_'); 
        acrostic = name(1:5); %acrostic for an individual subj
        subjid = cname{1}; subjid = subjid(6:end);
        name = name(10:end);
        datei = strfind(name,'201'); %search for year
        exptdate = name(datei:datei+7);
        listtagfilenames = {};
        
        %% Search using acrostic first, if there are multiple fies, use exptdate
        %Search for the tag file
        tagid = find(cellfun(@(x) ~isempty(regexp(x,acrostic,'ONCE')),acrtag,'UniformOutput',1));
        
        if length(tagid)>1%Use exptdate
           subacrtag = acrtag(tagid);
           sublisttag = listtag(tagid);
           tagid = find(cellfun(@(x) ~isempty(regexp(x,exptdate,'ONCE')),subacrtag,'UniformOutput',1));
           
           if length(tagid)>1
               
               if length(tagid)~=1 %Fail to use exptdate, empty tagid or more than one tagid
                   %% Ask for a user input
                   %Show all .csv tags
                   %Show matfile
                   fig = figure('Name','Select a matching .csv file','Position',[680 478 500 350],'Resize','off');
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
                               set(obj,'String',{'Cannot locate .CSV for.....',files(n).name});
                               tagid = 0;
                               break
                           end
                       catch
                           return
                       end
                       drawnow %Feed the current event to update tb1/2/3 values
                   end
                   
                   if tagid==0
                       %Missing Tags
                       missing_csvfiles = [missing_csvfiles;{files(n).name;}];
                       set(obj,'String',{'Cannot locate .CSV for.....',files(n).name});
                       drawnow; %Force matlab to display the string in the result editbox
                       continue;
                   else %
                       listtagfilenames = listtag(tagid);
                   end
               end

           end
           
        elseif isempty(tagid)
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
            
            
            indResp = strcmp(tagrespbase,tagcol);
            
            if any(indResp)
                t1Resp = startTime(indResp);
                t2Resp = stopTime(indResp);
                
                %% For each region, calculate psd
                for nroi=1:Ntask
                    newtag = cell(1,ncol);
                    newtag{1,1} = acrostic;
                    newtag{1,2} = subjnum;
                    newtag{1,3} = exptdate;
                    newtag{1,4} = expttime;
                    newtag{1,5} = varlist{nsig};
                    newtag{1,6} = filename;

                    taskname = taskRegions{nroi};
                    
                    newtag{1,7} = taskname;
                    newtag{1,8} = 'RespAdj';
                    
                    
                    set(obj,'String',{['File = ',files(n).name],['Computing.....',varlist{nsig}],['Operation Tag = ',taskname]});
                    drawnow; %Force matlab to display the string in the result editbox
                    
                    indTask = strcmp(taskname,tagcol);
                    
                    if any(indTask)
                        if sum(indTask)>1 %Same name on one file
                            set(obj,'String',{'Warning.....',[files(n).name,' has repeated ROIs within the CSV file']});
                            drawnow; %Force matlab to display the string in the result editbox

                            
                            t1Task = startTime(indTask);
                            t2Task = stopTime(indTask);
                            t1Task = t1Task(1);
                            t2Task = t2Task(2);
                            
                        else
                            t1Task = startTime(indTask);
                            t2Task = stopTime(indTask);
                            
                        end
                    else
                        if nsig==1
                            %disp(['Cannot find ',taskname,' from ',filename]);
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
                    
                    y = eval(['s.',varlist{nsig}]);
                    resp = eval(['s.',varresp]);
                    if isempty(y)  %cannot calculate psd, newtag = [];
                        temp = missing_signal_matfiles{nsig};
                        if isempty(temp)
                            temp = {filename};
                        else
                            temp = [temp,{filename}];
                        end
                        missing_signal_matfiles{nsig} = temp;
                        %Empty variable
                        newtag = [];
                        
                        %Check if resp is missing before breaking the loop
                        if isempty(resp) %cannot calculate psd, newtag = []
                            if nsig==1
                                temp = missing_signal_matfiles{end};
                                if isempty(temp)
                                    temp = {filename};
                                else
                                    temp = [temp,{filename}];
                                end
                                missing_signal_matfiles{end} = temp;
                            end
                            
                        end
                        break;
                    end
                    
                    if isempty(resp)%cannot calculate psd, newtag = []
                        if nsig==1
                            temp = missing_signal_matfiles{end};
                            if isempty(temp)
                                temp = {filename};
                            else
                                temp = [temp,{filename}];
                            end
                            missing_signal_matfiles{end} = temp;
                        end
                        %Empty variable
                        newtag = [];
                        break;
                        
                    end
                    %1.Downsample to fs & normalize if needed
                    if ~rem(fsvar(nsig),fs) %fs is divisible by fresamp
                        y = downsample(y, fsvar(nsig)/fs);
                    else
                        [p,q] = rat(fs/fsvar(nsig));
                        y = resample(y,p,q, 0); %filter order = 0
                    end
 
                    if isnorm
                       y = y/prctile(y,95); 
                    end
                    
                    if ~rem(fsresp,fs) %fs is divisible by fresamp
                        resp = downsample(resp, fsresp/fs);
                    else
                        [p,q] = rat(fs/fsresp);
                        resp = resample(resp,p,q, 0); %filter order = 0
                    end
                    
                                        
                    %% 2. Compute Respiratory-Adjusted PSD (don't adjust during baseline)
                    i1Task = round(t1Task*2)+1;
                    i2Task = round(t2Task*2)+1;
                    
                    i1RespBase = round(t1Resp*2)+1;
                    i2RespBase = round(t2Resp*2)+1;
                    
                    %Adjust for respiration
                    try
                        outresp = TIVPSD(resp(i1RespBase:i2RespBase),fs,'method','ar');
                    catch
                        set(obj,'String',['Error while calculating respiratory spectrum for.....',files(n).name]);
                        drawnow; %Force matlab to display the string in the result editbox
                        newtag = []; %Shouldn't work for any task
                        break;
                    end
                    
                    try
                        %Task
                        out = TIVPSD_inputadj(y(i1Task:i2Task),resp(i1Task:i2Task),outresp.Sy,fs,'method','arx','df',df,'detrendorder',detrendorder);
                        %Loop frequency ranges
                        nrow = length(fname); %No. of freq bands
                        newtag = repmat(newtag,nrow+2,1);
                        for nf=1:nrow
                            z = out.f>=fregion(nf,1) & out.f<fregion(nf,2);
                            if ~isempty(z)
                                newtag{nf,ncol} = trapz(out.Sya(z))*df;
                            else
                                newtag{nf,ncol} = 0; %The frequency range is outside the spectra
                            end
                            newtag{nf,ncol-1} = fname{nf};
                            
                        end
                        newtag{nrow+1,ncol-1} = 'TotalPwr';
                        newtag{nrow+1,ncol} = trapz(out.f,out.Sya);
                        newtag{nrow+2,ncol-1} = 'RespTotalPwr';
                        newtag{nrow+2,ncol} = trapz(outresp.f,outresp.Sy);
                    catch
                        set(obj,'String',['Error while calculating PSD for.....',files(n).name]);
                        drawnow; %Force matlab to display the string in the result editbox
                        newtag = [];
                        break;
                    end

                    if ~isempty(newtag) %if newtag is empty -> vars do not exist, else some tasks are calculated
                        try
                            allresults = [allresults;newtag];
                        catch
                            set(obj,'String',['Dimensions are not consistent.....',files(n).name]);
                            drawnow; %Force matlab to display the string in the result editbox
                        end
                    end
                    
               
                end
            else %Cannot calculate psd, newtag = [];
                if nsig==1
                    %                     disp(['Cannot find Respiratory Baseline Tag: ',filename]);
                    temp = missing_tag_csvfiles{end};
                    if isempty(temp)
                        temp = {filename};
                    else
                        temp = [temp,{filename}];
                    end
                    missing_tag_csvfiles{end} = temp;
                end
                newtag = [];
            end
        end
            

        
        
        

        
    end
end


catch
   set(obj,'String','Error while calculating PSD');
   drawnow; %Force matlab to display the string in the result editbox

    
end


end

