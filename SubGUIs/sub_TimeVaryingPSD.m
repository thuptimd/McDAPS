function varargout = sub_TimeVaryingPSD(varargin)
% SUB_TIMEVARYINGPSD MATLAB code for sub_TimeVaryingPSD.fig
%      SUB_TIMEVARYINGPSD, by itself, creates a new SUB_TIMEVARYINGPSD or raises the existing
%      singleton*.
%
%      H = SUB_TIMEVARYINGPSD returns the handle to a new SUB_TIMEVARYINGPSD or the handle to
%      the existing singleton*.
%
%      SUB_TIMEVARYINGPSD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_TIMEVARYINGPSD.M with the given input arguments.
%
%      SUB_TIMEVARYINGPSD('Property','Value',...) creates a new SUB_TIMEVARYINGPSD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_TimeVaryingPSD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_TimeVaryingPSD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_TimeVaryingPSD

% Last Modified by GUIDE v2.5 05-May-2016 14:13:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_TimeVaryingPSD_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_TimeVaryingPSD_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sub_TimeVaryingPSD is made visible.
function sub_TimeVaryingPSD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_TimeVaryingPSD (see VARARGIN)

% Choose default command line output for sub_TimeVaryingPSD
handles.output = hObject;

% Set handles property to point at Data Browser
handles.DataBrowser = [];

% Check if hObject of the main_DataBrowser is passed in varargin
DataBrowserInput = find(strcmp(varargin, 'DataBrowser'));
if ~isempty(DataBrowserInput)
   handles.DataBrowser = varargin{DataBrowserInput+1};
end



init(hObject,handles);
handles = guidata(hObject);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_TimeVaryingPSD wait for user response (see UIRESUME)
% uiwait(handles.figTimeVaryingPSD);


% --- Outputs from this function are returned to the command line.
function varargout = sub_TimeVaryingPSD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;






function editTVPStatus_Callback(hObject, eventdata, handles)
% hObject    handle to editTVPStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVPStatus as text
%        str2double(get(hObject,'String')) returns contents of editTVPStatus as a double

%============================= Non-callback Functions  ====================================
function init(hObject,handles)

%% Modified 13June2019
figw = 1280;
figh = 720;
but_width = 67;
txt_width = 54;
but_height = 21.6;

set(handles.figTimeVaryingPSD,'Unit','pixels','Position',[511 100 figw figh],'Name','Time-Varying PSD  06/14/2019','Resize','on');

if ispc %Set the fontSize for windows & mac
    fntsize = 10;
else
    fntsize = 14;
end

%Fontsize, locations of GUI objects
%panelSPWrkspc
set(handles.panelSPWrkspc,'FontSize',fntsize,'Unit','normalized');
set(handles.listWrkspc,'FontSize',fntsize);
set(handles.txtFilename,'FontSize',fntsize);
set(handles.editFilename,'FontSize',fntsize);

%panelSignal
set(handles.panelSignal,'FontSize',fntsize,'Unit','normalized');
panelChildren = get(handles.panelSignal,'Children');
set(panelChildren,'FontSize',fntsize);

%panelMethods
set(handles.panelMethods,'FontSize',fntsize,'Unit','normalized');
panelChildren = get(handles.panelMethods,'Children');
set(panelChildren,'FontSize',fntsize);

%panelDataRange
set(handles.panelDataRange,'FontSize',fntsize,'Unit','normalized');
panelChildren = get(handles.panelDataRange,'Children');
set(panelChildren,'FontSize',fntsize);


%panelRecentComputation
set(handles.panelRecentComputation,'FontSize',fntsize,'Unit','normalized');
panelChildren = get(handles.panelRecentComputation,'Children');
set(panelChildren,'FontSize',fntsize);

%panelTVPAxes
%panelBatch is a child of panelTVPAxes so I have to re-assign its parent
%Always Keep panelBatch unit pixels 
set(handles.panelBatch,'Parent',handles.figTimeVaryingPSD);
set(handles.panelBatch,'Unit','Pixels','Position',[0 0 figw figh],'Title','Batch processing - Time Varying PSD','FontSize',fntsize,'FontWeight','bold'); 
panelChildren = get(handles.panelBatch,'Children');
set(panelChildren,'Unit','pixels','FontUnits','pixels','FontSize',fntsize);


%panelBSignals
set(handles.panelBSignals,'Parent',handles.panelBatch,'Unit','pixels','Position',[20 300 600 260],'FontUnits','pixels','FontSize',fntsize,'Title','Select Variables','Unit','normalized');
panelChildren_sub = get(handles.panelBSignals,'Children');
set(panelChildren_sub,'FontUnits','pixels','FontSize',fntsize,'Enable','off');
set(handles.editBFs,'Unit','pixels','Position',[14 14 but_width 30]);
set(handles.butBAddVar,'Unit','pixels','Position',[handles.editBFs.Position(1)+but_width+5 14 160 30]);
set(handles.editBSignal,'Unit','pixels','Position',[handles.editBFs.Position(1) handles.butBAddVar.Position(2)+5+30 but_width+160+5 30]);
set(handles.chkEnableVarName,'Unit','pixels','Position',[handles.editBSignal.Position(1)+handles.editBSignal.Position(3) handles.editBSignal.Position(2) but_width but_height],'Enable','on');
set(handles.listBVar,'Unit','pixels','Position',[handles.editBFs.Position(1) handles.editBSignal.Position(2)+5+30 but_width+160+5 150]);
set(handles.listSelectedVar,'Unit','pixels','Position',[handles.listBVar.Position(1)+handles.listBVar.Position(3)+50 handles.listBVar.Position(2) 160 80]);
set(handles.txtBSignal,'HorizontalAlignment','left','Unit','pixels','Position',[handles.listSelectedVar.Position(1) handles.listSelectedVar.Position(2)+85 txt_width but_height]);
set(handles.butDBatchVar,'Unit','pixels','Position',[sum(handles.listSelectedVar.Position([1,3]))+5 handles.listSelectedVar.Position(2) 0.5*but_width 30]);

set(panelChildren_sub,'Unit','normalized','Enable','off');


%%panelBROI
set(handles.panelBROI,'Unit','pixels','Position',[640 300 600 260],'Unit','normalized','FontUnits','pixels','Title','Region of Interests (ROIs)','FontSize',fntsize);
panelChildren_sub = get(handles.panelBROI,'Children');
set(panelChildren_sub,'Unit','pixels','FontUnits','pixels','FontSize',fntsize,'Enable','off');
%panelROI left objects
set(handles.editTagName,'Position',[14 14+but_height+5 80 30]);
set(handles.butAddROIName,'Position',[handles.editTagName.Position(1)+85 14+but_height+5 160 30]);
set(handles.butBROI,'Position',[14 handles.butAddROIName.Position(2)+35 165 30]);
set(handles.listAllTags,'Position',[14 handles.butBROI.Position(2)+35 165+but_width 100]);

%panelROI right objects
set(handles.butBCompute,'Position',[handles.listAllTags.Position(1)+handles.listAllTags.Position(3)+70 14 80 30]);
set(handles.butBClear,'Position',[handles.butBCompute.Position(1)+handles.butBCompute.Position(3)+5 handles.butBCompute.Position(2) 80 30]);
set(handles.chkBWelch,'Position',[handles.butBCompute.Position(1) handles.butBCompute.Position(2)+but_height+15 but_width but_height]);
set(handles.chkBAR,'Position',[handles.chkBWelch.Position(1)+5+but_width handles.chkBWelch.Position(2) but_width but_height]);
set(handles.listSelectRegion,'Position',[handles.butBCompute.Position(1) handles.listAllTags.Position(2) handles.listAllTags.Position(3) handles.listAllTags.Position(4)]);
set(handles.txtAnalysis,'HorizontalAlignment','left','Position',[handles.listSelectRegion.Position(1) sum(handles.listSelectRegion.Position([2,4]))+5 txt_width but_height],'String','Analysis');
set(handles.butDBROI,'Position',[sum(handles.listSelectRegion.Position([1,3]))+5 handles.listSelectRegion.Position(2) 0.5*but_width 30]);
set(panelChildren_sub,'Unit','normalized');

%editBResultDisplay
set(handles.editBResultDisplay,'FontUnits','pixels','FontSize',fntsize,'String','','Unit','pixels','Position',[20 20 600 250],'Enable','inactive');


%textBTimeVarying
set(handles.textBTimeVarying,'FontUnits','pixels','FontSize',fntsize,'Unit','pixels','Position',[640 20 600 250],'Enable','inactive')

%txtMatFolder
pos = getpixelposition(handles.editMatpath);
set(handles.txtMatFolder,'FontSize',fntsize,'String','Data Folder:','HorizontalAlignment','right','Unit','pixels','Position',[pos(1)-105 pos(2) 100 30],'Unit','normalized');

%txtTagFolder
pos = getpixelposition(handles.editTagpath);
set(handles.txtTagFolder,'FontSize',fntsize,'HorizontalAlignment','right','String','Tag Folder:','Unit','pixels','Position',[pos(1)-105 pos(2) 100 30],'Unit','normalized');

%txtSaveFolder
pos = getpixelposition(handles.editSavepath);
set(handles.txtSaveFolder,'FontSize',fntsize,'HorizontalAlignment','right','String','Save to','Unit','pixels','Position',[pos(1)-105 pos(2) 100 30],'Unit','normalized');

%Retrieve the opened signals from Data Browser
 
h = guidata(handles.DataBrowser); %Get handles(struct) of DataBrowser
if isfield(h.DB,'varname') && ~isempty(h.DB.varname)
     handles.varname     = h.DB.varname;
     handles.filename    = h.DB.filename;
     handles.acrostic    = h.DB.acrostic;
     handles.subjnum     = h.DB.subjnum;
     handles.exptdate    = h.DB.exptdate;
     handles.expttime    = h.DB.expttime;
     handles.signal      = h.DB.signal;
     handles.fs          = h.DB.fs;
     handles.flagnorm    = h.DB.flagnorm;
     handles.flagdetrend = h.DB.flagdetrend;
     handles.detrend     = h.DB.detrend;
     handles.scale       = h.DB.scale;
     
     %Functions
     handles.getActiveTagEditor = @getActiveTagEditor;
     handles.genDefineRegionTag = @genDefineRegionTag;
     handles.updatePopChoices = @updatePopChoices;
     handles.updatePopMenu = @updatePopMenu;
     
     %========Workspace Panel==========
    varind = 1;
    [~,name,ext] = fileparts(handles.filename{varind});
    set(handles.listWrkspc,'String',handles.varname,'Value',varind,'Enable','on');
    set(handles.editFilename,'String',[name,ext],'Enable','inactive');
     
     
     %==========Plots' Panel===================
     set(handles.axes1,'Visible','off');
     set(handles.axes2,'Visible','off');
     set(handles.axes3,'Visible','off');
     set(handles.axes4,'Visible','off');
     set(handles.axes5,'Visible','off');
     set(handles.txtAxes1,'Visible','off');
     set(handles.txtAxes2,'Visible','off');
     set(handles.txtAxes3,'Visible','off');
     set(handles.txtAxes4,'Visible','off');
     set(handles.txtAxes5,'Visible','off');
     set(handles.txtTime,'Visible','off');
     set(handles.menuMode,'Enable','on');
     set(handles.panelBatch,'Visible','off');
     
     %==========Color's codes====================
     colorcode{1} = [0 0 1];          %blue
     colorcode{2} = [0 0.5 0];        %dark green
     colorcode{3} = [1 0.5 0];        %orange
     colorcode{4} = [0 0.75 0.75];    %teal
     colorcode{5} = [0.75 0 0.75];    %purple
     handles.colorcode = colorcode;
     
     
     
     %==========Data Range's Panel================
     set(handles.popTest,'String',{'<Tags>'},'Value',1,'Enable','off');
     set(handles.popBase,'String',{'<Tags>'},'Value',1,'Enable','off');

 else
    set(handles.menuMode,'Enable','off');
    set(handles.panelBatch,'Visible','on');
    handles.batch.matpath = [];
    handles.batch.tagpath = [];
    handles.batch.savepath = [];
    handles.batch.varlist = [];
    handles.batch.fslist = [];
    handles.batch.taskRegions = [];
    handles.batch.fsvar = [];
     
 end
guidata(hObject,handles)



function [newtags] = genDefineRegionTag(tagrange,handles)
    
varind = 1;
% needed variables
xmin = tagrange(1)./handles.fresamp(varind);
xmax = tagrange(2)./handles.fresamp(varind);
filename = handles.yfilename{varind};
[path,name,ext] = fileparts(filename);
filename = [name,ext];
acrostic = handles.yacrostic{varind};
subjnum = handles.ysubjnum{varind};
fs = handles.fresamp(varind);  
varname = handles.yvarname{varind};
exptdate = handles.yexptdate{varind};
expttime = handles.yexpttime{varind};
  
% new tags
ncol = 15;
newtags = cell(1,ncol); %select one var at a time
%Input will be the cell array
prompt = {'Enter Tag Name'};
def = {'TAG'};
dlg_title = '';
num_lines = 1;
tag = newid(prompt,dlg_title,num_lines,def);

if isempty(tag)
   newtags = [];
   return
end

poptag = get(handles.popTest,'String');
  
for i=1:length(poptag)
  % get tagname
  i1 = strfind(poptag{i},'(')-2;
  tagname = poptag{i}(1:i1);
  if strcmpi(tag{1,1},tagname)
     warndlg('This tagname already exists');
     newtags = [];
     return
  end
end

% extract side if selected variable has side info
rr = strfind(varname,'right');
if ~isempty(rr)
   side = 'right';
else
   ll = strfind(varname,'left');
   if ~isempty(ll)
       side = 'left';
   else
       side = '-';
   end
end

newtags{1,1}  = filename;             %Filename
newtags{1,2}  = 'TVPSD';             %Module
newtags{1,3}  = acrostic;             %Acrostic
newtags{1,4}  = subjnum;              %SubjID
newtags{1,5}  = exptdate;             %ExptDate
newtags{1,6}  = expttime;             %ExptTime
newtags{1,7}  = varname;              %Variable
newtags{1,8}  = side;                 %Side
newtags{1,9}  = fs;                   %Sampling frequency
newtags{1,10} = xmin;                 %Begin
newtags{1,11} = xmax;                 %End
newtags{1,12} = tag{1,1};             %Tag
newtags{1,13} = 'DefineRegion';       %Operation
newtags{1,14} = '-';                   %Operation Tag
newtags{1,15} = NaN;                   %Value

%Update Active Tag Editor (DB or TM). 
handlesTE = getActiveTagEditor(handles);
handlesTE.updateEditorTags(handlesTE,newtags);


function [handlesTE] = getActiveTagEditor(handles)
h = guidata(handles.DataBrowser);
handlesTM = guidata(h.TagManager);

if strcmp(get(h.tableEditor,'Enable'),'on')
    handlesTE = h;
else
    handlesTE = handlesTM;
end

function [str] = updatePopChoices(currentstr,newtags,filename)
% needed variables
% 1. all DefineRegion tags (fullformat)
% 2. filename = [name,ext]

tagcol = 12; % name of tags
begincol = 10;
endcol = 11;
if isempty(currentstr)
    str = {'<Tags>'};
else
    str = currentstr;
end
if ~isempty(newtags)
    % search rowid to the tag of that file
    tagid = find(ismember(newtags(:,1),filename));

    for n=1:length(tagid)
       id = tagid(n);    
       tag = [newtags{id,tagcol},' (',...
             num2str(newtags{id,begincol},'%10.2f'),' - ',...
             num2str(newtags{id,endcol},'%10.2f'),' sec)'];
             str = [str; tag];
    end
end

function [] = updatePopMenu(handles,newtags,mode)
%update when users select signal
varind = 1;
% ischange = false;
switch mode
    case 'test' %select define region button
        % Test
        [pathstr,name,ext] = fileparts(handles.yfilename{varind});
        oldstr = get(handles.popTest,'String');
        str = handles.updatePopChoices(oldstr,newtags,[name,ext]);
        val = length(str);
        set(handles.popTest,'String',str,'Value',val,'Enable','on');
        set(handles.popBase,'String',str);
    case 'base'
        % Base
        [pathstr,name,ext] = fileparts(handles.yfilename{varind});
        oldstr = get(handles.popBase,'String');
        str = handles.updatePopChoices(oldstr,newtags,[name,ext]);
        val = length(str);
        set(handles.popBase,'String',str,'Value',val,'Enable','on');
        set(handles.popTest,'String',str);

    otherwise %delete or update button
        [pathstr,name,ext] = fileparts(handles.yfilename{varind});
        str = handles.updatePopChoices([],newtags,[name,ext]);
        val = 1;
        set(handles.popTest,'String',str,'Value',val);
        set(handles.popBase,'String',str,'Value',val);

end

guidata(handles.popTest,handles);


%==========================================================================================


% --- Executes during object creation, after setting all properties.
function editTVPStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVPStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listWrkspc.
function listWrkspc_Callback(hObject, eventdata, handles)
% hObject    handle to listWrkspc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listWrkspc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listWrkspc
varind = get(handles.listWrkspc,'Value');
[pathstr,name,ext] = fileparts(handles.filename{varind});

%Display info of any operations applied to the selected signal
set(handles.editFilename,'String',[name,ext]);




guidata(hObject, handles); %update handles structure

% --- Executes during object creation, after setting all properties.
function listWrkspc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listWrkspc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editFilename_Callback(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFilename as text
%        str2double(get(hObject,'String')) returns contents of editFilename as a double


% --- Executes during object creation, after setting all properties.
function editFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkTVPNorm.
function chkTVPNorm_Callback(hObject, eventdata, handles)
% hObject    handle to chkTVPNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTVPNorm


% --- Executes on button press in chkTVPDetrend.
function chkTVPDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to chkTVPDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTVPDetrend



function editTVPDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to editTVPDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVPDetrend as text
%        str2double(get(hObject,'String')) returns contents of editTVPDetrend as a double


% --- Executes during object creation, after setting all properties.
function editTVPDetrend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVPDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkTVPScale.
function chkTVPScale_Callback(hObject, eventdata, handles)
% hObject    handle to chkTVPScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTVPScale



function editTVPScale_Callback(hObject, eventdata, handles)
% hObject    handle to editTVPScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVPScale as text
%        str2double(get(hObject,'String')) returns contents of editTVPScale as a double


% --- Executes during object creation, after setting all properties.
function editTVPScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVPScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkTVPYshift.
function chkTVPYshift_Callback(hObject, eventdata, handles)
% hObject    handle to chkTVPYshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTVPYshift


% --- Executes on button press in chkTVPXshift.
function chkTVPXshift_Callback(hObject, eventdata, handles)
% hObject    handle to chkTVPXshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTVPXshift



function editTVPYshift_Callback(hObject, eventdata, handles)
% hObject    handle to editTVPYshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVPYshift as text
%        str2double(get(hObject,'String')) returns contents of editTVPYshift as a double


% --- Executes during object creation, after setting all properties.
function editTVPYshift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVPYshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTVPXshift_Callback(hObject, eventdata, handles)
% hObject    handle to editTVPXshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVPXshift as text
%        str2double(get(hObject,'String')) returns contents of editTVPXshift as a double


% --- Executes during object creation, after setting all properties.
function editTVPXshift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVPXshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkTVPFs.
function chkTVPFs_Callback(hObject, eventdata, handles)
% hObject    handle to chkTVPFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkTVPFs



function editTVPFs_Callback(hObject, eventdata, handles)
% hObject    handle to editTVPFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTVPFs as text
%        str2double(get(hObject,'String')) returns contents of editTVPFs as a double


% --- Executes during object creation, after setting all properties.
function editTVPFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTVPFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSignal_Callback(hObject, eventdata, handles)
% hObject    handle to editSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSignal as text
%        str2double(get(hObject,'String')) returns contents of editSignal as a double


% --- Executes during object creation, after setting all properties.
function editSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkFresamp.
function chkFresamp_Callback(hObject, eventdata, handles)
% hObject    handle to chkFresamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFresamp
if get(hObject,'Value'),
    set(handles.editFresamp,'Enable','on');
else
    set(handles.editFresamp,'Enable','off');
end

guidata(hObject,handles);



function editFresamp_Callback(hObject, eventdata, handles)
% hObject    handle to editFresamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFresamp as text
%        str2double(get(hObject,'String')) returns contents of editFresamp as a double


% --- Executes during object creation, after setting all properties.
function editFresamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFresamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSignal.
function butSignal_Callback(hObject, eventdata, handles)
% hObject    handle to butSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varind = get(handles.listWrkspc,'Value');
y = handles.signal{varind}; %selected signal

if isvector(y) && isnumeric(y) && ~isscalar(y),
    

    %Display selected variable
    selvar = handles.varname{varind};
    
    
    %Apply any operations to the signal    
    yorig = y; %original selected signal
    
    %Transpose signal into a column vector
    if isrow(yorig)
        y = yorig(:);
        flagrow = 1;
    else
        y = yorig;
    end

    %Normalize
    if handles.flagnorm(varind)>0
        y = (y - mean(yorig))/std(yorig); %normalized signal
    end

    %Detrend
    if handles.flagdetrend(varind)>0
        y = detrendPoly(y,handles.detrend(varind)); %detrended signal
    end



    %scale
    y = handles.scale(varind)*y;


    %Transpose signal back to its original form
    if exist('flagrow','var') && flagrow==1
       y = y';
    end
    
    fs = handles.fs(varind);
    
    %Clear variables
    set(handles.editSignal,'String',selvar);

    
    %Store and initialize variables, ordered by the selection
    handles.time = {(0:length(y)-1)'/fs};
    handles.y = {y};
    handles.yvarname = {selvar};
    handles.yfs = fs;
    handles.resp = {[]};
    handles.respname = {[]};
    handles.respfs = [];
    handles.yfilename = handles.filename(varind);
    handles.yacrostic = handles.acrostic(varind);
    handles.ysubjnum  = handles.subjnum(varind);
    handles.yexptdate = handles.exptdate(varind);
    handles.yexpttime = handles.expttime(varind);
    handles.testrange = [0,0];
    handles.baserange = [0,0];
    handles.testtag = {[]};
    handles.basetag = {[]};
    handles.fresamp   = [];
%     handles.freq = {0};
%     handles.ypsd = {0};
    handles.lfp = {[]};
    handles.hfp = {[]};
    handles.lhr = {[]};
    

    
    %Plot Signal
    set(handles.axes1,'Visible','on');
    plot(handles.axes1,handles.time{end},handles.y{end},'Color',handles.colorcode{1});
    set(handles.axes1,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.y{end})),1.2*(max(handles.y{end}))]);
    set(handles.txtAxes1,'String',handles.yvarname{end},'Visible','on');
    set(handles.txtTime,'Visible','on');
    
    %Update pop-up tag
    handlesTE = getActiveTagEditor(handles);
    definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
 
    if ~isempty(definetags),  
        handles.updatePopMenu(handles,definetags,'all');
    end
    
    %Clear respiration
    cla(handles.axes2); set(handles.axes2,'Visible','off');
    set(handles.txtAxes2,'String','Respiration','Visible','off');
    set(handles.editResp,'String','');  
    if get(handles.chkRespAR,'Value'),
        set(handles.butResp,'Enable','on');
    end
    %Clear other axes except Resp
    cla(handles.axes3); set(handles.axes3,'Visible','off');
    cla(handles.axes4); set(handles.axes4,'Visible','off');
    cla(handles.axes5); set(handles.axes5,'Visible','off');
    
    %Disable chkFresamp & editFresamp
    set(handles.butOK,'Enable','on');
    set(handles.chkFresamp,'Enable','on','Value',0);
    set(handles.editFresamp,'Enable','off');
    
    
    %Enable butCompute
    set(handles.butCompute,'Enable','on');
    set(handles.popBase,'Enable','off','Value',1);
    set(handles.popTest,'Enable','off','Value',1);
    set(handles.butBase,'Enable','off');
    set(handles.butTest,'Enable','off');
    
    
else
    warndlg('Selected variable is invalid for computing stationary PSD.','Warning','modal');
    return
    
end
guidata(hObject,handles);


% --- Executes on button press in butResp.
function butResp_Callback(hObject, eventdata, handles)
% hObject    handle to butResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get respiratory signal
varind = get(handles.listWrkspc,'Value');
resp = handles.signal{varind}; %selected signal

if ~strcmp(handles.filename{varind},handles.yfilename{end}),
   msgbox('The respiration should belong to the same file as the signal','Warning','warn');
   return 
end
if isvector(resp) && isnumeric(resp) && ~isscalar(resp)
    
    %Display selected variable
    selvar = handles.varname{varind};
    
    
    %Apply any operations to the signal    
    yorig = resp; %original selected signal

    %Transpose signal into a column vector
    if isrow(yorig)
       resp = yorig(:);
       flagrow = 1;
    else
       resp = yorig;
    end

    %Normalize
    if handles.flagnorm(varind)>0
        resp = (resp - mean(yorig))/std(yorig); %normalized signal
    end

    %Detrend
    if handles.flagdetrend(varind)>0
        resp = detrendPoly(resp,handles.detrend(varind)); %detrended signal
    end


    %scale
    resp = handles.scale(varind)*resp;



    %Transpose signal back to its original form
    if exist('flagrow','var') && flagrow==1
        resp = resp';
    end
        
    fs = handles.fs(varind);
    time = (0:length(resp)-1)'/fs;
    
    %Save respiration to handles
    %Downsample if fresamp exists
    if ~isempty(handles.fresamp),
        fresamp = handles.fresamp(end);
        %Downsample respiration
        if fs>fresamp,
            if ~rem(fs,fresamp) %fs is divisible by fresamp
                resp = downsample(resp, fs/fresamp);
            else
                [p,q] = rat(fresamp/fs);
                resp = resample(resp,p,q,0); %filter order = 0
            end
            %Enable butBase&popBase
            set(handles.butBase,'Enable','on');
            set(handles.popBase,'Enable','on');
            time = handles.time{end};
        elseif fs<fresamp, %Warning 
            msgbox('The sampling frequency of respiration is lower than the downsampled frequency','Warning','warn');
            return           
        end

    end
    handles.resp{end} = resp;
    handles.respname{end} = selvar;
    handles.respfs = fs;
    
    %Display selected variable
    set(handles.editResp,'String',selvar);
    
    %Plot Respiration
    set(handles.axes2,'Visible','on');
    plot(handles.axes2,time,handles.resp{end},'Color',handles.colorcode{2});
    set(handles.axes2,'XLim',[0,ceil(max(time))],'YLim',[0.8*(min(handles.resp{end})),1.2*(max(handles.resp{end}))]);
    set(handles.txtAxes2,'String',handles.respname{end},'Visible','on');
    
    %Link axes
    linkaxes([handles.axes1,handles.axes2],'x');

    
else
    warndlg('Selected variable is invalid for computing stationary PSD.','Warning','modal');
    return
end
guidata(hObject,handles);



function editResp_Callback(hObject, eventdata, handles)
% hObject    handle to editResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResp as text
%        str2double(get(hObject,'String')) returns contents of editResp as a double


% --- Executes during object creation, after setting all properties.
function editResp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkFFT.
function chkFFT_Callback(hObject, eventdata, handles)
% hObject    handle to chkFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkFFT
if get(hObject,'Value')
   set(handles.chkFFT,'Enable','off');
   
   %Enable other methods
   set(handles.chkAR,'Value',0,'Enable','on');
   set(handles.editARorder,'String','','Enable','off');
   set(handles.chkRespAR,'Value',0,'Enable','on');
   set(handles.chkPreFFT,'Value',0,'Enable','on');
   
   %Disable butResp
   set(handles.butResp,'Enable','off');
   set(handles.butBase,'Enable','off');
   set(handles.popBase,'Enable','off');
   
   
   %Resp plot
   if isfield(handles,'resp') && ~isempty(handles.resp{end})
     set(handles.axes2,'Visible','off');
     hline = get(handles.axes2,'Children');
     set(hline,'LineStyle','None');
     set(handles.txtAxes2,'Visible','off');
   end
end

guidata(hObject,handles);


% --- Executes on button press in chkAR.
function chkAR_Callback(hObject, eventdata, handles)
% hObject    handle to chkAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkAR
if get(hObject,'Value')
   set(handles.chkAR,'Enable','off');
   
   %Enable other methods
   set(handles.chkFFT,'Value',0,'Enable','on');
   set(handles.chkRespAR,'Value',0,'Enable','on');
    set(handles.chkPreFFT,'Value',0,'Enable','on');
   set(handles.editARorder,'String','','Enable','on');
   
   %Disable butResp,butBase,popBase & plot
   set(handles.butResp,'Enable','off');
   set(handles.butBase,'Enable','off');
   set(handles.popBase,'Enable','off');
   %Resp plot
   if isfield(handles,'resp') && ~isempty(handles.resp{end})
     set(handles.axes2,'Visible','off');
     hline = get(handles.axes2,'Children');
     set(hline,'LineStyle','None');
     set(handles.txtAxes2,'Visible','off');
   end
end
guidata(hObject,handles);


% --- Executes on button press in chkRespAR.
function chkRespAR_Callback(hObject, eventdata, handles)
% hObject    handle to chkRespAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkRespAR
if get(hObject,'Value')
   set(handles.chkRespAR,'Enable','off');
   
   %Enable other methods
   set(handles.chkFFT,'Value',0,'Enable','on');
   set(handles.chkAR,'Value',0,'Enable','on');
   set(handles.chkPreFFT,'Value',0,'Enable','on');
   set(handles.editARorder,'String','','Enable','off');
   
   %Enable butResp
   if isfield(handles,'y') && ~isempty(handles.y)
     set(handles.butResp,'Enable','on');
   end
   if isfield(handles,'resp') && ~isempty(handles.resp{end})
        if ~isempty(handles.fresamp)
            set(handles.butBase,'Enable','on');
            set(handles.popBase,'Enable','on');
        end
    set(handles.axes2,'Visible','on');
    hline = get(handles.axes2,'Children');
    set(hline,'LineStyle','-'); 
    set(handles.txtAxes2,'Visible','on');
   end
end
guidata(hObject,handles);

% --- Executes on button press in chkPreFFT.
function chkPreFFT_Callback(hObject, eventdata, handles)
% hObject    handle to chkPreFFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of chkPreFFT
if get(hObject,'Value')
   set(handles.chkPreFFT,'Enable','off');
   
   %Enable other methods
   set(handles.chkFFT,'Value',0,'Enable','on');
   set(handles.chkAR,'Value',0,'Enable','on');
   set(handles.editARorder,'String','','Enable','off');
   set(handles.chkRespAR,'Value',0,'Enable','on');
   
   %Disable butResp
   set(handles.butResp,'Enable','off');
   set(handles.butBase,'Enable','off');
   set(handles.popBase,'Enable','off');
   %Resp plot
   if isfield(handles,'resp') && ~isempty(handles.resp{end})
     set(handles.axes2,'Visible','off');
     hline = get(handles.axes2,'Children');
     set(hline,'LineStyle','None');
     set(handles.txtAxes2,'Visible','off');
   end
    
end
guidata(hObject,handles);


function editRespARorder_Callback(hObject, eventdata, handles)
% hObject    handle to editRespARorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRespARorder as text
%        str2double(get(hObject,'String')) returns contents of editRespARorder as a double


% --- Executes during object creation, after setting all properties.
function editRespARorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRespARorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editARorder_Callback(hObject, eventdata, handles)
% hObject    handle to editARorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editARorder as text
%        str2double(get(hObject,'String')) returns contents of editARorder as a double


% --- Executes during object creation, after setting all properties.
function editARorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editARorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in butCompute.
function butCompute_Callback(hObject, eventdata, handles)
% hObject    handle to butCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varind = 1;
windowsize = 60; %size of moving window [sec]
set(handles.chkLHR,'Enable','off');

%===== SANG =====
yorig = handles.y{end};
handles.y{end} = detrendPoly(yorig,5);
%================

if handles.testrange(varind,1)~=0 && handles.testrange(varind,2)~=0
    yarx = handles.y{end};
    test = handles.testrange(1):1:handles.testrange(2);
    if get(handles.chkFFT,'Value')
        [LFPar,HFPar] = movingPSD(yarx(test),handles.fresamp,windowsize,handles.editTVPStatus,'fft');
        set(handles.editMethod,'String','FFT','Enable','inactive','HorizontalAlignment','left');
        set(handles.editBase,'Enable','off');
    elseif get(handles.chkAR,'Value') %AR
            order = get(handles.editARorder,'String');
            order = str2double(order);
            if ~isnan(order) && ~ischar(order) && ~rem(order,1) && order>0
                [LFPar,HFPar] = movingPSD(yarx(test),handles.fresamp,windowsize,handles.editTVPStatus,'arfixed',order);
            else
                %Unadjusted PSD using AR
                [LFPar,HFPar] = movingPSD(yarx(test),handles.fresamp,windowsize,handles.editTVPStatus,'ar');
            end
            set(handles.editMethod,'String','AR','Enable','inactive','HorizontalAlignment','left');
            set(handles.editBase,'Enable','off');
    elseif get(handles.chkPreFFT,'Value') %FFT
           [LFPar,HFPar] = movingPSD(yarx(test),handles.fresamp,windowsize,'whitenfft');
           set(handles.editMethod,'String','Pre-whitened FFT','Enable','inactive','HorizontalAlignment','left');
           set(handles.editBase,'Enable','off');

    elseif get(handles.chkRespAR,'Value') %Resp-adjusted
        if handles.baserange(varind,1) ~=0 && handles.baserange(varind,2) ~=0
            if ~isempty(handles.resp)
                resp = handles.resp{end};
                resp0 = resp(handles.baserange(1):handles.baserange(2));                            
                outresp = TIVPSD(resp0,handles.fresamp,'method','ar','df',0.001,'detrendorder',5);
                [LFPar,HFPar] = movingPSD(yarx(test),handles.fresamp,windowsize,handles.editTVPStatus,'resp-adjusted',resp(test),outresp.Sy); %resp = respiration synchronous with y
                
                set(handles.editMethod,'String','Resp-adjusted','Enable','inactive','HorizontalAlignment','left');
                set(handles.editBase,'String',handles.basetag{end},'Enable','inactive','HorizontalAlignment','left');
            else
                %warning
                msgbox('Please select the respiration!','Warning','warn');
                return    
                
            end
            
        else
            %warning
            msgbox('Please select the respiration baseline!','Warning','warn');
            return    
            
        end
    end
else
    %warning
    msgbox('Please select the test range!','Warning','warn');
    return    
    
end


handles.y{end} = yorig;


%Assign results to variables
handles.lfp{end} = zeros(length(yarx),1);
handles.hfp{end} = zeros(length(yarx),1);

handles.lfp{end}(test) = LFPar(:);
handles.hfp{end}(test) = HFPar(:);

%Plot LFP
set(handles.axes3,'Visible','on');
plot(handles.axes3,handles.time{end},handles.lfp{end},'Color',handles.colorcode{3});
set(handles.axes3,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.lfp{end})),1.2*(max(handles.lfp{end}))]);
set(handles.txtAxes3,'String','LFP','Visible','on');

%Plot HFP
set(handles.axes4,'Visible','on');
plot(handles.axes4,handles.time{end},handles.hfp{end},'Color',handles.colorcode{4});
set(handles.axes4,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.hfp{end})),1.2*(max(handles.hfp{end}))]);
set(handles.txtAxes4,'String','HFP','Visible','on');

%Compute LHR
handles.lhr{end} = zeros(length(yarx),1);
temp = LFPar./HFPar;
temp(isnan(temp)) = 0; %replace NaN with zero
handles.lhr{end}(test) = temp(:);

%Compute LHR
if get(handles.chkLHR,'Value')

   %Plot the results
   set(handles.axes5,'Visible','on');
   plot(handles.axes5,handles.time{end},handles.lhr{end},'Color',handles.colorcode{5});
   set(handles.axes5,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.lhr{end})),1.2*(max(handles.lhr{end}))]);
   set(handles.txtAxes5,'String','LHR','Visible','on');
   
  
    
else
   %Plot the results
   cla(handles.axes5);
   set(handles.axes5,'Visible','off');
   set(handles.txtAxes5,'Visible','off');
 
end

set(handles.chkLHR,'Enable','on');
set(handles.editTest,'String',handles.testtag{end},'Enable','inactive','HorizontalAlignment','left');
linkaxes([handles.axes1,handles.axes2,handles.axes3,handles.axes4,handles.axes5],'x');


guidata(hObject,handles);


% --- Executes on button press in butTest.
function butTest_Callback(hObject, eventdata, handles)
% hObject    handle to butTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Check if the signal is selected
varind = 1;
if ~isempty(get(handles.axes1, 'Children'))
   set(handles.axes1,'Color',[1 0.93 0.93]);
   
   %Select test range
   rect = getrect(handles.axes1); %rect = [xmin ymin width height] (unit = unit of x-axis)

   %Restore color of axes
   set(handles.axes1,'Color',[1,1,1]);
   
   %Check if width of selected region = 0. If so, enable other tools & return.
    if rect(3)==0
        return
    end

    %Get selected range [no. of samples]
    i1 = floor(handles.fresamp(varind)*rect(1));
    i2 = ceil(handles.fresamp(varind)*(rect(1) + rect(3)));
    if i1<1
        i1 = 1;
    end
    if i2>length(handles.y{varind})
        i2 = length(handles.y{varind});
    end
    
    if i1>i2 %Invalid range
        return;
    end
    

    %Generate Tag
    [tag] = genDefineRegionTag([i1,i2],handles);
        
    if isempty(tag)
        return;
    end
    %Assign testrange
    handles.testrange(varind,1) = i1;
    handles.testrange(varind,2) = i2;
    
    %Get tagname
    handles.testtag{varind} = tag{1,12};
       
    %Update popTest&popBase
    handles.updatePopMenu(handles,tag,'test');   
    
    %Plot testrange
    plot(handles.axes1,handles.time{varind},handles.y{varind},'Color',handles.colorcode{1});
    hold(handles.axes1,'on');
    plot(handles.axes1,handles.time{varind}(i1:i2),handles.y{varind}(i1:i2),'r');
    hold(handles.axes1,'off');
    set(handles.axes1,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.y{varind})),1.2*(max(handles.y{varind}))]);

end

guidata(hObject,handles);


% --- Executes on selection change in popTest.
function popTest_Callback(hObject, eventdata, handles)
% hObject    handle to popTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popTest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popTest
varind = 1;

if get(hObject,'Value')<=1 %Select <Tag>
    %Plot the signal 
    set(handles.axes1,'Visible','on');
    plot(handles.axes1,handles.time{varind},handles.y{varind},'Color',handles.colorcode{1});
    set(handles.axes1,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.y{varind})),1.2*(max(handles.y{varind}))]);
    set(handles.txtAxes1,'String',handles.yvarname{varind},'Visible','on');
    
    %Remove testrange
    handles.testrange(varind,:) = [0,0];
    
else
    contents = cellstr(get(hObject,'String'));
    seltag = contents{get(hObject,'Value')};
    
    i1 = strfind(seltag,'(');
    i2 = strfind(seltag,' - ');
    i3 = strfind(seltag,'sec');
    range(1) = str2double(seltag(i1+1:i2-1)); %[sec]
    range(2) = str2double(seltag(i2+3:i3-1)); %[sec]
    r1 = round(range(1)*handles.fresamp(varind));
    r2 = round(range(2)*handles.fresamp(varind));
    
    
    if r1<=0
        r1 = 1;
    end
    
    if r2>length(handles.y{varind})
        r2 = length(handles.y{varind});
    end
     
    %Update testrange
    handles.testrange(varind,:) = [r1,r2];
    handles.testtag{varind} = seltag(1:i1-1); % tagname;
    
    %Plot testrange on the signal
    plot(handles.axes1,handles.time{varind},handles.y{varind},'Color',handles.colorcode{1});
    hold(handles.axes1,'on');
    plot(handles.axes1,handles.time{varind}(r1:r2),handles.y{varind}(r1:r2),'r');
    hold(handles.axes1,'off');
    set(handles.axes1,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.y{varind})),1.2*(max(handles.y{varind}))]);

end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butBase.
function butBase_Callback(hObject, eventdata, handles)
% hObject    handle to butBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varind = 1;
if ~isempty(get(handles.axes2, 'Children')) && get(handles.chkRespAR,'Value'),
   set(handles.axes2,'Color',[1 0.93 0.93]);
   
   %Select test range
   rect = getrect(handles.axes2); %rect = [xmin ymin width height] (unit = unit of x-axis)

   %Restore color of axes
   set(handles.axes2,'Color',[1,1,1]);
   
   %Check if width of selected region = 0. If so, enable other tools & return.
    if rect(3)==0
        return
    end

    %Get selected range [no. of samples]
    i1 = floor(handles.fresamp(varind)*rect(1));
    i2 = ceil(handles.fresamp(varind)*(rect(1) + rect(3)));
    if i1<1
        i1 = 1;
    end
    if i2>length(handles.y{varind})
        i2 = length(handles.y{varind});
    end
    
    if i1>i2 %Invalid range
        return;
    end
    

    %Generate Tag
    [tag] = genDefineRegionTag([i1,i2],handles);
    
    if isempty(tag)
        return
    end
        
    %Assign testrange
    handles.baserange(varind,1) = i1;
    handles.baserange(varind,2) = i2;
    
    %Get tagname
    handles.basetag{varind} = tag{1,12};
       
    %Update popTest&popBase
    handles.updatePopMenu(handles,tag,'base');   
    
    %Plot testrange
    plot(handles.axes2,handles.time{varind},handles.resp{varind},'Color',handles.colorcode{2});
    hold(handles.axes2,'on');

    plot(handles.axes2,handles.time{varind}(i1:i2),handles.resp{varind}(i1:i2),'c');
    hold(handles.axes2,'off');
    set(handles.axes2,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.resp{varind})),1.2*(max(handles.resp{varind}))]);

end

guidata(hObject,handles);


% --- Executes on button press in butUpdateTag.
function butUpdateTag_Callback(hObject, eventdata, handles)
% hObject    handle to butUpdateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesTE = getActiveTagEditor(handles);
definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
handles.updatePopMenu(handles,definetags,'all');
varind = 1;
 %Plot the signal 
 set(handles.axes1,'Visible','on');
 plot(handles.axes1,handles.time{varind},handles.y{varind},'Color',handles.colorcode{1});
 set(handles.axes1,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.y{varind})),1.2*(max(handles.y{varind}))]);
 set(handles.txtAxes1,'String',handles.yvarname{varind},'Visible','on');
    
 %Remove testrange
 handles.testrange(varind,:) = [0,0];
 %Remove baserange
 handles.baserange(varind,:) = [0,0];    
 
 if get(handles.chkRespAR,'Value')
    %Plot the signal 
    set(handles.axes2,'Visible','on');
    plot(handles.axes2,handles.time{varind},handles.resp{varind},'Color',handles.colorcode{2});
    set(handles.axes2,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.resp{varind})),1.2*(max(handles.resp{varind}))]);
    set(handles.txtAxes2,'String',handles.respname{varind},'Visible','on');
 else
    
    plot(handles.axes2,handles.time{varind},handles.resp{varind},'Color',handles.colorcode{2},'LineStyle','None');
    set(handles.axes2,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.resp{varind})),1.2*(max(handles.resp{varind}))]);
     
 end
    
guidata(hObject,handles);


% --- Executes on selection change in popBase.
function popBase_Callback(hObject, eventdata, handles)
% hObject    handle to popBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popBase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popBase
varind = 1;

if get(hObject,'Value')<=1 %Select <Tag>
    %Plot the signal 
    set(handles.axes2,'Visible','on');
    plot(handles.axes2,handles.time{varind},handles.resp{varind},'Color',handles.colorcode{2});
    set(handles.axes2,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.resp{varind})),1.2*(max(handles.resp{varind}))]);
    set(handles.txtAxes2,'String',handles.respname{varind},'Visible','on');
    
    %Remove testrange
    handles.baserange(varind,:) = [0,0];  
else
    contents = cellstr(get(hObject,'String'));
    seltag = contents{get(hObject,'Value')};
    
    i1 = strfind(seltag,'(');
    i2 = strfind(seltag,' - ');
    i3 = strfind(seltag,'sec');
    range(1) = str2double(seltag(i1+1:i2-1)); %[sec]
    range(2) = str2double(seltag(i2+3:i3-1)); %[sec]
    r1 = round(range(1)*handles.fresamp(varind));
    r2 = round(range(2)*handles.fresamp(varind));
    
    %Update baserange
    handles.baserange(varind,:) = [r1,r2];
    handles.basetag{varind} = seltag(1:i1-1); % tagname;
    
    %Plot baserange on the signal
    plot(handles.axes2,handles.time{varind},handles.resp{varind},'Color',handles.colorcode{2});
    hold(handles.axes2,'on');
    plot(handles.axes2,handles.time{varind}(r1:r2),handles.resp{varind}(r1:r2),'c');
    hold(handles.axes2,'off');
    set(handles.axes2,'XLim',[0,ceil(max(handles.time{varind}))],'YLim',[0.8*(min(handles.resp{varind})),1.2*(max(handles.resp{varind}))]);
    
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figTimeVaryingPSD.
function figTimeVaryingPSD_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figTimeVaryingPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
h = guidata(handles.DataBrowser);
h.subTVPSD = [];
guidata(handles.DataBrowser,h);
delete(hObject);


% --- Executes on button press in butOK.
function butOK_Callback(hObject, eventdata, handles)
% hObject    handle to butOK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



 
fs = handles.yfs(end);
fresamp = str2double(get(handles.editFresamp,'String'));
y = handles.y{end};
%Downsample selected variable
if fs~=fresamp && fs>fresamp
   if ~rem(fs,fresamp) %fs is divisible by fresamp
       y = downsample(y, fs/fresamp);
   else
       [p,q] = rat(fresamp/fs);
       y = resample(y,p,q,0); %filter order = 0

   end

    
elseif fs<fresamp,
    %warning
    msgbox('Cannot downsample because the sampling frequency of the signal is lower.','Warning','warn');
    return    
    
end

set(handles.chkFresamp,'Enable','off'); %After downsampling, can't downsample the same signal anymore
set(handles.editFresamp,'Enable','off');


%Downsample respiration
if isfield(handles,'resp') && ~isempty(handles.resp{end})
    fs = handles.respfs(end);
    resp = handles.resp{end};
    if fs~=fresamp && fs>fresamp
        if ~rem(fs,fresamp) %fs is divisible by fresamp
            resp = downsample(resp, fs/fresamp);
        else
            [p,q] = rat(fresamp/fs);
            resp = resample(resp,p,q,0); %filter order = 0
        end
        handles.resp{end} = resp;
    elseif fs<fresamp
        %warning
        msgbox('Cannot downsample respiration because the sampling frequency of the respiration is lower.','Warning','warn');
        return    
        
    end
end

handles.y{end} = y;
handles.fresamp = fresamp;
handles.time{end} = (0:length(y)-1)'/fresamp;

%Plot signal
set(handles.axes1,'Visible','on');
plot(handles.axes1,handles.time{end},handles.y{end},'Color',handles.colorcode{1});
set(handles.axes1,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.y{end})),1.2*(max(handles.y{end}))]);
set(handles.txtAxes1,'String',handles.yvarname{end},'Visible','on');
%Enable butTest&popTest
set(handles.butTest,'Enable','on');
set(handles.popTest,'Enable','on','Value',1);


%Plot respiration if exists
if isfield(handles,'resp') && ~isempty(handles.resp{end}),
            
    set(handles.axes2,'Visible','on');
    plot(handles.axes2,handles.time{end},handles.resp{end},'Color',handles.colorcode{2});
    set(handles.axes2,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.resp{end})),1.2*(max(handles.resp{end}))]);
    set(handles.txtAxes2,'String',handles.respname{end},'Visible','on');
    
    %Enable butBase&popBase
    set(handles.butBase,'Enable','on');
    set(handles.popBase,'Enable','on','Value',1);
    
end
set(handles.chkFresamp,'Value',1,'Enable','off');
set(handles.butOK,'Enable','off');

guidata(hObject,handles);


% --- Executes on button press in butSave.
function butSave_Callback(hObject, eventdata, handles)
% hObject    handle to butSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = guidata(handles.DataBrowser); %Get handles(struct) of DataBrowser
filename = handles.yfilename{end};



if ~isempty(handles.lfp{end})
    if get(handles.chkLHR,'Value') && ~isempty(handles.lhr{end})
        varlist = cell(3,1);
        varlist{1} = handles.lfp{end};
        varlist{2} = handles.hfp{end};
        varlist{3} = handles.lhr{end};
        varname = {'_lfp';'_hfp';'_lhr'};
        varname = cellfun(@(x) strcat(handles.yvarname{end},x),varname,'UniformOutput',0);
        
    else
        varlist = cell(2,1);
        varlist{1} = handles.lfp{end};
        varlist{2} = handles.hfp{end};
        varname = {'_lfp';'_hfp'};
        varname = cellfun(@(x) strcat(handles.yvarname{end},x),varname,'UniformOutput',0);
    end
    hwait = waitbar(0,'Please wait...');
    steps = 10;
    for v=1:length(varlist)
        
        %Get Acrostic and Subject ID
        [pathstr,name,ext] = fileparts(filename); 
        h.DB.acrostic = [h.DB.acrostic; name(1:5)];
        allvars = who('-file',filename);
        temp = strfind(allvars,'SubjectNumber'); %search for 'SubjectNumber'
        waitbar(v / steps)
        if any(~cellfun(@isempty,temp))
            load(filename,'SubjectNumber');
            h.DB.subjnum = [h.DB.subjnum; num2str(SubjectNumber)];
        else
            h.DB.subjnum = [h.DB.subjnum; '-'];
        end
            
        h.DB.filename    = [h.DB.filename; filename];
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
        h.DB.fs          = [h.DB.fs; handles.fresamp];        
        h.DB.flagnorm    = [h.DB.flagnorm; -1];
        h.DB.flagdetrend = [h.DB.flagdetrend; -1];
        h.DB.detrend     = [h.DB.detrend; 1];
        h.DB.scale       = [h.DB.scale; 1];
        h.DB.flagtivpsd  = [h.DB.flagtivpsd; 0];
        
        waitbar(1*v / steps);
        waitbar(2*v / steps);
        waitbar(3*v / steps);
        waitbar(4*v / steps);
        waitbar(5*v / steps);
    end
    
    %Add new variables to Workspace
    varind = length(h.DB.varname);
    set(h.listWrkspc,'String',h.DB.varname,'Value',varind,'Enable','on');
    
    %Update UI controls in variable operations in Workspace
    updateVariableOperations(h.output,h,varind);
    
    %Set context menus
    setContextMenus(h.output,h);
    pause(1);
    close(hwait);
else
   msgbox('The LFP&HFP are empty!','Warning','warn');
   return 
    
end
guidata(hObject,handles);


% --- Executes on button press in chkLHR.
function chkLHR_Callback(hObject, eventdata, handles)
% hObject    handle to chkLHR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkLHR

if get(hObject,'Value')
    if isfield(handles,'lhr') && ~isempty(handles.lhr{end})
        if isempty( get(handles.axes5,'Children'))
            %Plot the results
            set(handles.axes5,'Visible','on');
            plot(handles.axes5,handles.time{end},handles.lhr{end},'Color',handles.colorcode{5});
            set(handles.axes5,'XLim',[0,ceil(max(handles.time{end}))],'YLim',[0.8*(min(handles.lhr{end})),1.2*(max(handles.lhr{end}))]);
            set(handles.txtAxes5,'String','LHR','Visible','on');
        else
            set(handles.axes5,'Visible','on');
            hline = get(handles.axes5,'Children');
            set(hline,'LineStyle','-'); 
            set(handles.txtAxes5,'Visible','on');
        end
   end
    
else
    if isfield(handles,'lhr') && ~isempty(handles.lhr{end})
        set(handles.axes5,'Visible','off');
        hline = get(handles.axes5,'Children');
        set(hline,'LineStyle','None');
        set(handles.txtAxes5,'Visible','off');
    end
    
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function toolScreenshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolScreenshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[figfile,figpath] = uiputfile('*.*','Take a Screenshot of the GUI');
if ~ischar(figfile)
    return %return if choosing invalid file
end

pause(0.3); %to ensure that the uiputfile figure is already closed

pos = get(handles.figTimeVaryingPSD,'Position');
imgdata = screencapture(0,'Position',pos); %take a screen capture
imwrite(imgdata,fullfile(figpath,[figfile,'.png'])); %save the captured image to file

guidata(hObject, handles); %update handles structure



function editBase_Callback(hObject, eventdata, handles)
% hObject    handle to editBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBase as text
%        str2double(get(hObject,'String')) returns contents of editBase as a double


% --- Executes during object creation, after setting all properties.
function editBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTest_Callback(hObject, eventdata, handles)
% hObject    handle to editTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTest as text
%        str2double(get(hObject,'String')) returns contents of editTest as a double


% --- Executes during object creation, after setting all properties.
function editTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMethod_Callback(hObject, eventdata, handles)
% hObject    handle to editMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMethod as text
%        str2double(get(hObject,'String')) returns contents of editMethod as a double


% --- Executes during object creation, after setting all properties.
function editMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menuMode_Callback(hObject, eventdata, handles)
% hObject    handle to menuMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuNormalTVPSD_Callback(hObject, eventdata, handles)
% hObject    handle to menuNormalTVPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Visible','off');
guidata(hObject,handles);


% --------------------------------------------------------------------
function menuBatchTVPSD_Callback(hObject, eventdata, handles)
% hObject    handle to menuBatchTVPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Visible','on');
guidata(hObject,handles);



function editMatpath_Callback(hObject, eventdata, handles)
% hObject    handle to editMatpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMatpath as text
%        str2double(get(hObject,'String')) returns contents of editMatpath as a double


% --- Executes during object creation, after setting all properties.
function editMatpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMatpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTagpath_Callback(hObject, eventdata, handles)
% hObject    handle to editTagpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTagpath as text
%        str2double(get(hObject,'String')) returns contents of editTagpath as a double


% --- Executes during object creation, after setting all properties.
function editTagpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTagpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSelectMatpath.
function butSelectMatpath_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectMatpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
% Load non-index variables into handles.listBVar in the 'Select Variables' panel
folder_name = uigetdir([],'Select Mat Directory');
handles.batch.matpath = folder_name;
if ~ischar(folder_name)
    return
end
set(handles.editMatpath,'String',folder_name);


%Set listBVar
try
temp = what(folder_name);
handles.batch.matfiles = temp.mat; %Get a cell storing mat filenames
matobj = matfile(fullfile(folder_name,handles.batch.matfiles{1})); %Create matobj to look at a variable property inside one matfile
details = whos(matobj); %Get all properties including size
names = {details.name}; 
sizes = {details.size};
logind = cellfun(@(x) x(1)>10 & x(2)==1,sizes,'UniformOutput',1); %Logical ind to elements that are time-series
logind = logind | cellfun(@(x) x(2)>10 & x(1)==1,sizes,'UniformOutput',1);
names = names(logind);

catch 
    warning('Cannot read a matfile ---TimeVarying PSD');
    return
end

if isempty(logind)
    return
    
end

%Exclude ind variables
logind = cellfun(@(x) isempty(strfind(x,'ind')),names,'UniformOutput',1); %Logical ind to elements that are not indices.
handles.batch.varlist = names;
handles.batch.fslist = 2*ones(length(names),1);
set(handles.listBVar,'String',names,'Value',1);

%Set the sampling frequency
logind_250 = (cellfun(@(x) ~isempty(strfind(x,'ecg')),names,'UniformOutput',1))|(cellfun(@(x) ~isempty(strfind(x,'pu')),names,'UniformOutput',1)) | (cellfun(@(x) ~isempty(strfind(x,'bp')),names,'UniformOutput',1)); 
logind_250 =logind_250 | (cellfun(@(x) ~isempty(strfind(x,'pat')),names,'UniformOutput',1));
logind_250 = logind_250 | (cellfun(@(x) ~isempty(strfind(x,'oxip')),names,'UniformOutput',1));
handles.batch.fslist(logind_250) = 250;
logind_30 = cellfun(@(x) ~isempty(strfind(x,'amp')),names,'UniformOutput',1); %Identify amplitude data
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'abd')),names,'UniformOutput',1));
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'thrx')),names,'UniformOutput',1));
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'therm')),names,'UniformOutput',1));
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'rri')),names,'UniformOutput',1));
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'sbp')),names,'UniformOutput',1));
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'dbp')),names,'UniformOutput',1));
logind_30 = logind_30 | (cellfun(@(x) ~isempty(strfind(x,'vt')),names,'UniformOutput',1));
handles.batch.fslist(logind_30) = 30;

set(handles.editBFs,'String',num2str(handles.batch.fslist(1)),'Enable','on');


%% Enable chkEnableVarName
set(handles.chkEnableVarName,'Enable','on','Value',0);

guidata(hObject,handles);

% --- Executes on button press in butSelectTagpath.
function butSelectTagpath_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectTagpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir([],'Select Tag Files Directory');
if ~ischar(folder_name),
    return
end
handles.batch.tagpath = folder_name;

listtag = dir(folder_name);
listtag = {listtag.name}; %List of the file
% Remove wrong elements (length(filename)<5)
cellind = strfind(listtag,'.csv');
ind = cellfun(@(x) ~isempty(x),cellind,'UniformOutput',1);
if any(ind),
    set(handles.editTagpath,'String',folder_name);
    listtag = listtag(ind); listtag = listtag'; %Change to a column vector
    handles.batch.listtag = listtag;
else
   warndlg('The selected directory does not have .csv file');
   return; %There is no .csv file in the folder. 
end

%Show all the tags inside the first file
tagpath = handles.batch.tagpath;
filename = listtag{1};
content = tagreader(fullfile(tagpath,filename));
if ~isempty(content.tagcol{1}), %Check if the function is able to read the file
   subregions = content.tagcol; 
else
   disp(['CANNOT READ THE FILE FROM ,',tagpath]);
   return;
    
end
% csvtext = importdata(fullfile(tagpath,filename));
% %Get tag column
% subregions = csvtext(2:end,12); %Discard the header
set(handles.listAllTags,'String',subregions);
handles.batch.alltags = subregions;

guidata(hObject,handles);


function editBResultDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to editBResultDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBResultDisplay as text
%        str2double(get(hObject,'String')) returns contents of editBResultDisplay as a double


% --- Executes during object creation, after setting all properties.
function editBResultDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBResultDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBSignal_Callback(hObject, eventdata, handles)
% hObject    handle to editBSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBSignal as text
%        str2double(get(hObject,'String')) returns contents of editBSignal as a double


% --- Executes during object creation, after setting all properties.
function editBSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listBVar.
function listBVar_Callback(hObject, eventdata, handles)
% hObject    handle to listBVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Description
% Display Frequency of the signal in editBFs when the variable is chosen (one-click)
%%
% Hints: contents = cellstr(get(hObject,'String')) returns listBVar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBVar
varind = get(handles.listBVar,'Value');
fs = handles.batch.fslist(varind);
set(handles.editBFs,'Enable','on','String',num2str(fs));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function listBVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listSelectedVar.
function listSelectedVar_Callback(hObject, eventdata, handles)
% hObject    handle to listSelectedVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listSelectedVar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listSelectedVar


% --- Executes during object creation, after setting all properties.
function listSelectedVar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listSelectedVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butBAddVar.
function butBAddVar_Callback(hObject, eventdata, handles)
% hObject    handle to butBAddVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
%Add selected signal from the listbox to the list of variables for
%processing
oldlist = get(handles.listSelectedVar,'String');
fs = str2double(get(handles.editBFs,'String'));

if isnan(fs),
    warndlg('Please enter a numeric value for the sampling frequency');
    return
end

if get(handles.chkEnableVarName,'Value'),
    newvar = get(handles.editBSignal,'String');
else
    allvars = get(handles.listBVar,'String');
    ind = get(handles.listBVar,'Value');
    ind = ind(1);
    newvar = allvars{ind};
    handles.batch.fslist(ind) = fs; %keep fs for variables on the listbox
end

if isempty(oldlist),
   oldlist = {newvar}; 
   newfs = fs;
   set(handles.listSelectedVar,'String',oldlist,'Value',1);
else
    check = cellfun(@(x) strcmpi(x,newvar),oldlist,'UniformOutput',1);
    if any(check),
        %That variable already exists
        warndlg('The variable already exists');
        return
    else
        oldlist = [oldlist;{newvar}];
        newfs = [handles.batch.fsvar;fs];
        set(handles.listSelectedVar,'String',oldlist,'Value',1,'Enable','on');
    end
end
handles.batch.varlist = oldlist;
handles.batch.fsvar = newfs;


%% Set Edit Box for arbitrary varname to default
set(handles.editBSignal,'String','Enter Variable Name','Enable','off');
set(handles.chkEnableVarName,'Value',0);

%% Set FS according to the listbox instead
varind = get(handles.listBVar,'Value');
fs = handles.batch.fslist(varind);
set(handles.editBFs,'Enable','on','String',num2str(fs));

guidata(hObject,handles);

% --- Executes on button press in butDBatchVar.
function butDBatchVar_Callback(hObject, eventdata, handles)
% hObject    handle to butDBatchVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
% Delete the selected variable from the list
ind = get(handles.listSelectedVar,'Value');
oldlist = get(handles.listSelectedVar,'String');
oldlist(ind) = [];
handles.batch.fsvar(ind) = [];
if ~isempty(oldlist)
   set(handles.listSelectedVar,'String',oldlist,'Value',1);
else
   set(handles.listSelectedVar,'String',[]);
   handles.batch.fsvar = [];
end

guidata(hObject,handles);


function editBFs_Callback(hObject, eventdata, handles)
% hObject    handle to editBFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBFs as text
%        str2double(get(hObject,'String')) returns contents of editBFs as a double


% --- Executes during object creation, after setting all properties.
function editBFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listSelectRegion.
function listSelectRegion_Callback(hObject, eventdata, handles)
% hObject    handle to listSelectRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listSelectRegion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listSelectRegion


% --- Executes during object creation, after setting all properties.
function listSelectRegion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listSelectRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listAllTags.
function listAllTags_Callback(hObject, eventdata, handles)
% hObject    handle to listAllTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listAllTags contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listAllTags


% --- Executes during object creation, after setting all properties.
function listAllTags_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listAllTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butBROI.
function butBROI_Callback(hObject, eventdata, handles)
% hObject    handle to butBROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
%Add the selected ROI into listSelectRegion
oldlist = get(handles.listSelectRegion,'String');
ind = get(handles.listAllTags,'Value');
newtag = handles.batch.alltags{ind};
if isempty(oldlist),
      oldlist = [oldlist;{newtag}];  
      set(handles.listSelectRegion,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmp(x,newtag),oldlist,'UniformOutput',1);
    if any(check),
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newtag}];
        set(handles.listSelectRegion,'String',oldlist,'Value',1,'Enable','on');
    end
end

handles.batch.taskRegions = oldlist;
guidata(hObject,handles);

% --- Executes on button press in butBCompute.
function butBCompute_Callback(hObject, eventdata, handles)
% hObject    handle to butBCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matpath = handles.batch.matpath;
tagpath = handles.batch.tagpath;

varlist = handles.batch.varlist;
fsvar = handles.batch.fsvar;
%% Check if input arguments are valid
if  isempty(varlist) || isempty(fsvar) 
    warndlg('Signals are not selected');
    return
end
if isfield(handles.batch,'taskRegions') && ~isempty(handles.batch.taskRegions)
    taskRegions = handles.batch.taskRegions;
else
    warndlg('ROIs are not selected');
    return;   
end

if isfield(handles.batch,'savepath') && ~isempty(handles.batch.savepath)
    savepath = handles.batch.savepath;
else
    warndlg('Please Select Save Directory!!');
    return;   
end

if get(handles.chkBAR,'Value')%AR
    method = 'ar';
    [missing_csvfiles,missing_tag_csvfiles,missing_signal_matfiles,rounds] = batchTVPSDforGUI(matpath,tagpath,savepath,taskRegions,varlist,fsvar,method);
    
elseif get(handles.chkBWelch,'Value')
    method = 'fft';
    [missing_csvfiles,missing_tag_csvfiles,missing_signal_matfiles,rounds] = batchTVPSDforGUI(matpath,tagpath,savepath,taskRegions,varlist,fsvar,method);
    
else
    return;
    
end

% Display results
strresult = {['Selected Method=', method,',******Results******'],['Total Matfiles=',num2str(rounds)]};

%% Missing csv files
if ~isempty(missing_csvfiles)
    strresult = [strresult,{'----Missing .csv----'},missing_csvfiles];
end

%% Missing Variables
for nvar = 1:length(varlist)
   temp = missing_signal_matfiles{nvar};
   if ~isempty(temp)
       strresult = [strresult,{['----Missing ',varlist{nvar},'----']},temp];
   end
   
end


%% Missing Tags
%Missing other signals
for nvar = 1:length(taskRegions),
   temp = missing_tag_csvfiles{nvar};
   if ~isempty(temp)
       strresult = [strresult,{['----Missing ',taskRegions{nvar},' tag----']},temp];
   end
   
end


strresult = char(strresult); %Change to vertical dim
set(handles.editBResultDisplay,'String',strresult,'Enable','inactive');

guidata(hObject,handles);

% --- Executes on button press in butBClear.
function butBClear_Callback(hObject, eventdata, handles)
% hObject    handle to butBClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.batch.varlist = [];
handles.batch.fsvar = [];
handles.batch.taskRegions = [];

set(handles.editBResultDisplay,'String',[]);
set(handles.listSelectRegion,'String',[]);
set(handles.listSelectedVar,'String',[]);

guidata(hObject,handles);

% --- Executes on button press in butDBROI.
function butDBROI_Callback(hObject, eventdata, handles)
% hObject    handle to butDBROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listSelectRegion,'Value');
oldlist = get(handles.listSelectRegion,'String');
if ~isempty(oldlist),
   oldlist(ind) = [];
   set(handles.listSelectRegion,'String',oldlist);
   handles.batch.taskRegions(ind) = [];
end

guidata(hObject,handles);
% --- Executes on button press in chkBWelch.
function chkBWelch_Callback(hObject, eventdata, handles)
% hObject    handle to chkBWelch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBWelch
if get(hObject,'Value'),
   set(hObject,'Enable','off');
   set(handles.chkBAR,'Value',0,'Enable','on');
end
guidata(hObject,handles);

% --- Executes on button press in chkBAR.
function chkBAR_Callback(hObject, eventdata, handles)
% hObject    handle to chkBAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBAR
if get(hObject,'Value'),
   set(hObject,'Enable','off');
   set(handles.chkBWelch,'Value',0,'Enable','on');
end
guidata(hObject,handles);

% --- Executes on button press in butAddROIName.
function butAddROIName_Callback(hObject, eventdata, handles)
% hObject    handle to butAddROIName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listSelectRegion,'String');
newtag = get(handles.editTagName,'String');
if isempty(oldlist),
      oldlist = [oldlist;{newtag}];  
      set(handles.listSelectRegion,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmp(x,newtag),oldlist,'UniformOutput',1);
    if any(check),
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newtag}];
        set(handles.listSelectRegion,'String',oldlist,'Value',1,'Enable','on');
    end
end

set(handles.editTagName,'String',[]);

handles.batch.taskRegions = oldlist;
guidata(hObject,handles);


function editTagName_Callback(hObject, eventdata, handles)
% hObject    handle to editTagName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTagName as text
%        str2double(get(hObject,'String')) returns contents of editTagName as a double


% --- Executes during object creation, after setting all properties.
function editTagName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTagName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSavepath_Callback(hObject, eventdata, handles)
% hObject    handle to editSavepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSavepath as text
%        str2double(get(hObject,'String')) returns contents of editSavepath as a double


% --- Executes during object creation, after setting all properties.
function editSavepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSavepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSelectSavepath.
function butSelectSavepath_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectSavepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir([],'Select Save Directory');
if ~ischar(folder_name),
    return
end

set(handles.editSavepath,'String',folder_name);
handles.batch.savepath = folder_name;
guidata(hObject,handles);


% --- Executes on button press in chkEnableVarName.
function chkEnableVarName_Callback(hObject, eventdata, handles)
% hObject    handle to chkEnableVarName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkEnableVarName
if get(hObject,'Value'),
   set(handles.editBSignal,'Enable','on'); 
   set(handles.editBFs,'String',[],'Enable','on'); %Need to enter fs everytime
else   
   set(handles.editBSignal,'Enable','off','String','Enter Variable Name');
   varind = get(handles.listBVar,'Value');
   fs = handles.batch.fslist(varind);
   set(handles.editBFs,'Enable','on','String',num2str(fs));
end
guidata(hObject,handles);
