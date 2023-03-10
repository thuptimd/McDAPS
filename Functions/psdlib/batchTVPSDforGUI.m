function [missing_csvfiles,missing_tag_csvfiles,missing_signal_matfiles,rounds] = batchTVPSDforGUI(matpath,tagpath,savepath,taskRegions,varlist,fsvar,method)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% INPUT FOR A FUNCTION
%matpath
%tagpath
%savepath

listtag = dir(tagpath);
listtag = {listtag.name};
ind = cellfun(@(x) length(x)<5, listtag,'UniformOutput',1);
listtag(ind) = [];
listtag = listtag'; %column vector


%%2016-04-22 Batch Time Varying PSD (fft)
%% Load .mat & signal range from the file
%matpath = a path to a folder containing .mat variables
%tagpath = a path to a folder containing defined region tags for each subject
files=dir(fullfile(matpath,'*.mat'));
Ntask = length(taskRegions);
Nvar = length(varlist);

rounds = length(files); % no. of matfiles
missing_csvfiles = {};
missing_tag_csvfiles = cell(Ntask,1); %Each cell contains the list for .csv that misses the task
missing_signal_matfiles = cell(Nvar,1); %Each cell contains the list for matfile that misses the signal
disp(['Processing ',num2str(rounds),' MATFILES']);
for n=1:rounds
    
    name = files(n).name;
    s =  load(fullfile(matpath,name));
   
    acrostic = name(1:5); %acrostic for an individual subj
    name = name(10:end);
    datei = strfind(name,'2'); %search for year
    exptdate = name(datei:datei+7);   
    savename = [acrostic,exptdate,'PSD.mat'];

    %Search for the tag file
    temp = regexpi(listtag,acrostic); %No case-sensitive
    tagid = find(cellfun(@(x) ~isempty(x),temp,'UniformOutput',1)); %tagid can has multiple values

    if isempty(tagid)
      %Missing Tags
      missing_csvfiles = [missing_csvfiles,{files(n).name}];
      disp(['No tag for:',files(n).name]);
    else
      filename = listtag{tagid};
      
      %% == Read Tags =====
      content = tagreader(fullfile(tagpath,filename));
      if ~isempty(content.tagcol)
          tagcol = content.tagcol;
          subjnum = content.subjnum;
          startTime = content.startTime;
          stopTime = content.stopTime;
          exptdate = content.exptdate;
      else
          continue;
      end
      
          
    %% INITATION result
    result = []; %a struct var contains PSD result
    result.acrostic = acrostic;
    result.subjid = subjnum;
    result.exptdate = exptdate;
    result.tvpsdmethod = method;

    for nvar=1:Nvar
        flagnosignal = false;
        %1. Downsample to 2Hz
        y = eval(['s.',varlist{nvar}]);

        
        if isempty(y)
            flagnosignal = true;
            %Empty variable
            temp = missing_signal_matfiles{nvar};
            if isempty(temp)
                temp = {files(n).name};
            else
                temp = [temp,files(n).name];
            end
            missing_signal_matfiles{nvar} = temp;
        else
            %fs is divisible by fresamp(2 Hz)
            y = downsample(y, fsvar(nvar)/2); %downsample only once
            
        end
              
        
        for ntask=1:Ntask
            flagnotask = false;
            taskname = taskRegions{ntask};
            indTask = strcmp(taskname,tagcol);
            
            LFPfield = [varlist{nvar},'LFP_',taskname];
            HFPfield = [varlist{nvar},'HFP_',taskname];
            LHRfield = [varlist{nvar},'LHR_',taskname];
            Syfield = [varlist{nvar},'Sy_',taskname];
            
            if any(indTask)
                t1Task = startTime(indTask);
                t2Task = stopTime(indTask);
            else %No Task , 
                flagnotask = true;
                if nvar==1 %do not duplicate the csvfile's name
                    temp = missing_tag_csvfiles{ntask};
                    if isempty(temp)
                        temp = {filename};
                        missing_tag_csvfiles{ntask} = temp;
                    else
                        missing_tag_csvfiles{ntask} = [temp,{filename}];
                    end
                end           
            end
            
             %% Check of there is a taskregion or signal available
             if flagnotask || flagnosignal
                 continue; %Either no task or no signal
             end
            i1 = round(t1Task*2)+1;
            i2 = round(t2Task*2)+1;
            
            %2. Compute psd
            [LFPar,HFPar,Sy] = movingPSD(y(i1:i2),2,60,method); %movingPSD(signal,fresamp,windowsize,method)
            LHR = LFPar./HFPar;
            LHR(isnan(LHR)) = 0; %replace NaN with zero
            
            result.(LFPfield) = LFPar;
            result.(HFPfield) = HFPar;
            result.(LHRfield) = LHR;
            result.(Syfield) = Sy;
            
        end
        
    end
          
    %4. Save time-series for each subject
    save(fullfile(savepath,savename),'-struct','result');
      
       
    end
      
end
% disp('Saving the csv file at the end');
% data = allresults;
% % get the selected file/path from users
% [file,path] = uiputfile('results.csv','Save Output');
% if ~isnumeric(file), 
%     filepath = fullfile(path,file);
%     colname = {'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'meanBaseLFP';'meanVerbalLFP';'meanTaskLFP';'meanBaseHFP';'meanVerbalHFP';'meanTaskHFP';'meanBaseLHR';'meanVerbalLHR';'meanTaskLHR'};
%     T = cell2table(data,'VariableNames',colname);
%     writetable(T,filepath);
% end

end


