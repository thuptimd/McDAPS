function varargout = subfex_filtersetting(varargin)
% SUBFEX_FILTERSETTING MATLAB code for subfex_filtersetting.fig
%      SUBFEX_FILTERSETTING, by itself, creates a new SUBFEX_FILTERSETTING or raises the existing
%      singleton*.
%
%      H = SUBFEX_FILTERSETTING returns the handle to a new SUBFEX_FILTERSETTING or the handle to
%      the existing singleton*.
%
%      SUBFEX_FILTERSETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBFEX_FILTERSETTING.M with the given input arguments.
%
%      SUBFEX_FILTERSETTING('Property','Value',...) creates a new SUBFEX_FILTERSETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before subfex_filtersetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to subfex_filtersetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help subfex_filtersetting

% Last Modified by GUIDE v2.5 11-Sep-2017 18:46:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subfex_filtersetting_OpeningFcn, ...
                   'gui_OutputFcn',  @subfex_filtersetting_OutputFcn, ...
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


% --- Executes just before subfex_filtersetting is made visible.
function subfex_filtersetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to subfex_filtersetting (see VARARGIN)

% Choose default command line output for subfex_filtersetting
if ispc
    fntsize = 10;
else
    fntsize = 14;
end
handles.output = hObject;
if ~isdeployed
    handles.subfexfiltercodepath = mfilename('fullpath');
    %Setting path
    handles.subfexfiltercodepath  = fileparts(handles.subfexfiltercodepath);
    handles.subfexfiltercodepath  = fileparts(handles.subfexfiltercodepath);
    handles.subfexfiltersettingpath = fullfile(handles.subfexfiltercodepath,'Setting');
else
    handles.subfexfiltersettingpath = which('fexsetting.mat');

    
end

set(handles.fexpanel_filtersetting,'Unit','pixels','Position',[589 522 853 451],'Unit','normalized','Resize','off');



%Setting filter
load(fullfile(handles.subfexfiltersettingpath,'fexsetting.mat'));
handles.fexfilterdata.filtertype = filtertype;
handles.fexfilterdata.medianfilterwindow = medianfilterwindow;

set(handles.fexfilter_radiobutmedianedit,'String',[num2str(handles.fexfilterdata.medianfilterwindow)]);
fexfilterpanel_ch = get(handles.fexfilterpanel_filtertypesetting,'Children');
set(fexfilterpanel_ch,'FontSize',fntsize);

fexfilterpanel_ch = get(handles.fexfilterpanel_filterbutgroup,'Children');
set(fexfilterpanel_ch,'FontSize',fntsize);

fexfilterpanel_ch = get(handles.fexfilterpanel_target,'Children');
set(fexfilterpanel_ch,'FontSize',fntsize);



switch handles.fexfilterdata.filtertype
    case 1
        set(handles.fexfilter_radiobutmedian,'Value',1);
    case 2
        set(handles.fexfilter_radiobutlowpass,'Value',1);
end


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes subfex_filtersetting wait for user response (see UIRESUME)
% uiwait(handles.fexpanel_filtersetting);


% --- Outputs from this function are returned to the command line.
function varargout = subfex_filtersetting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function fexfilter_radiobutmedianedit_Callback(hObject, eventdata, handles)
% hObject    handle to fexfilter_radiobutmedianedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fexfilter_radiobutmedianedit as text
%        str2double(get(hObject,'String')) returns contents of fexfilter_radiobutmedianedit as a double


% --- Executes during object creation, after setting all properties.
function fexfilter_radiobutmedianedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fexfilter_radiobutmedianedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fexfilterpanel_edittarget_Callback(hObject, eventdata, handles)
% hObject    handle to fexfilterpanel_edittarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fexfilterpanel_edittarget as text
%        str2double(get(hObject,'String')) returns contents of fexfilterpanel_edittarget as a double


% --- Executes during object creation, after setting all properties.
function fexfilterpanel_edittarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fexfilterpanel_edittarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fexfilterpanel_buttarget.
function fexfilterpanel_buttarget_Callback(hObject, eventdata, handles)
% hObject    handle to fexfilterpanel_buttarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Choose a file, a variable and sampling frequency
[inputfile,inputpath] = uigetfile('*.mat','Select a MAT-file');
if ~ischar(inputfile)
    return %return if choosing invalid file
end
matobj = matfile(fullfile(inputpath,inputfile)); %without loading
listvars = who(matobj);
templistvars = listvars;
displaylistvars = [];

% read variables from textfiles
fid = fopen(fullfile(handles.subfexfiltersettingpath,'filtervariablenames.txt'));
A = fscanf(fid,'%c'); %scan characters from a textfile, each line is splitted by a whitespace
keywords = strsplit(A);
logicalind = false(length(templistvars),1);
for n=1:length(keywords)
    tempcellind = regexpi(templistvars,keywords{n});
    addind = cellfun(@(x) ~isempty(x),tempcellind,'UniformOutput',1);
    logicalind = logicalind | addind;
end
varstoadd = templistvars(logicalind);
displaylistvars = [displaylistvars;varstoadd];

fig = figure('Name','Select a target variable','Position',[680 478 300 350],'Resize','off');
lb = uicontrol(fig,'Style','listbox',...
                'String',displaylistvars,...
                'FontSize',14,...
                'Units','normalized',...
                'Position',[0.1 0.45 0.8 0.5],'Value',1);
txtbox = uicontrol(fig,'Style','edit',...
                'String','Enter sampling frequency (hertz) here.',...
                'Units','normalized',...
                'FontSize',10,...
                'Position',[0.1 0.25 0.8 0.2]);
tb = uicontrol(fig,'Style','togglebutton',...
                'String','Continue',...
                'Units','normalized',...
                'FontSize',14,...
                'Value',0,'Position',[0.1 0.05 0.8 0.2]);
            
            
% Check which variable is a target
targetvariable = '';
target_fs = 0;
while true
   try
   if get(tb,'Value')
       target_fs = str2double(get(txtbox,'String'));
       if isnan(target_fs)
          warndlg('Please enter a sampling frequency'); 
          close(fig)
          break
       end

       selected_index = get(lb,'Value');
       if length(selected_index)>1
           selected_index = selected_index(1);
       end
       targetvariable = displaylistvars{selected_index};
       close(fig)
       break
   elseif ~ishandle(fig) %Check if the figure is closed
       return
   end
   catch
       return
   end
   drawnow %Feed the current event to update tb1/2/3 values
end

load(fullfile(inputpath,inputfile),targetvariable);
eval(['filtervar=',targetvariable,';']);
if isempty(filtervar)
   warndlg([targetvariable,' is empty. Please select another file or target']);
   return
    
end
%% Set a target panel
window = 5;
set(handles.fexfilterpanel_edittarget,'String',targetvariable,'Enable','off');
set(handles.fexfilter_radiobutmedianedit,'String',num2str(window),'Enable','on');




%% Plot a filtered response on the file
w = round(target_fs*window);
wb = waitbar(0, 'Filtering.....');
wbch = allchild(wb);
jp = wbch(1).JavaPeer;
jp.setIndeterminate(1);
%Check filter type

if get(handles.fexfilter_radiobutmedian,'Value')
    filteredresponse = getTrend(filtervar,'window',w);
elseif get(handles.fexfilter_radiobutlowpass,'Value')
    filteredresponse = lowfilterHamming10(filtervar);

end

delete(wb);
filtertime = 0:length(filteredresponse)-1; filtertime = filtertime/target_fs;
cla(handles.fexfilterpanel_axe);
plot(handles.fexfilterpanel_axe,filtertime,filtervar,'b','LineWidth',1); hold(handles.fexfilterpanel_axe,'on');
plot(handles.fexfilterpanel_axe,filtertime,filteredresponse,'k','LineWidth',2);
xlabel('Time','FontSize',16); 

handles.fexfilterdata.targetvariable = targetvariable;
handles.fexfilterdata.target_fs = target_fs;
handles.fexfilterdata.filtervar = filtervar;
handles.fexfilterdata.window = window;

guidata(hObject,handles)


% --- Executes on button press in fexfilter_previewbut.
function fexfilter_previewbut_Callback(hObject, eventdata, handles)
% hObject    handle to fexfilter_previewbut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles.fexfilterdata,'targetvariable') || isempty(handles.fexfilterdata.targetvariable)
   return 
end
targetvariable = handles.fexfilterdata.targetvariable;
target_fs = handles.fexfilterdata.target_fs;
filtervar = handles.fexfilterdata.filtervar;
window = str2double(get(handles.fexfilter_radiobutmedianedit,'String'));
if isnan(window)
    warndlg('Window size is available');
    return
    
end
if isempty(filtervar)
   warndlg([targetvariable,' is empty. Please select another file or target']);
   return
    
end
w = round(target_fs*window);
wb = waitbar(0, 'Filtering.....');
wbch = allchild(wb);
jp = wbch(1).JavaPeer;
jp.setIndeterminate(1);

filteredresponse = getTrend(filtervar,'window',w);
delete(wb);
filtertime = 0:length(filteredresponse)-1; filtertime = filtertime/target_fs;
cla(handles.fexfilterpanel_axe);
plot(handles.fexfilterpanel_axe,filtertime,filtervar,'b','LineWidth',1); hold(handles.fexfilterpanel_axe,'on');
plot(handles.fexfilterpanel_axe,filtertime,filteredresponse,'k','LineWidth',2);
xlabel('Time(s)','FontSize',16); 


guidata(hObject,handles);


% --- Executes on button press in fexfilter_checkdefault.
function fexfilter_checkdefault_Callback(hObject, eventdata, handles)
% hObject    handle to fexfilter_checkdefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fexfilter_checkdefault


% --- Executes when user attempts to close fexpanel_filtersetting.
function fexpanel_filtersetting_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fexpanel_filtersetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% Save setting if the default checkbox is ticked
if get(handles.fexfilter_checkdefault,'Value')
   filtertype = 1;
   if get(handles.fexfilter_radiobutmedian,'Value')
       filtertype = 1;
   elseif get(handles.fexfilter_radiobutlowpass,'Value')
       filtertype = 2;
   end
   
   medianfilterwindow = str2double(get(handles.fexfilter_radiobutmedianedit,'String'));
   if isnan(medianfilterwindow)
       medianfilterwindow = 5;
   end
   
   save(fullfile(handles.subfexfiltersettingpath,'fexsetting.mat'),'filtertype','-append');
   save(fullfile(handles.subfexfiltersettingpath,'fexsetting.mat'),'medianfilterwindow','-append');

end
delete(hObject);
