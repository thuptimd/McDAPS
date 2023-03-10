function varargout = sub_MovingCorrelation(varargin)
% SUB_MOVINGCORRELATION MATLAB code for sub_MovingCorrelation.fig
%      SUB_MOVINGCORRELATION, by itself, creates a new SUB_MOVINGCORRELATION or raises the existing
%      singleton*.
%
%      H = SUB_MOVINGCORRELATION returns the handle to a new SUB_MOVINGCORRELATION or the handle to
%      the existing singleton*.
%
%      SUB_MOVINGCORRELATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_MOVINGCORRELATION.M with the given input arguments.
%
%      SUB_MOVINGCORRELATION('Property','Value',...) creates a new SUB_MOVINGCORRELATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_MovingCorrelation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_MovingCorrelation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_MovingCorrelation

% Last Modified by GUIDE v2.5 18-May-2016 19:14:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_MovingCorrelation_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_MovingCorrelation_OutputFcn, ...
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


% --- Executes just before sub_MovingCorrelation is made visible.
function sub_MovingCorrelation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_MovingCorrelation (see VARARGIN)

% Choose default command line output for sub_MovingCorrelation
handles.output = hObject;

% Set handles property to point at Data Browser
handles.DataBrowser = [];

% Check if hObject of the main_DataBrowser is passed in varargin
DataBrowserInput = find(strcmp(varargin, 'DataBrowser'));
if ~isempty(DataBrowserInput)
   handles.DataBrowser = varargin{DataBrowserInput+1};
end

handles.getSelectedTags = @getSelectedTags;
handles.genDefineRegionTag = @genDefineRegionTag;
handles.updatePopChoices = @updatePopChoices;
handles.updatePopMenu = @updatePopMenu;
handles.isvaractive = @isvaractive;
handles.getActiveTagEditor = @getActiveTagEditor;
initializeSubGUI(hObject,handles);
handles = guidata(hObject);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_MovingCorrelation wait for user response (see UIRESUME)
% uiwait(handles.figMovingCorrelation);


% --- Outputs from this function are returned to the command line.
function varargout = sub_MovingCorrelation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function editRStatus_Callback(hObject, eventdata, handles)
% hObject    handle to editRStatus (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRStatus as text
%        str2double(get(hObject,'String')) returns contents of editRStatus as a double


% --- Executes during object creation, after setting all properties.
function editRStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRStatus (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in listRWrkspc.
function listRWrkspc_Callback(hObject, eventdata, handles)
% hObject    handle to listRWrkspc (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listRWrkspc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listRWrkspc

varind = get(handles.listRWrkspc,'Value');
varind = varind(1);

[pathstr,name,ext] = fileparts(handles.filename{varind});

%Display info of any operations applied to the selected signal
set(handles.editRFilename,'String',[name,ext]);


guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function listRWrkspc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listRWrkspc (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butRVar1.
function butRVar1_Callback(hObject, eventdata, handles)
% hObject    handle to butRVar1 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varind = get(handles.listRWrkspc,'Value');
varind = varind(1); %in case select multiple signals
y = handles.signal{varind}; %selected signal

if isvector(y) && isnumeric(y) && ~isscalar(y)
    
    %Clear axes
    cla(handles.haxes(1));
    
    %Display selected variable
    selvar = handles.varname{varind};
    set(handles.editRVar1,'String',selvar);
    
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
    
    %Store variables into handles structure
    oldfile = handles.filename1;
    handles.y1 = y;
    handles.fs1 = handles.fs(varind);
    handles.filename1 = handles.filename{varind};
    handles.acrostic1 = handles.acrostic{varind};
    handles.subjnum1  = handles.subjnum{varind};
    handles.exptdate1 = handles.exptdate{varind};
    handles.expttime1 = handles.expttime{varind};
    
    
    handles.newvarflag = true;
    
    %Set pop-up tags
    
    
    %Clear corr coeff results if the selected signal belongs to a different file
    if ~strcmp(oldfile,handles.filename1)
        
        %Clear axes 3 and 4 if there's a change in Test range
        cla(handles.haxes(3));
        cla(handles.haxes(4));
        set(handles.haxes(3),'Visible','off');
        set(handles.haxes(4),'Visible','off');



    end    
    
    %Plot selected variable
    x = (0:length(y)-1)/handles.fs1;
    axes(handles.haxes(1));
    plot(x,y,'Color',handles.pcolor(1,:));
    if isfield(handles,'baserange') && ~isempty(handles.baserange)
        [b1,b2] = getIndex(handles.baserange,handles.fs1,length(y));
        plot(x(b1:b2),y(b1:b2),'Color',handles.bcolor);
    end
    if isfield(handles,'testrange') && ~isempty(handles.testrange)
        [t1,t2] = getIndex(handles.testrange,handles.fs1,length(y));
        plot(x(t1:t2),y(t1:t2),'Color',handles.tcolor);
    end
    set(handles.haxes(1),'Box','on','Xlim',[0,max(x)],'Unit','normalized','Position',handles.axespos(1,:));
    ylabel(selvar);
    linkaxes(handles.haxes(1:2),'x');
    
    %Enable buttons for computing correlation if already select 2 variables
    s = get(handles.editRVar2,'String');
    if ~isempty(s)
        
        handlesTE = getActiveTagEditor(handles);
        definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
        
        if ~isempty(definetags)
            if ~strcmp(oldfile,handles.filename1)   
                handles.updatePopMenu(handles,definetags,'all'); 
            end
        end
        
        
        set(handles.butRBase,'Enable','on');
        set(handles.butRTest,'Enable','on');
        set(handles.butRCorr,'Enable','on');
                
    else
        set(handles.butRBase,'Enable','off');
        set(handles.butRTest,'Enable','off');
        set(handles.butRCorr,'Enable','off');
        
        %Clear axes
        cla(handles.haxes(2));
        set(handles.haxes(2),'Visible','off');
    end
    
    %Clear correlation results if selected variable changed & clear axes
    if ~strcmp(handles.varname1,selvar)
        
        
        %Clear axes
        cla(handles.haxes(3));
        cla(handles.haxes(4));
        set(handles.haxes(3),'Visible','off');
        set(handles.haxes(4),'Visible','off');

    end
    
    %Update selected variable 1 (after comparing)
    handles.varname1 = selvar;

else
    set(handles.editRVar1,'String','');
    cla(handles.haxes(1)); %clear axes
    set(handles.haxes(1),'Visible','off');
    h = warndlg('Selected variable is invalid for computing correlation.','Warning','modal');
    return
end

guidata(hObject, handles); %update handles structure

% --- Executes on button press in butRVar2.
function butRVar2_Callback(hObject, eventdata, handles)
% hObject    handle to butRVar2 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

varind = get(handles.listRWrkspc,'Value');
%h = waitbar(0,'Please wait...');
%steps = length(varind);

varind = sort(varind);
varname = handles.varname(varind);
oldstr = get(handles.editRVar2,'String');
if length(oldstr)==sum(isspace(oldstr)),
    oldstr = {};
else
    oldstr = cellstr(oldstr);
end

for n=1:length(varind),
    y = handles.signal{varind(n)}; %selected signal
    selvar = varname{n}; 

    if isvector(y) && isnumeric(y) && ~isscalar(y),
      
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
            y = detrendPoly(y,handles.detrend(varind(n))); %detrended signal
        end
        

        
        %scale
        y = handles.scale(varind(n))*y;
        
        
        %Transpose signal back to its original form
        if exist('flagrow','var') && flagrow==1
            y = y';
        end
        tempfile = handles.filename2;
        if ~strcmp(handles.filename{varind(n)},tempfile), %First signal or new file
            %Store variables into handles structure
            handles.y2 = {y};
            handles.fs2 = handles.fs(varind(n));
            handles.filename2 = handles.filename{varind(n)};
            handles.acrostic2 = handles.acrostic{varind(n)};
            handles.subjnum2  = handles.subjnum{varind(n)};
            handles.exptdate2 = handles.exptdate{varind(n)};
            handles.expttime2 = handles.expttime{varind(n)};
            handles.varname2 = {selvar};
            
            %Enable buttons for computing correlation if already select 2 variables
            s = get(handles.editRVar1,'String');
            if ~isempty(s)
                handlesTE = getActiveTagEditor(handles);
                definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
                handles.updatePopMenu(handles,definetags,'all');
                
                set(handles.butRBase,'Enable','on');
                set(handles.butRTest,'Enable','on');
                set(handles.butRCorr,'Enable','on');
            else
                set(handles.butRBase,'Enable','off');
                set(handles.butRTest,'Enable','off');
                set(handles.butRCorr,'Enable','off');
                
                %Clear axes
                cla(handles.haxes(1));
                set(handles.haxes(1),'Visible','off');
            end
            
            %Plot selected variable
            x = (0:length(y)-1)/handles.fs2(n);
            axes(handles.haxes(2));
            plot(x,y,'Color',handles.pcolor(2,:));
            if isfield(handles,'baserange') && ~isempty(handles.baserange)
                [b1,b2] = getIndex(handles.baserange,handles.fs2(n),length(y));
                plot(x(b1:b2),y(b1:b2),'Color',handles.bcolor);
            end
            if isfield(handles,'testrange') && ~isempty(handles.testrange)
                [t1,t2] = getIndex(handles.testrange,handles.fs2(n),length(y));
                plot(x(t1:t2),y(t1:t2),'Color',handles.tcolor);
            end
            set(handles.haxes(2),'Box','on','Xlim',[0,max(x)],'Unit','normalized','Position',handles.axespos(2,:));
            xlabel('Time(sec)');
            ylabel(selvar);
            linkaxes(handles.haxes(1:2),'x');
            
            %Set editVar2
            oldstr = {selvar};
            
            
            %Clear axes
            cla(handles.haxes(3));
            cla(handles.haxes(4));
            set(handles.haxes(3),'Visible','off');
            set(handles.haxes(4),'Visible','off');
            
            
        else
            if ismember(selvar,oldstr),
                warndlg('The signal already exists','Warning!');
                continue;
            end
            oldstr = [oldstr;selvar];
            handles.y2 = [handles.y2;y];
            handles.varname2 = [handles.varname2;selvar];
            handles.fs2 = [handles.fs2;handles.fs(varind(n))];
        end
        
        handles.newvarflag = true;
        
        
    else

        warndlg([selvar,' is invalid for computing correlation.'],'Warning','modal');
        continue
    end



end

%Update editVar2
if ~isempty(oldstr)
    [r,~] = size(oldstr);
    newstr = [];
    oldstr = cellstr(oldstr);
    for n=1:r
        if ~(sum(isspace(oldstr{n}))==length(oldstr{n}))
            newstr = [newstr,sprintf('%s\n',oldstr{n})];
        end
    end
    set(handles.editRVar2,'String',newstr);
end



guidata(hObject, handles); %update handles structure


function editRVar1_Callback(hObject, eventdata, handles)
% hObject    handle to editRVar1 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRVar1 as text
%        str2double(get(hObject,'String')) returns contents of editRVar1 as a double


% --- Executes during object creation, after setting all properties.
function editRVar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRVar1 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRVar2_Callback(hObject, eventdata, handles)
% hObject    handle to editRVar2 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRVar2 as text
%        str2double(get(hObject,'String')) returns contents of editRVar2 as a double


% --- Executes during object creation, after setting all properties.
function editRVar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRVar2 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRFilename_Callback(hObject, eventdata, handles)
% hObject    handle to editRFilename (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRFilename as text
%        str2double(get(hObject,'String')) returns contents of editRFilename as a double


% --- Executes during object creation, after setting all properties.
function editRFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRFilename (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butRBase.
function butRBase_Callback(hObject, eventdata, handles)
% hObject    handle to butRBase (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Mark baseline region
%Show instruction to select the current plot
cfig = get(gcf,'Color');
set(handles.editRStatus,...
    'String','Instruction: Click on the plot you want to mark a region.',...
    'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');

%Get current axes
[x,y] = ginputCross(1);
hax = gca;

xlim = get(hax,'Xlim');
ylim = get(hax,'Ylim');

if x<xlim(1) || x>xlim(2), %did not select any axes
    return
elseif y<ylim(1) || y>ylim(2),
    return    
end



%Check if test range was marked on the correlation plots
%--> If yes, do not allow marking i.e. return
z = handles.haxes(3:4)==hax;
if any(z)
    %Remove instruction
    set(handles.editRStatus,...
        'String','',...
        'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
        'Enable','off');
    return
end

%Highlight selected axes
c = get(hax,'Color');
set(hax,'Color',[1 0.93 0.93]);

%Show instruction to mark a region
set(handles.editRStatus,...
    'String','Instruction: Draw a rectangle on the highlighted plot to mark a region.',...
    'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
    'Enable','inactive');

%Select range
rect = getrect(hax); %rect = [xmin ymin width height] (unit = unit of x-axis)

%Restore color of axes
set(hax,'Color',c);

%Remove instruction
set(handles.editRStatus,...
    'String','',...
    'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
    'Enable','off');


%Check if width of selected region = 0. If so, enable other tools & return.
if rect(3)==0
    return
end

%Check if selected region is valid
timerange = [rect(1), rect(1)+rect(3)];
axind = find(handles.haxes==hax);
if axind ==2,
    y= handles.y2{1};
    fs = handles.fs2(1);
else
    eval(['y  = handles.y',num2str(axind),';']);
    eval(['fs = handles.fs',num2str(axind),';']);
end
[time1,time2] = checkValidTimeRange(timerange,fs,length(y));
[newdftag] = genDefineRegionTag(1,[time1,time2],handles);
if isempty(newdftag),
    return;
end
%Clear axes 3 and 4 if there's a change in Test range;
%Clear correlation results
if isfield(handles,'baserange') && time1~=handles.baserange(1) && time2~=handles.baserange(2)
    cla(handles.haxes(3));
    cla(handles.haxes(4));
    set(handles.haxes(3),'Visible','off');
    set(handles.haxes(4),'Visible','off');
   

end
handles.updatePopMenu(handles,newdftag,'base');
handles.baserange(1) = time1; %[sec]
handles.baserange(2) = time2; %[sec]
handles.tag1 = newdftag{12};

%Restore color of axes
set(hax,'Color',c);

%Remove instruction
set(handles.editRStatus,...
    'String','',...
    'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
    'Enable','off');

%Get xlimit
xlimit = get(handles.haxes(1),'Xlim');

%Signal 1
axes(handles.haxes(1));
[b1,b2] = getIndex(handles.baserange,handles.fs1,length(handles.y1));
x1 = (0:length(handles.y1)-1)/handles.fs1;
plot(x1,handles.y1,'Color',handles.pcolor(1,:)); hold on;
plot(x1(b1:b2),handles.y1(b1:b2),'Color',handles.bcolor);
if isfield(handles,'testrange') && ~isempty(handles.testrange)
    [t1,t2] = getIndex(handles.testrange,handles.fs1,length(handles.y1));
    plot(x1(t1:t2),handles.y1(t1:t2),'Color',handles.tcolor);
end
ylabel(handles.varname1);
set(handles.haxes(1),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(1,:));

%Signal 2
axes(handles.haxes(2));
[b1,b2] = getIndex(handles.baserange,handles.fs2(1),length(handles.y2{1}));
x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
plot(x2,handles.y2{1},'Color',handles.pcolor(2,:)); hold on;
plot(x2(b1:b2),handles.y2{1}(b1:b2),'Color',handles.bcolor);
if isfield(handles,'testrange') && ~isempty(handles.testrange)
    [t1,t2] = getIndex(handles.testrange,handles.fs2(1),length(handles.y2{1}));
    plot(x2(t1:t2),handles.y2{1}(t1:t2),'Color',handles.tcolor);
end
ylabel(handles.varname2{1});
set(handles.haxes(2),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(2,:));

%Linkaxes
linkaxes(handles.haxes(1:2),'x');

guidata(hObject, handles); %update handles structure


% --- Executes on button press in butRTest.
function butRTest_Callback(hObject, eventdata, handles)
% hObject    handle to butRTest (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Mark test region
    %Show instruction to select the current plot
    cfig = get(gcf,'Color');
    set(handles.editRStatus,...
        'String','Instruction: Click on the plot you want to mark a region.',...
        'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
        'Enable','inactive');

    %Get current axes
    [x,y] = ginputCross(1);
    hax = gca;
    


    xlim = get(hax,'Xlim');
    ylim = get(hax,'Ylim');
    
    if x<xlim(1) || x>xlim(2), %did not select any axes
        return
    elseif y<ylim(1) || y>ylim(2),
        return
    end

    
    %Check if test range was marked on the correlation plots
    %--> If yes, do not allow marking i.e. return
    z = handles.haxes(3:4)==hax;
    if any(z)
        %Remove instruction
        set(handles.editRStatus,...
            'String','',...
            'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
            'Enable','off');
        return
    end

    %Highlight selected axes
    c = get(hax,'Color');
    set(hax,'Color',[1 0.93 0.93]);

    %Show instruction to mark a region
    set(handles.editRStatus,...
        'String','Instruction: Draw a rectangle on the highlighted plot to mark a region.',...
        'BackgroundColor',cfig,'ForegroundColor',[1 0.4 0],'FontAngle','italic',...
        'Enable','inactive');

    %Select range
    rect = getrect(hax); %rect = [xmin ymin width height] (unit = unit of x-axis)
    
    %Restore color of axes
    set(hax,'Color',c);

    %Remove instruction
    set(handles.editRStatus,...
        'String','',...
        'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
        'Enable','off');
    
    %Check if width of selected region = 0. If so, enable other tools & return.
    if rect(3)==0
        return
    end
    
    %Check if selected region is valid
    timerange = [rect(1), rect(1)+rect(3)];
    axind = find(handles.haxes==hax);
    if axind ==2,
        y= handles.y2{1};
        fs = handles.fs2(1);
    else
        eval(['y  = handles.y',num2str(axind),';']);
        eval(['fs = handles.fs',num2str(axind),';']); 
    end
 
    [time1,time2] = checkValidTimeRange(timerange,fs,length(y));  
    [newdftag] = genDefineRegionTag(1,[time1,time2],handles);
    if isempty(newdftag),
        return;
    end
    handles.updatePopMenu(handles,newdftag,'test');


%Clear axes 3 and 4 if there's a change in Test range;
%Clear correlation results
if isfield(handles,'testrange') && time1~=handles.testrange(1) && time2~=handles.testrange(2)
    cla(handles.haxes(3));
    cla(handles.haxes(4));
    set(handles.haxes(3),'Visible','off');
    set(handles.haxes(4),'Visible','off');
    
end

%Set test range to be the new marked range
handles.testrange(1) = time1;
handles.testrange(2) = time2;
handles.tag2         = newdftag{12};

xlimit = get(handles.haxes(1),'Xlim');

%Signal 1
cla(handles.haxes(1));
axes(handles.haxes(1));
x1 = (0:length(handles.y1)-1)/handles.fs1;
plot(x1,handles.y1,'Color',handles.pcolor(1,:)); hold on;
if isfield(handles,'baserange') && ~isempty(handles.baserange)
    [b1,b2] = getIndex(handles.baserange,handles.fs1,length(handles.y1));
    plot(x1(b1:b2),handles.y1(b1:b2),'Color',handles.bcolor);
end
[t1,t2] = getIndex(handles.testrange,handles.fs1,length(handles.y1));
plot(x1(t1:t2),handles.y1(t1:t2),'Color',handles.tcolor);
ylabel(handles.varname1);
set(handles.haxes(1),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(1,:));

%Signal 2
cla(handles.haxes(2));
subplot(handles.haxes(2));
x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
plot(x2,handles.y2{1},'Color',handles.pcolor(2,:)); hold on;
if isfield(handles,'baserange') && ~isempty(handles.baserange)
    [b1,b2] = getIndex(handles.baserange,handles.fs2(1),length(handles.y2{1}));
    plot(x2(b1:b2),handles.y2{1}(b1:b2),'Color',handles.bcolor);
end
[t1,t2] = getIndex(handles.testrange,handles.fs2(1),length(handles.y2{1}));
plot(x2(t1:t2),handles.y2{1}(t1:t2),'Color',handles.tcolor);
ylabel(handles.varname2{1});
set(handles.haxes(2),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(2,:));

%Linkaxes
linkaxes(handles.haxes(1:2),'x');

guidata(hObject, handles); %update handles structure



% --- Executes on button press in butRCorr.
function butRCorr_Callback(hObject, eventdata, handles)
% hObject    handle to butRCorr (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'baserange') && ~isempty(handles.baserange) && isfield(handles,'testrange') && ~isempty(handles.testrange)
    
    if length(handles.y2)==1    
        handles.newvarflag = false;
    end
    
    pos = get(handles.figMovingCorrelation,'Position');
    for n=1:length(handles.y2)
        %Display wait message in status bar & command window)
        
        y1 = handles.y1;
        y2 = handles.y2{n};
        fs1 = handles.fs1;
        fs2 = handles.fs2(n);
        
        %Always downsample/upsample fs1 and fs2 to 2 Hz
        fresamp = 2;
        if fs1<fresamp || fs1>fresamp
            [P,Q] = rat(fresamp/fs1);
            %Signal 1
            y1 = resample(y1,P,Q,0); %filter order = 0      
        end
        
        if fs2<fresamp || fs2>fresamp
            [P,Q] = rat(fresamp/fs2);
            %Signal 2
            y2 = resample(y2,P,Q,0); %filter order = 0  
          
        end
        

        handles.y1      = y1;
        handles.y2{n}      = y2;
        handles.fs1     = fresamp;
        handles.fs2(n)  = fresamp;
        handles.fresamp = fresamp;
        
        %Define testsegment and y
        [t1,t2] = getIndex(handles.testrange,handles.fs1,length(handles.y1));

        
        %Get other data ranges in the unit of data points
        [b1,b2] = getIndex(handles.baserange,handles.fresamp,length(y2)); %baseline
        timedelay = str2double(get(handles.editSearchWindow,'String'));
        if isnan(timedelay) || isempty(timedelay)
            ndelay = 10*handles.fresamp;
            set(handles.editSearchWindow,'String','10');
        else
            ndelay = timedelay*handles.fresamp;
        end
        
      [pearson,spearman] = compareRvsBaseNullR(y1,y2,ndelay,[b1,b2],[t1,t2],handles.roption);
      
      
      if isempty(pearson) && isempty(spearman)
          cla(handles.haxes(3)); cla(handles.haxes(4));
          set(handles.haxes(4),'Visible','off');
          set(handles.haxes(3),'Visible','off');
          return
      end
      
      
      %Plot pearson result for the first signal
      if n==1
          cla(handles.haxes(3));
          set(handles.haxes(3),'Visible','on');
          axes(handles.haxes(3)); hold on;
          plot(pearson.basecdf(:,1),pearson.basecdf(:,2),'k'); hold on;
          plot([pearson.r,pearson.r],[0,1],'r'); hold off;
          text(0.1,0.9,['r = ',num2str(pearson.r,'%10.3f')],'Unit','normalized','Color','r');
          text(0.1,0.8,['p = ',num2str(pearson.p,'%10.3f')],'Unit','normalized','Color','r');
          text(0.1,0.7,['N = ',num2str(pearson.N)],         'Unit','normalized','Color','r');
          %title('Pearson: Cumulative Distribution Function','FontWeight','bold');
          text(0.1,0.6,'Pearson: Cumulative Distribution Function','Unit','normalized','Color','k');

          hold(handles.haxes(3),'off');
          set(handles.haxes(3),'Xlim',[-1,1],'Position',handles.axespos(3,:),'Visible','on','Box','on');
      end
      
      set(handles.butRDeletetag,'Enable','on');
      
      %Extract side if selected variable has side info
      rr = strfind(handles.varname2{n},'right');
      if ~isempty(rr)
          side = 'right';
      else
          ll = strfind(handles.varname2{n},'left');
          if ~isempty(ll)
              side = 'left';
          else
              side = '-';
          end
      end
      
      %Add new tag
      [pathstr,name,ext] = fileparts(handles.filename2);
      nrow = 6;
      ncol = 15;
      newtag = cell(nrow,ncol);
      
      newtag(:,1)  = repmat({[name,ext]},nrow,1); %filename of tested signal
      newtag(:,2)  = repmat({'MoveCorr'},nrow,1); %module
      newtag(:,3)  = repmat({handles.acrostic2},nrow,1); %acrostic
      newtag(:,4)  = repmat({handles.subjnum2},nrow,1); %subject ID
      newtag(:,5)  = repmat({handles.exptdate2},nrow,1); %experimental date
      newtag(:,6)  = repmat({handles.expttime2},nrow,1); %experimental time
      newtag(:,7)  = repmat({[handles.varname1,' & ',handles.varname2{n}]},nrow,1); %test signal & tested signal
      newtag(:,8)  = repmat({side},nrow,1); %side
      newtag(:,9)  = repmat({handles.fresamp},nrow,1); %sampling frequency [Hz]
      newtag(:,10) = repmat({min(handles.testrange)},nrow,1); %beginning of test range [sec]
      newtag(:,11) = repmat({max(handles.testrange)},nrow,1); %end of test range [sec]
      newtag(:,12) = repmat({handles.tag2},nrow,1); %tag
      newtag(:,13) = repmat({'MoveCorr'},nrow,1); %operation
      
      
      %col14 = operation tag, col15 = value
      newtag{1,14} = 'Baseline range';          newtag{1,15} = handles.tag1;     %baseline range or baseline tag
      newtag{2,14} = 'No. of shifts';           newtag{2,15} = pearson.N;         %N = no. of shifts to perform null distribution
      newtag{3,14} = 'Pearson r';               newtag{3,15} = str2double(sprintf('%.3f',pearson.r));           
      newtag{4,14} = 'Pearson p-value';         newtag{4,15} = str2double(sprintf('%.3f',pearson.p));               
      
      
     if ~isempty(spearman)
         
         if n==1
             cla(handles.haxes(4));
             set(handles.haxes(4),'Visible','on');
             axes(handles.haxes(4)); hold on;
             plot(spearman.basecdf(:,1),spearman.basecdf(:,2),'k'); hold on;
             plot([spearman.r,spearman.r],[0,1],'m'); hold off;
             text(0.1,0.9,['r = ',num2str(spearman.r,'%10.3f')],'Unit','normalized','Color','m');
             text(0.1,0.8,['p = ',num2str(spearman.p,'%10.3f')],'Unit','normalized','Color','m');
             text(0.1,0.7,['N = ',num2str(spearman.N)],         'Unit','normalized','Color','m');
             %title('Spearman: Cumulative Distribution Function','FontWeight','bold');
             text(0.1,0.6,'Spearman: Cumulative Distribution Function','Unit','normalized','Color','k');
             xlabel('Correlation Coefficient');
             hold(handles.haxes(4),'off');
             set(handles.haxes(4),'Xlim',[-1,1],'Unit','normalized','Position',handles.axespos(4,:),'Visible','on','Box','on');
         end
         newtag{5,14} = 'Spearman r';              newtag{5,15} = str2double(sprintf('%.3f',spearman.r));           
         newtag{6,14} = 'Spearman p-value';        newtag{6,15} = str2double(sprintf('%.3f',spearman.p)); 
         rs = spearman.r;
         ps = spearman.p;
         dsp = spearman.d;
         slopesp = spearman.slope;
     else
        cla(handles.haxes(4));
        set(handles.haxes(4),'Visible','off');
        newtag{5,14} = 'Spearman r';              newtag{5,15} = [];           
        newtag{6,14} = 'Spearman p-value';        newtag{6,15} = []; 
        rs = [];
        ps = [];
        dsp = [];
        slopesp = [];
         
     end
      
      
           
      handles.rtags = [handles.rtags; newtag];
      tabdata = get(handles.tableRTags,'Data'); %old table data
      displaynewtag = [newtag(1,3:9),handles.tag2,str2double(sprintf('%.2f',min(handles.testrange))),str2double(sprintf('%.2f',max(handles.testrange))),...
      handles.tag1,str2double(sprintf('%.2f',min(handles.baserange))),str2double(sprintf('%.2f',max(handles.baserange))),...
      pearson.N,str2double(sprintf('%.3f',pearson.r)),str2double(sprintf('%.3f',pearson.p)),pearson.d,str2double(sprintf('%.3f',pearson.slope)),str2double(sprintf('%.3f',rs)),str2double(sprintf('%.3f',ps)),dsp,str2double(sprintf('%.3f',slopesp))];
      
      
      checkbox = num2cell(false(1,1));
      displaynewtag = [checkbox,displaynewtag];
      
      tabdata = [tabdata; displaynewtag]; %updated table data
      set(handles.tableRTags,'Data',tabdata,'Enable','on'); %update data to the table

    end

    


else
    warndlg('Baseline and Test ranges must be specified.','Warning','modal');
end

%Remove wait message from status bar
set(handles.editRStatus,...
    'String','',...
    'FontAngle','normal','BackgroundColor','white','ForegroundColor','black','Enable','off');

guidata(hObject, handles); %update handles structure



function editRBaseRp_Callback(hObject, eventdata, handles)
% hObject    handle to editRBaseRp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRBaseRp as text
%        str2double(get(hObject,'String')) returns contents of editRBaseRp as a double


% --- Executes during object creation, after setting all properties.
function editRBaseRp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRBaseRp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBaseMaxcorrS_Callback(hObject, eventdata, handles)
% hObject    handle to editBaseMaxcorrS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBaseMaxcorrS as text
%        str2double(get(hObject,'String')) returns contents of editBaseMaxcorrS as a double


% --- Executes during object creation, after setting all properties.
function editBaseMaxcorrS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBaseMaxcorrS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTestMaxcorrS_Callback(hObject, eventdata, handles)
% hObject    handle to editTestMaxcorrS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTestMaxcorrS as text
%        str2double(get(hObject,'String')) returns contents of editTestMaxcorrS as a double


% --- Executes during object creation, after setting all properties.
function editTestMaxcorrS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTestMaxcorrS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTestMaxcorrP_Callback(hObject, eventdata, handles)
% hObject    handle to editTestMaxcorrP (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTestMaxcorrP as text
%        str2double(get(hObject,'String')) returns contents of editTestMaxcorrP as a double


% --- Executes during object creation, after setting all properties.
function editTestMaxcorrP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTestMaxcorrP (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function editRBaseTp_Callback(hObject, eventdata, handles)
% hObject    handle to editRBaseTp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRBaseTp as text
%        str2double(get(hObject,'String')) returns contents of editRBaseTp as a double


% --- Executes during object creation, after setting all properties.
function editRBaseTp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRBaseTp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTestTimeP_Callback(hObject, eventdata, handles)
% hObject    handle to editTestTimeP (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTestTimeP as text
%        str2double(get(hObject,'String')) returns contents of editTestTimeP as a double


% --- Executes during object creation, after setting all properties.
function editTestTimeP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTestTimeP (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBaseTimeS_Callback(hObject, eventdata, handles)
% hObject    handle to editBaseTimeS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBaseTimeS as text
%        str2double(get(hObject,'String')) returns contents of editBaseTimeS as a double


% --- Executes during object creation, after setting all properties.
function editBaseTimeS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBaseTimeS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTestTimeS_Callback(hObject, eventdata, handles)
% hObject    handle to editTestTimeS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTestTimeS as text
%        str2double(get(hObject,'String')) returns contents of editTestTimeS as a double


% --- Executes during object creation, after setting all properties.
function editTestTimeS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTestTimeS (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in radRVar1.
function radRVar1_Callback(hObject, eventdata, handles)
% hObject    handle to radRVar1 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radRVar1

if get(hObject,'Value');
    set(handles.radRVar2,'Value',0);    
end

guidata(hObject, handles); %update handles structure



% --- Executes on button press in radRVar2.
function radRVar2_Callback(hObject, eventdata, handles)
% hObject    handle to radRVar2 (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radRVar2

if get(hObject,'Value');
    set(handles.radRVar1,'Value',0);    
end

guidata(hObject, handles); %update handles structure



% --- Executes on button press in chkRNorm.
function chkRNorm_Callback(hObject, eventdata, handles)
% hObject    handle to chkRNorm (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRNorm


% --- Executes on button press in chkRDetrend.
function chkRDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to chkRDetrend (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRDetrend



function editRDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to editRDetrend (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRDetrend as text
%        str2double(get(hObject,'String')) returns contents of editRDetrend as a double


% --- Executes during object creation, after setting all properties.
function editRDetrend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRDetrend (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkRScale.
function chkRScale_Callback(hObject, eventdata, handles)
% hObject    handle to chkRScale (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRScale



function editRScale_Callback(hObject, eventdata, handles)
% hObject    handle to editRScale (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRScale as text
%        str2double(get(hObject,'String')) returns contents of editRScale as a double


% --- Executes during object creation, after setting all properties.
function editRScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRScale (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkRYshift.
function chkRYshift_Callback(hObject, eventdata, handles)
% hObject    handle to chkRYshift (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRYshift


% --- Executes on button press in chkRXshift.
function chkRXshift_Callback(hObject, eventdata, handles)
% hObject    handle to chkRXshift (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkRXshift



function editRYshift_Callback(hObject, eventdata, handles)
% hObject    handle to editRYshift (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRYshift as text
%        str2double(get(hObject,'String')) returns contents of editRYshift as a double


% --- Executes during object creation, after setting all properties.
function editRYshift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRYshift (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRXshift_Callback(hObject, eventdata, handles)
% hObject    handle to editRXshift (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRXshift as text
%        str2double(get(hObject,'String')) returns contents of editRXshift as a double


% --- Executes during object creation, after setting all properties.
function editRXshift_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRXshift (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRTestRp_Callback(hObject, eventdata, handles)
% hObject    handle to editRTestRp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRTestRp as text
%        str2double(get(hObject,'String')) returns contents of editRTestRp as a double


% --- Executes during object creation, after setting all properties.
function editRTestRp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRTestRp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRTestTp_Callback(hObject, eventdata, handles)
% hObject    handle to editRTestTp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRTestTp as text
%        str2double(get(hObject,'String')) returns contents of editRTestTp as a double


% --- Executes during object creation, after setting all properties.
function editRTestTp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRTestTp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRBaseRs_Callback(hObject, eventdata, handles)
% hObject    handle to editRBaseRs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRBaseRs as text
%        str2double(get(hObject,'String')) returns contents of editRBaseRs as a double


% --- Executes during object creation, after setting all properties.
function editRBaseRs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRBaseRs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRBaseTs_Callback(hObject, eventdata, handles)
% hObject    handle to editRBaseTs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRBaseTs as text
%        str2double(get(hObject,'String')) returns contents of editRBaseTs as a double


% --- Executes during object creation, after setting all properties.
function editRBaseTs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRBaseTs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRTestRs_Callback(hObject, eventdata, handles)
% hObject    handle to editRTestRs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRTestRs as text
%        str2double(get(hObject,'String')) returns contents of editRTestRs as a double


% --- Executes during object creation, after setting all properties.
function editRTestRs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRTestRs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRTestTs_Callback(hObject, eventdata, handles)
% hObject    handle to editRTestTs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRTestTs as text
%        str2double(get(hObject,'String')) returns contents of editRTestTs as a double


% --- Executes during object creation, after setting all properties.
function editRTestTs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRTestTs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRPs_Callback(hObject, eventdata, handles)
% hObject    handle to editRPs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRPs as text
%        str2double(get(hObject,'String')) returns contents of editRPs as a double


% --- Executes during object creation, after setting all properties.
function editRPs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRPs (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRPp_Callback(hObject, eventdata, handles)
% hObject    handle to editRPp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRPp as text
%        str2double(get(hObject,'String')) returns contents of editRPp as a double


% --- Executes during object creation, after setting all properties.
function editRPp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRPp (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butRDeletetag.
function butRDeletetag_Callback(hObject, eventdata, handles)
% hObject    handle to butRDeletetag (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Get selected tag rows
[tabdata,ind,select] = handles.getSelectedTags(handles);

if isempty(ind)
    return
end

% %Delete correlation results
% handles.r(select)      = [];
% handles.se(select)     = [];
% handles.lci95(select)  = [];
% handles.uci95(select)  = [];
% handles.baseRp(select) = [];
% handles.testRp(select) = [];
% handles.p(select)      = [];
% 
% if ~handles.flagToolbox
%     handles.rs(select)     = [];
%     handles.ses(select)    = [];
%     handles.lci95s(select) = [];
%     handles.uci95s(select) = [];
%     handles.baseRs(select) = [];
%     handles.testRs(select) = [];
%     handles.ps(select)     = [];
% end
 

handles.rtags(ind,:) = []; %updated tag list
tabdata(select,:) = [];
set(handles.tableRTags,'Data',tabdata);

if isempty(handles.rtags);
    set(handles.butRDeletetag,'Enable','off');
    set(handles.chkSelectAll,'Value',0);
end



guidata(hObject, handles); %update handles structure






% --- Executes on selection change in popRBase.
function popRBase_Callback(hObject, eventdata, handles)
% hObject    handle to popRBase (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popRBase contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popRBase

contents = cellstr(get(hObject,'String'));
seltag = contents{get(hObject,'Value')};

if get(hObject,'Value')<=1,
    %Get xlimit
    xlimit = get(handles.haxes(1),'Xlim');
    handles.baserange = []; %[sec]
    %Signal 1
    axes(handles.haxes(1));
    x1 = (0:length(handles.y1)-1)/handles.fs1;
    plot(x1,handles.y1,'Color',handles.pcolor(1,:)); hold on;
    if isfield(handles,'testrange') && ~isempty(handles.testrange)
        [t1,t2] = getIndex(handles.testrange,handles.fs1,length(handles.y1));
        plot(x1(t1:t2),handles.y1(t1:t2),'Color',handles.tcolor);
    end
    ylabel(handles.varname1);
    set(handles.haxes(1),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(1,:));
    
    %Signal 2
    axes(handles.haxes(2));
    x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
    plot(x2,handles.y2{1},'Color',handles.pcolor(2,:)); hold on; 
    if isfield(handles,'testrange') && ~isempty(handles.testrange)
        [t1,t2] = getIndex(handles.testrange,handles.fs2(1),length(handles.y2{1}));
        plot(x2(t1:t2),handles.y2{1}(t1:t2),'Color',handles.tcolor);
    end
    ylabel(handles.varname2{1});
    set(handles.haxes(2),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(2,:));
    
    
    cla(handles.haxes(3));
    cla(handles.haxes(4));
    set(handles.haxes(3),'Visible','off');
    set(handles.haxes(4),'Visible','off');
    
    guidata(hObject,handles);
    return
    
end

i1 = strfind(seltag,'(');
i2 = strfind(seltag,' - ');
i3 = strfind(seltag,'sec');
handles.baserange(1) = str2double(seltag(i1+1:i2-1)); %[sec]
handles.baserange(2) = str2double(seltag(i2+3:i3-1)); %[sec]
handles.tag1 = seltag(1:i1-2);

%Get xlimit
xlimit = get(handles.haxes(1),'Xlim');


%Signal 1
axes(handles.haxes(1));
[b1,b2] = getIndex(handles.baserange,handles.fs1,length(handles.y1));
x1 = (0:length(handles.y1)-1)/handles.fs1;
plot(x1,handles.y1,'Color',handles.pcolor(1,:)); hold on;
plot(x1(b1:b2),handles.y1(b1:b2),'Color',handles.bcolor);
if isfield(handles,'testrange') && ~isempty(handles.testrange)
    [t1,t2] = getIndex(handles.testrange,handles.fs1,length(handles.y1));
    plot(x1(t1:t2),handles.y1(t1:t2),'Color',handles.tcolor);
end
ylabel(handles.varname1);
set(handles.haxes(1),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(1,:));

%Signal 2
axes(handles.haxes(2));
[b1,b2] = getIndex(handles.baserange,handles.fs2(1),length(handles.y2{1}));
x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
plot(x2,handles.y2{1},'Color',handles.pcolor(2,:)); hold on;
plot(x2(b1:b2),handles.y2{1}(b1:b2),'Color',handles.bcolor);
if isfield(handles,'testrange') && ~isempty(handles.testrange)
    [t1,t2] = getIndex(handles.testrange,handles.fs2(1),length(handles.y2{1}));
    plot(x2(t1:t2),handles.y2{1}(t1:t2),'Color',handles.tcolor);
end
ylabel(handles.varname2{1});
set(handles.haxes(2),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(2,:));


cla(handles.haxes(3));
cla(handles.haxes(4));
set(handles.haxes(3),'Visible','off');
set(handles.haxes(4),'Visible','off');




%Linkaxes
linkaxes(handles.haxes(1:2),'x');

guidata(hObject, handles); %update handles structure



% --- Executes during object creation, after setting all properties.
function popRBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popRBase (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popRTest.
function popRTest_Callback(hObject, eventdata, handles)
% hObject    handle to popRTest (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popRTest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popRTest

contents = cellstr(get(hObject,'String'));
seltag = contents{get(hObject,'Value')};

if get(hObject,'Value')<=1
    %Get xlimit
    xlimit = get(handles.haxes(1),'Xlim');
    handles.testrange = []; %[sec]
    
    %Signal 1
    axes(handles.haxes(1));
    x1 = (0:length(handles.y1)-1)/handles.fs1;
    plot(x1,handles.y1,'Color',handles.pcolor(1,:)); hold on;
    if isfield(handles,'baserange') && ~isempty(handles.baserange)
        [t1,t2] = getIndex(handles.baserange,handles.fs1,length(handles.y1));
        plot(x1(t1:t2),handles.y1(t1:t2),'Color',handles.bcolor);
    end
    ylabel(handles.varname1);
    set(handles.haxes(1),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(1,:));
    
    %Signal 2
    axes(handles.haxes(2));
    x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
    plot(x2,handles.y2{1},'Color',handles.pcolor(2,:)); hold on; 
    if isfield(handles,'baserange') && ~isempty(handles.baserange)
        [t1,t2] = getIndex(handles.baserange,handles.fs2(1),length(handles.y2{1}));
        plot(x2(t1:t2),handles.y2{1}(t1:t2),'Color',handles.bcolor);
    end
    ylabel(handles.varname2{1});
    set(handles.haxes(2),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(2,:));
    
    
    cla(handles.haxes(3));
    cla(handles.haxes(4));
    set(handles.haxes(3),'Visible','off');
    set(handles.haxes(4),'Visible','off');
    
     guidata(hObject,handles);
    
    return

end
i1 = strfind(seltag,'(');
i2 = strfind(seltag,' - ');
i3 = strfind(seltag,'sec');
time1 = str2double(seltag(i1+1:i2-1)); %[sec]
time2 = str2double(seltag(i2+3:i3-1)); %[sec]
tag2 =  seltag(1:i1-2);

%Clear axes 3 and 4 if there's a change in Test range;
%Clear correlation results
if isfield(handles,'testrange') && ~isempty(handles.testrange) && time1~=handles.testrange(1) && time2~=handles.testrange(2) && isfield(handles,'baserange') && isfield(handles,'testrange')
    cla(handles.haxes(3));
    cla(handles.haxes(4));
    set(handles.haxes(3),'Visible','off');
    set(handles.haxes(4),'Visible','off');
    
end

handles.testrange(1) = time1; %[sec]
handles.testrange(2) = time2; %[sec]
handles.tag2 = tag2;

xlimit = get(handles.haxes(1),'Xlim');

%Signal 1
cla(handles.haxes(1));
axes(handles.haxes(1));
x1 = (0:length(handles.y1)-1)/handles.fs1;
plot(x1,handles.y1,'Color',handles.pcolor(1,:)); hold on;
if isfield(handles,'baserange') && ~isempty(handles.baserange)
    [b1,b2] = getIndex(handles.baserange,handles.fs1,length(handles.y1));
    plot(x1(b1:b2),handles.y1(b1:b2),'Color',handles.bcolor);
end
[t1,t2] = getIndex(handles.testrange,handles.fs1,length(handles.y1));
plot(x1(t1:t2),handles.y1(t1:t2),'Color',handles.tcolor);
ylabel(handles.varname1);
set(handles.haxes(1),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(1,:));

%Signal 2
cla(handles.haxes(2));
subplot(handles.haxes(2));
x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
plot(x2,handles.y2{1},'Color',handles.pcolor(2,:)); hold on;
if isfield(handles,'baserange') && ~isempty(handles.baserange)
    [b1,b2] = getIndex(handles.baserange,handles.fs2(1),length(handles.y2{1}));
    plot(x2(b1:b2),handles.y2{1}(b1:b2),'Color',handles.bcolor);
end
[t1,t2] = getIndex(handles.testrange,handles.fs2(1),length(handles.y2{1}));
plot(x2(t1:t2),handles.y2{1}(t1:t2),'Color',handles.tcolor);
ylabel(handles.varname2{1});
set(handles.haxes(2),'Xlim',xlimit,'Unit','normalized','Position',handles.axespos(2,:));

%Linkaxes
linkaxes(handles.haxes(1:2),'x');
    



guidata(hObject, handles); %update handles structure



% --- Executes during object creation, after setting all properties.
function popRTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popRTest (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --------------------------------------------------------------------
function toolRScreenshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolRScreenshot (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[figfile,figpath] = uiputfile('*.*','Take a Screenshot of the GUI');
if ~ischar(figfile)
    return %return if choosing invalid file
end

pause(0.3); %to ensure that the uiputfile figure is already closed

pos = get(handles.figMovingCorrelation,'Position');
imgdata = screencapture(0,'Position',pos); %take a screen capture
imwrite(imgdata,fullfile(figpath,[figfile,'.png'])); %save the captured image to file

guidata(hObject, handles); %update handles structure



%==========================================================================
 function initializeSubGUI(hObject,handles)

%Get shared data and stored them in handles structure
hfigmain = getappdata(0, 'hfigmain');
handles.emptyworkspace = getappdata(hfigmain,'FlagEmptyWorkspace');
%% If there are no variables in workspace, automatically opens batch 2016-04-08
if handles.emptyworkspace
    set(handles.panelBatch,'Visible','on');
    set(handles.menuMode,'Enable','off');
    handles.batch.matpath = [];
    handles.batch.tagpath = [];
    handles.batch.xvarlist = [];
    handles.batch.yvarlist = [];
    handles.batch.xfslist = [];
    handles.batch.yfslist = [];
    handles.batch.baseRegions = [];
    handles.batch.testRegions = [];
    handles.batch.ndelay = [];
    handles.batch.varlist = [];
    handles.batch.fslist = [];
    handles.batch.allresults = [];
else
    set(handles.menuMode,'Enable','on');
    set(handles.panelBatch,'Visible','off');
    handles.varname     = getappdata(hfigmain, 'SDvarname');
    handles.filename    = getappdata(hfigmain, 'SDfilename');
    handles.acrostic    = getappdata(hfigmain, 'SDacrostic');
    handles.subjnum     = getappdata(hfigmain, 'SDsubjnum');
    handles.exptdate    = getappdata(hfigmain, 'SDexptdate');
    handles.expttime    = getappdata(hfigmain, 'SDexpttime');
    handles.signal      = getappdata(hfigmain, 'SDsignal');
    handles.fs          = getappdata(hfigmain, 'SDfs');
    handles.flagnorm    = getappdata(hfigmain, 'SDflagnorm');
    handles.flagdetrend = getappdata(hfigmain, 'SDflagdetrend');
    handles.detrend     = getappdata(hfigmain, 'SDdetrend');
    handles.scale       = getappdata(hfigmain, 'SDscale');
    handles.alltags     = getappdata(hfigmain, 'SDtag');
    
    %Initialize variables
    varind = 1;
    handles.varname1 = '';
    handles.varname2 = '';
    handles.filename1 = '';
    handles.filename2 = {[]};
    handles.rtags   = {};
    
    handles.roption = 'positive';
    
    handles.newvarflag = false; %Keep track if new variables are selected
    
    %Initial axes
    handles.haxes(1) = subplot(4,1,1,'Parent',handles.panelRAxes);
    set(handles.haxes(1),'Visible','off');
    handles.haxes(2) = subplot(4,1,2,'Parent',handles.panelRAxes);
    set(handles.haxes(2),'Visible','off');
    handles.haxes(3) = subplot(4,1,3,'Parent',handles.panelRAxes);
    set(handles.haxes(3),'Visible','off');
    handles.haxes(4) = subplot(4,1,4,'Parent',handles.panelRAxes);
    set(handles.haxes(4),'Visible','off');
    
    
    %Compute positions of each axes
    hpad   = 0.05;
    wplot  = 0.9;
    hplot  = (1 - 5*hpad)/4; %4 axes with 5 paddings between each axes
    handles.axespos = [[0.07, 4*hpad + (4-1)*hplot, wplot, hplot];... %subplot 1
        [0.07, 3*hpad + (3-1)*hplot, wplot, hplot];... %subplot 2
        [0.07, 2*hpad + (2-1)*hplot, wplot, hplot];... %subplot 3
        [0.07, 1*hpad + (1-1)*hplot, wplot, hplot]];   %subplot 4
    
    %Color codes
    handles.pcolor = [[0.8,  0, 0];...    %subplot 1: dark red
        [0,    0, 0];...    %subplot 2: black
        [0,    0, 1];...    %subplot 3: blue
        [0.75, 0, 0.75]];   %subplot 4: purple
    handles.bcolor = [0, 0.75, 0.75];     %baseline color: light blue
    handles.tcolor = [1, 0.4, 0];         %test color: orange
    handles.lcolor = [0.25, 0.25, 0.25];  %horizontal line color: grey
    handles.mcolor = [1, 0, 0];           %marker color: red
    
    %Workspace
    [pathstr,name,ext] = fileparts(handles.filename{varind});
    set(handles.listRWrkspc,'FontSize',10,'String',handles.varname,'Value',varind,'Enable','on');
    set(handles.txtRFilename,'FontSize',10);
    set(handles.editRFilename,'FontSize',10,'String',[name,ext],'Enable','inactive');
    
    
    %Variable 1
    set(handles.butRVar1,'FontSize',10,'Enable','on');
    set(handles.editRVar1,'FontSize',10,'String','','Enable','inactive');
    
    %Variable 2
    set(handles.butRVar2,'FontSize',10,'Enable','on');
    set(handles.editRVar2,'FontSize',10,'String','','Enable','inactive');
    
    %Compute correlation
    set(handles.butRBase,'FontSize',10,'Enable','off');
    set(handles.butRTest,'FontSize',10,'Enable','off');
    set(handles.popRBase,'FontSize',10,'String',{'<Tags>'},'Value',1,'Enable','off');
    set(handles.popRTest,'FontSize',10,'String',{'<Tags>'},'Value',1,'Enable','off');
    set(handles.butRCorr,'FontSize',10,'Enable','off');
    
    %Tags
    set(handles.tableRTags,'Fontsize',10,'Data',{},'Enable','off');
    set(handles.butRDeletetag,'Fontsize',10,'Enable','off');
    
    
    %Status bar
    set(handles.editRStatus,'FontSize',10,'Enable','off');
    
    %Check if Statistics toolbox is avaiable
    handles.flagToolbox = 1;
    if ~license('test','Statistics_Toolbox')
        disp('Statistics toolbox is not available.');
        disp('--> Only Pearson correlation will be computed.');
        disp(' ');
        
        handles.flagToolbox = 0;
        
    end

end
guidata(hObject, handles); %update handles structure


% --- Executes when user attempts to close figMovingCorrelation.
function figMovingCorrelation_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figMovingCorrelation (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
% update submovecorr in DB first

handlesDB = guidata(handles.DataBrowser);
handlesDB.subMovingCorrelation = [];
guidata(handles.DataBrowser,handlesDB);
delete(hObject);


% --------------------------------------------------------------------
function toolRSelectRegion_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolRSelectRegion (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% select and highlight the selected axes
% delete any shaded area being plotted
delete(findobj(0,'Type','patch'));

% disable other tools
set(handles.toolRScreenshot,'Enable','off');
set(handles.toolRZoomin,'Enable','off');
set(handles.toolRZoomout,'Enable','off');
set(handles.toolRPan,'Enable','off');
set(handles.toolRDataCursor,'Enable','off');

s = get(handles.toolRSelectRegion,'State');

if strcmp(s,'on') %select the tool
    [x,y] = ginputCross(1); % automatically disable other tools
    ax = gca;
    % check if axe is either test||tested signal
    % check if the signal is plotted, isempty(axe.children)
    
    
    if (ax~=handles.haxes(1) && ax~=handles.haxes(2)) || isempty(get(ax,'Children'))
        set(handles.toolRSelectRegion,'State','off');
        
        return
    end
    % user selects the test signal
    if ax==handles.haxes(1),
        numsignal = 1;
    else % select the tested signal
        numsignal = 2;
    end
 
    c = get(ax,'Color');
    set(ax,'Color',[1 0.93 0.93]);

    % Define area to be shaded
    rect = getrect(ax); %rect = [xmin ymin width height] (unit = unit of x-axis)
    % Restore axes color
    set(ax,'Color',c);

    %Check if width = 0. If so, enable other tools & return.
    if rect(3)==0    
         %Enable tools
         set(handles.toolRSelectRegion,'State','off');
         set(handles.toolRScreenshot,'Enable','on');
         set(handles.toolRZoomin,'Enable','on');
         set(handles.toolRZoomout,'Enable','on');
         set(handles.toolRPan,'Enable','on');
         set(handles.toolRDataCursor,'Enable','on');
        return
    end
    
    % check if selected region is valid
    xmin = rect(1);
    if xmin<0
            xmin = 0;
    end
    % xmax = xmin+width
    xmax = rect(1) + rect(3);
    % hchildren includes signal, baseline & testrange
    hchildren = get(ax,'Children');
    xchildren = get(hchildren,'XData');
    if iscell(xchildren) %multiple signals in current axes
            XMAX = max((cellfun(@max,xchildren)));
    else %only 1 signal in current axes  
            XMAX = max(xchildren);
    end
    
    if xmax>XMAX
           xmax = XMAX;
    end
        
    %Display selected region
    ylimit = get(ax,'Ylim');
    yrange = range(ylimit);
    ymin = min(ylimit) + 0.02*yrange;
    ymax = max(ylimit) - 0.02*yrange;
    axes(ax); hold on;
    hshade = fill([xmin xmin xmax xmax],[ymin ymax ymax ymin],[1 1 0.8],'EdgeColor',[1 1 0.8]);
    uistack(hshade,'bottom');
    
    handles.genDefineRegionTag(numsignal,[xmin;xmax],handles);
    %Enable tools
    set(handles.toolRSelectRegion,'State','off');
    set(handles.toolRScreenshot,'Enable','on');
    set(handles.toolRZoomin,'Enable','on');
    set(handles.toolRZoomout,'Enable','on');
    set(handles.toolRPan,'Enable','on');
    set(handles.toolRDataCursor,'Enable','on');
            
else % deselect the tool
    % enable tools
    set(handles.toolRSelectRegion,'State','off');
    set(handles.toolRScreenshot,'Enable','on');
    set(handles.toolRZoomin,'Enable','on');
    set(handles.toolRZoomout,'Enable','on');
    set(handles.toolRPan,'Enable','on');
    set(handles.toolRDataCursor,'Enable','on');

end

guidata(hObject,handles);


% --- Executes when entered data in editable cell(s) in tableRTags.
function tableRTags_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tableRTags (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% data=get(hObject,'Data'); % get the data cell array of the table
% cols=get(hObject,'ColumnFormat'); % get the column formats
% r = eventdata.Indices(1);
% c = eventdata.Indices(2);
% coprTag = 12;
% if strcmp(cols(eventdata.Indices(2)),'logical') % if the column of the edited cell is logical
%     if eventdata.EditData % if the checkbox was set to true
%         select = true;
%     else
%         select = false;
%     end
%         %set row&col
%         data{r,c}= select; % set the data value to true       
%         % search downward&upward
%         ind1 = strfind(data(:,coprTag),'Baseline range'); % search all
%         ind2 = find(~cellfun(@isempty,ind1)>0);
%         % search its baseline range 
%         temp = find(ind2<=r,1,'last'); %get its baseline
%         first = ind2(temp);
%         temp = find(ind2>r,1,'first'); %gets the next baseline
%         last = ind2(temp);
%         if ~isempty(last),
%             for i=ind2:(last-1),
%                  data{i,c} = select;
%             end
%         else
%             for i=first:length(data(:,c)),
%                  data{i,c} = select;
%             end
%         end    
% 
% end
% set(hObject,'Data',data);

% --- Executes on button press in butExportAllTags.
function butExportAllTags_Callback(hObject, eventdata, handles)
% hObject    handle to butExportAllTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesTE = getActiveTagEditor(handles);
handlesTE.updateEditorTags(handlesTE,handles.rtags(:,:));

%update tag list in the table
handles.rtags = []; %updated tag list
tabdata = [];
set(handles.tableRTags,'Data',tabdata);
set(handles.butRDeletetag,'Enable','off');


% --- Executes on button press in butExportTags.
function butExportTags_Callback(hObject, eventdata, handles)
% hObject    handle to butExportTags (see GCBO)
% eventdata  reserved - to be Define in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Export result tags to Tag Editor
handlesTE = getActiveTagEditor(handles);%Collects Data from the handle, which is the table to the left of the button
tabdata = get(handles.tableRTags,'Data');
cselect = 1;
select = cellfun(@(x) x==1, tabdata(:,cselect), 'UniformOutput', 1); %logical array
select = find(select);
%this handleTE commands dont work, I know what its supposed to do but for
%some reason does not like doing this
%handlesTE.updateEditorTags(handlesTE,tabdata(select,:));
tabdata=tabdata(select,:);
if isempty(tabdata) %Added by Toey 1Nov2017
    msgbox('PLEASE SELECT RESULTS BEFORE EXPORT','MOVING CORRELATION Says..');
    return
end
[file,path] = uiputfile('MovingCorrelationresults.csv','Save Output');%User chooses new path for save
if ~isequal(file,0) %Added by Toey 1Nov2017
    filepath=fullfile(path,file);
    %v transfer the cell to a table with the columns listed Note, Ignoring
    %1/F as well
    T2=cell2table(tabdata,'VariableNames',{'Select' 'Acrostic' 'Subject_ID' 'Expt_Date' 'Expt_Time' 'Variable' 'Side' 'OnceperFs' 'TestTag' 'TestBegin' 'TestEnd' 'Baseline' 'BaselineBegin' 'BaselineEnd' 'NumberofShiftsforNullDist' 'Pearson_r' 'Pearson_p' 'Pearson_delay' 'Pearson_slope' 'Spearman_r' 'Spearman_p' 'Spearman_delay' 'Spearman_slope'});
    T=[T2(:,2),T2(:,3),T2(:,4),T2(:,5),T2(:,6),T2(:,8),T2(:,9),T2(:,10),T2(:,11),T2(:,12),T2(:,13),T2(:,14),T2(:,15),T2(:,16),T2(:,17),T2(:,18),T2(:,19),T2(:,20),T2(:,21),T2(:,22),T2(:,23)];
    writetable(T,filepath);%Writes the table to created file
end

%Toey greened out 15Nov2017
%{
handlesTE = getActiveTagEditor(handles);
[tabdata,ind,select] = getSelectedTags(handles);
handlesTE.updateEditorTags(handlesTE,handles.rtags(ind,:));

%update tag list in the table
handles.rtags(ind,:) = []; %updated tag list
tabdata(select,:) = [];
set(handles.tableRTags,'Data',tabdata);

if isempty(handles.rtags)
    set(handles.butRDeletetag,'Enable','off');
end
%}
guidata(hObject,handles);

% --- Executes on button press in chkSelectAll.
function chkSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to chkSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSelectAll
tabdata = get(handles.tableRTags,'Data');
[nrow,ncol] = size(tabdata);
if (get(hObject,'Value') == get(hObject,'Max')),
   if nrow>0,
       checkbox = num2cell(true(nrow,1));
       tabdata = [checkbox,tabdata(:,2:end)];
   end
else
   if nrow>0,
       checkbox = num2cell(false(nrow,1));
       tabdata = [checkbox,tabdata(:,2:end)];
   end
 
end

% set select columns in the table
set(handles.tableRTags,'Data',tabdata);
guidata(hObject,handles);

% --- Executes on button press in butUpdatePopChoices.
function butUpdatePopChoices_Callback(hObject, eventdata, handles)
% hObject    handle to butUpdatePopChoices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handlesTE = getActiveTagEditor(handles);
definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
handles.updatePopMenu(handles,definetags,'all');
handles.baserange = [];
handles.testrange = [];

guidata(hObject,handles)

%------------------Non-Callback Functions------------------%
%------------------Non-Callback Functions------------------%
%------------------Non-Callback Functions------------------%
%------------------Non-Callback Functions------------------%
%------------------Non-Callback Functions------------------%


function [str] = updatePopChoices(currentstr,newtags,filename)
% needed variables
% 1. all DefineRegion tags (fullformat)
% 2. filename = [name,ext]

tagcol = 12; % name of tags
begincol = 10;
endcol = 11;
if isempty(currentstr),
    str = {'<Tags>'};
else
    str = currentstr;
end
if ~isempty(newtags)
    % search rowid to the tag of that file
    tagid = find(ismember(newtags(:,1),filename));

    for n=1:length(tagid),
       id = tagid(n);    
       tag = [newtags{id,tagcol},' (',...
             num2str(newtags{id,begincol},'%10.2f'),' - ',...
             num2str(newtags{id,endcol},'%10.2f'),' sec)'];
             str = [str; tag];
    end
end

function [] = updatePopMenu(handles,newtags,mode)
% newtags = recent added DefineRegion tags
% handles to MoveCorr 
% mode = 'base' || 'test' || []
% if newtags is empty, all defineregion tags are deleted
% Case 0: both variables are not selected
if ~handles.isvaractive(handles) || isempty(newtags),
    return
end

ischange = false;
switch mode
    case 'base' %select baseline button
        oldstr = get(handles.popRBase,'String');
        % Baseline
        [pathstr,name,ext] = fileparts(handles.filename1);
        str1 = handles.updatePopChoices(oldstr,newtags,[name,ext]);
        val1 = length(str1);
        if strcmp(handles.filename1,handles.filename2),
            str2 = str1;
        else
            str2 = get(handles.popRTest,'String');
        end
        val2 = get(handles.popRTest,'Value');
    case 'test' %select test button
        % Test
        [pathstr,name,ext] = fileparts(handles.filename2);
        oldstr = get(handles.popRTest,'String');
        str2 = handles.updatePopChoices(oldstr,newtags,[name,ext]);
        val2 = length(str2);
        if strcmp(handles.filename1,handles.filename2),
            str1 = str2;
        else
            str1 = get(handles.popRBase,'Value');
        end
        val1 = get(handles.popRBase,'Value');
    otherwise %delete or update button
        [pathstr,name,ext] = fileparts(handles.filename1);
        str1 = handles.updatePopChoices([],newtags,[name,ext]);
        [pathstr,name,ext] = fileparts(handles.filename2);
        str2 = handles.updatePopChoices([],newtags,[name,ext]);
        
        val1 = 1;
        val2 = 1;
        ischange = true;
%         val1 = get(handles.popRBase,'Value');
%         val2 = get(handles.popRBase,'Value');
end
set(handles.popRBase,'String',str1,'Value',val1,'Enable','on');
set(handles.popRTest,'String',str2,'Value',val2,'Enable','on');


% reset both plots if one of the tags from rbase and rtest is removed
if ischange,
     % reset plot
     cla(handles.haxes(1));
     axes(handles.haxes(1));
     x1 = (0:length(handles.y1)-1)/handles.fs1;
     plot(x1,handles.y1,'Color',handles.pcolor(1,:));
     set(handles.popRBase,'Value',1,'Enable','on');
         
     cla(handles.haxes(2));
     x2 = (0:length(handles.y2{1})-1)/handles.fs2(1);
     axes(handles.haxes(2));
     plot(x2,handles.y2{1},'Color',handles.pcolor(2,:));
     set(handles.popRTest,'Value',1,'Enable','on');
end
guidata(handles.popRBase,handles);


function [av] = isvaractive(handles)
%Enable buttons for computing correlation if already select 2 variables
s1 = get(handles.editRVar1,'String');
s2 = get(handles.editRVar1,'String');
if ~isempty(s1)&&~isempty(s2),
    av = true;
else
    av = false;
end
    
function [handlesTE] = getActiveTagEditor(handles)
handlesDB = guidata(handles.DataBrowser);
handlesTM = guidata(handlesDB.TagManager);

if strcmp(get(handlesDB.tableEditor,'Enable'),'on')
    handlesTE = handlesDB;
else
    handlesTE = handlesTM;
end

function [newtags] = genDefineRegionTag(numsignal,tagrange,handles)
    
% needed variables
  xmin = tagrange(1);
  xmax = tagrange(2);
  signal = num2str(numsignal);
  eval(['filename=','handles.filename',signal,';']);
  [path,name,ext] = fileparts(filename);
  filename = [name,ext];
  eval(['acrostic=','handles.acrostic',signal,';']);
  eval(['subjnum=','handles.subjnum',signal,';']);
  eval(['fs=','handles.fs',signal,';']);
  eval(['exptdate=','handles.exptdate',signal,';']);
  eval(['expttime=','handles.expttime',signal,';']);
  eval(['varname=','handles.varname',signal,';']);
% new tags
  ncol = 15;
  newtags = cell(1,ncol); %select one var at a time

  %Input will be the cell array
  prompt = {'Enter Tag Name'};
  def = {'TAG'};
  dlg_title = '';
  num_lines = 1;
  tag = newid(prompt,dlg_title,num_lines,def);
  if isempty(tag),
        newtags = [];
        return
  end

  if numsignal == 1,
      poptag = get(handles.popRBase,'String');
  else
      poptag = get(handles.popRTest,'String');
  end
  for i=1:length(poptag),
      % get tagname
      i1 = strfind(poptag{i},'(')-2;
      tagname = poptag{i}(1:i1);
      if strcmpi(tag{1,1},tagname),
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

  newtags{1,1}  = filename;         %Filename
  newtags{1,2}  = 'MoveCorr';       %Module
  newtags{1,3}  = acrostic;         %Acrostic
  newtags{1,4}  = subjnum;          %SubjID
  newtags{1,5}  = exptdate;         %ExptDate
  newtags{1,6}  = expttime;         %ExptTime
  newtags{1,7}  = varname;          %Variable
  newtags{1,8}  = side;             %Side
  newtags{1,9}  = fs;               %Sampling frequency
  newtags{1,10} = xmin;             %Begin
  newtags{1,11} = xmax;             %End
  newtags{1,12} = tag{1,1};         %Tag
  newtags{1,13} = 'DefineRegion';   %Operation
  newtags{1,14} = '-';              %Operation Tag
  newtags{1,15} = NaN;               %Value

  %Update Active Tag Editor (DB or TM). 
  handlesTE = getActiveTagEditor(handles);
  handlesTE.updateEditorTags(handlesTE,newtags);

function [i1,i2] = getIndex(timerange,fs,lgth)
%Convert unit of selected region in time to no. of data points
i1 = round(fs*min(timerange)+1);
if i1<1
    i1 = 1;
end
i2 = round(fs*max(timerange)+1);
if i2>lgth
    i2 = lgth;
end


function [time1,time2] = checkValidTimeRange(timerange,fs,lgth)

%Check if selected region (in time) is valid
time1 = min(timerange);
if time1<0
    time1 = 0;
end
time2 = max(timerange);
if time2>(lgth/fs)
    time2 = lgth/fs;
end


function [tabdata,ind,select] = getSelectedTags(handles)
%function output
%select : indices to the selected rows
%ind : indices to the set
%------------------Get Selected Tag Rows--------------------%
tabdata = get(handles.tableRTags,'Data');
cselect = 1;
select = cellfun(@(x) x==1, tabdata(:,cselect), 'UniformOutput', 1); %logical array
select = find(select);

nrow = 6;
ind = [];
for n=1:length(select),
    row = select(n);
    indstart = nrow*(row-1)+1;
    indend = indstart+nrow-1; 
    ind = [ind;(indstart:indend)'];
end   
    
%-------------------------End---------------------------%
%------------------Get Selected Tag Rows--------------------%
% tabdata = get(handles.tableRTags,'Data'); 
% %get the number of sets
% ind1 = strfind(handles.rtags(:,14),'Baseline range');
% ind2 = find(~cellfun(@isempty,ind1)>0); %length = # of sets
% 
% 
% %get the selected rows
% cselect = 1;
% select = cellfun(@(x) x==1, tabdata(:,cselect), 'UniformOutput', 1); %row indices
% 
% %get the indices of each set
% ind = find(select(ind2));
%-------------------------End---------------------------%


% --- Executes on button press in butSaveOutput.
function butSaveOutput_Callback(hObject, eventdata, handles)
% hObject    handle to butSaveOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Get selected tag rows
[tabdata,ind,select] = handles.getSelectedTags(handles);

if isempty(select),
    warndlg('Please select outputs before saving','Warning','modal');
    return
end

data = tabdata(select,2:end);

% get the selected file/path from users
[file,path] = uiputfile('movingcorr_results.csv','Save Output as .csv file');

% write file
if ~isequal(file,0)
    filepath = fullfile(path,file);
    colname = {'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'Side';'Fs';'TestTag';'TestBegin';'TestEnd';'Baseline';'BaseBegin';'BaseEnd';'NumberOfShifts';'Pearson_r';'Pearson_p';'Pearson_delay';'Pearson_slope';'Spearman_r';'Spearman_p';'Spearman_delay';'Spearman_slope'};
    %Check existing file
    if exist(filepath,'file') == 2
        % read .csv file
        fid = fopen(filepath);
        % read header size(c) = 1 x ncol, don't use the header
        textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',1,'delimiter',',');
        % read content
        c = textscan(fid,'%s%s%s%s%s%s%f%s%f%f%s%f%f%f%f%f%f%f%f%f%f%f','delimiter',',');
        fclose(fid);
        
        % set variables
        nrow = length(c{1,1});
        ncol = length(c);
        temp = cell(nrow,ncol);
        for n=1:ncol
            % Fs,Begin and End column
            if ismember(n,[7,9,10,12,13,14,15:18])
                temp(:,n) = num2cell(c{1,n});
                
            else
                temp(:,n) = c{1,n};
            end
%             temp(:,n) = c{1,n};
        end
        temp = cell2table(temp,'VariableNames',colname);

        %Concatenate the file
       % temp = readtable(filepath);
    else
       temp = [];
    end
    
    T = cell2table(data,'VariableNames',colname);
    writetable([temp;T],filepath);
    
    
end

guidata(hObject,handles);


% --- Executes on button press in butRClear.
function butRClear_Callback(hObject, eventdata, handles)
% hObject    handle to butRClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clear variables
handles.y2 = [];
handles.fs2 = [];
handles.filename2 = [];
handles.acrostic2 = [];
handles.subjnum2  = [];
handles.exptdate2 = [];
handles.expttime2 = [];
handles.varname2 = [];
handles.tag1 = [];
handles.tag2 = [];
handles.baserange = [];
handles.testrange = [];

%Clear editRVar2
set(handles.editRVar2,'String',[]);


%Clear popUpTags
set(handles.popRBase,'Value',1,'Enable','off');
set(handles.popRTest,'Value',1,'Enable','off');
set(handles.butRBase,'Enable','off');
set(handles.butRTest,'Enable','off');

%Correlation options
set(handles.radiobutPositive,'Value',1);



%Clear axes
cla(handles.haxes(2)); ylabel(handles.haxes(2),'');
cla(handles.haxes(3));
cla(handles.haxes(4));
set(handles.haxes(3),'Visible','off');
set(handles.haxes(4),'Visible','off');

guidata(hObject,handles);


% --- Executes when selected object is changed in buttongroupOption.
function buttongroupOption_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongroupOption 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject==handles.radiobutNegative,
    handles.roption = 'negative';
elseif hObject == handles.radiobutPositive,
    handles.roption = 'positive';
elseif hObject == handles.radiobutAbsolute,
    handles.roption = 'absolute';
end
guidata(hObject,handles);



function editSearchWindow_Callback(hObject, eventdata, handles)
% hObject    handle to editSearchWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSearchWindow as text
%        str2double(get(hObject,'String')) returns contents of editSearchWindow as a double


% --- Executes during object creation, after setting all properties.
function editSearchWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSearchWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkSearchWindow.
function chkSearchWindow_Callback(hObject, eventdata, handles)
% hObject    handle to chkSearchWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value'),
    set(handles.editSearchWindow,'Enable','on');
else
    set(handles.editSearchWindow,'Enable','off');
end

% Hint: get(hObject,'Value') returns toggle state of chkSearchWindow
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
folder_name = uigetdir([],'Select A Mat Directory');
handles.batch.matpath = folder_name;
if ~ischar(folder_name)
    return
end
set(handles.editMatpath,'String',folder_name);


%Set listBVar
temp = what(folder_name);
handles.batch.matfiles = temp.mat; %Get a cell storing mat filenames
matobj = matfile(fullfile(folder_name,handles.batch.matfiles{1})); %Create matobj to look at a variable property inside one matfile
details = whos(matobj); %Get all properties including size
names = {details.name}; 
sizes = {details.size};
logind = cellfun(@(x) x(1)>10,sizes,'UniformOutput',1); %Logical ind to elements that are time-series
names = names(logind);

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

set(handles.editBFs,'String',num2str(handles.batch.fslist(1)),'Enable','on');


%% Enable chkEnableVarName
set(handles.chkEnableVarName,'Enable','on','Value',0);

%% Clear everybox
handles.batch.xvarlist = [];
handles.batch.yvarlist = [];
handles.batch.xfslist = [];
handles.batch.yfslist = [];

%% Clear listbox for variables
set(handles.listBTestedSignals,'String',[]);
set(handles.listBTestSignals,'String',[]);



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

set(handles.listAllTags,'String',subregions,'Value',1);
handles.batch.alltags = subregions;

%% Clear listboxes in the selected region panel

set(handles.chkEnterRegionName,'Enable','on','Value',0);
set(handles.editTagName,'Enable','off','String',handles.batch.alltags{1});
set(handles.listBBaseline,'String',[]);
set(handles.listBTest,'String',[]);
handles.batch.baseRegions = [];
handles.batch.testRegions = [];


guidata(hObject,handles);

% --------------------------------------------------------------------
function menuMode_Callback(hObject, eventdata, handles)
% hObject    handle to menuMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuNormalMC_Callback(hObject, eventdata, handles)
% hObject    handle to menuNormalMC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Visible','off');
guidata(hObject,handles);

% --------------------------------------------------------------------
function menuBatchMC_Callback(hObject, eventdata, handles)
% hObject    handle to menuBatchMC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Visible','on');
guidata(hObject,handles);



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

% Hints: contents = cellstr(get(hObject,'String')) returns listBVar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBVar
set(handles.chkEnableVarName,'Value',0);
varind = get(handles.listBVar,'Value');
fs = handles.batch.fslist(varind);
varname = handles.batch.varlist{varind};
set(handles.editBFs,'Enable','on','String',num2str(fs));
set(handles.editBSignal,'Enable','off','String',varname);


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


% --- Executes on selection change in listBTestSignals.
function listBTestSignals_Callback(hObject, eventdata, handles)
% hObject    handle to listBTestSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listBTestSignals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBTestSignals


% --- Executes during object creation, after setting all properties.
function listBTestSignals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBTestSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butBAddToTest.
function butBAddToTest_Callback(hObject, eventdata, handles)
% hObject    handle to butBAddToTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listBTestSignals,'String');
fs = str2double(get(handles.editBFs,'String'));

if isnan(fs),
    warndlg('Please enter a numeric value for the sampling frequency');
    return
end

if get(handles.chkEnableVarName,'Value'), %If checkbox is checked, use the one the user entered
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
   set(handles.listBTestSignals,'String',oldlist,'Value',1);
else
    check = cellfun(@(x) strcmpi(x,newvar),oldlist,'UniformOutput',1);
    if any(check),
        %That variable already exists
        warndlg('The variable already exists');
        return
    else
        oldlist = [oldlist;{newvar}];
        newfs = [handles.batch.xfslist;fs];
        set(handles.listBTestSignals,'String',oldlist,'Value',1,'Enable','on');
    end
end
handles.batch.xvarlist = oldlist;
handles.batch.xfslist = newfs;


%% Set Edit Box for arbitrary varname to default
set(handles.editBSignal,'String','Enter Variable Name','Enable','off');
set(handles.chkEnableVarName,'Value',0);

%% Set FS according to the listbox instead
varind = get(handles.listBVar,'Value');
fs = handles.batch.fslist(varind);
set(handles.editBFs,'Enable','on','String',num2str(fs));

guidata(hObject,handles);

% --- Executes on button press in butdeleteBTestSignals.
function butdeleteBTestSignals_Callback(hObject, eventdata, handles)
% hObject    handle to butdeleteBTestSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listBTestSignals,'Value');
oldlist = get(handles.listBTestSignals,'String');
oldlist(ind) = [];
handles.batch.xvarlist(ind) = [];
handles.batch.xfslist(ind) = [];  
if ~isempty(oldlist), 
   set(handles.listBTestSignals,'String',oldlist,'Value',1);
else
   handles.batch.xvarlist = [];
   handles.batch.xfslist = [];
   set(handles.listBTestSignals,'String',[]);
    
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


% --- Executes on button press in chkEnableVarName.
function chkEnableVarName_Callback(hObject, eventdata, handles)
% hObject    handle to chkEnableVarName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkEnableVarName
if get(hObject,'Value'),
   set(handles.editBSignal,'Enable','on','String',[]); 
   set(handles.editBFs,'String',[],'Enable','on'); %Need to enter fs everytime
else     
   varind = get(handles.listBVar,'Value');
   fs = handles.batch.fslist(varind);
   set(handles.editBFs,'Enable','on','String',num2str(fs));
   set(handles.editBSignal,'Enable','off','String',handles.batch.varlist{varind});
end
guidata(hObject,handles);

% --- Executes on selection change in listBTestedSignals.
function listBTestedSignals_Callback(hObject, eventdata, handles)
% hObject    handle to listBTestedSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listBTestedSignals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBTestedSignals


% --- Executes during object creation, after setting all properties.
function listBTestedSignals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBTestedSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butdeleteBTestedSignals.
function butdeleteBTestedSignals_Callback(hObject, eventdata, handles)
% hObject    handle to butdeleteBTestedSignals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listBTestedSignals,'Value');
oldlist = get(handles.listBTestedSignals,'String');
oldlist(ind) = [];
handles.batch.yvarlist(ind) = [];
handles.batch.yfslist(ind) = [];  
if ~isempty(oldlist), 
   set(handles.listBTestedSignals,'String',oldlist,'Value',1);
else
   handles.batch.yvarlist = [];
   handles.batch.yfslist = [];
   set(handles.listBTestedSignals,'String',[],'Value',0);
    
end

guidata(hObject,handles);

% --- Executes on button press in butBAddToTested.
function butBAddToTested_Callback(hObject, eventdata, handles)
% hObject    handle to butBAddToTested (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listBTestedSignals,'String');
fs = str2double(get(handles.editBFs,'String'));

if isnan(fs),
    warndlg('Please enter a numeric value for the sampling frequency');
    return
end

if get(handles.chkEnableVarName,'Value'), %If checkbox is checked, use the one the user entered
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
   set(handles.listBTestedSignals,'String',oldlist,'Value',1);
else
    check = cellfun(@(x) strcmpi(x,newvar),oldlist,'UniformOutput',1);
    if any(check),
        %That variable already exists
        warndlg('The variable already exists');
        return
    else
        oldlist = [oldlist;{newvar}];
        newfs = [handles.batch.yfslist;fs];
        set(handles.listBTestedSignals,'String',oldlist,'Value',1,'Enable','on');
    end
end
handles.batch.yvarlist = oldlist;
handles.batch.yfslist = newfs;


%% Set Edit Box for arbitrary varname to default
set(handles.editBSignal,'String','Enter Variable Name','Enable','off');
set(handles.chkEnableVarName,'Value',0);

%% Set FS according to the listbox instead
varind = get(handles.listBVar,'Value');
fs = handles.batch.fslist(varind);
set(handles.editBFs,'Enable','on','String',num2str(fs));

guidata(hObject,handles);


% --- Executes on selection change in listBBaseline.
function listBBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to listBBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listBBaseline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBBaseline


% --- Executes during object creation, after setting all properties.
function listBBaseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBBaseline (see GCBO)
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
set(handles.chkEnterRegionName,'Value',0);
varind = get(handles.listAllTags,'Value');
tagname = handles.batch.alltags{varind};
set(handles.editTagName,'Enable','off','String',tagname);
guidata(hObject,handles);
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


% --- Executes on button press in butBBaseline.
function butBBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to butBBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listBBaseline,'String');

if get(handles.chkEnterRegionName,'Value'),
    newtag = get(handles.editTagName,'String');
else %Get from listbox
    alltags = get(handles.listAllTags,'String');
    ind = get(handles.listAllTags,'Value');
    ind = ind(1);
    newtag = alltags{ind};
end
if isempty(oldlist),
      oldlist = [oldlist;{newtag}];  
      set(handles.listBBaseline,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmpi(x,newtag),oldlist,'UniformOutput',1);
    if any(check),
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newtag}];
        set(handles.listBBaseline,'String',oldlist,'Value',1,'Enable','on');
    end
end

set(handles.chkEnterRegionName,'Value',0);
ind = get(handles.listAllTags,'Value');

set(handles.editTagName,'Enable','off','String',handles.batch.alltags{ind});
handles.batch.baseRegions = oldlist;
guidata(hObject,handles);

% --- Executes on button press in butdeleteBBaselineRegions.
function butdeleteBBaselineRegions_Callback(hObject, eventdata, handles)
% hObject    handle to butdeleteBBaselineRegions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listBBaseline,'Value');
oldlist = get(handles.listBBaseline,'String');
oldlist(ind) = [];
handles.batch.baseRegions(ind) = [];
if ~isempty(oldlist), 
   set(handles.listBBaseline,'String',oldlist,'Value',1);
else
   handles.batch.baseRegions = [];
   set(handles.listBBaseline,'String',[],'Value',0);    
end

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


% --- Executes on button press in butBTest.
function butBTest_Callback(hObject, eventdata, handles)
% hObject    handle to butBTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listBTest,'String');
if get(handles.chkEnterRegionName,'Value'),
    newtag = get(handles.editTagName,'String');
else %Get from listbox
    alltags = get(handles.listAllTags,'String');
    ind = get(handles.listAllTags,'Value');
    ind = ind(1);
    newtag = alltags{ind};
end
if isempty(oldlist),
      oldlist = [oldlist;{newtag}];  
      set(handles.listBTest,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmpi(x,newtag),oldlist,'UniformOutput',1);
    if any(check),
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newtag}];
        set(handles.listBTest,'String',oldlist,'Value',1,'Enable','on');
    end
end

set(handles.chkEnterRegionName,'Value',0);
ind = get(handles.listAllTags,'Value');

set(handles.editTagName,'Enable','off','String',handles.batch.alltags{ind});
handles.batch.testRegions = oldlist;
guidata(hObject,handles);

% --- Executes on selection change in listBTest.
function listBTest_Callback(hObject, eventdata, handles)
% hObject    handle to listBTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listBTest contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBTest


% --- Executes during object creation, after setting all properties.
function listBTest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butdeleteBTestRegions.
function butdeleteBTestRegions_Callback(hObject, eventdata, handles)
% hObject    handle to butdeleteBTestRegions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listBTest,'Value');
oldlist = get(handles.listBTest,'String');
oldlist(ind) = [];
handles.batch.testRegions(ind) = [];
if ~isempty(oldlist), 
   set(handles.listBTest,'String',oldlist,'Value',1);
else
   handles.batch.testRegions = [];
   set(handles.listBTest,'String',[],'Value',0);    
end

guidata(hObject,handles);

% --- Executes on button press in chkEnterRegionName.
function chkEnterRegionName_Callback(hObject, eventdata, handles)
% hObject    handle to chkEnterRegionName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkEnterRegionName
if get(hObject,'Value'),
   set(handles.editTagName,'Enable','on','String',[]); 
else   
   varind = get(handles.listAllTags,'Value');
   set(handles.editTagName,'Enable','off','String',handles.batch.alltags{varind});
end
guidata(hObject,handles);

% --- Executes on button press in butBCompute.
function butBCompute_Callback(hObject, eventdata, handles)
% hObject    handle to butBCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matpath = handles.batch.matpath;
tagpath = handles.batch.tagpath;
xvarlist = handles.batch.xvarlist;
yvarlist = handles.batch.yvarlist;
xfslist = handles.batch.xfslist;
yfslist = handles.batch.yfslist;
baseRegions = handles.batch.baseRegions;
testRegions = handles.batch.testRegions;
ndelay = 50; %25 seconds
if get(handles.radiobutBPositive,'Value')
    opt = 'positive';
elseif get(handles.radiobutBNegative,'Value')
    opt = 'negative';
elseif get(handles.radiobutBAbsolute,'Value')
    opt = 'absolute';
end
pos = get(handles.figMovingCorrelation,'Position');

if isempty(matpath),
    warndlg('The matfile directory is not selected');
    return
end

if isempty(tagpath),
    warndlg('The tagfile directory is not selected');
    return
end

if isempty(xvarlist) || isempty(xfslist),
    warndlg('The test variables are not selected');
    return
end

if isempty(yvarlist) || isempty(yfslist),
    warndlg('The tested variables are not selected');
    return
end

if isempty(baseRegions),
    warndlg('The baseline regions are not selected');
    return
end

if isempty(testRegions),
    warndlg('The test regions are not selected');
    return
end


[rounds,allresults,varlist,taglist,missing_csvfiles,missing_signal_matfiles,missing_tags] = batchMovingCorrelation(matpath,tagpath,xvarlist,yvarlist,xfslist,yfslist,baseRegions,testRegions,ndelay,opt);
%% Display results
strresult = {['Correlation Option=', opt,',******Results******'],['Total Matfiles=',num2str(rounds)]};

%% Missing csv files
if ~isempty(missing_csvfiles),
    strresult = [strresult,{'----Missing .csv----'},missing_csvfiles];
end

%% Missing Variables
for nvar = 1:length(varlist),
   temp = missing_signal_matfiles{nvar};
   if ~isempty(temp)
       strresult = [strresult,{['----Missing ',varlist{nvar},'----']},temp];
   end
   
end


%% Missing Tags
%Missing other signals
for nvar = 1:length(taglist),
   temp = missing_tags{nvar};
   if ~isempty(temp)
       strresult = [strresult,{['----Missing ',taglist{nvar},' tag----']},temp];
   end
   
end


strresult = char(strresult); %Change to vertical dim
set(handles.editBResultDisplay,'String',strresult,'Enable','inactive');
handles.batch.allresults = allresults;
guidata(hObject,handles);


% --- Executes on button press in butBClear.
function butBClear_Callback(hObject, eventdata, handles)
% hObject    handle to butBClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Backend
handles.batch.allresults = [];
handles.batch.matpath = [];
handles.batch.tagpath = [];
handles.batch.xvarlist = [];
handles.batch.yvarlist = [];
handles.batch.xfslist = [];
handles.batch.yfslist = [];
handles.batch.baseRegions = [];
handles.batch.testRegions = [];
handles.batch.ndelay = [];
handles.batch.varlist = [];
handles.batch.fslist = [];

%% Interface
set(handles.editMatpath,'String',[]);
set(handles.editTagpath,'String',[]);
set(handles.listBTestedSignals,'String',[]);
set(handles.listBTestSignals,'String',[]);
set(handles.chkEnterRegionName,'Enable','on','Value',0);
set(handles.editTagName,'Enable','off','String',handles.batch.alltags{1});
set(handles.listBBaseline,'String',[]);
set(handles.listBTest,'String',[]);
set(handles.editBResultDisplay,'String',[],'Enable','inactive');
set(handles.listBVar,'String',[],'Value',0);
set(handles.listAllTags,'String',[]);
set(handles.editTagName,'Enable','off','String',[]);
set(handles.editBFs,'Enable','on','String',[]);
set(handles.editBSignal,'Enable','off','String',[]);


guidata(hObject,handles);

% --- Executes when selected object is changed in buttongroupBatch.
function buttongroupBatch_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongroupBatch 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if hObject==handles.radiobutBNegative,
    handles.batch.roption = 'negative';
elseif hObject == handles.radiobutBPositive,
    handles.batch.roption = 'positive';
elseif hObject == handles.radiobutBAbsolute,
    handles.batch.roption = 'absolute';
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


% --- Executes on button press in butBSaveOutput.
function butBSaveOutput_Callback(hObject, eventdata, handles)
% hObject    handle to butBSaveOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles.batch,'allresults') || isempty(handles.batch.allresults),
    return;
else
   data = handles.batch.allresults;
   colname = {'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'Side';'Fs';'TestTag';'TestBegin';'TestEnd';'Baseline';'BaseBegin';'BaseEnd';'NumberOfShifts';'Pearson_r';'Pearson_p';'Pearson_delay';'Pearson_slope';'Spearman_r';'Spearman_p';'Spearman_delay';'Spearman_slope'};
    % get the selected file/path from users
    [file,path] = uiputfile('movingcorr_results.csv','Save Output');
    if ~isnumeric(file),
        filepath = fullfile(path,file);
        T = cell2table(data,'VariableNames',colname);
        writetable(T,filepath);
    end

    
end
guidata(hObject,handles);
