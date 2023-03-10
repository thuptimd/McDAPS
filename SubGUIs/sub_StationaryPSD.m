function varargout = sub_StationaryPSD(varargin)
% SUB_STATIONARYPSD MATLAB code for sub_StationaryPSD.fig
%      SUB_STATIONARYPSD, by itself, creates a new SUB_STATIONARYPSD or raises the existing
%      singleton*.
%
%      H = SUB_STATIONARYPSD returns the handle to a new SUB_STATIONARYPSD or the handle to
%      the existing singleton*.
%
%      SUB_STATIONARYPSD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_STATIONARYPSD.M with the given input arguments.
%
%      SUB_STATIONARYPSD('Property','Value',...) creates a new SUB_STATIONARYPSD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_StationaryPSD_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_StationaryPSD_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_StationaryPSD

% Last Modified by GUIDE v2.5 25-Apr-2019 12:30:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_StationaryPSD_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_StationaryPSD_OutputFcn, ...
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


% --- Executes just before sub_StationaryPSD is made visible.
function sub_StationaryPSD_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_StationaryPSD (see VARARGIN)

% Choose default command line output for sub_StationaryPSD
handles.output = hObject;

% Set handles property to point at Data Browser
handles.DataBrowser = [];

% Check if hObject of the main_DataBrowser is passed in varargin
DataBrowserInput = find(strcmp(varargin, 'DataBrowser'));
if ~isempty(DataBrowserInput)
   handles.DataBrowser = varargin{DataBrowserInput+1};
end

%Setting path
if ~isdeployed
    handles.substationarysettingpath = mfilename('fullpath');
    handles.substationarysettingpath  = fileparts(handles.substationarysettingpath);
    handles.substationarysettingpath  = fileparts(handles.substationarysettingpath);
    handles.substationarysettingpath = fullfile(handles.substationarysettingpath,'Setting');
else %For a standalone version, use ctfroot as a path to Setting folder
    pathtofexsetting = which('psdsetting.mat');
    [p,~,~] = fileparts(pathtofexsetting); %Search relative path to ctfroot
    handles.substationarysettingpath = p;
    
end

handles.getActiveTagEditor = @getActiveTagEditor;
handles.genDefineRegionTag = @genDefineRegionTag;
handles.updatePopChoices = @updatePopChoices;
handles.updatePopMenu = @updatePopMenu;
initializeSubGUI(hObject,handles);
handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_StationaryPSD wait for user response (see UIRESUME)
% uiwait(handles.figStationaryPSD);


% --- Outputs from this function are returned to the command line.
function varargout = sub_StationaryPSD_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function editSPStatus_Callback(hObject, eventdata, handles)
% hObject    handle to editSPStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPStatus as text
%        str2double(get(hObject,'String')) returns contents of editSPStatus as a double


% --- Executes during object creation, after setting all properties.
function editSPStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPStatus (see GCBO)
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


% --- Executes on button press in chkSPNorm.
function chkSPNorm_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPNorm


% --- Executes on button press in chkSPDetrend.
function chkSPDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPDetrend



function editSPDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to editSPDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPDetrend as text
%        str2double(get(hObject,'String')) returns contents of editSPDetrend as a double


% --- Executes during object creation, after setting all properties.
function editSPDetrend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkSPScale.
function chkSPScale_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPScale



function editSPScale_Callback(hObject, eventdata, handles)
% hObject    handle to editSPScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPScale as text
%        str2double(get(hObject,'String')) returns contents of editSPScale as a double


% --- Executes during object creation, after setting all properties.
function editSPScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkSPYshift.
function chkSPYshift_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPYshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPYshift


% --- Executes on button press in chkSPXshift.
function chkSPXshift_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPXshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPXshift



function editSPYshift_Callback(hObject, eventdata, handles)
% hObject    handle to editSPYshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPYshift as text
%        str2double(get(hObject,'String')) returns contents of editSPYshift as a double


% --- Executes during object creation, after setting all properties.
function editSPYshift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPYshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSPXshift_Callback(hObject, eventdata, handles)
% hObject    handle to editSPXshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPXshift as text
%        str2double(get(hObject,'String')) returns contents of editSPXshift as a double


% --- Executes during object creation, after setting all properties.
function editSPXshift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPXshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in butSPResp.
function butSPResp_Callback(hObject, eventdata, handles)
% hObject    handle to butSPResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Check if the signal is selected
if isempty(get(handles.editSPSignal,'String'))
    msgbox('Please select the signal before select resp!','Warning','warn');
    return;
end

% Get respiratory signal
varind = get(handles.listWrkspc,'Value');
resp = handles.signal{varind}; %selected signal

if isvector(resp) && isnumeric(resp) && ~isscalar(resp)
    
    %Display selected variable
    selvar = handles.varname{varind};
    set(handles.editSPResp,'String',selvar,'Enable','inactive');
    
    %% Apply any operations to the signal    
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
        

        handles.resp = resp;
        handles.respname = selvar;
        handles.respfs = fs;
        handles.resptime = time;
        
        %Update pop-up tag, and enable buttons
        handlesTE = getActiveTagEditor(handles);
        definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
        
        if ~isempty(definetags)
            handles.updatePopMenu(handles,definetags,'all'); %Update in case, it hasn't been updated
        end
    
        set(handles.butSPBase,'Enable','on');
        set(handles.popSPBase,'Enable','on');

else
    warndlg('Selected variable is invalid for computing stationary PSD.','Warning','modal');
    return
    
end


%% Update 25 March 2019
%Plotting
subplot(handles.haxes(2,1)); plot(time,handles.resp,'k');
title(selvar,'Color','k','FontWeight','bold');
xlabel('Time (sec)');
set(handles.haxes(2,1),'Color',[1 0.93 0.93]); 

%Set ylim
%If the signal is clean, the maximum is the actual data
%Otherwise, it's artifact
gap = prctile(handles.resp,96)-prctile(handles.resp,94);
pct99 = prctile(handles.resp,99);
pct100 = max(handles.resp);
dpctmax = (pct100-pct99)/pct99; %Change from pct99

pct1 = min(handles.resp);
pct2 = prctile(handles.resp,2);
dpctmin = (pct2-pct1)/pct1; 

if abs(dpctmax)>0.5 %Maximum is artifact
    %Determine range
    %Assume normal distribution  
    ymax = pct99+gap;    
else
    ymax= pct100+gap;
end

if  abs(dpctmin)>0.5
    
    ymin = pct2-gap;
else
    ymin = pct1-gap;
end


set(handles.haxes(2,1),'YLim',[ymin ymax]);




guidata(hObject,handles);

function editSPResp_Callback(hObject, eventdata, handles)
% hObject    handle to editSPResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPResp as text
%        str2double(get(hObject,'String')) returns contents of editSPResp as a double


% --- Executes during object creation, after setting all properties.
function editSPResp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSPBase.
function butSPBase_Callback(hObject, eventdata, handles)
% hObject    handle to butSPBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varind = handles.currentvarind;
if isempty(handles.resp) %I only have one respiratory signal
    msgbox('Please select respiration!','Warning','warn');
    return;
end
cfig = get(gcf,'Color');
axenum = 2;
hax = handles.haxes(axenum,1);
%Highlight selected axes
set(hax,'Color',[1 0.93 0.93]);

%Show instruction to mark a region
set(handles.editSPStatus,...
    'String','Instruction: Draw a rectangle on the highlighted plot to mark a region.',...
    'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');

%Select test range
rect = getrect(hax); %rect = [xmin ymin width height] (unit = unit of x-axis)

%Restore color of axes
set(hax,'Color',[1,1,1]);

%Remove instruction
set(handles.editSPStatus,...
    'String','',...
    'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
    'Enable','off');

%Check if width of selected region = 0. If so, enable other tools & return.
if rect(3)==0
    return
end

%Identify selected signal
% varind = find(handles.haxes(:,1)==hax);

%Get selected range [sec]
i1 = rect(1);
i2 = rect(1) + rect(3);
if i1<0
    i1 = 0;
end
if i2>handles.resptime(end)
    i2 = handles.resptime(end);
end
%====================================
%Just in case selected test range is invalid
if i1>=i2
    if handles.baserange(1,1)==0 && handles.baserange(1,2)==0
        %Test range has never been selected
        %--> Reset color of the plotted signal & return
        set(hline,'Color','b');
        return
    else
        %Test range was previously selected
        %--> Restore previously selected test range value
        i1 = handles.baserange(1,1);
        i2 = handles.baserange(1,2);
    end    
end
%====================================
[newtags] = genDefineRegionTag([i1,i2],handles);

% check if the user name the tag or not
if ~isempty(newtags)    
    
    if handles.haxes(2,2)~=0 && i1~=handles.baserange(1) && i2~=handles.baserange(2)
        cla(subplot(handles.haxes(2,2)));
        set(handles.haxes(2,2),'Visible','off');
        handles.haxes(2,2) = 0;
    end

    %Plot signal
    subplot(handles.haxes(2,1));
    xlimit = get(handles.haxes(2,1),'Xlim');
    plot(handles.resptime,handles.resp,'k'); hold on;
 

    plot(handles.resptime(handles.resptime>=i1 & handles.resptime<=i2),handles.resp(handles.resptime>=i1 & handles.resptime<=i2),'c');
    hold off;
    title(handles.respname,'Color','k','FontWeight','bold');
    xlabel('Time (sec)');
    xlim(xlimit);
    
    gap = prctile(handles.resp,96)-prctile(handles.resp,94);
    pct99 = prctile(handles.resp,99);
    pct100 = max(handles.resp);
    dpctmax = (pct100-pct99)/pct99; %Change from pct99
    
    pct1 = min(handles.resp);
    pct2 = prctile(handles.resp,2);
    dpctmin = (pct2-pct1)/pct1;
    
    if abs(dpctmax)>0.5 %Maximum is artifact
        %Determine range
        %Assume normal distribution
        ymax = pct99+gap;
    else
        ymax= pct100+gap;
    end
    
    if  abs(dpctmin)>0.5
        
        ymin = pct2-gap;
    else
        ymin = pct1-gap;
    end
    
    
    set(handles.haxes(2,1),'YLim',[ymin ymax]);
    
    handles.baserange = [i1,i2]; %[sec,sec]
    %Get test tagname
    handles.basetag = newtags{1,12};
       
    % Update pop-up choices 
    handles.updatePopMenu(handles,newtags,'base');   

end

guidata(hObject,handles);


% --- Executes on button press in butSPSignal.
function butSPSignal_Callback(hObject, eventdata, handles)
% hObject    handle to butSPSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varind = get(handles.listWrkspc,'Value'); %Get a selected signal from the listbox
y = handles.signal{varind}; %selected signal

if isvector(y) && isnumeric(y) && ~isscalar(y)
    
    %Display selected variable
    selvar = handles.varname{varind};
    set(handles.editSPSignal,'String',selvar,'Enable','inactive');
    
    %% Apply any operations to the signal    
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
    fs = handles.fs(varind); %The sampling frequency of the signal
    
    

    %% Store and initialize variables, ordered by the selection
    %Signal
    handles.y = y;
    handles.yfs = fs; 
    handles.yvarname = selvar;
    handles.yfilename = handles.filename{varind};
    handles.yacrostic = handles.acrostic{varind};
    handles.ysubjnum  = handles.subjnum{varind};
    handles.yexptdate = handles.exptdate{varind};
    handles.yexpttime = handles.expttime{varind};
    handles.testrange = [0,0];
    handles.baserange = [0,0];
    handles.testtag   = '-';
    handles.basetag   = '-';
    handles.freq = 0;
    handles.ypsd = 0;
    handles.totp = 0;
    handles.frepower = 0;
    handles.time = (0:length(y)-1)'/fs;
          
    %% Plot signals    
    if handles.haxes(1,1)~=0
        plot(handles.haxes(1,1),handles.time,handles.y,'k');
        title(handles.haxes(1,1),handles.yvarname,'Color','k','FontWeight','bold');
        
        if handles.haxes(1,2) ~=0
           cla(handles.haxes(1,2)); delete(handles.haxes(1,2));
           handles.haxes(1,2) = 0;
        end
    
    else %The axis is empty    
        %Create a plot if necessary
        handles.haxes(1,1) = subplot(1,2,1,'Parent',handles.panelSPAxes,'Visible','off');
        naxes = 1;
        sploth = floor((handles.panelh - 25 - (naxes*handles.gaph))/naxes); %height of each subplot [pixel]
        sploty = handles.panelh - sploth - 25; %y-coordinate of subplot [pixel]
        
        set(handles.haxes(1,1),'Unit','normalized','Xlim',[0 ceil(max(handles.time))],'Box','on',...
            'Position',[handles.splotx1/handles.panelw, sploty/handles.panelh, handles.splotw1/handles.panelw, sploth/handles.panelh]);
        
        plot(handles.haxes(1,1),handles.time,handles.y,'k');
        set(handles.haxes(1,1),'FontSize',14);
        title(handles.haxes(1,1),handles.yvarname,'Color','k','FontWeight','bold');
    end
    
    gap = prctile(handles.y,96)-prctile(handles.y,94);
    pct99 = prctile(handles.y,99);
    pct100 = max(handles.y);
    dpctmax = (pct100-pct99)/pct99; %Change from pct99
    
    pct1 = min(handles.y);
    pct2 = prctile(handles.y,2);
    dpctmin = (pct2-pct1)/pct1;
    
    if abs(dpctmax)>0.5 %Maximum is artifact
        %Determine range
        %Assume normal distribution
        ymax = pct99+gap;
    else
        ymax= pct100+gap;
    end
    
    if  abs(dpctmin)>0.5
        
        ymin = pct2-gap;
    else
        ymin = pct1-gap;
    end
    
    
    set(handles.haxes(1,1),'YLim',[ymin ymax]);

    %% Enable checkboxes for PSD estimation methods
    set(handles.popSPBase,'Enable','off','Value',1);
    set(handles.popSPTest,'Enable','off','Value',1);
    set(handles.butSPBase,'Enable','off');
    set(handles.butSPTest,'Enable','off');
    set(handles.butSPFreRange,'Enable','off');
    
    
    
    %Enable select test range
    set(handles.butUpdateTag,'Enable','on');

    
      
    %Update pop-up tag
    handlesTE = getActiveTagEditor(handles);
    definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
    
    if ~isempty(definetags)
        handles.updatePopMenu(handles,definetags,'all');
    end
    
    
    %Enable compute buttons
    set(handles.butSPTest,'Enable','on');
    set(handles.popSPTest,'Enable','on');
    set(handles.butSPCompute,'Enable','on');
    



else
    set(handles.editSPSignal,'String','');
    h = warndlg('Selected variable is invalid for computing stationary PSD.','Warning','modal');
    return
end

guidata(hObject, handles); %update handles structure


% --- Executes on button press in butSPSave.
function butSPSave_Callback(hObject, eventdata, handles)
% hObject    handle to butSPSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hfigmain = getappdata(0, 'hfigmain');

%Collect output
if isfield(handles,'y') && ~isempty(handles.y)
    
    %Initialize output structure
    psdname  = {};
    psd      = {};
    psdfs    = [];
    psdfile  = {};

    for n=1:size(handles.y,1)
        if handles.ypsd{n}~=0
            psdname = [psdname; ['psd_',handles.yvarname{n}]];
            psd     = [psd; handles.ypsd{n}];
            psdfs   = [psdfs; 2*(length(handles.freq{n})-1)/handles.fresamp(n)];
            psdfile = [psdfile; handles.yfilename{n}];
        end
    end
end

setappdata(hfigmain,'psdname',psdname);
setappdata(hfigmain,'psd',psd);
setappdata(hfigmain,'psdfs',psdfs);
setappdata(hfigmain,'psdfile',psdfile);

psdtags = get(handles.tableSPTags,'Data');
setappdata(hfigmain,'psdtags',psdtags);

handlesDB = guidata(handles.DataBrowser);
handlesDB.addResults(handlesDB.output,handlesDB,'PSD'); %add results to DB

guidata(hObject,handles);

% close;


function editSPSignal_Callback(hObject, eventdata, handles)
% hObject    handle to editSPSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPSignal as text
%        str2double(get(hObject,'String')) returns contents of editSPSignal as a double


% --- Executes during object creation, after setting all properties.
function editSPSignal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPSignal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSPDeleteTag.
function butSPDeleteTag_Callback(hObject, eventdata, handles)
% hObject    handle to butSPDeleteTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get selected row number

tabdata = get(handles.tableSPTags,'Data');
cselect = 1;
select = cellfun(@(x) x==1, tabdata(:,cselect), 'UniformOutput', 1); %logical array
select = find(select);
if ~isempty(select)
    %Delete selected row
    tabdata = get(handles.tableSPTags,'Data');
    tabdata(select,:) = [];
    set(handles.tableSPTags,'Data',tabdata);
 
    %Delete selected row in sptags
    handles.sptags(select,:) = [];
    
    
end

if isempty(tabdata)
    set(handles.butSPDeleteTag,'Enable','off');
end

set(handles.chkSelectAll,'Value',0);

guidata(hObject, handles); %update handles structure



% --------------------------------------------------------------------
function toolSPScreenshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolSPScreenshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[figfile,figpath] = uiputfile('*.*','Take a Screenshot of the GUI');
if ~ischar(figfile)
    return %return if choosing invalid file
end

pause(0.3); %to ensure that the uiputfile figure is already closed

pos = get(handles.figStationaryPSD,'Position');
imgdata = screencapture(0,'Position',pos); %take a screen capture
imwrite(imgdata,fullfile(figpath,[figfile,'.png'])); %save the captured image to file

guidata(hObject, handles); %update handles structure


% --- Executes on button press in chkSPFs.
function chkSPFs_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPFs



function editSPFs_Callback(hObject, eventdata, handles)
% hObject    handle to editSPFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPFs as text
%        str2double(get(hObject,'String')) returns contents of editSPFs as a double


% --- Executes during object creation, after setting all properties.
function editSPFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end











%==========================================================================
function initializeSubGUI(hObject,handles)

figw = 1280; %width of figure
figh = 720;  %height of figure
set(handles.figStationaryPSD,'Unit','pixels','Position',[511 100 figw figh],'Name','Stationary PSD Ultra 04/29/2019','Resize','on');


%Setting filter
load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'freqname');
load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'freqreg');
load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'selectedfreq');




if ispc %Set the fontSize for windows & mac
    fntsize = 10;
else
    fntsize = 14;
end

pnp_width = 208;
pnp_height = 94;
but_width = 67;
txt_width = 54;
but_height = 21.6;
but_define_height = 27;
left_margin = 5; 
top_margin = 20;


%Get shared data and stored them in handles structure
hfigmain = getappdata(0, 'hfigmain');
handles.emptyworkspace = getappdata(hfigmain,'FlagEmptyWorkspace');

%% Fontsize, locations of GUI objects
%panelSPWrkspc
set(handles.panelSPWrkspc,'FontSize',fntsize,'Unit','normalized');
set(handles.listWrkspc,'FontSize',fntsize);
set(handles.txtFilename,'FontSize',fntsize);
set(handles.editFilename,'FontSize',fntsize);


%Method
set(handles.panelMethods,'FontSize',fntsize,'Unit','normalized');
set(handles.chkSPWelch,'FontSize',fntsize);
set(handles.chkSPAR,'FontSize',fntsize);
set(handles.chkSPRespAR,'FontSize',fntsize);



%Data
set(handles.panelSignals,'FontSize',fntsize,'Unit','pixels');
parent_height = handles.panelSignals.Position(4);
panelChildren = get(handles.panelSignals,'Children');
set(panelChildren,'Unit','pixels');
set(handles.txtSignalName,'FontSize',fntsize,...,
    'Position',[5,parent_height-but_height-top_margin,txt_width,but_height]);
set(handles.editSPSignal,'FontSize',fntsize,...
    'Position',[64,parent_height-top_margin-but_height,but_width,but_height]);
set(handles.butSPSignal,'FontSize',fntsize,...
    'Position',[136,parent_height-top_margin-but_height,but_width,but_height]);
set(handles.popSPTest,'FontSize',fntsize,...
    'Position',[23,20.8,2*txt_width,but_height]);

set(handles.butSPTest,'FontSize',fntsize,...
    'Position',[136,handles.butSPSignal.Position(2)-10-but_define_height,0.5*but_width,but_define_height]);


set(handles.panelSignals,'FontSize',fntsize,'Unit','normalized');
panelChildren = get(handles.panelSignals,'Children');
set(panelChildren,'Unit','normalized');





%Respiratory signal
set(handles.panelSPPSD,'FontSize',fntsize,'Unit','pixels');
parent_height = handles.panelSPPSD.Position(4);
panelChildren = get(handles.panelSPPSD,'Children');
set(panelChildren,'Unit','pixels');

set(handles.txtRespName,'FontSize',fntsize,...
    'Position',[5,parent_height-but_height-top_margin,txt_width,but_height]);
set(handles.editSPResp,'FontSize',fntsize,...
    'Position',[64,parent_height-top_margin-but_height,but_width,but_height]);
set(handles.butSPResp,'FontSize',fntsize,...
    'Position',[136,parent_height-top_margin-but_height,but_width,but_height]);
set(handles.popSPBase,'FontSize',fntsize,...
    'Position',[23,parent_height-top_margin-2*but_height-10,2*txt_width,but_height]);
set(handles.butSPBase,'FontSize',fntsize,...
    'Position',[136,handles.butSPResp.Position(2)-10-but_define_height,0.5*but_width,but_define_height]);

%update tag but
set(handles.butUpdateTag,'FontSize',fntsize,'Unit','pixels','Position',[108 handles.panelSPPSD.Position(2)-26.5-2 102 26.5],'Unit','normalized');

set(handles.panelSPPSD,'FontSize',fntsize,'Unit','normalized');
set(panelChildren,'Unit','normalized');




%Frequency ranges
set(handles.panelSPFreq,'FontSize',fntsize,'Unit','pixels');
parent_height = handles.panelSPFreq.Position(4);
panelChildren = get(handles.panelSPFreq,'Children');
set(panelChildren,'Unit','pixels');


set(handles.listFreRange,'FontSize',fntsize,...
    'Position',[5,parent_height-3*but_height-top_margin,but_width,3*but_height]);

set(handles.butSPFreRange,'FontSize',fntsize,...
    'Position',[handles.listFreRange.Position(1)+handles.listFreRange.Position(3)+5,handles.listFreRange.Position(2),0.5*but_width,but_define_height]);
set(handles.editSPF1,'FontSize',fntsize,...
    'Position',[handles.butSPFreRange.Position(1),handles.butSPFreRange.Position(2)+10+but_height,0.5*but_width,but_height]);
set(handles.editSPF2,'FontSize',fntsize,...
    'Position',[handles.editSPF1.Position(1)+handles.editSPF1.Position(3)+15,handles.editSPF1.Position(2),0.5*but_width,but_height]);
set(handles.txtHz,'FontSize',fntsize,...
    'HorizontalAlignment','left',...
    'Position',[handles.editSPF2.Position(1)+handles.editSPF2.Position(3)+1,handles.editSPF2.Position(2)-2,txt_width,but_height]);
set(handles.txtHyphen,'FontSize',fntsize,...
    'Position',[handles.editSPF2.Position(1)-13,handles.editSPF2.Position(2)-2,11,but_height]);
set(handles.butSPCompute,'FontSize',fntsize);

set(handles.panelSPFreq,'FontSize',fntsize,'Unit','normalized');
set(panelChildren,'Unit','normalized');



%panelSPAxes
set(handles.panelSPAxes,'Unit','Pixels','Position',[210 220 1065,500]); set(handles.panelSPAxes,'Unit','normalized');

%Output table
set(handles.tableSPTags,'Unit','Pixels','Position',[210 20 988 200]); set(handles.tableSPTags,'Unit','normalized');

%Buttons for tableSPTags
set(handles.chkSelectAll,'FontSize',fntsize,'Unit','Pixels','Position',[1203 20 but_width but_height],'Unit','normalized');
set(handles.butSPDeleteTag,'FontSize',fntsize,'Unit','Pixels','Position',[1203 48.5 but_width but_height],'Unit','normalized'); %xpos = 5 pixels from the table, ypos = 2 pixels above chkSelectAll
set(handles.butSPExportTag,'FontSize',fntsize,'Unit','Pixels','Position',[1203 77 but_width but_height],'Unit','normalized');  %xpos = 5 pixels from the table, ypos = 2 pixels above chkSelectAll


%Save & Compute buttons
set(handles.butSPSave,'FontSize',fntsize,'Unit','pixels','Position',[2 120 102 26.5],'Unit','normalized');
set(handles.butSPCompute,'FontSize',fntsize,'Unit','pixels','Position',[108 120 102 26.5],'Unit','normalized');

%panelBatch
set(handles.panelBatch,'Unit','Pixels','Position',[0 0 figw figh],'Title','Batch processing','FontSize',fntsize,'FontWeight','bold'); set(handles.panelBatch,'Unit','normalized');
panelChildren = get(handles.panelBatch,'Children');
set(panelChildren,'FontSize',fntsize);

%panelBSignals
set(handles.panelBSignals,'Unit','pixels','Position',[20 300 600 260]);
panelChildren_sub = get(handles.panelBSignals,'Children');
set(panelChildren_sub,'FontSize',fntsize,'Unit','pixels');
set(handles.editBFs,'Position',[14 14 but_width 30]);
set(handles.butAddResp,'Position',[handles.editBFs.Position(1)+but_width+5 14 160 30]);
set(handles.butAddVar,'Position',[handles.butAddResp.Position(1) handles.butAddResp.Position(2)+35 160 30]); %5 pixels above butAddResp
set(handles.listBVar,'Position',[handles.editBFs.Position(1) handles.butAddVar.Position(2)+5+30 but_width+160+5 150]);
set(handles.txtBResp,'HorizontalAlignment','left','Position',[handles.listBVar.Position(1)+handles.listBVar.Position(3)+50 handles.listBVar.Position(2)+30 txt_width but_height]);
set(handles.editBatchResp,'Position',[handles.txtBResp.Position(1) handles.listBVar.Position(2) 160 30]);  
set(handles.butDBatchResp,'Position',[handles.editBatchResp.Position(1)+160+5 handles.editBatchResp.Position(2) 0.5*but_width 30]);
set(handles.listSelectedVar,'Position',[handles.editBatchResp.Position(1) handles.txtBResp.Position(2)+but_height+5 160 80]);
set(handles.txtBSignal,'HorizontalAlignment','left','Position',[handles.listSelectedVar.Position(1) handles.listSelectedVar.Position(2)+80 txt_width but_height]);
set(handles.butDBatchVar,'Position',[handles.listSelectedVar.Position(1)+160+5 handles.listSelectedVar.Position(2) 0.5*but_width 30]);

set(panelChildren_sub,'Unit','normalized','Enable','off');

%panelROI
set(handles.panelBROI,'Unit','pixels','Position',[640 300 600 260],'Unit','normalized');
panelChildren_sub = get(handles.panelBROI,'Children');
set(panelChildren_sub,'FontSize',fntsize,'Enable','off');

pos = getpixelposition(handles.editMatpath);
set(handles.txtDataFolder,'FontSize',fntsize,'String','Data Folder','HorizontalAlignment','right','Unit','pixels','Position',[pos(1)-105 pos(2) 100 30],'Unit','normalized');

pos = getpixelposition(handles.editTagpath);
set(handles.txtTagFolder,'FontSize',fntsize,'HorizontalAlignment','right','String','Tag Folder','Unit','pixels','Position',[pos(1)-105 pos(2) 100 30],'Unit','normalized');


set(handles.butBSaveOutput,'Enable','off');

set(handles.editBResultDisplay,'FontSize',fntsize,'String','','Unit','pixels','Position',[20 20 600 250],'Enable','inactive');


%% If there are no variables in workspace, automatically opens batch 2016-04-08
if handles.emptyworkspace
    set(handles.panelBatch,'Visible','on');
    set(handles.menuMode,'Enable','off');
else
    handles.varname     = getappdata(hfigmain, 'SDvarname');
    handles.filename    = getappdata(hfigmain, 'SDfilename');
    handles.acrostic    = getappdata(hfigmain, 'SDacrostic');
    handles.subjnum     = getappdata(hfigmain, 'SDsubjnum');
    handles.exptdate    = getappdata(hfigmain,'SDexptdate');
    handles.expttime    = getappdata(hfigmain,'SDexpttime');
    handles.signal      = getappdata(hfigmain, 'SDsignal');
    handles.fs          = getappdata(hfigmain, 'SDfs');
    handles.flagnorm    = getappdata(hfigmain, 'SDflagnorm');
    handles.flagdetrend = getappdata(hfigmain, 'SDflagdetrend');
    handles.detrend     = getappdata(hfigmain, 'SDdetrend');
    handles.scale       = getappdata(hfigmain, 'SDscale');
    handles.y           = {};
    handles.ypsd        = {};
    handles.freq        = {};
    handles.fresamp     = [];
    handles.df = [];
    
    %Respiration
    handles.resp = [];
    handles.respfs = [];
    handles.respname = '-';
    handles.resptime = [];
    
    
    %Initial frequency ranges
    handles.fregion = freqreg;  %Load from psdsetting.mat
    
    %Define frequency region in listbox
    handles.fregname = freqname; %Load from psdsetting.mat
    handles.sptags = {}; %output tags after compute
    
    %Keep track of current PSD variable index.
    handles.currentvarind = 0;
    handles.currentmethod = 'Welch';
    
    
    
    %% Initialize graphic variables
    varind = 1;
    handles.panelw = 1065;  %width of axes panel [pixel]
    handles.panelh = 500;  %height of axes panel [pixel]
    handles.splotx1 = 45;  %x-coordinate of the left subplots [pixel]
    handles.splotx2 = 590; %x-coordinate of the right subplots [pixel]
    handles.splotw1 = 500; %width of the left subplots [pixel]
    handles.splotw2 = 475; %width of the right subplots [pixel]
    handles.gaph    = 60;  %gap between upper and lower subplots [pixel]
    
    %Initial axes
    delete(findobj(handles.panelSPAxes,'Type','axes'));
    handles.haxes = zeros(2,2);
    
    
    
    
    %Workspace
    varind = 1;
    [~,name,ext] = fileparts(handles.filename{varind});
    set(handles.listWrkspc,'String',handles.varname,'Value',varind,'Enable','on');
    set(handles.editFilename,'String',[name,ext],'Enable','inactive');
    
    %Select Signals
    set(handles.butSPSignal,'FontSize',fntsize,'Enable','on');
    set(handles.editSPSignal,'FontSize',fntsize,'String','','Enable','inactive');
    set(handles.butSPResp,'FontSize',fntsize,'Enable','off');
    set(handles.editSPResp,'FontSize',fntsize,'String','','Enable','off');
    
    %Methods
    set(handles.chkSPWelch,'FontSize',fntsize,'Value',1,'Enable','off');
    set(handles.chkSPAR,'FontSize',fntsize,'Value',0,'Enable','on');
    set(handles.chkSPRespAR,'FontSize',fntsize,'Value',0,'Enable','on');
    
    %Frequency Ranges
    set(handles.editSPF1,'FontSize',fntsize,'String',handles.fregion(1,1));
    set(handles.editSPF2,'FontSize',fntsize,'String',handles.fregion(1,2));
    
    %Compute PSD
    set(handles.butSPBase,'FontSize',fntsize,'Enable','off');
    set(handles.butSPCompute,'FontSize',fntsize,'Enable','off');
    set(handles.popSPTest,'FontSize',fntsize,'String',{'<Tags>'},'Value',1,'Enable','off');
    set(handles.popSPBase,'FontSize',fntsize,'String',{'<Tags>'},'Value',1,'Enable','off');
    
    %Tags
    set(handles.tableSPTags,'FontSize',fntsize,'Enable','inactive','Data',{});
    set(handles.butSPDeleteTag,'FontSize',fntsize,'Enable','off');
    
    %Save to workspace
    set(handles.butSPSave,'FontSize',fntsize,'FontWeight','bold','Enable','off');
    
    %Status bar
    set(handles.editSPStatus,'FontSize',fntsize,'Enable','off');
    
    %Check if Statistics toolbox is avaiable
    handles.flagToolbox = 1;
    
    %List box (frequency range)
    % 1. Retrieve DefineRegionFreq where end is less than max.
    %handlesTE = getActiveTagEditor(handles);
    %ftags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegionFreq');

    % 2. Update listbox, fregion and fregname
    if any(selectedfreq)
        handles.fregname = freqname(selectedfreq);
        handles.fregion = freqreg(selectedfreq,:);

    end
    %3. Save define frequency region to listbox
    set(handles.listFreRange,'FontSize',fntsize,'String',handles.fregname,'Value',1,'Enable','on');
    
end




guidata(hObject, handles); %update handles structure


% --- Executes when user attempts to close figStationaryPSD.
function figStationaryPSD_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figStationaryPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
    handlesDB = guidata(handles.DataBrowser);
    handlesDB.subStationaryPSD = [];
    guidata(handles.DataBrowser,handlesDB);
    
    obj = findobj('Tag','DataBrowser_TIVPSDsetting');
    if ~isempty(obj)
        close(obj);
    end
    delete(hObject);
catch
    delete(hObject);
end


% --- Executes on button press in butSPCompute.
function butSPCompute_Callback(hObject, eventdata, handles)
% hObject    handle to butSPCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %Enable checkboxes for PSD estimation methods

set(handles.editSPStatus,...
    'String','Computing.....',...
    'BackgroundColor',[1 1 1],'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');

load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'df');
load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'fs');
load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'isnorm');
load(fullfile(handles.substationarysettingpath,'psdsetting.mat'),'detrendorder');


%% Downsample the selected signal,y
fresamp = fs;
handles.fresamp = fresamp;

if handles.yfs~=fresamp && handles.yfs>fresamp  %Check whether the original fs of y is multiple of fs
    if ~rem(handles.yfs,fresamp)                %fs is divisible by fresamp
        downsampled_y = downsample(handles.y, handles.yfs/fresamp);
    else
        [p,q] = rat(fresamp/handles.yfs);
        downsampled_y = resample(handles.y,p,q, 0); %filter order = 0
    end
    
elseif handles.yfs == fresamp
    downsampled_y = handles.y;
    
        
elseif fs<fresamp
    %warning
    msgbox('Cannot downsample because the sampling frequency of the signal is lower.','Warning','warn');
    return
    
end



%% Downsample the respiration, if selected
if ~isempty(handles.resp)
    if handles.respfs~=fresamp && handles.respfs>fresamp %Check whether the original fs of y is multiple of fs
        if ~rem(handles.respfs,fresamp)                  %fs is divisible by fresamp
            downsampled_resp = downsample(handles.resp, handles.respfs/fresamp);
        else
            [p,q] = rat(fresamp/handles.respfs);
            downsampled_resp = resample(handles.resp,p,q, 0); %filter order = 0
        end
        
    elseif handles.respfs == fresamp
        downsampled_resp = handles.resp;    
    elseif handles.respfs<fresamp
        %warning
        msgbox('Cannot downsample because the sampling frequency of the signal is lower.','Warning','warn');
        return
        
    end

else
    downsampled_resp = [];
    
end



%% Data for calculation
downsampled_f = handles.fresamp;
%Normalize to the 95%tile
if isnorm
    downsampled_y = downsampled_y/prctile(downsampled_y,95);
end

%% Load frequency resolution, detrending order, frequency ranges, modeling order

%% Get testrange, the indices must match the input frequency
i1 = round(handles.testrange(1)*fresamp+1); %convert from sec to samples
i2 = round(handles.testrange(2)*fresamp+1); %convert from sec to samples

if i2>length(downsampled_y)
    i2 = length(downsampled_y);
end

nrow = length(handles.fregion(:,1)); %all the frequency ranges to output
fregname = {'Totalpwr'}; %Use all current fregions we want to output



%Welch PSD
if get(handles.chkSPWelch,'Value')

    %% Check if task indices are valid
    if i1==0 || i2==0 || isnan(i1) || isnan(i2)
        msgbox('Please select data range!','Warning','warn');
        return;
        
    else

        y = downsampled_y(i1:i2);     
    end
  
    %Users aren't allowed to change the model order yet
    out = TIVPSD(y,downsampled_f,'method','welch','df',df,'detrendorder',detrendorder);   
    
    p = out.Sy;
    df = out.df;
    fpower = trapz(out.f,out.Sy); %Total power;
    handles.freq = out.f;
    handles.ypsd= p;
    handles.df = df;
    
    % store all frequency power in 1 cell
    handles.frepower = fpower; %Total power
    nrow = nrow+1; %Add total power (aka variance)
   
elseif get(handles.chkSPAR,'Value') %Autoregressive   
    if i1==0 || i2==0 || isnan(i1) || isnan(i2)
        msgbox('Please select data range!','Warning','warn');
        return;                
    else       
        y = downsampled_y(i1:i2);     
    end

    %Call TIVPSD, maximum model order is 20
    out = TIVPSD(y,downsampled_f,'method','ar','df',df,'detrendorder',detrendorder);   
    
    p = out.Sy;
    df = out.df;
    fpower = trapz(out.f,out.Sy); %Total power;
    handles.freq = out.f;
    handles.ypsd= p;
    handles.df = df;
    
    % store all frequency power in 1 cell
    handles.frepower = fpower; %Total power
    nrow = nrow+1; %Add total power (aka variance)

    
      
elseif get(handles.chkSPRespAR,'Value')

    r1 = round((handles.baserange(1)*fresamp+1)); %convert from sec to sample
    r2 = round(handles.baserange(2)*fresamp+1); %convert from sec to sample
    
    if isempty(downsampled_resp)
        set(handles.editSPStatus,...
            'String','Respiratory signal is not selected!.....',...
            'BackgroundColor',[1 1 1],'ForegroundColor',[1 0 0],'FontAngle','italic',...
            'Enable','inactive');
        return
    end
    
    if r2>length(downsampled_resp)
        r2 = length(downsampled_resp);      
    end
    
 
    
    if i1==0 || i2==0 || isnan(i1) || isnan(i2)  %Use the whole data
        msgbox('Please select data range!','Warning','warn');
        return;             
    else       
        y = downsampled_y(i1:i2);     
    end
    
    if r1==0 || r2== 0 || isnan(r1) || isnan(r2)
        msgbox('Please select respiration baseline!','Warning','warn');
        return;
    else
        resp = downsampled_resp(i1:i2);
        resp0 = downsampled_resp(r1:r2); %Baseline range
    end
    
    
    %Respiratory-adjusted PSD
    outresp = TIVPSD(resp0,fresamp,'method','ar','df',df,'detrendorder',detrendorder);
    TotalPwr = trapz(outresp.f,outresp.Sy);
    out = TIVPSD_inputadj(y,resp,outresp.Sy,downsampled_f,'method','arx','df',df,'detrendorder',detrendorder);
    
    f = (0:df:fresamp/2)'; %frequency vector for positive freqs [Hz]
    handles.freq = f;
    handles.ypsd = out.Sya;
    handles.df = df;
    p = out.Sya;
    
    fpower = trapz(out.f,out.Sya);
    % store all frequency power in 1 cell
    handles.frepower = fpower;    
    nrow = nrow+2; %Add total power of a signal&resp
   
end


%% Plotting
%If the method = Resp-AR
if strcmp(handles.currentmethod,'RespadjAR') %Resp-AR has extra subplots   
    pos = get(handles.haxes(1,1),'Position');
    handles.haxes(1,2) = subplot(2,2,2,'Parent',handles.panelSPAxes);     %Generate a subplot
    subplot(handles.haxes(1,2)); plot(handles.freq,handles.ypsd,'r'); %Plot on the current axis
        
    set(handles.haxes(1,2),'Unit','normalized','Xlim',[0,downsampled_f/2],'FontSize',14,'Box','on',...
        'Position',[handles.splotx2/handles.panelw, pos(2), pos(3), pos(4)]);   
    title(handles.testtag,'FontWeight','bold');

    
    %Plot the spectrum of respiration
    pos = get(handles.haxes(2,1),'Position');
    handles.haxes(2,2) = subplot(2,2,4,'Parent',handles.panelSPAxes);     %Generate a subplot
    subplot(handles.haxes(2,2)); plot(handles.freq,outresp.Sy,'r'); %Plot on the current axis
    
    set(handles.haxes(2,2),'Unit','normalized','Xlim',[0,downsampled_f/2],'FontSize',14,'Box','on',...
        'Position',[handles.splotx2/handles.panelw, pos(2), pos(3), pos(4)]);

    
    
    title(handles.basetag,'FontWeight','bold');
    xlabel('Frequency (Hz)');
    
else %If the current method = Welch, AR
     %Plot the spectrum of the signal
    pos = get(handles.haxes(1,1),'Position');
    handles.haxes(1,2) = subplot(1,2,2,'Parent',handles.panelSPAxes);     %Generate a subplot
    subplot(handles.haxes(1,2)); plot(handles.freq,handles.ypsd,'r'); %Plot on the current axis
    set(handles.haxes(1,2),'Unit','normalized','Xlim',[0,downsampled_f/2],'FontSize',14,'Box','on',...
        'Position',[handles.splotx2/handles.panelw, pos(2), handles.splotw2/handles.panelw, pos(4)]);
    
    title(handles.testtag,'FontWeight','bold');
    xlabel('Frequency (Hz)');

end

%Display fs, df on the plot
%Sampling frequency
axes(handles.haxes(1,1));
txt = text(0,0,['fs = ',num2str(handles.fresamp)]);  set(txt,'Unit','normalized','Position',[0.8 0.95]);
axes(handles.haxes(1,2));
txt = text(0,0,['df = ',num2str(df)]);  set(txt,'Unit','normalized','Position',[0.8 0.95]);

%% Final output
ncol = 15;
newtag = cell(nrow,ncol);

%% Update fpower
[pathstr,name,ext] = fileparts(handles.yfilename);
if strcmp(handles.currentmethod,'RespadjAR')
   %fregname = [handles.basetag;fregname];
   fregname = {[handles.respname,'-Totalpwr'];[handles.yvarname,'-Totalpwr']}; %Frequency ranges = total power
   i1 = handles.baserange(1);
   i2 = handles.baserange(2); %sec
   
   fpower = {TotalPwr;fpower}; %Output total power of baseline respiration & test signal
  
   newtag(:,10) = [{i1};repmat({handles.testrange(1)},nrow-1,1)]; %beginning of test range [sec]
   newtag(:,11) = [{i2};repmat({handles.testrange(2)},nrow-1,1)]; %end of test range [sec]
   newtag(:,12) = [{handles.basetag};repmat({handles.testtag},nrow-1,1)];
else
    newtag(:,10) = repmat({handles.testrange(1)},nrow,1); %beginning of test range [sec]
    newtag(:,11) = repmat({handles.testrange(2)},nrow,1); %end of test range [sec]
    newtag(:,12) = repmat({handles.testtag},nrow,1);
    fpower = {fpower};
end
%Calculate power for the other frequency ranges

for nf=1:length(handles.fregion(:,1))
    z = handles.freq>=handles.fregion(nf,1) & handles.freq<handles.fregion(nf,2);
    if ~isempty(z)
        fpower = [fpower;trapz(p(z))*df];
    else
        fpower = [fpower;0]; %The frequency range is outside the spectra
    end
    fregname = [fregname;handles.fregname{nf}];

end

    
%% Extract side if selected variable has side info
rr = strfind(handles.yvarname,'right');
if ~isempty(rr)
    side = 'right';
else
    ll = strfind(handles.yvarname,'left');
    if ~isempty(ll)
        side = 'left';
    else
        side = '-';
    end
end
newtag(:,1)  = repmat({[name,ext]},nrow,1); 
newtag(:,2)  = repmat({'TIVPSD'},nrow,1);
newtag(:,3)  = repmat({[handles.yacrostic]},nrow,1);
newtag(:,4)  = repmat({[handles.ysubjnum]},nrow,1);
newtag(:,5)  = repmat({[handles.yexptdate]},nrow,1);
newtag(:,6)  = repmat({[handles.yexpttime]},nrow,1);
newtag(:,7)  = repmat({[handles.yvarname]},nrow,1);
newtag(:,8)  = repmat({side},nrow,1);
newtag(:,9)  = repmat({1/df},nrow,1);


newtag(:,13) = repmat({[handles.currentmethod]},nrow,1);
newtag(:,14) = fregname;
newtag(:,15) = fpower; %total power is in the first row


%% Update Output Table        
checkbox = num2cell(false(nrow,1));
display = [checkbox,newtag(:,3:5),newtag(:,7:15)];
tabdata = get(handles.tableSPTags,'Data'); %old tags data
tabdata = [tabdata; display]; %updated table data
set(handles.tableSPTags,'Data',tabdata,'Enable','on');
handles.sptags = [handles.sptags;newtag]; %output tags after compute


%% Enable UI controls
set(handles.butSPSave,'Enable','on');
set(handles.butSPDeleteTag,'Enable','on');
set(handles.butSPSignal,'Enable','on');
set(handles.butSPFreRange,'Enable','on');


set(handles.editSPStatus,...
    'String','Finish!.....',...
    'BackgroundColor',[1 1 1],'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');


guidata(hObject, handles); %update handles structure


% --- Executes on button press in butSPTest.
function butSPTest_Callback(hObject, eventdata, handles)
% hObject    handle to butSPTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Show instruction to select the current plot
cfig = get(gcf,'Color');
%varind = handles.currentvarind;
%axenum = find(handles.varonaxes == varind);
axenum = 1;
hax = handles.haxes(axenum,1);
%Highlight selected axes
set(hax,'Color',[1 0.93 0.93]);

%Show instruction to mark a region
set(handles.editSPStatus,...
    'String','Instruction: Draw a rectangle on the highlighted plot to mark a region.',...
    'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');

%Select test range
rect = getrect(hax); %rect = [xmin ymin width height] (unit = unit of x-axis)

%Restore color of axes
set(hax,'Color',[1,1,1]);

%Remove instruction
set(handles.editSPStatus,...
    'String','',...
    'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
    'Enable','off');

%Check if width of selected region = 0. If so, enable other tools & return.
if rect(3)==0
    return
end



%Get selected range [no. of samples]
i1 = rect(1);
i2 = rect(1) + rect(3);
if i1<0
    i1 = 0;
end
if i2>handles.time(end)
    i2 = handles.time(end);
end
%====================================
%Just in case selected test range is invalid
if i1>=i2
    if handles.testrange(1,1)==0 && handles.testrange(1,2)==0
        %Test range has never been selected
        %--> Reset color of the plotted signal & return
        hline = get(hax,'Children');
        if ~isempty(hline)
            set(hline,'Color','b');
        end
        return
    else
        %Test range was previously selected
        %--> Restore previously selected test range value
        i1 = handles.testrange(1,1);
        i2 = handles.testrange(1,2);
    end    
end
%====================================
[newtags] = genDefineRegionTag([i1,i2],handles);

% check if the user named the tag or not
if ~isempty(newtags) 
    
    %At this point a user selected the tag for a signal, 
    %If the spectra plot is not empty, and the tag is not the current tag,
    %clear the plot
    if handles.haxes(1,2)~=0 && i1~=handles.testrange(1,1) && i2~=handles.testrange(1,2)        
        cla(subplot(handles.haxes(1,2)));
        set(handles.haxes(1,2),'Visible','off');
        handles.haxes(1,2) = 0;
        handles.ypsd = 0;        
    end
    

    
    %Plot signal
    time = handles.time;
    subplot(handles.haxes(1,1));
    xlimit = get(handles.haxes(1,1),'Xlim');
    plot(handles.time,handles.y,'k'); hold on;
    plot(time(time>=i1 & time<=i2),handles.y(time>=i1 & time<=i2),'r'); hold off;
    title(handles.yvarname,'Color','k','FontWeight','bold');
    xlabel('Time (sec)');
    xlim(xlimit);
    
        gap = prctile(handles.y,96)-prctile(handles.y,94);
    pct99 = prctile(handles.y,99);
    pct100 = max(handles.y);
    dpctmax = (pct100-pct99)/pct99; %Change from pct99
    
    pct1 = min(handles.y);
    pct2 = prctile(handles.y,2);
    dpctmin = (pct2-pct1)/pct1;
    
    if abs(dpctmax)>0.5 %Maximum is artifact
        %Determine range
        %Assume normal distribution
        ymax = pct99+gap;
    else
        ymax= pct100+gap;
    end
    
    if  abs(dpctmin)>0.5
        
        ymin = pct2-gap;
    else
        ymin = pct1-gap;
    end
    
    
    set(handles.haxes(1,1),'YLim',[ymin ymax]);

    
    handles.testrange = [i1,i2]; %[sec,sec]
    %Get test tagname
    handles.testtag = newtags{1,12};
       
    % Update pop-up choices 
    handles.updatePopMenu(handles,newtags,'test');   

end


guidata(hObject,handles);

% --- Executes on selection change in popSPTest.
function popSPTest_Callback(hObject, eventdata, handles)
% hObject    handle to popSPTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varind = handles.currentvarind;
% if varind==0
%     return
% end
contents = cellstr(get(hObject,'String'));
seltag = contents{get(hObject,'Value')};

if get(hObject,'Value') >= 1
    i1 = strfind(seltag,'(');
    i2 = strfind(seltag,' - ');
    i3 = strfind(seltag,'sec');
    r1 = str2double(seltag(i1+1:i2-1)); %[sec]
    r2 = str2double(seltag(i2+3:i3-1)); %[sec]


    handles.testrange = [r1,r2]; %Time(sec)
    handles.testtag = seltag(1:i1-1); % tagname
    hax = handles.haxes(1,1);
    set(hax,'Color',[1,1,1]);

    %Plot signal
    time = handles.time;
    signal = handles.y;
    subplot(handles.haxes(1,1));
    plot(time,signal,'k'); hold on;
    plot(time(time>=r1 & time<=r2),signal(time>=r1 & time<=r2),'r'); hold off;
    title(handles.yvarname,'Color','k','FontWeight','bold');
    xlabel('Time (sec)');
    
    gap = prctile(handles.y,96)-prctile(handles.y,94);
    pct99 = prctile(handles.y,99);
    pct100 = max(handles.y);
    dpctmax = (pct100-pct99)/pct99; %Change from pct99
    
    pct1 = min(handles.y);
    pct2 = prctile(handles.y,2);
    dpctmin = (pct2-pct1)/pct1;
    
    if abs(dpctmax)>0.5 %Maximum is artifact
        %Determine range
        %Assume normal distribution
        ymax = pct99+gap;
    else
        ymax= pct100+gap;
    end
    
    if  abs(dpctmin)>0.5
        
        ymin = pct2-gap;
    else
        ymin = pct1-gap;
    end
    
    
    set(handles.haxes(1,1),'YLim',[ymin ymax],'FontSize',14);
    
end



guidata(hObject,handles);

% --- Executes on button press in butUpdateTag.
function butUpdateTag_Callback(hObject, eventdata, handles)
% hObject    handle to butUpdateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesTE = getActiveTagEditor(handles);
definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion'); %Get new tags and update in the pop-ups
handles.updatePopMenu(handles,definetags,'all'); %Update pop-ups for tags

    
%% Reset test&base ranges, basename,tagname - Need changes
handles.testrange = [0,0];
handles.baserange = [0,0];
handles.testtag = '-';
handles.basetag = '-';


%Replot the signal to update the regions if necessary
if handles.haxes(1,1) ~= 0
    
    %Plot the signal   
    plot(handles.haxes(1,1),handles.time,handles.y,'k');
    xlabel('Time (sec)');
    title(handles.yvarname,'FontWeight','bold');
    
    %Delete output plots, if exist
    if handles.haxes(1,2) ~=0      
       delete(handles.haxes(1,2)); handles.haxes(1,2) = 0; 
    end
    

    %Plot respiration if exists
    if get(handles.chkSPRespAR,'Value') && handles.haxes(2,1)~=0 %If respiration is plotted
        
            
        %Replot respiration without tag
        plot(handles.haxes(2,1),handles.time,handles.resp,'k');
        title(handles.respname,'Color','k','FontWeight','bold');
        xlabel('Time (sec)');
                
        set(handles.butSPBase,'Enable','on');
        set(handles.popSPBase,'Enable','on');
        set(handles.butSPFreRange,'Enable','off');
    
    end

end

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popSPTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSPTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%------------------------------Non-Callbacck Functions--------------------
function [newtags] = genDefineRegionTag(tagrange,handles)
    
% needed variables
  xmin = tagrange(1);
  xmax = tagrange(2);
  filename = handles.yfilename;
  [path,name,ext] = fileparts(filename);
  filename = [name,ext];
  acrostic = handles.yacrostic;
  subjnum = handles.ysubjnum;
  fs = handles.fresamp;  
  varname = handles.yvarname;
  exptdate = handles.yexptdate;
  expttime = handles.yexpttime;
  
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
  poptag = get(handles.popSPTest,'String');
  
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
  newtags{1,2}  = 'TIVPSD';             %Module
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
handlesDB = guidata(handles.DataBrowser);
handlesTM = guidata(handlesDB.TagManager);

if strcmp(get(handlesDB.tableEditor,'Enable'),'on')
    handlesTE = handlesDB;
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
             % str = [str; tag];
    end
end

function [] = updatePopMenu(handles,newtags,mode)
if isempty(handles.yfilename)
    return %If the signal is not selected, do not update
end
%update pop-ups for tags
switch mode
    case 'test' %select define region button
        % Test
        [pathstr,name,ext] = fileparts(handles.yfilename);
        oldstr = get(handles.popSPTest,'String');
        str = handles.updatePopChoices(oldstr,newtags,[name,ext]);
        val = length(str);
        set(handles.popSPTest,'String',str,'Value',val,'Enable','on');
    case 'base'
        % Base
        [pathstr,name,ext] = fileparts(handles.yfilename);
        oldstr = get(handles.popSPBase,'String');
        str = handles.updatePopChoices(oldstr,newtags,[name,ext]);
        val = length(str);
        set(handles.popSPBase,'String',str,'Value',val,'Enable','on');

    otherwise %delete or update button
        [pathstr,name,ext] = fileparts(handles.yfilename);
        str = handles.updatePopChoices([],newtags,[name,ext]);
        val = 1;
        set(handles.popSPTest,'String',str,'Value',val);
        set(handles.popSPBase,'String',str,'Value',val);
end

guidata(handles.popSPTest,handles);



% --- Executes on button press in chkSPWelch.
function chkSPWelch_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPWelch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPWelch
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.currentmethod = 'Welch';
    %Uncheck AR and RespadjAR
    set(handles.chkSPAR,'Value',0,'Enable','on');
    set(handles.chkSPRespAR,'Value',0,'Enable','on');
    set(handles.chkSPWelch,'Enable','off');
    

    
    set(handles.butSPResp,'Enable','off');
    set(handles.editSPResp,'Enable','off','String',[]);
    
    
    set(handles.butSPBase,'Enable','off');
    set(handles.popSPBase,'Value',1,'Enable','off');
    
    %% Create new axes
    if handles.haxes(1,2) ~=0 
         delete(handles.haxes(1,2)); handles.haxes(1,2) = 0;
    end
    
    if handles.haxes(1,1) ~=0 
        delete(handles.haxes(1,1)); handles.haxes(1,1) = 0; 
    end
    
    if handles.haxes(2,1) ~=0 
        delete(handles.haxes(2,1)); handles.haxes(2,1) = 0; 
    end
    
    if handles.haxes(2,2) ~=0 
        delete(handles.haxes(2,2)); handles.haxes(2,2) = 0; 
    end
    
    handles.haxes(1,1) = subplot(1,2,1,'Parent',handles.panelSPAxes,'Visible','off');   
    naxes = 1;
    sploth = floor((handles.panelh - 25 - (naxes*handles.gaph))/naxes); %height of each subplot [pixel]
    sploty = handles.panelh - sploth - 25; %y-coordinate of subplot [pixel]
    
    if isfield(handles,'time') && ~isempty(handles.time)

        set(handles.haxes(1,1),'Unit','normalized','Xlim',[0 ceil(max(handles.time))],'FontSize',10,'Box','on',...
            'Position',[handles.splotx1/handles.panelw, sploty/handles.panelh, handles.splotw1/handles.panelw, sploth/handles.panelh]);
    end
    
    if isfield(handles,'y') && ~isempty(handles.y)       
        plot(handles.haxes(1,1),handles.time,handles.y,'k');
        xlabel('Time (sec)');
        title(handles.yvarname,'FontWeight','bold');
        
        %Plot the selected tag, if exists
        if handles.testrange(1)~=0 && handles.testrange(2)~=0
            i1 = handles.testrange(1); i2 = handles.testrange(2);
            
            hold(handles.haxes(1,1),'on');
            plot(handles.haxes(1,1),handles.time(handles.time>=i1 & handles.time<=i2),handles.y(handles.time>=i1 & handles.time<=i2),'r');
            hold(handles.haxes(1,1),'off');
            
            
        end
        
    end
    
    
    %Check respiration        
    %% Remove respiration
    handles.resp = [];
    handles.respfs = [];
    handles.respname = '-';
    handles.resptime = [];

    
    
end
guidata(hObject,handles);


% --- Executes on button press in chkSPAR.
function chkSPAR_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPAR
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.currentmethod = 'AR';
    
    
    %Uncheck AR and RespadjAR
    set(handles.chkSPWelch,'Value',0,'Enable','on');
    set(handles.chkSPRespAR,'Value',0,'Enable','on');
    set(handles.chkSPAR,'Enable','off');
    
    %Disable edit order box
    set(handles.editSPResp,'Enable','off','String','');
    set(handles.butSPResp,'Enable','off');
    
    
    set(handles.butSPBase,'Enable','off');
    set(handles.popSPBase,'Enable','off');
    
    %% Create new axes
    if handles.haxes(1,2) ~=0 
         delete(handles.haxes(1,2)); handles.haxes(1,2) = 0;
    end
    
    if handles.haxes(1,1) ~=0 
        delete(handles.haxes(1,1)); handles.haxes(1,1) = 0; 
    end
    
    
    if handles.haxes(2,1) ~=0 
        delete(handles.haxes(2,1)); handles.haxes(2,1) = 0; 
    end
    
    if handles.haxes(2,2) ~=0 
        delete(handles.haxes(2,2)); handles.haxes(2,2) = 0; 
    end
    
    
    
    handles.haxes(1,1) = subplot(1,2,1,'Parent',handles.panelSPAxes,'Visible','off');   
    naxes = 1;
    sploth = floor((handles.panelh - 25 - (naxes*handles.gaph))/naxes); %height of each subplot [pixel]
    sploty = handles.panelh - sploth - 25; %y-coordinate of subplot [pixel]
    
    %Error when changing the method before selecting the signal
    if isfield(handles,'time') && ~isempty(handles.time)
        set(handles.haxes(1,1),'Unit','normalized','Xlim',[0 ceil(max(handles.time))],'FontSize',10,'Box','on',...
            'Position',[handles.splotx1/handles.panelw, sploty/handles.panelh, handles.splotw1/handles.panelw, sploth/handles.panelh]);
    end
    
    if isfield(handles,'y') && ~isempty(handles.y)       
        plot(handles.haxes(1,1),handles.time,handles.y,'k');
        xlabel('Time (sec)');
        title(handles.yvarname,'FontWeight','bold');
        
        %Plot the selected tag, if exists
        if handles.testrange(1)~=0 && handles.testrange(2)~=0
            i1 = handles.testrange(1); i2 = handles.testrange(2);
            
            hold(handles.haxes(1,1),'on');
            plot(handles.haxes(1,1),handles.time(handles.time>=i1 & handles.time<=i2),handles.y(handles.time>=i1 & handles.time<=i2),'r');
            hold(handles.haxes(1,1),'off');
            
            
        end
        
    end
    
    
    %Check respiration        
    %% Remove respiration
    handles.resp = [];
    handles.respfs = [];
    handles.respname = '-';
    handles.resptime = [];
    
 
    
    
end
guidata(hObject,handles);


% --- Executes on button press in chkSPRespAR.
function chkSPRespAR_Callback(hObject, eventdata, handles)
% hObject    handle to chkSPRespAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSPRespAR
if (get(hObject,'Value') == get(hObject,'Max'))
    handles.currentmethod = 'RespadjAR';
    set(handles.butSPResp,'Enable','on');
    set(handles.chkSPRespAR,'Enable','off');
    
    %Uncheck AR and RespadjAR
    set(handles.chkSPWelch,'Value',0,'Enable','on');
    set(handles.chkSPAR,'Value',0,'Enable','on');
    set(handles.editSPResp,'Enable','inactive');
    

    
    
    %% Create new axes
    handles.haxes(1,1) = subplot(2,2,1,'Parent',handles.panelSPAxes,'Visible','off');
    handles.haxes(2,1) = subplot(2,2,3,'Parent',handles.panelSPAxes,'Visible','off');
    
    %clear output axis
    if handles.haxes(1,2) ~=0
        cla(handles.haxes(1,2)); delete(handles.haxes(1,2));
        handles.haxes(1,2) = 0;
    end
    
    if handles.haxes(2,2) ~=0
        cla(handles.haxes(1,2)); delete(handles.haxes(1,2));
        handles.haxes(2,2) = 0;
    end
    
    naxes = 2;
    sploth = floor((handles.panelh - 25 - (naxes*handles.gaph))/naxes); %height of each subplot [pixel]
    sploty = handles.panelh - sploth - 25; %y-coordinate of subplot [pixel]
    
    %% If at least one signal is selected, handles.time is not zero  
    if isfield(handles,'time') && ~isempty(handles.time)
    
        set(handles.haxes(1,1),'Unit','normalized','Xlim',[0 ceil(max(handles.time))],'FontSize',10,'Box','on',...
            'Position',[handles.splotx1/handles.panelw, sploty/handles.panelh, handles.splotw1/handles.panelw, sploth/handles.panelh]);
        
        %Recalculate sploty for the bottom axis
        sploty = handles.panelh - 2*sploth - handles.gaph - 25; %n*sploth-(n-1)*handles.gaph
        set(handles.haxes(2,1),'Unit','normalized','Xlim',[0 ceil(max(handles.time))],'FontSize',10,'Box','on',...
            'Position',[handles.splotx1/handles.panelw, sploty/handles.panelh, handles.splotw1/handles.panelw, sploth/handles.panelh]);
        
        
        %% Replot the current signals if exist
        %Signal
        if ~isempty(handles.y)
            
            plot(handles.haxes(1,1),handles.time,handles.y,'k');
            title(handles.yvarname,'Color','k','FontWeight','bold');
            xlabel('Time (sec)');
            
            %Plot the selected tag, if exists
            if handles.testrange(1)~=0 && handles.testrange(2)~=0
                i1 = handles.testrange(1); i2 = handles.testrange(2);
                
                hold(handles.haxes(1,1),'on');
                plot(handles.haxes(1,1),handles.time(handles.time>=i1 & handles.time<=i2),handles.y(handles.time>=i1 & handles.time<=i2),'r');
                hold(handles.haxes(1,1),'off');
                
                
            end
            
            
        end
              
        
        %Respiration
        if ~isempty(handles.resp)
            plot(handles.haxes(2,1),handles.resptime,handles.resp,'k');
            title(handles.respname,'Color','k','FontWeight','bold');
            xlabel('Time (sec)');
            
            %Plot the baseline tag, if exists
            if handles.baserange(1)~=0 && handles.baserange(2)~=0
                i1 = handles.baserange(1); i2 = handles.baserange(2);
                
                hold(handles.haxes(2,1),'on');
                plot(handles.haxes(2,1),handles.resptime(handles.resptime>=i1& handles.resptime<=i2),handles.resp(handles.resptime>=i1& handles.resptime<=i2),'r');
                hold(handles.haxes(2,1),'off');
                
                
            end
            

            
        end
            
        
        
    end



    
    
    
   
    


end
guidata(hObject,handles);


% --- Executes on selection change in listFreRange.
function listFreRange_Callback(hObject, eventdata, handles)
% hObject    handle to listFreRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listFreRange contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listFreRange
%Display frequency range
value = get(hObject,'Value'); %Get selection
set(handles.editSPF1,'FontSize',10,'String',handles.fregion(value,1));
set(handles.editSPF2,'FontSize',10,'String',handles.fregion(value,2));


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function listFreRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listFreRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function editSPF1_Callback(hObject, eventdata, handles)
% hObject    handle to editSPF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPF1 as text
%        str2double(get(hObject,'String')) returns contents of editSPF1 as a double


% --- Executes during object creation, after setting all properties.
function editSPF1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPF1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSPF2_Callback(hObject, eventdata, handles)
% hObject    handle to editSPF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSPF2 as text
%        str2double(get(hObject,'String')) returns contents of editSPF2 as a double


% --- Executes during object creation, after setting all properties.
function editSPF2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSPF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSPFreRange.
function butSPFreRange_Callback(hObject, eventdata, handles)
% hObject    handle to butSPFreRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% First check if the computation is done
cfig = get(gcf,'Color');
%varind = handles.currentvarind;
% axenum = mod(varind,handles.maxnumaxes);
% if axenum==0,
%     axenum = handles.maxnumaxes;
% end

%axenum = find(handles.varonaxes == varind);
if handles.haxes(1,2)~=0 % PSD is computed
    %1. Mark a region
    hax = handles.haxes(1,2);

    %Highlight selected axes
    set(hax,'Color',[1 0.93 0.93]);

    %Show instruction to mark a region
    set(handles.editSPStatus,...
        'String','Instruction: Draw a rectangle on the highlighted plot to mark a frequency region.',...
        'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
        'Enable','inactive');

    %Select test range
    rect = getrect(hax); %rect = [xmin ymin width height] (unit = unit of x-axis)

    %Restore color of axes
    set(hax,'Color',[1,1,1]);
    
    %Remove instruction
    set(handles.editSPStatus,...
        'String','',...
        'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
        'Enable','off');

    %Check if width of selected region = 0. If so, enable other tools & return.
    if rect(3)==0
        return
    end
    
    fmin = rect(1);
    fmin =  str2double(sprintf('%.2f',fmin));
    fmax = rect(1)+rect(3);
    fmax=  str2double(sprintf('%.2f',fmax));
    %2. Update fregion, fregname in handles
    if fmax>max(handles.freq)
        fmax = max(handles.freq);
    end
    if fmin<0
        fmin = 0;
    end
    
    %Input will be the cell array
    prompt = {'Enter FreqTag Name'};
    def = {'FREQTAG'};
    dlg_title = 'Frequency Range';
    num_lines = 1;
    tag = newid(prompt,dlg_title,num_lines,def);

    if isempty(tag)
        return
    end
    % check repeated tag names
    isrepeat = sum(strcmpi(tag, handles.fregname));
    if isrepeat
        warndlg('This frequency name is already used');
        return
    end
    handles.fregion = [handles.fregion;[fmin,fmax]];
    %Define frequency region in listbox
    handles.fregname = [handles.fregname;tag];
    
    %3. Save define frequency region to listbox
    set(handles.listFreRange,'FontSize',10,'String',handles.fregname,'Value',length(handles.fregname),'Enable','on');
    
    %4. Save define frequency region to Tag Manager
    % Comment out on 25 April 2019, why would I need this?
    % needed variables
    %{
    filename = handles.yfilename;
    [path,name,ext] = fileparts(filename);
    filename = [name,ext];
    acrostic = handles.yacrostic;
    subjnum = handles.ysubjnum;
    fs = 1/handles.df;  
    varname = ['psd_',handles.yvarname];
    exptdate = handles.yexptdate;
    expttime = handles.yexpttime;
  
    % new tags
    ncol = 15;
    newtags = cell(1,ncol); %select one var at a time

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
  newtags{1,2}  = 'TIVPSD';             %Module
  newtags{1,3}  = acrostic;             %Acrostic
  newtags{1,4}  = subjnum;              %SubjID
  newtags{1,5}  = exptdate;             %ExptDate
  newtags{1,6}  = expttime;             %ExptTime
  newtags{1,7}  = varname;              %Variable
  newtags{1,8}  = side;                 %Side
  newtags{1,9}  = fs;                   %Sampling frequency
  newtags{1,10} = fmin;                 %Begin
  newtags{1,11} = fmax;                 %End
  newtags{1,12} = tag{1,1};             %Tag
  newtags{1,13} = 'DefineRegionFreq';   %Operation
  newtags{1,14} = '-';                   %Operation Tag
  newtags{1,15} = NaN;                   %Value

  %Update Active Tag Editor (DB or TM). 
  handlesTE = getActiveTagEditor(handles);
  handlesTE.updateEditorTags(handlesTE,newtags);
    %}
end
guidata(hObject,handles);
    



% --- Executes on button press in chkSelectAll.
function chkSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to chkSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSelectAll
% Hint: get(hObject,'Value') returns toggle state of chkSelectAll
tabdata = get(handles.tableSPTags,'Data');
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
set(handles.tableSPTags,'Data',tabdata);
guidata(hObject,handles);



% --- Executes on button press in butSPExportTag.
function butSPExportTag_Callback(hObject, eventdata, handles)
% hObject    handle to butSPExportTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesTE = getActiveTagEditor(handles);%Collects Data from the handle, which is the table to the left of the button
tabdata = get(handles.tableSPTags,'Data');
cselect = 1;
select = cellfun(@(x) x==1, tabdata(:,cselect), 'UniformOutput', 1); %logical array
select = find(select);
handlesTE.updateEditorTags(handlesTE,handles.sptags(select,:));
tabdata=tabdata(select,:);
if isempty(tabdata) %Added by Toey 1Nov2017
    msgbox('PLEASE SELECT RESULTS BEFORE EXPORT','STATIONARY PSD Says..');
    return
end
[file,path] = uiputfile('StationaryPSDresults.csv','Save Output');%User chooses new path for save
if ~isequal(file,0) %Added by Toey 1Nov2017
    filepath=fullfile(path,file);
    %v transfer the cell to a table with the columns listed
    T2=cell2table(tabdata,'VariableNames',{'Select' 'Acrostic' 'Subject_ID' 'Expt_Date' 'Variable' 'Side' 'OnceperFs' 'Begin' 'End' 'Tag' 'Operation' 'Operation_Tag' 'Value'});
    T=[T2(:,2),T2(:,3),T2(:,4),T2(:,5),T2(:,6),T2(:,8),T2(:,9),T2(:,10),T2(:,11),T2(:,12),T2(:,13)];
    writetable(T,filepath);%Writes the table to created file
    set(handles.editSPStatus,...
    'String',[' Status:',file,' is now exported'],...
    'BackgroundColor',[1 1 1],'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');
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






% --- Executes on selection change in popSPBase.
function popSPBase_Callback(hObject, eventdata, handles)
% hObject    handle to popSPBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popSPBase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popSPBase


if ~get(handles.chkSPRespAR,'Value') || isempty(handles.resp)
   return;    
end
contents = cellstr(get(hObject,'String'));
seltag = contents{get(hObject,'Value')};


    
if get(hObject,'Value') >= 1
    i1 = strfind(seltag,'(');
    i2 = strfind(seltag,' - ');
    i3 = strfind(seltag,'sec');
    r1 = str2double(seltag(i1+1:i2-1)); %[sec]
    r2 = str2double(seltag(i2+3:i3-1)); %[sec]

    
    
    if r1<0
        r1 = 0;
    end
    
    if r2 > handles.resptime(end)
        r2 =  handles.resptime(end);
        
    end
    handles.baserange = [r1,r2]; %in secs
    handles.basetag = seltag(1:i1-1); % tagname

    hax = handles.haxes(2,1);
    set(hax,'Color',[1,1,1]);

    %Plot respiration if psd is not computed
    if ~isempty(handles.resp)
        time = handles.resptime;
        signal = handles.resp;
        subplot(handles.haxes(2,1));
        xlimit = get(handles.haxes(2,1),'Xlim');
        plot(time,signal,'k'); hold on;
    
        plot(time(time>=r1 & time<=r2),signal(time>=r1 & time<=r2),'c');

        hold off;
        title(handles.respname,'Color','k','FontWeight','bold');
        xlabel('Time (sec)');
        xlim(xlimit);
        
            gap = prctile(handles.resp,96)-prctile(handles.resp,94);
    pct99 = prctile(handles.resp,99);
    pct100 = max(handles.resp);
    dpctmax = (pct100-pct99)/pct99; %Change from pct99
    
    pct1 = min(handles.resp);
    pct2 = prctile(handles.resp,2);
    dpctmin = (pct2-pct1)/pct1;
    
    if abs(dpctmax)>0.5 %Maximum is artifact
        %Determine range
        %Assume normal distribution
        ymax = pct99+gap;
    else
        ymax= pct100+gap;
    end
    
    if  abs(dpctmin)>0.5
        
        ymin = pct2-gap;
    else
        ymin = pct1-gap;
    end
    
    
    set(handles.haxes(2,1),'YLim',[ymin ymax]);
    end   
end



guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popSPBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popSPBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
function menuNormalTIVPSD_Callback(hObject, eventdata, handles)
% hObject    handle to menuNormalTIVPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Visible','off');
guidata(hObject,handles);


% --------------------------------------------------------------------
function menuBatchTIVPSD_Callback(hObject, eventdata, handles)
% hObject    handle to menuBatchTIVPSD (see GCBO)
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

%%
folder_name = uigetdir;
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
   set(handles.editBResultDisplay,'String','Warning!: .MAT files cannot be located'); 
   return
end    
if isempty(logind)
   return
    
end
%Exclude ind variables
logind = cellfun(@(x) isempty(strfind(x,'ind')),names,'UniformOutput',1); %Logical ind to elements that are not indices.
names = names(logind);
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

try 
    set(handles.editBFs,'String',num2str(handles.batch.fslist(1)),'Enable','on');
catch %Cannot identify the sampling frequency
    set(handles.editBFs,'String','','Enable','on');
end

handles.batch.fsvar = [];
handles.batch.varresp = [];
handles.batch.fsresp = [];
handles.batch.taskRegions = [];
handles.batch.tagrespbase = [];
handles.batch.allresults = {};
handles.batch.header = {};

set(handles.editBResultDisplay,'String',[]);
set(handles.listSelectRegion,'String',[]);
set(handles.listSelectedVar,'String',[]);
set(handles.editBatchResp,'String',[]);
set(handles.editBRespBase,'String',[]);

%At this point, the matpath exists
panelChildren_sub = get(handles.panelBSignals,'Children');
set(panelChildren_sub,'Enable','on');

guidata(hObject,handles);

% --- Executes on button press in butSelectTagpath.
function butSelectTagpath_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectTagpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
%1. Read the tags from one file and list all the tags in the listbox (listAllTags)
%2. Save the tags in handles.batch.alltags
%%
folder_name = uigetdir;
if ~ischar(folder_name)
    return
end
handles.batch.tagpath = folder_name;
set(handles.editTagpath,'String',folder_name);
listtag = dir(folder_name);
listtag = {listtag.name}; %List of the file
% Remove wrong elements (length(filename)<5)
cellind = strfind(listtag,'.csv');
ind = cellfun(@(x) ~isempty(x),cellind,'UniformOutput',1);
listtag = listtag(ind); listtag = listtag'; %Change to a column vector
handles.batch.listtag = listtag;

%Show all the tags inside the first file
try
    tagpath = handles.batch.tagpath;
    filename = listtag{1};
catch
    set(handles.editBResultDisplay,'String','Warning!: .CSV cannot be located'); 
end
% csvtext = importdata(fullfile(tagpath,filename));
% %Get tag column
% subregions = csvtext(2:end,12); %Discard the header
content = tagreader(fullfile(tagpath,filename));
if ~isempty(content.tagcol{1}) %Check if the function is able to read the file
   subregions = content.tagcol; 
else
   set(handles.editBResultDisplay,'String','Warning!: .CSV cannot be located from ',tagpath); 
   return;   
end
set(handles.listAllTags,'String',subregions);
handles.batch.alltags = subregions;

panelChildren_sub = get(handles.panelBROI,'Children');
set(panelChildren_sub,'Enable','on');


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


% --- Executes on button press in butAddVar.
function butAddVar_Callback(hObject, eventdata, handles)
% hObject    handle to butAddVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
%1. Add the selected variable from listBVar to the signal
%2. Get the sampling freq of that variable from the editbox
%3. If fs is changed, replace the old fs in the fslist 
%4. varlist = list of variables for the batch processing
oldlist = get(handles.listSelectedVar,'String');
allvars = get(handles.listBVar,'String');
ind = get(handles.listBVar,'Value');
ind = ind(1);
newvar = allvars{ind};
fs = str2double(get(handles.editBFs,'String'));

if isnan(fs)
    warndlg('Please enter a number for the sampling frequency');
    return
end

if isempty(oldlist)
   oldlist = {newvar}; 
   newfs = fs;
   set(handles.listSelectedVar,'String',oldlist,'Value',1);
else
    check = cellfun(@(x) strcmp(x,newvar),oldlist,'UniformOutput',1);
    if any(check)
        %That variable already exists
        return
    else
        oldlist = [oldlist;{newvar}];
        newfs = [handles.batch.fsvar;fs];
        set(handles.listSelectedVar,'String',oldlist,'Value',1,'Enable','on');
    end
end
handles.batch.varlist = oldlist;
handles.batch.fsvar = newfs;
handles.batch.fslist(ind) = fs;

guidata(hObject,handles);


% --- Executes on button press in butDBatchVar.
function butDBatchVar_Callback(hObject, eventdata, handles)
% hObject    handle to butDBatchVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
% Delete a selected variable in listSelectedVar and varlist and fsvar
%
ind = get(handles.listSelectedVar,'Value');
oldlist = get(handles.listSelectedVar,'String');
if ~isempty(oldlist),
   oldlist(ind) = [];
   set(handles.listSelectedVar,'String',oldlist);
   handles.batch.varlist(ind) = [];
   handles.batch.fsvar(ind) = [];
end

guidata(hObject,handles);


% --- Executes on button press in butAddResp.
function butAddResp_Callback(hObject, eventdata, handles)
% hObject    handle to butAddResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
%1. Add a respiratory signal (name) to varresp
%2. Add new fs to fsresp 
%%
allvars = get(handles.listBVar,'String');
ind = get(handles.listBVar,'Value');
ind = ind(1);
newvar = allvars{ind};
fs = str2double(get(handles.editBFs,'String'));

if isnan(fs)
    warndlg('Please enter a number for the sampling frequency');
    return
end

set(handles.editBatchResp,'String',newvar,'Enable','inactive');
handles.batch.varresp = newvar;
handles.batch.fsresp = fs;

guidata(hObject,handles);


function editBatchResp_Callback(hObject, eventdata, handles)
% hObject    handle to editBatchResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBatchResp as text
%        str2double(get(hObject,'String')) returns contents of editBatchResp as a double


% --- Executes during object creation, after setting all properties.
function editBatchResp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBatchResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDBatchResp.
function butDBatchResp_Callback(hObject, eventdata, handles)
% hObject    handle to butDBatchResp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.batch.varresp = [];
handles.batch.fsresp = [];
set(handles.editBatchResp,'String',[]);
guidata(hObject,handles);


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


% --- Executes on button press in butBRespBase.
function butBRespBase_Callback(hObject, eventdata, handles)
% hObject    handle to butBRespBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
% Add a respiratory baseline tag to the list
%


%%
newtag = get(handles.editTagName,'String');
if isempty(newtag)
    ind = get(handles.listAllTags,'Value');
    newtag = handles.batch.alltags{ind};
    set(handles.editBRespBase,'String',newtag,'Enable','inactive');
    handles.batch.tagrespbase = newtag;
else
    set(handles.editBRespBase,'String',newtag,'Enable','inactive');
    handles.batch.tagrespbase = newtag;
end

set(handles.editTagName,'String',[]);


%%
guidata(hObject,handles);

% --- Executes on button press in butBROI.
function butBROI_Callback(hObject, eventdata, handles)
% hObject    handle to butBROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Description
%1. Add the selected ROI into listSelectRegion
%2. 
oldlist = get(handles.listSelectRegion,'String');
ind = get(handles.listAllTags,'Value');
%% Test
newtag = handles.batch.alltags{ind};
if isempty(oldlist)
      oldlist = [oldlist;{newtag}];  
      set(handles.listSelectRegion,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmp(x,newtag),oldlist,'UniformOutput',1);
    if any(check)
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
if ~isfield(handles,'batch')
    return
end

if ~isfield(handles.batch,'matpath') ||  isempty(handles.batch.matpath) || ~isfield(handles.batch,'tagpath') ||  isempty(handles.batch.tagpath) || ~isfield(handles.batch,'varlist') ||  ~isfield(handles.batch,'fsvar') 
    return
end
matpath = handles.batch.matpath;
tagpath = handles.batch.tagpath;
varlist = handles.batch.varlist;
fsvar = handles.batch.fsvar;
%% Check if input arguments are valid
if  isempty(varlist) || isempty(fsvar) 
    warning('Signals are not selected');
    return
end
if isfield(handles.batch,'taskRegions') && ~isempty(handles.batch.taskRegions)
    taskRegions = handles.batch.taskRegions;
else
    warning('ROIs are not selected');
    return;
    
end
method = [];

if get(handles.chkBRA,'Value') %if respiratory-adjusted, check if resp is selected
    method = 'Respiratory-Adjusted PSD';
    if ~(isfield(handles.batch,'tagrespbase') && ~isempty(handles.batch.tagrespbase))
        warning('Respiratory baseline is not selected');
        return;
    else
        tagrespbase = handles.batch.tagrespbase;
    end
    
    if isfield(handles.batch,'varresp') && ~isempty(handles.batch.varresp)
        resp = handles.batch.varresp;
        fsresp = handles.batch.fsresp;
    else
        warning('Respiratory signal is not selected');
    end
    
    %% Compute respiratory-adjusted
    inp.matpath = matpath;
    inp.tagpath = tagpath;
    inp.taskRegions = taskRegions;
    inp.varlist = varlist;
    inp.method = method;
    inp.fsvar = fsvar;
    inp.settingpath = handles.substationarysettingpath;
    inp.editBResultDisplay = handles.editBResultDisplay;
    inp.tagrespbase = tagrespbase;
    inp.varresp = resp;
    inp.fsresp = fsresp;

    [allresults,header,missing_signal_matfiles,missing_tag_csvfiles,missing_csvfiles,rounds] = batchRespARforGUI(inp);

elseif get(handles.chkBAR,'Value') %AR
    method = 'AR';
    inp.matpath = matpath;
    inp.tagpath = tagpath;
    inp.taskRegions = taskRegions;
    inp.varlist = varlist;
    inp.method = method;
    inp.fsvar = fsvar;
    inp.settingpath = handles.substationarysettingpath;
    inp.editBResultDisplay = handles.editBResultDisplay;
    [allresults,header,missing_signal_matfiles,missing_tag_csvfiles,missing_csvfiles,rounds] = batchWelchARforGUI(inp);
    
elseif get(handles.chkBWelch,'Value')
    method = 'Welch';
    inp.matpath = matpath;
    inp.tagpath = tagpath;
    inp.taskRegions = taskRegions;
    inp.varlist = varlist;
    inp.method = method;
    inp.fsvar = fsvar;
    inp.settingpath = handles.substationarysettingpath;
    inp.editBResultDisplay = handles.editBResultDisplay;

    
    [allresults,header,missing_signal_matfiles,missing_tag_csvfiles,missing_csvfiles,rounds] = batchWelchARforGUI(inp);
    
else
    return;
    
end


handles.batch.allresults = allresults;
handles.batch.header = header;

%% Display results
lastcomputestr = datestr(datetime);
strresult = {['Processing Summary::',lastcomputestr],['Selected Method = ', method],['Total Matfiles=',num2str(rounds)]};

%% Missing csv files
if ~isempty(missing_csvfiles)
    strresult = [strresult,{[newline '----List of .MAT files missing .CSV----']},missing_csvfiles'];
end

%% Missing Variables
try
for nvar = 1:length(varlist)
   temp = missing_signal_matfiles{nvar};
   if ~isempty(temp)
       strresult = [strresult,{[newline '----List of .MAT files missing ',varlist{nvar},' ----']},temp];
   end
   
end
catch
   disp('ERROR'); 
end
if get(handles.chkBRA,'Value')
    %Missing respiration variable
    temp = missing_signal_matfiles{end};
    if ~isempty(temp)
        strresult = [strresult,{[newline '----List of .MAT files missting ',resp,' ----']},temp];
    end
end

%% Missing Tags
%Missing other signals
for nvar = 1:length(taskRegions)
   temp = missing_tag_csvfiles{nvar};
   if ~isempty(temp)
       strresult = [strresult,{[newline '----List of .CSV files missing ',taskRegions{nvar},' ----']},temp];
   end
   
end

if get(handles.chkBRA,'Value')
    %Missing respiration tag
    temp = missing_tag_csvfiles{end};
    if ~isempty(temp)
        strresult = [strresult,{[newline '----List of .CSV files missing ',tagrespbase,' ---']},temp];
    end

end



if ~isempty(handles.batch.allresults)
    set(handles.butBSaveOutput,'Enable','on');
else
    set(handles.butBSaveOutput,'Enable','off');
end

strresult = char(strresult);
set(handles.editBResultDisplay,'String',strresult,'Enable','inactive');
guidata(hObject,handles);




% --- Executes on button press in butBClear.
function butBClear_Callback(hObject, eventdata, handles)
% hObject    handle to butBClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.batch.varlist = [];
handles.batch.fsvar = [];
handles.batch.varresp = [];
handles.batch.fsresp = [];
handles.batch.taskRegions = [];
handles.batch.tagrespbase = [];
handles.batch.allresults = {};
handles.batch.header = {};

set(handles.editBResultDisplay,'String',[]);
set(handles.listSelectRegion,'String',[]);
set(handles.listSelectedVar,'String',[]);
set(handles.editBatchResp,'String',[]);
set(handles.editBRespBase,'String',[]);




guidata(hObject,handles);

% --- Executes on button press in butDBROI.
function butDBROI_Callback(hObject, eventdata, handles)
% hObject    handle to butDBROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listSelectRegion,'Value');
oldlist = get(handles.listSelectRegion,'String');
if ~isempty(oldlist)
   oldlist(ind) = [];
   set(handles.listSelectRegion,'String',oldlist);
   handles.batch.taskRegions(ind) = [];
end
guidata(hObject,handles);

% --- Executes on button press in butDBRespBase.
function butDBRespBase_Callback(hObject, eventdata, handles)
% hObject    handle to butDBRespBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editBRespBase,'String',[]);
handles.batch.tagrespbase = [];
guidata(hObject,handles);

function editBRespBase_Callback(hObject, eventdata, handles)
% hObject    handle to editBRespBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBRespBase as text
%        str2double(get(hObject,'String')) returns contents of editBRespBase as a double


% --- Executes during object creation, after setting all properties.
function editBRespBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBRespBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkBWelch.
function chkBWelch_Callback(hObject, eventdata, handles)
% hObject    handle to chkBWelch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBWelch
%% Description : Uncheck chkBAR and chkBRA if this one is selected
if get(hObject,'Value'),
   set(hObject,'Enable','off');
   set(handles.chkBAR,'Value',0,'Enable','on');
   set(handles.chkBRA,'Value',0,'Enable','on');
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
   set(handles.chkBRA,'Value',0,'Enable','on');
end
guidata(hObject,handles);

% --- Executes on button press in chkBRA.
function chkBRA_Callback(hObject, eventdata, handles)
% hObject    handle to chkBRA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkBRA
if get(hObject,'Value')
   set(hObject,'Enable','off');
   set(handles.chkBWelch,'Value',0,'Enable','on');
   set(handles.chkBAR,'Value',0,'Enable','on');
end
guidata(hObject,handles);


% --- Executes on button press in butAddROIName.
function butAddROIName_Callback(hObject, eventdata, handles)
% hObject    handle to butAddROIName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Description
%1. Add the selected ROI into listSelectRegion
%2. 
oldlist = get(handles.listSelectRegion,'String');
newtag = get(handles.editTagName,'String');
if isempty(newtag)
    return
end
if isempty(oldlist)
      oldlist = [oldlist;{newtag}];  
      set(handles.listSelectRegion,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmp(x,newtag),oldlist,'UniformOutput',1);
    if any(check)
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


% --- Executes on button press in butBSaveOutput.
function butBSaveOutput_Callback(hObject, eventdata, handles)
% hObject    handle to butBSaveOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles.batch,'allresults') || isempty(handles.batch.allresults)
    return;
else
    data = handles.batch.allresults;
    colname = handles.batch.header;
    % get the selected file/path from users
    [file,path] = uiputfile('psdras_results.csv','Save Output');
    if ~isnumeric(file)
        filepath = fullfile(path,file);
        
        T = cell2table(data,'VariableNames',colname);
        try
            writetable(T,filepath);
            set(handles.editBResultDisplay,'String','........Results are saved!.............');
        catch
            warndlg('Permission denied. cannot overwite the openned file','Export error in Stationary PSD');
        end
    end

    
end
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


% --------------------------------------------------------------------
function submenuTIVPSDsetting_Callback(hObject, eventdata, handles)
% hObject    handle to submenuTIVPSDsetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = findobj('Tag','DataBrowser_TIVPSDsetting');
if isempty(obj) %The setting window is not openned
    subtivpsd_setting(handles.substationarysettingpath,'psdsetting.mat');
else
    figure(obj);
end

guidata(hObject,handles);
