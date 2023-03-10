function [Nmat,allresults,varlist,taglist,missing_csvfiles,missing_signal_matfiles,missing_tags] = batchMovingCorrelation(matpath,tagpath,xvarlist,yvarlist,xfslist,yfslist,baseRegions,testRegions,ndelay,opt)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%  Function arguments
%matpath = the directory contains processed matfiles
%tagpath = the directory contains .csv defined tags

%xvarlist = list of therm signals
%yvarlist = list of response signals
%xfslist = list of sampling frequency for therm signals
%yfslist = list of sampling frequency for response signals
%baseRegions = baseline regions for null distribution
%testRegions = regions for cross-correlation
%ndelay = the window allow for extension
%opt = sign of expected r
% 2016-05-11 

%% Test script
%matpath ='/Users/To-Ey/Documents/SCD/GUITestData/DummyPainProcessed_Data';
%tagpath = '/Users/To-Ey/Documents/SCD/GUITestData/DummyPainTags';
% pos = [];
% xvarlist = {'therm'};
% yvarlist = {'rri','oxipamp'};
% xfslist = [30]; 
% yfslist = [30,30];
% baseRegions = {'truebaseline1'};
% testRegions = {'task1'};
% ndelay = 20; %10secs times 2 hz
% opt = 'positive';




%% Initiate Nmat, Nx=#signal1, Ny=#signal2, Nbasetag, Ntesttag 
files=dir(fullfile(matpath,'*.mat')); %MATFILES
listtag = dir(tagpath);
listtag = {listtag.name};
ind = cellfun(@(x) length(x)<5, listtag,'UniformOutput',1); %GET RID OF non-csv file
listtag(ind) = [];
listtag = listtag'; %column vector

Nmat = length(files);
Nx = length(xvarlist);
Ny = length(yvarlist);
Nbase = length(baseRegions);
Ntest = length(testRegions);

fresamp = 2; %Downsample from the original freq to fresamp
allresults = {};


%% Missing variables,tags,baseline regions, test regions
%Search if
varlist = union(xvarlist,yvarlist); %Combine two cells with no repitions
taglist = union(baseRegions,testRegions);
missing_csvfiles = {};
missing_signal_matfiles = cell(length(varlist),1); 
missing_tags = cell(length(taglist),1); %Store .csv file that misses the region


for nmat=1:Nmat
   %% Search .csv file for this mat variable
   % Report if the .csv file doesn't exist
   % If it exists get all the tags
   name = files(nmat).name;
   s =  load(fullfile(matpath,name));
   
   acrostic = name(1:5); %acrostic for an individual subj
   name = name(10:end);
   datei = strfind(name,'2'); %search for year
   exptdate = name(datei:datei+7);
   
   %Search for the tag file
   temp = regexpi(listtag,acrostic); %No case-sensitive
   tagid = find(cellfun(@(x) ~isempty(x),temp,'UniformOutput',1)); %tagid can has multiple values
   
   if isempty(tagid)
       %Missing Tags
       missing_csvfiles = [missing_csvfiles,{files(nmat).name}];
       disp(['No tag for:',files(nmat).name]);
       continue;
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
           expttime = content.expttime;
       else
           continue;
       end
   end
   
   for nx=1:Nx %i.e., Therm signals
       if ~isfield(s,xvarlist{nx})
           logicalIND = find(strcmp(varlist,xvarlist{nx}));
           temp = missing_signal_matfiles{logicalIND};
           
           if isempty(temp)
               temp = {files(nmat).name};
               missing_signal_matfiles{logicalIND} = temp;
           else
               if ~any(strcmp(temp,files(nmat).name)) %Already report this filename
                   temp = [temp,files(nmat).name];
                   missing_signal_matfiles{logicalIND} = temp;
               end
           end
           %report 
           continue; 
       end
       
       x = eval(['s.',xvarlist{nx}]);
       fs1 = xfslist(nx);
       
       if isempty(x)
           logicalIND = find(strcmp(varlist,xvarlist{nx}));
           temp = missing_signal_matfiles{logicalIND};
           
           if isempty(temp)
               temp = {files(nmat).name};
               missing_signal_matfiles{logicalIND} = temp;
           else
               if ~any(strcmp(temp,files(nmat).name)), %Already report this filename
                   temp = [temp,files(nmat).name];
                   missing_signal_matfiles{logicalIND} = temp;
               end
           end
          %report
          continue;
       end
       
       %Always downsample/upsample fs1 and fs2 to 2 Hz
       if fs1<fresamp || fs1>fresamp
           [P,Q] = rat(fresamp/fs1);
           %Signal 1
           x = resample(x,P,Q,0); %filter order = 0
       end

       for ny=1:Ny %i.e., oxipamp 
           if ~isfield(s,yvarlist{ny})
                %report
                logicalIND = find(strcmp(varlist,yvarlist{ny}));
                temp = missing_signal_matfiles{logicalIND};
                
                if isempty(temp)
                    temp = {files(nmat).name};
                    missing_signal_matfiles{logicalIND} = temp;
                else
                    if ~any(strcmp(temp,files(nmat).name)) %Already report this filename
                        temp = [temp,files(nmat).name];
                        missing_signal_matfiles{logicalIND} = temp;
                    end
                end
                continue;
           end
           
           y = eval(['s.',yvarlist{ny}]);
           fs2 = yfslist(ny);
           
           if isempty(y)
              %report
              logicalIND = find(strcmp(varlist,yvarlist{ny}));
              temp = missing_signal_matfiles{logicalIND};
              
              if isempty(temp)
                  temp = {files(nmat).name};
                  missing_signal_matfiles{logicalIND} = temp;
              else
                  if ~any(strcmp(temp,files(nmat).name)) %Already report this filename
                      temp = [temp,files(nmat).name];
                      missing_signal_matfiles{logicalIND} = temp;
                  end
              end
              continue;
           end

           if fs2<fresamp || fs2>fresamp
               [P,Q] = rat(fresamp/fs2);
               %Signal 2
               y = resample(y,P,Q,0); %filter order = 0
           end
           
           for nbase=1:Nbase
               %% Search baseline region in the tag
               basename = baseRegions{nbase};
               indBase = strcmpi(basename,tagcol);
               
               if any(indBase)
                   tbase1 = startTime(indBase);
                   tbase2 = stopTime(indBase);
                   ibase1 = round(tbase1*fresamp+1);
                   ibase2 = round(tbase2*fresamp+1);
               else %No base - report
                   logicalIND = find(strcmp(taglist,basename));
                   temp = missing_tags{logicalIND};
                    if isempty(temp)
                        temp = {files(nmat).name};
                        missing_tags{logicalIND} = temp;
                    else
                        if ~any(strcmp(temp,files(nmat).name))
                            missing_tags{logicalIND} = [temp,files(nmat).name];
                        end
                    end
               end

               for ntest=1:Ntest  
                                     
                   %% Search test region in the tag
                   testname = testRegions{ntest};
                   indTest = strcmpi(testname,tagcol);
                   
                   if any(indTest)
                       ttest1 = startTime(indTest);
                       ttest2 = stopTime(indTest);
                       itest1 = round(ttest1*fresamp+1);
                       itest2 = round(ttest2*fresamp+1);
                       
                   else %No test region - report
                       %Save test region for once
                       logicalIND = find(strcmp(taglist,basename));
                       temp = missing_tags{logicalIND};
                       if isempty(temp)
                           temp = {files(nmat).name};
                           missing_tags{logicalIND} = temp;
                       else
                           if ~any(strcmp(temp,files(nmat).name))
                                missing_tags{logicalIND} = [temp,files(nmat).name];
                           end
                       end
                       continue; %Go to the next test region
                   end
                   
                   if ~any(indBase)
                       break; %Go to the outer loop for the next baseline
                   end
                   
                   %% =================Generate Output===========================
                   newtag = cell(1,22);
                   newtag{1,1} = acrostic;
                   newtag{1,2} = subjnum;
                   newtag{1,3} = exptdate;
                   newtag{1,4} = expttime;
                   newtag{1,5} = [xvarlist{nx},'&',yvarlist{ny}];
                   newtag{1,6} = '-'; %side
                   newtag{1,7} = fresamp;%fresamp
                   newtag{1,8} = testname;
                   newtag{1,9} = ttest1;
                   newtag{1,10} = ttest2;
                   newtag{1,11} = basename;
                   newtag{1,12} = tbase1;
                   newtag{1,13} = tbase2;
                   
                   
                  
                   %% Compute cross-correlation
                   [pearson,spearman] = compareRvsBaseNullR(x,y,ndelay,[ibase1,ibase2],[itest1,itest2],opt);
                   if isempty(pearson) 
                      disp('cannot construct null distribution');
                      continue; %suspect that the null dist. cannot be constructed 
                   elseif isempty(spearman)
                      spearman.r = [];
                      spearman.p = [];
                      spearman.d = [];
                      spearman.slope = [];                     
                   end
                   
                   newtag{1,14} = pearson.N;
                   newtag{1,15} = pearson.r;
                   newtag{1,16} = pearson.p;
                   newtag{1,17} = pearson.d;
                   newtag{1,18} = pearson.slope;
                   newtag{1,19} = spearman.r;
                   newtag{1,20} = spearman.p;
                   newtag{1,21} = spearman.d;
                   newtag{1,22} = spearman.slope;
                   
                   allresults = [allresults;newtag];
                   newtag = [];
                   
               end
           end
       end
   end
    
end


end

