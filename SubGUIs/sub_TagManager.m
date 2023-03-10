function varargout = sub_TagManager(varargin)
% SUB_TAGMANAGER MATLAB code for sub_TagManager.fig
%      SUB_TAGMANAGER, by itself, creates a new SUB_TAGMANAGER or raises the existing
%      singleton*.
%
%      H = SUB_TAGMANAGER returns the handle to a new SUB_TAGMANAGER or the handle to
%      the existing singleton*.
%
%      SUB_TAGMANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_TAGMANAGER.M with the given input arguments.
%
%      SUB_TAGMANAGER('Property','Value',...) creates a new SUB_TAGMANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_TagManager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_TagManager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_TagManager

% Last Modified by GUIDE v2.5 18-Sep-2014 11:43:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_TagManager_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_TagManager_OutputFcn, ...
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


% --- Executes just before sub_TagManager is made visible.
function sub_TagManager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_TagManager (see VARARGIN)

% Choose default command line output for sub_TagManager
handles.output = hObject;


% Clear table
set(handles.tableEditor,'Data',{});
set(handles.tableViewer,'Data',{});

% Clear checkboxes
set(handles.chkSelectAllEditor,'Value',0);
set(handles.chkSelectAllViewer,'Value',0);


% Initialize Tag Manager
% Construct TM's data structure
% Storing data
handles.editorTags = []; %all tags in Tag Editor
handles.viewerTags = [];
handles.savepath = [];   %remember savepath
handles.importpath = [];
handles.filterEditor = [];
handles.filterViewer = [];
handles.jtableEditor = [];



% Functions
handles.updateEditorTags = @updateEditorTags;
handles.updateViewerTags = @updateViewerTags;
handles.getFilteredTags = @getFilteredTags;
handles.getSelectedTags = @getSelectedTags;
handles.getDefineRegionTags =@getDefineRegionTags;
handles.updateActiveSubModuleTags = @updateActiveSubModuleTags;
handles.setValueAtEditor = @setValueAtEditor;
handles.getColId = @getColId;
handles.setValflag = false;


init(hObject,handles); %Set fontsize and position

%Link to other GUIs
handles.DataBrowser = [];

% Check if hObject of the main_DataBrowser is passed in varargin
DataBrowserInput = find(strcmp(varargin, 'DataBrowser'));
if ~isempty(DataBrowserInput)
   handles.DataBrowser = varargin{DataBrowserInput+1};
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_TagManager wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sub_TagManager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Don't close this figure. It must be deleted from main_DataBrowser
% Hint: delete(hObject) closes the figure
try
    handlesDB = guidata(handles.DataBrowser);
    set(handlesDB.tableEditor,'Data',{});
    handlesDB.editorTags = [];
    
    data = get(handles.tableEditor,'Data');
    if ~isempty(data)
        checkbox = data(:,1);
        % update Data Browser handles automatically
        handlesDB.updateEditorTags(handlesDB,handles.editorTags,checkbox);     
    end
    
    % Enable Tag Editor in DB
    set(handlesDB.tableEditor,'Visible','on','Enable','on');
    % Disable Tag Editor in TM
    set(handles.tableEditor,'Visible','off','Enable','off');
    
    set(handles.output,'Visible','off');
    guidata(hObject,handles);
catch ME
    disp(ME);
end




% --- Executes on button press in butExportTags.
function butExportTags_Callback(hObject, eventdata, handles)
% hObject    handle to butExportTags (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jScrollPane = findjobj(handles.tableViewer);
jtable = jScrollPane.getViewport.getView;
indfilter = handles.getFilteredTags(jtable);
htable = handles.tableViewer;
data   = get(htable,'Data');
ind    = handles.getSelectedTags(indfilter,data);
if isempty(ind)
   return
end
newtags = handles.viewerTags(ind,:);
handles.updateEditorTags(handles,newtags);




% --- Executes on button press in butImportTagViewer.
function butImportTagViewer_Callback(hObject, eventdata, handles)
% hObject    handle to butImportTagViewer (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% check if importpath exists
if ~isempty(handles.importpath)
    importpath = handles.importpath;
else
    handleDB = guidata(handles.DataBrowser);
    importpath = fullfile(handleDB.codepath,'Tags');
end

% ask user to select data file
[file,path] = uigetfile('*.csv','Select a TAG-file (.csv)',importpath);
if ~ischar(file)
    return % return if choosing invalid file
end


% clear old contents
set(handles.tableViewer,'Data',{});

% read .csv file
filepath = fullfile(path,file);
fid = fopen(filepath);
% read header size(c) = 1 x ncol, don't use the header
textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',1,'delimiter',',');
% read content
c = textscan(fid,'%s%s%s%s%s%s%s%s%f%f%f%s%s%s%s','delimiter',',');
fclose(fid);

% set variables
nrow = length(c{1,1});
ncol = length(c); 
data = cell(nrow,ncol);
for n=1:ncol
    % Fs,Begin and End column
    if ismember(n,[9,10,11])
        data(:,n) = num2cell(c{1,n});
     
    else
        if size(c{1,n},1) == size(data(:,n),1) %In case the value column size does not match data size
            data(:,n) = c{1,n};            
        end
    end
end
% update savepath
handles.importpath = importpath;

%sort later
handles.viewerTags = data; %overwrite existing tags
handles.updateViewerTags(handles,data);

guidata(hObject,handles);


% --- Executes on button press in butSaveTagEditor.
function butSaveTagEditor_Callback(hObject, eventdata, handles)
% hObject    handle to butSaveTagEditor (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

jScrollPane = findjobj(handles.tableEditor);
jtable = jScrollPane.getViewport.getView;
indfilter = handles.getFilteredTags(jtable);
htable=handles.tableEditor;
data = get(htable,'Data');
ind = handles.getSelectedTags(indfilter,data);
if isempty(ind)
    return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% htable=handles.tableEditor;
% data = get(htable,'Data');
% ind = handles.getSelectedTags([],data); % no filter for this table
% if isempty(ind),
%     return
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% data = data(ind,:);
data = handles.editorTags(ind,:);

% check if savepath exists
if ~isempty(handles.savepath)
    savepath = handles.savepath;
else
    handleDB = guidata(handles.DataBrowser);
    savepath = fullfile(handleDB.codepath,'Tags');
end

% get the selected file/path from users
[file,path] = uiputfile('tag.csv','Save Tags',savepath);

% write file
if ~isequal(file,0)
    filepath = fullfile(path,file);
    editorheader = get(htable,'ColumnName');
    if exist(filepath,'file') == 2
        %Concatenate the file
        temp = readtable(filepath);
    else
        temp = [];
    end

    %colname = cellstr(s);
    colname = {'Filename';'Module';'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'Side';'Fs';'Begin';'End';'Tag';'Operation';'OperationTag';'Value'};
    T = cell2table(data,'VariableNames',colname);
    writetable([temp;T],filepath);
end
% update savepath
handles.savepath = path;
guidata(hObject,handles);

% --- Executes on button press in butDelTagEditor.
function butDelTagEditor_Callback(hObject, eventdata, handles)
% hObject    handle to butDelTagEditor (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
jScrollPane = findjobj(handles.tableEditor);
jtable = jScrollPane.getViewport.getView;
indfilter = handles.getFilteredTags(jtable);
htable=handles.tableEditor;
data = get(htable,'Data');
ind = handles.getSelectedTags(indfilter,data);
if isempty(ind)
    return
end

% % check if define tags are being deleted
data(ind,:) = []; 
handles.editorTags(ind,:) = [];

if isempty(handles.editorTags)
    set(handles.butDelTagEditor,'Enable','off');
    set(handles.butSaveTagEditor,'Enable','off');
    set(handles.chkSelectAllEditor,'Value',0,'Enable','off');
end


%set data in the tag editor
set(handles.tableEditor,'Data',data);

guidata(hObject,handles);

% --- Executes when entered data in editable cell(s) in tableEditor.
function tableEditor_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tableEditor (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if handles.setValflag %value is changed from setValueAtEditor 
    handles.setValflag = false;
    guidata(hObject,handles);
    return
end
%Turn off any line selection highlight
handlesDB = guidata(handles.DataBrowser); 
turnoffLinehighlight(handles.DataBrowser,handlesDB);
handles = guidata(hObject);

%Get index of editted cell
c = eventdata.Indices;
row = c(1);
col = c(2);

%Get data from the table
tabdata = get(handles.tableEditor,'Data');
jScrollPane = findjobj(handles.tableEditor);
jtable = jScrollPane.getViewport.getView;
jtable.setRowSelectionAllowed(0);
jtable.setColumnSelectionAllowed(0);


[valid,colname] = handlesDB.isEditInfoValid(handlesDB,handles,row,col);
if valid
    % update editorTags for Tag, Begin and End
    if ~strcmp(colname,'select')
        handles.editorTags{row,getColId(colname,'file')} = tabdata{row,col};
    end
    % update filterEditor in TM
    if ~isempty(handles.filterEditor)
      filter = handles.filterEditor;
      filter.getFilterEditor(col-1).resetFilter();
    end
else
    % set the cell to original value
    oldval = handles.editorTags{row,getColId(colname,'file')};
    tabdata{row,col} = oldval;
    set(handles.tableEditor,'Data',tabdata);
    jtable.changeSelection(row-1,col-1, false, false);
    
end

%Draw a shade to display the selected region if the selected variable is plotted
if ~strcmp(colname,'select')
[axesnum]= handlesDB.getAxesnum(handlesDB,row,handles.editorTags);
handlesDB.drawShade(handlesDB,row,axesnum,handles.editorTags);
end
% set(handles.butDeletetag,'Enable','on');
set(handlesDB.butUptag,'ForegroundColor',[0 0 0],'Enable','on');
set(handlesDB.butDowntag,'ForegroundColor',[0 0 0],'Enable','on');

%Set context menus
setContextMenus(handles.DataBrowser,handlesDB);
guidata(handles.DataBrowser,handlesDB);
guidata(hObject,handles);


% --- Executes when selected cell(s) is changed in tableEditor.
function tableEditor_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tableEditor (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
handlesDB = guidata(handles.DataBrowser);
turnoffLinehighlight(handles.DataBrowser,handlesDB);

%Get index of editted cell
c = eventdata.Indices;
if isempty(c) || c(2)==1, % don't highlight when select checkboxes
    return
end
row = c(1);
[axesnum]= handlesDB.getAxesnum(handlesDB,row,handles.editorTags);
handlesDB.drawShade(handlesDB,row,axesnum,handles.editorTags);

guidata(handles.DataBrowser,handlesDB);
guidata(hObject, handles); %update handles structure


% --- Executes on button press in chkSelectAllEditor.
function chkSelectAllEditor_Callback(hObject, eventdata, handles)
% hObject    handle to chkSelectAllEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSelectAllEditor
% Hint: get(hObject,'Value') returns toggle state of chkSelectAll
tabdata = get(handles.tableEditor,'Data');
[nrow,ncol] = size(tabdata);
if (get(hObject,'Value') == get(hObject,'Max')),
   if nrow>0
       checkbox = num2cell(true(nrow,1));
       tabdata = [checkbox,tabdata(:,2:end)];
   end
else
   if nrow>0
       checkbox = num2cell(false(nrow,1));
       tabdata = [checkbox,tabdata(:,2:end)];
   end
 
end

% set select columns in the table
set(handles.tableEditor,'Data',tabdata);
guidata(hObject,handles);

% --- Executes on button press in chkSelectAllViewer.
function chkSelectAllViewer_Callback(hObject, eventdata, handles)
% hObject    handle to chkSelectAllViewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSelectAllViewer
tabdata = get(handles.tableViewer,'Data');
[nrow,ncol] = size(tabdata);
if (get(hObject,'Value') == get(hObject,'Max'))
   if nrow>0
       checkbox = num2cell(true(nrow,1));
       tabdata = [checkbox,tabdata(:,2:end)];
   end
else
   if nrow>0
       checkbox = num2cell(false(nrow,1));
       tabdata = [checkbox,tabdata(:,2:end)];
   end
 
end

% set select columns in the table
set(handles.tableViewer,'Data',tabdata);
guidata(hObject,handles)


%------------------------- Non-Callback Functions -------------------------------%
function init(hObject,handles)
%Modified 5Jan2019
if ispc %Set the fontSize for windows & mac
    fntsize = 10;
else
    fntsize = 16;
end

%figw = 1004;
%figh = 588;


figw = 704;
figh = 600;
set(handles.figure1,'Name','Tag Manager',...
    'Position',[624 151 figw figh],... %[left bottom width height]
    'Unit','pixels',...
    'Resize','off');  



%% Tag editor, set position normalize to parent
set(handles.panelTagEditor,'FontSize',fntsize,...
    'Unit','normalized',...
    'Position',[0.014 0.554 0.979 0.42]);
set(handles.butDelTagEditor,'Unit','normalized',...
    'Position',[0.955 0.28 0.042 0.129],...
    'FontSize',fntsize); %Unit normalized to panel
set(handles.butSaveTagEditor,'Unit','normalized',...
    'Position',[0.955 0.14 0.042 0.129]);
set(handles.tableEditor,'Unit','normalized',...
    'Position',[0.01 0.136 0.94 0.86],...
    'FontSize',fntsize);
set(handles.chkSelectAllEditor,'Unit','normalized',...
    'Position',[0.01 0.036 0.2 0.1],...
    'FontSize',fntsize);


%% Tag viewer
set(handles.panelTagViewer,'FontSize',fntsize,...
    'Unit','normalized',...
    'Position',[0.014 0.107 0.979 0.42]);

set(handles.tableViewer,'Unit','normalized',...
    'Position',[0.01 0.136 0.94 0.86],...
    'FontSize',fntsize);
set(handles.chkSelectAllViewer,'Unit','normalized',...
    'Position',[0.01 0.036 0.2 0.1],...
    'FontSize',fntsize);
set(handles.butExportTags,'Unit','normalized',...
    'Position',[0.85 0.036 0.1 0.09],...
    'FontSize',fntsize);
set(handles.butImportTagViewer,'Unit','normalized',...
    'Position',[0.955 0.14 0.042 0.129]);

guidata(hObject,handles)


function [colId] = getColId(colname,mode)
dispHeader = {'select','acrostic','subjid','exptdate','variable','side','fs','begin','end','tag','operation','operationtag','value'};
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
    
function setValueAtEditor(handles,value,row,colname)
% Get colid from Tag Manager
col = getColId(colname,'display');

if ~ischar(value)
    value = num2str(value);
end
jScrollPane = findjobj(handles.tableEditor);
jtable = jScrollPane.getViewport.getView;
jtable.setRowSelectionAllowed(0);
jtable.setColumnSelectionAllowed(0);
handles.setValflag = true;
jtable.setValueAt(value,row-1,col-1);


% if filter is active, reset the choice
% only tag column has filter attached to it
if ~isempty(handles.filterEditor) && strcmp(colname,'tag')
    filter = handles.filterEditor;
    filter.getFilterEditor(col-1).resetFilter();
end

if ~strcmp(colname,'select')
    filecol = getColId(colname,'file');
    handles.editorTags{row,filecol} = value;
end

guidata(handles.output,handles);


  
%Add new tags to the table
function updateViewerTags(handles,newtags)
if ~isempty(newtags)
    nrow = length(newtags(:,1));   
    %create display tags
    displaytags = [newtags(:,3:5), newtags(:,7:15)];
    % add checkbox
    checkbox = num2cell(false(nrow,1));
    displaytags = [checkbox,displaytags];
    
    %Sort tags based on 'operation'&'subjectID'
    set(handles.tableViewer,'Data',displaytags,'Enable','on'); %display tags users are working on
    
end
guidata(handles.output,handles);


function updateEditorTags(handles,newtags,varargin)
if ~isempty(newtags)
    % sort later
    handles.editorTags = [handles.editorTags;newtags]; %Overwrite the existing tags
   
    % create display tags
    displaytags = [newtags(:,3:5), newtags(:,7:15)];
    nrow = length(newtags(:,1));
    % add checkbox
    if ~isempty(varargin)
        checkbox = varargin{1};
    else
        checkbox = num2cell(false(nrow,1));
    end
    displaytags = [checkbox,displaytags];
    displaytags = [get(handles.tableEditor,'Data');displaytags];
    
    %Sort tags based on 'operation'&'subjectID'
    % matlab concatenates the new tag to the table
    set(handles.tableEditor,'Data',displaytags,'Enable','on'); %display tags users are working on
    
    if ~isempty(handles.editorTags)
        set(handles.butDelTagEditor,'Enable','on');
        set(handles.butSaveTagEditor,'Enable','on');
        set(handles.chkSelectAllEditor,'Value',0,'Enable','on');

    else
        set(handles.butDelTagEditor,'Enable','off');
        set(handles.butSaveTagEditor,'Enable','off');
        set(handles.chkSelectAllEditor,'Value',0,'Enable','off');
    end
    guidata(handles.output,handles);
end

function [tags] = getDefineRegionTags(handles,mode)
% mode = DefineRegion || DefineRegionFreq
tags = [];
colId = getColId('operation','file');
if ~isempty(handles.editorTags) %13 is oper. tag
    tagid = find(ismember(handles.editorTags(:,colId),mode));
    if ~isempty(tagid)
        tags = handles.editorTags(tagid,:);
    end
end

function [] = updateActiveSubModuleTags(newtags,handlesDB)
% check if MoveCorr is active
% if newtags is empty, there is no more define tags
MoveCorr = handlesDB.subMovingCorrelation;
if ~isempty(MoveCorr) % MoveCorr is active
    handlesMC = guidata(MoveCorr);
    handlesMC.updatePopMenu(handlesMC,newtags);
end

function [indrow] = getFilteredTags(jtable)
%indrow is the matrix of indices to the rows of original table
rowsorter = jtable.getRowSorter();
if isempty(rowsorter)
    indrow = [];
else
    %   get the number of filtered rows
    numrow = rowsorter.getViewRowCount();
    indrow = zeros(numrow,1);
    for n=1:numrow
        % the result+1 because java returns 0 for the first row
        indrow(n) = rowsorter.convertRowIndexToModel(n-1)+1; %java begins with index 0
    end
end

function [ind] = getSelectedTags(indfilter,data)
%ind : indices to row in table
%Check the table is not empty

if ~isempty(data)
   %get the selected rows
    cselect = 1;
    %select size = # rows -->logical array
    select = cellfun(@(x) x==1, data(:,cselect), 'UniformOutput', 1); %row indices
    
    %check if the filter is active
    if ~isempty(indfilter) %active
        indtemp = find(select(indfilter)); %only get the selected rows from the filter
        ind = indfilter(indtemp);
    
    else
        ind = find(select);
    end
    
else
   ind = [];
end
    
