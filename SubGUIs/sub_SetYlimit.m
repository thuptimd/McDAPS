function varargout = sub_SetYlimit(varargin)
% SUB_SETYLIMIT MATLAB code for sub_SetYlimit.fig
%      SUB_SETYLIMIT, by itself, creates a new SUB_SETYLIMIT or raises the existing
%      singleton*.
%
%      H = SUB_SETYLIMIT returns the handle to a new SUB_SETYLIMIT or the handle to
%      the existing singleton*.
%
%      SUB_SETYLIMIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_SETYLIMIT.M with the given input arguments.
%
%      SUB_SETYLIMIT('Property','Value',...) creates a new SUB_SETYLIMIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_SetYlimit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_SetYlimit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_SetYlimit

% Last Modified by GUIDE v2.5 20-Jul-2014 18:07:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_SetYlimit_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_SetYlimit_OutputFcn, ...
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


% --- Executes just before sub_SetYlimit is made visible.
function sub_SetYlimit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_SetYlimit (see VARARGIN)

% Choose default command line output for sub_SetYlimit
handles.output = hObject;

initializeSubGUI(hObject,handles);
handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_SetYlimit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sub_SetYlimit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editYmin_Callback(hObject, eventdata, handles)
% hObject    handle to editYmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmin as text
%        str2double(get(hObject,'String')) returns contents of editYmin as a double


% --- Executes during object creation, after setting all properties.
function editYmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYmax_Callback(hObject, eventdata, handles)
% hObject    handle to editYmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYmax as text
%        str2double(get(hObject,'String')) returns contents of editYmax as a double


% --- Executes during object creation, after setting all properties.
function editYmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSet.
function butSet_Callback(hObject, eventdata, handles)
% hObject    handle to butSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

valmin = str2num(get(handles.editYmin,'String')); %use str2num because it can convert math symbol operating on numbers e.g. 2+3
valmax = str2num(get(handles.editYmax,'String')); %use str2num because it can convert math symbol operating on numbers e.g. 2+3

if ~isempty(valmin) && isreal(valmin) && ~isempty(valmax) && isreal(valmax) 
    
    %Check if ymin < ymax
    if valmin < valmax
        set(handles.editYmin,'String',num2str(valmin,'%10.3f'));
        set(handles.editYmax,'String',num2str(valmax,'%10.3f'));
        handles.ymin = valmin;
        handles.ymax = valmax;
    else
        set(handles.editYmin,'String',num2str(handles.ymin,'%10.3f'));
        h = warndlg('Limits are out of order. Previous values were restored.','Warning!','modal');
        return
    end

else
    set(handles.editYmin,'String',num2str(handles.ymin,'%10.3f'));
    h = warndlg('The minimum/maximum of y-limit must be a number.','Warning!','modal');
    return
end
    
%Update shared data and close sub-GUI only if ymin and ymax data are valid
hfigmain = getappdata(0, 'hfigmain');
setappdata(hfigmain, 'newylimit', [handles.ymin, handles.ymax]);
close;


function initializeSubGUI(hObject,handles)

hfigmain = getappdata(0, 'hfigmain');
oldylimit = getappdata(hfigmain, 'newylimit');

handles.ymin = oldylimit(1);
handles.ymax = oldylimit(2);

set(handles.txtYlimit,'FontSize',10);
set(handles.txtYmin,'FontSize',10);
set(handles.txtYmax,'FontSize',10);
set(handles.editYmin,'FontSize',10,'String',num2str(oldylimit(1),'%10.3f'));
set(handles.editYmax,'FontSize',10,'String',num2str(oldylimit(2),'%10.3f'));
set(handles.butSet,'FontSize',10);

guidata(hObject, handles); %update handles structure
