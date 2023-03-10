function [out] = batchFEX(inp)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% 11Nov2015
% Batch Processing for FEX
%% Initialization
% % 1.Select Folder of matfiles
% matpath = 'C:\Users\kashi_pc\Documents\Toey\SCD Project\Pain_processed_samples';
% % 2.Select Folder of tags
% tagpath = 'C:\Users\kashi_pc\Documents\Toey\Phd Research\2015-2016\GCS on Pain\Pain - Tags';
% listtag = dir(tagpath);
% listtag = {listtag.name};
% % Remove wrong elements (length(filename)<5)
% ind = cellfun(@(x) length(x)<5, listtag,'UniformOutput',1);
% listtag(ind) = [];
% listtag = listtag'; %column vector
% Get the acrostics

% 
% % 3.Select variables in the list
% varlist = {'oxipamp','pu_left','pu_right'};
% % 4.Select Trend or Raw signal
% istrend = false;
% % 5.Select Normalization
% isnorm = false;
% % 6.Select output path
% savename = 'testbatch.csv';
% savepath = fullfile(matpath,savename);
% % 7.Select baseline & Tasks
% csvtext = importdata(fullfile(tagpath,listtag{1}));
% subregions = csvtext(2:end,12); %Discard the column 
% baselineRegions = subregions(1); %Users-setected, indices to baseline
% taskRegions = subregions(3); %Users-selected, indices to tasks

% 8.Select frequency for each signal
% fslist = [30,250,250];


%% Input
matpath = inp.matpath; %Path to the mat folder
tagpath = inp.tagpath; %Path to the tag folder
listtag = inp.listtag; %List of the tags in the selected folder
taskRegions = inp.taskRegions;
baselineRegions = inp.baselineRegions;
varlist = inp.varlist;
fslist = inp.fslist;
isnorm = inp.isnorm;
isfilter = inp.isfilter;
%Load setting
load(fullfile(inp.settingpath,'fexsetting'));

acrtag = cellfun(@(x) [lower(x(1:5)),x(6:end-4)],listtag,'UniformOutput',0); %List of the .csv files in the selected folder without .csv at the end

%% Output variable
allresults = {};

% 9.Features
feature = descriptivename(logical(descriptiveflag));
ncol_info = 7;
ncol_feature = length(feature);
ncol_curvefeature = 0;
ncol_mvasoc = 0; %No of parameters given by mvasoc = [mvasoc,tvasoc,avasoc,nvasoc]


if descriptiveflag(9) %Fit a curve
    switch curvefittingtype
        case 1 %None
            ncol_curvefeature = 2; %Time-to-halfmax, halfmax
        case 2 %Expo
            ncol_curvefeature = 4; %Time-to-halfmax,halfmax,scaling,time-constant
        case 3 %Polynomial
            ncol_curvefeature = 1+polycurve.order; %Intercept, coefficients
        case 4 %Sigmoid
            ncol_curvefeature = 4; %Upper,lower,slope,midpoint

    end
    ncol_feature = ncol_feature-1;
    ind =strcmpi(feature,'enablecurvefitting'); %Remove enablecurvefitting from feature
    feature(ind) = [];                          %Remove enablecurvefitting from feature
end

if descriptiveflag(10) %If mvasoc is enable
    ncol_mvasoc = 4; %No. of features given by mvasoc = 4
    ind =strcmpi(feature,'vasoc');
    feature(ind) = []; 
    ncol_feature = ncol_feature-1;

end


%%
files=dir(fullfile(matpath,'*.mat'));
rounds = length(files);
missing_signals = 0;
missing_tags = 0;
missing_signals_files = {};
missing_tags_files = {};
missing_roi_csvfiles = {}; %A CSV file that does not have the selected ROI

curvefeature = []; %Add later when the curve fitting is used
vasocfeature = []; %Add mvasoc later when mvasoc is selected

try
%% Loop matfiles
for n=1:rounds 
   set(inp.resultbox,'String',['Processing......',num2str(round((100*n)/rounds)),'%']);
   drawnow;

    name = files(n).name;
    disp(name);
    s =  load(fullfile(matpath,name));
    cname = strsplit(name,'_');
    acrostic = name(1:5); %acrostic+subjid for an individual subj
    name = name(10:end);
    datei = strfind(name,'2'); %search for year
    exptdate = name(datei:datei+7); %expt date from matfile
    [jj,ff,ext] = fileparts(files(n).name);
    listtagfilenames = {};
    
    
    %Search using acrostic first, if there are multiple files, use exptdate
    %Search for the tag file (a matching CSV file)
    tagid = find(cellfun(@(x) ~isempty(regexpi(x,acrostic,'ONCE')),acrtag,'UniformOutput',1));
    
    if length(tagid)>1 
        subacrtag = acrtag(tagid);
        sublisttag = listtag(tagid);
        tagid = find(cellfun(@(x) ~isempty(regexpi(x,exptdate,'ONCE')),subacrtag,'UniformOutput',1)); %Check with the experimental date
        
        if length(tagid)~=1 %Fail to use exptdate, ask for a user's input
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
                        
                        tagid = 0;
                        break
                    end
                catch
                    return
                end
                drawnow %Feed the current event to update tb1/2/3 values
            end
            
            if tagid==0
                %Missing CSV files
                missing_tags = missing_tags+1;
                missing_tags_files = [missing_tags_files;files(n).name];
                set(inp.resultbox,'String',['.CSV for ',acrostic,' is not found']);
                continue;
            else %
                listtagfilenames = listtag(tagid);
            end
        end
        
    
    elseif ~isempty(tagid)
        filename = listtag{tagid}; % tagfile (with .csv)
        listtagfilenames = {filename};        
    end
    
    if isempty(tagid)
        %Missing Tags
        missing_tags = missing_tags+1;
        missing_tags_files = [missing_tags_files;files(n).name]; %Missing .csv files
        set(inp.resultbox,'String',['.CSV for ',acrostic,' is not found']);
    else
        %% LOOP TAGFILES
        for nfilename=1:length(listtagfilenames)
            filename = listtagfilenames{nfilename};
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
                    if ~isempty(baselineRegions)
                        %% Loop Baseline
                        for nbase=1:length(baselineRegions)
                            basename = baselineRegions{nbase};
                            indBase = strcmp(basename,tagcol); %logical
                            if ~any(indBase)
                                missing_roi_csvfiles =[missing_roi_csvfiles;[filename,' - ',basename]];
                                continue
                            end
                            
                            if sum(indBase)>1

                                missing_roi_csvfiles =[missing_roi_csvfiles;[filename,' - has multiple ',basename]];

                                t1Base = startTime(indBase);
                                t2Base = stopTime(indBase);
                                t1Base = t1Base(1);
                                t2Base = t2Base(1);
                            else
                                t1Base = startTime(indBase);
                                t2Base = stopTime(indBase);
                                
                            end
                                    
                            %% Loop Tasks
                            for ntask=1:length(taskRegions)
                                taskname = taskRegions{ntask};
                                indTask = strcmp(taskname,tagcol); %logical
                                if ~any(indTask)
                                    missing_roi_csvfiles =[missing_roi_csvfiles;[filename,' -',taskname]];

                                    continue
                                end
                                
                                if sum(indTask)>1 %Same name on one file
                                    t1Task = startTime(indTask);
                                    t2Task = stopTime(indTask);
                                    t1Task = t1Task(1);
                                    t2Task = t2Task(2);
                                    
                                    missing_roi_csvfiles =[missing_roi_csvfiles;[filename,' - has multiple ',taskname]];

                                    
                                else
                                    t1Task = startTime(indTask);
                                    t2Task = stopTime(indTask);
                                    
                                end

                                %% Loop variables
                                for nvar=1:length(varlist)
                                    fs = fslist(nvar);
                                    if isfield(s,varlist{nvar})
                                        signal = eval(['s.',varlist{nvar}]);
                                    else
                                        continue
                                    end
                                    if isempty(signal)
                                        %Empty variable
                                        missing_signals = missing_signals+1;
                                        missing_signals_files = [missing_signals_files;name];
                                        continue
                                    end
                                    if isrow(signal)
                                        signal = signal';
                                    end
                                    %Calculate 95% of the original flow
                                    pct95 =  prctile(signal,95); %Percentile from the signal (can be trend or signal)
                                    %Find
                                    minval = min(signal);
                                    
                                    if isfilter
                                        switch filtertype
                                            case 1 %median filter window
                                                signal = getTrend(signal,'window',round(medianfilterwindow*fs));
                                            case 2
                                                signal = lowfilterHamming10(signal);
                                        end
                                    end
                                    
                                    %Normalized signal
                                    if isnorm
                                        signal = (signal)/pct95; %Normalize by 95% maxflow
                                    end
                                    i1Base = round(t1Base*fs+1);
                                    i2Base = round(t2Base*fs+1);
                                    baseline_med = median(signal(i1Base:i2Base));
                                    baseline_mean = mean(signal(i1Base:i2Base));
                                    %% =================Generate Output===========================
                                    newtag = cell(1,ncol_info+ncol_feature+ncol_curvefeature+ncol_mvasoc);
                                    newtag{1,1} = ff;
                                    newtag{1,2} = acrostic;
                                    newtag{1,3} = exptdate;
                                    newtag{1,4} = varlist{nvar};
                                    newtag{1,5} = filename; %Global Tag
                                    newtag{1,6} = taskname;%Subregion
                                    newtag{1,7} = basename;
                                    
                                    
                                    
                                    i1Task = round(t1Task*fs+1);
                                    i2Task = round(t2Task*fs+1);
                                    try
                                        y = signal(i1Task:i2Task);
                                    catch
                                        
                                        continue;
                                    end

                                    for m=1:ncol_feature %Loop feature
                                        if strcmpi(feature{m},'area')
                                            if ~isempty(baseline_med)
                                                dt = (1/(60*fs));
                                                
                                                %% Recalculate area
                                                temp = dt*cumtrapz(y);
                                                
                                                %Baseline median
                                                time_y = (length(y)-1)*(dt); %min
                                                try
                                                    output = (baseline_med*time_y)-temp(end);
                                                catch
                                                    disp('Error calculating the area');
                                                end
                                                
                                                newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
                                                
                                                %Baseline mean
                                                %output = (baseline_mean*time_y)-temp(end);
                                                %newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
                                                
                                            else
                                                newtag{1,ncol_inf+m} = 0; %num2str(output,'%10.2f');
                                            end
                                        elseif strcmpi(feature{m},'mean')
                                            output = mean(y);
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                        elseif strcmpi(feature{m},'median')
                                            output = median(y);
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                        elseif strcmpi(feature{m},'min')
                                            output = min(y);
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                        elseif strcmpi(feature{m},'max')
                                            output = max(y);
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                        elseif strcmpi(feature{m},'duration')
                                            output = t2Task-t1Task;
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
                                        elseif strcmpi(feature{m},'maxflow')
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',pct95)); %num2str(output,'%10.4f');
                                        elseif strcmpi(feature{m},'cv')                                                                                                                    
                                            %output = var(y);
                                            if mean(y)~=0
                                                output = std(y)./(mean(y)); %Coefficient of variation
                                            else
                                                output = 0;
                                            end
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output));                                                                                                                    
                                        end
                                   
                                    end
                                    %Add curve fitting features
                                    if descriptiveflag(9) %is curve fitting enabled?, add curve fitting features to the output                               

                                        try
                                            x = (0:length(y)-1)/fs; x = x';
                                            %Initial parameters
                                            %Expo = scaling,timeconstant
                                            %Poly = order
                                            %Sigmoid = upper,lower
                                            switch curvefittingtype
                                                case 1 %Just use whatever there is, for simplicity
                                                    initpar = [];
                                                    
                                                case 2
                                                    initpar = expocurve;
                                                case 3
                                                    initpar = polycurve;
                                                case 4
                                                    initpar = sigmoidcurve;
                                                    
                                            end
                                            
                                            curvefitting_result = fex_fitcurve(y,x,'AnalysisRegion',analysisregion,'Curvetype',curvefittingtype,'Init',initpar,'ROIname',taskname,'Varname',varlist{nvar},'Filename',filename,'ShowFigure',0);
                                            curvefeature = curvefitting_result.feature;
                                            
                                            %Add output from the curvefitting, after LOOP FEATURE
                                            %% Add values
                                            for nc=1:ncol_curvefeature
                                                newtag{1,ncol_info+ncol_feature+nc} = str2double(sprintf('%0.4f',curvefitting_result.par(nc)));
                                            end
                                            
                                            
                                        catch
                                            set(inp.resultbox,'String',['There is an error while fitting a curve during ',taskname]);
                                            curvefeature = repmat({'Empty'},1,ncol_curvefeature); %Empty features

                                        end
                                    end
                                    if descriptiveflag(10) %mvasoc enabled
                                        offset = ncol_info+ncol_feature+ncol_curvefeature;
                                        [Mvasoc, Avasoc, Tvasoc, Nvasoc] = get_vasoc_features(y, fs);
                                        newtag{1,offset+1} = str2double(sprintf('%0.4f',Mvasoc));
                                        newtag{1,offset+2} = str2double(sprintf('%0.4f',Avasoc));
                                        newtag{1,offset+3} = str2double(sprintf('%0.4f',Tvasoc));
                                        newtag{1,offset+4} = str2double(sprintf('%0.4f',Nvasoc));
                                        vasocfeature = {'mvasoc','avasoc','tvasoc','nvasoc'};
                                    end
                                    
                                    allresults = [allresults;newtag];
                                    
                                end
                                
                                
                            end
                            
                        end
                        
                    else
                        %Find Task1
                        for ntask=1:length(taskRegions)
                            taskname = taskRegions{ntask};
                            indTask = strcmp(taskname,tagcol); %logical
                            if ~any(indTask)
                                set(inp.resultbox,'String',[taskname,' does not exist in ',filename]);

                                continue
                            end
                            
                                if sum(indTask)>1 %Same name on one file
                                    t1Task = startTime(indTask);
                                    t2Task = stopTime(indTask);
                                    t1Task = t1Task(1);
                                    t2Task = t2Task(2);
                                    
                                    missing_roi_csvfiles =[missing_roi_csvfiles;[filename,' - has multiple ',taskname]];

                                    
                                else
                                    t1Task = startTime(indTask);
                                    t2Task = stopTime(indTask);
                                    
                                end
                                
                            
                            for nvar=1:length(varlist)
                                if isfield(s,varlist{nvar})
                                    signal = eval(['s.',varlist{nvar}]);
                                end

                                fs = fslist(nvar);
                                if isempty(signal)
                                    %Empty variable
                                    missing_signals = missing_signals+1;
                                    missing_signals_files = [missing_signals_files;name];
                                    continue
                                end
                                
                                if isrow(signal)
                                    signal = signal';
                                end
                                
                                
                                %Calculate 95% of the original flow
                                pct95 =  prctile(signal,95); %Percentile from the signal (can be trend or signal)
                                %Find
                                minval = min(signal);
                                
                                if isfilter
                                    switch filtertype
                                        case 1 %median filter window
                                            signal = getTrend(signal,'window',round(medianfilterwindow*fs));
                                        case 2
                                            signal = lowfilterHamming10(signal);
                                    end
                                end
                                
                                %Normalized signal
                                if isnorm
                                    signal = (signal)/pct95; %Normalize by 95% maxflow
                                end
                                
                                
                                baseline_med = [];
                                baseline_mean = [];
                                % =================Generate Output===========================
                                newtag = cell(1,ncol_info+ncol_feature+ncol_curvefeature+ncol_mvasoc);
                                newtag{1,1} = ff;
                                newtag{1,2} = acrostic;
                                newtag{1,3} = exptdate;
                                newtag{1,4} = varlist{nvar};
                                newtag{1,5} = filename; %Global Tag
                                newtag{1,6} = taskname;%Subregion
                                newtag{1,7} = 'None';
                                
                                
                                i1Task = round(t1Task*fs+1);
                                i2Task = round(t2Task*fs+1);
                                try
                                    y = signal(i1Task:i2Task);
                                catch
                                    
                                    continue;
                                end
                                
                                for m=1:ncol_feature
                                    if strcmpi(feature{m},'area')
                                        if ~isempty(baseline_med)
                                            dt = (1/(60*fs));
                                            
                                            %Recalculate area
                                            temp = dt*cumtrapz(y);
                                            
                                            %Baseline median
                                            time_y = (length(y)-1)*(dt); %min
                                            try
                                                output = (baseline_med*time_y)-temp(end);
                                            catch
                                                set(inp.resultbox,'String',['There is an error while calculating the area for ',taskname]);

                                            end
                                            
                                            newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
                                                                                   
                                            
                                        else
                                            newtag{1,ncol_info+m} = 0; %num2str(output,'%10.2f');
                                        end
                                    elseif strcmpi(feature{m},'mean')
                                        output = mean(y);
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                    elseif strcmpi(feature{m},'median')
                                        output = median(y);
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                    elseif strcmpi(feature{m},'min')
                                        output = min(y);
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                    elseif strcmpi(feature{m},'max')
                                        output = max(y);
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');
                                    elseif strcmpi(feature{m},'duration')
                                        output = t2Task-t1Task;
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
                                    elseif strcmpi(feature{m},'maxflow')
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',pct95)); %num2str(output,'%10.4f');
                                    elseif strcmpi(feature{m},'cv')
                                        
                                        %output = var(y);
                                        if mean(y)~=0
                                            output = std(y)./(mean(y)); %Coefficient of variation
                                        else
                                            output = 0;
                                        end
                                        newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output));
                                        
                                    end
                                    
                                end
                                %Add curve fitting features
                                if descriptiveflag(9) %is curve fitting enabled?, add curve fitting features to the output
                                    
                                    try
                                        x = (0:length(y)-1)/fs; x = x';
                                        %Initial parameters
                                        %Expo = scaling,timeconstant
                                        %Poly = order
                                        %Sigmoid = upper,lower
                                        switch curvefittingtype
                                            case 1 %Just use whatever there is, for simplicity
                                                initpar = [];
                                                
                                            case 2
                                                initpar = expocurve;
                                            case 3
                                                initpar = polycurve;
                                            case 4
                                                initpar = sigmoidcurve;
                                                
                                        end
                                        
                                        curvefitting_result = fex_fitcurve(y,x,'AnalysisRegion',analysisregion,'Curvetype',curvefittingtype,'Init',initpar,'ROIname',taskname,'Varname',varlist{nvar},'Filename',filename,'ShowFigure',0);
                                        curvefeature = curvefitting_result.feature;
                                        
                                        %Add output from the curvefitting, after LOOP FEATURE
                                        %% Add values
                                        for nc=1:ncol_curvefeature
                                            newtag{1,ncol_info+ncol_feature+nc} = str2double(sprintf('%0.4f',curvefitting_result.par(nc)));
                                        end
                                        
                                        
                                    catch
                                          set(inp.resultbox,'String',['There is an error while fitting a curve during ',taskname]);
                                          curvefeature = repmat({'Empty'},1,ncol_curvefeature); %Empty features

                                    end
                                end
                                
                                if descriptiveflag(10) %mvasoc enabled
                                    offset = ncol_info+ncol_feature+ncol_curvefeature;
                                    [Mvasoc, Avasoc, Tvasoc, Nvasoc] = get_vasoc_features(y, fs);
                                    newtag{1,offset+1} = str2double(sprintf('%0.4f',Mvasoc));
                                    newtag{1,offset+2} = str2double(sprintf('%0.4f',Avasoc));
                                    newtag{1,offset+3} = str2double(sprintf('%0.4f',Tvasoc));
                                    newtag{1,offset+4} = str2double(sprintf('%0.4f',Nvasoc));
                                    vasocfeature = {'mvasoc','avasoc','tvasoc','nvasoc'};
                                end
                                
                                allresults = [allresults;newtag];
                                
                            end
                            
                            
                        end
                        
                    end
            
        end
        
        
    end
    
    
end
catch ME
   disp(ME.message);
   set(inp.resultbox,'String','There is an error occured during Batch Analysis');
  %return
end
%% Output
out.allresults = allresults;
out.missing_signals = missing_signals;
out.missing_tags = missing_tags;
out.missing_signals_files = missing_signals_files;
out.missing_tags_files = missing_tags_files;
out.missing_roi_csvfiles = missing_roi_csvfiles;

out.rounds = rounds;
out.feature = [feature,curvefeature,vasocfeature]; %All features export from this function

end

