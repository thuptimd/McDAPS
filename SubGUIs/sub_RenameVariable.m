function varargout = sub_RenameVariable(varargin)
% SUB_RENAMEVARIABLE MATLAB code for sub_RenameVariable.fig
%      SUB_RENAMEVARIABLE, by itself, creates a new SUB_RENAMEVARIABLE or raises the existing
%      singleton*.
%
%      H = SUB_RENAMEVARIABLE returns the handle to a new SUB_RENAMEVARIABLE or the handle to
%      the existing singleton*.
%
%      SUB_RENAMEVARIABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_RENAMEVARIABLE.M with the given input arguments.
%
%      SUB_RENAMEVARIABLE('Property','Value',...) creates a new SUB_RENAMEVARIABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_RenameVariable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_RenameVariable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_RenameVariable

% Last Modified by GUIDE v2.5 25-Jun-2014 18:07:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_RenameVariable_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_RenameVariable_OutputFcn, ...
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


% --- Executes just before sub_RenameVariable is made visible.
function sub_RenameVariable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_RenameVariable (see VARARGIN)

% Choose default command line output for sub_RenameVariable
handles.output = hObject;

initializeSubGUI(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_RenameVariable wait for user response (see UIRESUME)
% uiwait(handles.figRename);


% --- Outputs from this function are returned to the command line.
function varargout = sub_RenameVariable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editRename_Callback(hObject, eventdata, handles)
% hObject    handle to editRename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRename as text
%        str2double(get(hObject,'String')) returns contents of editRename as a double


% --- Executes during object creation, after setting all properties.
function editRename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butRename.
function butRename_Callback(hObject, eventdata, handles)
% hObject    handle to butRename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hfigmain = getappdata(0, 'hfigmain');

%Get the entered variable name
str = get(handles.editRename,'String');
if ~isempty(str)
    
    %Check if the entered variable name is valid
    if isvarname(str) && ~iskeyword(str)
        
        %If valid --> check if the new variable name is unique
        varnames = getappdata(hfigmain,'SDvarname');
        if any(strcmp(varnames,str)) %found variable with the same name
            h = warndlg('The entered variable name already exists.','Warning','modal');
            return
        else
            setappdata(hfigmain, 'renamevar', str);
            close;
        end

    else %invalid variable name or variable name is a keyword
        h = warndlg('The entered variable name is invalid.','Warning','modal');
        return;
    end
    
else %empty editbox
    h = warndlg('Please enter a variable name.','Warning','modal');
    return
end


function initializeSubGUI(handles)

hfigmain = getappdata(0, 'hfigmain');
renamevar = getappdata(hfigmain, 'renamevar');
set(handles.editRename,'BackgroundColor','white','FontSize',10,'String',renamevar);
set(handles.txtRename,'FontSize',10);
set(handles.butRename,'FontSize',10);
