function [colId] = getColId(colname,mode,varargin)

%1.Filename              
%2.Module                
%3.Acrostic
%4.SubjID
%5.ExptDate
%6.ExptTime
%7.Variable
%8.Side
%9.Sampling frequency
%10.Begin
%11.End
%12.Tag
%13.Operation
%14.Operation Tag
%15.Value
if isempty(varargin)
    dispHeader = {'select','acrostic','tag','begin','end','exptdate','variable','side','fs','operation','operationtag','value'};
elseif strcmp(varargin{1},'TagManager'),
    dispHeader = {'select','acrostic','subjid','exptdate','variable','side','fs','begin','end','tag','operation','operationtag','value'};
else
    disp('getColId varargin');
    dispHeader = {'select','acrostic','tag','begin','end','exptdate','variable','side','fs','operation','operationtag','value'};
end   
    fileHeader = {'filename','module','acrostic','subjid','exptdate','expttime','variable','side','fs','begin','end','tag','operation','operationtag','value'};
if strcmp(mode,'display')
    celltemp = strfind(dispHeader,colname);
    colId = find(cellfun(@isempty,celltemp)==0);
    colId = colId(1); % case tag/operationtag
elseif strcmp(mode,'file')
    celltemp = strfind(fileHeader,colname);
    colId = find(cellfun(@isempty,celltemp)==0);
    colId = colId(1);
end
    