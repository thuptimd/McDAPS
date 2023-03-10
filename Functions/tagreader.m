function [data] = tagreader(filename)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% 2016-04-20
% Read defined-tag csv or spread sheet file
%% INITIATION
tagcol = [];
startTime = [];
stopTime = [];
expttime = [];
exptdate = [];
data.tagcol = [];
data.startTime = [];
data.stopTime = [];
data.expttime = [];
data.exptdate = [];
data.subjnum = [];

%% CHECK FILE EXTENSION
[pathstr,name,ext] = fileparts(filename); 

if strcmp(ext,'xlsx') %Able to use this code if
    %% == import data == 
    % RETURNS STRUCT for .xlsx file
    % RETURNS TEXT for .csv file
    % xlsread in importdata only works in WINDOW!!
    if ispc
        try
            content = importdata(filename);
            textdata = content.textdata;
            numericdata = content.data;
            tagcol = textdata(2:end,12);
            startTime = numericdata(2:end,10);
            stopTime = numericdata(2:end,11);
            expttime = textdata{2,6};
            exptdate = numericdata{2,5};
        catch
            disp('CANNOT USE IMPORTDATA');
        end
    else
        warndlg('CANNOT READ .xlsx in MAC');
    end

elseif strcmp(ext,'.csv')
    %% == text scan =====
    % DID NOT WORK WITH .xlsx extension
    % ONLY WORKS FOR .CSV FILE
    fid = fopen(filename);
    try
        header = textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',1,'delimiter',',');
        if ~strcmpi(header{12},'tag')
            return
        end
        % read content
        c = textscan(fid,'%s%s%s%s%s%s%s%s%f%f%f%s%s%s%s','delimiter',','); %Assume this structure
        fclose(fid);
    catch
        return
    end
    tagcol = c{12}; %cell
    startTime = c{10}; %array
    stopTime = c{11}; %array
    subjnum = c{4}; subjnum = subjnum{1}; %string
    expttime = c{6}; expttime = expttime{1}; %string
    exptdate = c{5}; exptdate = exptdate{1}; %string i.e.,1/29/2016
    
else
   %% UNABLE TO READ THE FILE 
   warndlg('THE FILE EXTENSION SHOULD BE .csv or .xlsx');
    
end
%% OUTPUT
try
    if ~isempty(tagcol{1}) && ~isnan(startTime(1))
        data.tagcol = strtrim(tagcol); %Remove leading and trailing whitespace from the tag
        data.startTime = startTime;
        data.stopTime = stopTime;
        data.expttime = expttime;
        data.exptdate = exptdate;
        data.subjnum = subjnum;

    end
catch
   warning('Tag Reader : Line 75 Please check');
   return 
    
    
    
end








end

