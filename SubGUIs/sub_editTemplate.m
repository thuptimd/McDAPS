function varargout = sub_editTemplate(varargin)
% SUB_EDITTEMPLATE MATLAB code for sub_editTemplate.fig
%      SUB_EDITTEMPLATE, by itself, creates a new SUB_EDITTEMPLATE or raises the existing
%      singleton*.
%
%      H = SUB_EDITTEMPLATE returns the handle to a new SUB_EDITTEMPLATE or the handle to
%      the existing singleton*.
%
%      SUB_EDITTEMPLATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_EDITTEMPLATE.M with the given input arguments.
%
%      SUB_EDITTEMPLATE('Property','Value',...) creates a new SUB_EDITTEMPLATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_editTemplate_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_editTemplate_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_editTemplate

% Last Modified by GUIDE v2.5 05-Aug-2014 19:46:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_editTemplate_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_editTemplate_OutputFcn, ...
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


% --- Executes just before sub_editTemplate is made visible.
function sub_editTemplate_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_editTemplate (see VARARGIN)

% Choose default command line output for sub_editTemplate
handles.output = hObject;

initializeSubGUI(hObject,handles);
handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_editTemplate wait for user response (see UIRESUME)
% uiwait(handles.figTPTemplate);


% --- Outputs from this function are returned to the command line.
function varargout = sub_editTemplate_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editTPList_Callback(hObject, eventdata, handles)
% hObject    handle to editTPList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTPList as text
%        str2double(get(hObject,'String')) returns contents of editTPList as a double


% --- Executes during object creation, after setting all properties.
function editTPList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTPList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butTPOk.
function butTPOk_Callback(hObject, eventdata, handles)
% hObject    handle to butTPOk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hfigmain = getappdata(0, 'hfigmain');
template = get(handles.editTPList,'String');
setappdata(hfigmain,'template',template);

close;


% --- Executes on button press in butTPCancel.
function butTPCancel_Callback(hObject, eventdata, handles)
% hObject    handle to butTPCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hfigmain = getappdata(0, 'hfigmain');
setappdata(hfigmain,'template',{});

close;


%==========================================================================
function initializeSubGUI(hObject,handles)

%Get shared data and stored them in handles structure
hfigmain = getappdata(0, 'hfigmain');
figname  = getappdata(hfigmain,'figname');
template = getappdata(hfigmain,'template');

set(handles.figTPTemplate,'Name',figname);
set(handles.txtTPLabel,'FontSize',10);
set(handles.editTPList,'FontSize',10);
set(handles.butTPOk,'FontSize',10);
set(handles.butTPCancel,'FontSize',10);

if ~isempty(template)
    template = cellfun(@num2str,template,'UniformOutput',0);
    nrow = size(template,1);
    cstr = cell(nrow,1);
    for n=1:nrow
        cstr{n} = [template{n,1},', ',template{n,2},', ',template{n,3}];
    end
    handles.template = cstr;
    set(handles.editTPList,'String',handles.template);
end

guidata(hObject, handles); %update handles structure
