function varargout = main_DataBrowser(varargin)
% MAIN_DATABROWSER MATLAB code for main_DataBrowser.fig
%      MAIN_DATABROWSER, by itself, creates a new MAIN_DATABROWSER or raises the existing
%      singleton*.
%
%      H = MAIN_DATABROWSER returns the handle to a new MAIN_DATABROWSER or the handle to
%      the existing singleton*.
%
%      MAIN_DATABROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_DATABROWSER.M with the given input arguments.
%
%      MAIN_DATABROWSER('Property','Value',...) creates a new MAIN_DATABROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_DataBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_DataBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_DataBrowser

% Last Modified by GUIDE v2.5 10-Oct-2021 16:44:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_DataBrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @main_DataBrowser_OutputFcn, ...
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


% --- Executes just before main_DataBrowser is made visible.
function main_DataBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_DataBrowser (see VARARGIN)

% Choose default command line output for main_DataBrowser
handles.output = hObject;

%Identify codepath & load CData for icons
if ~isdeployed %If this is not a standalone application
    p = mfilename('fullpath'); %Get the current directory
    [handles.codepath,~,~] = fileparts(p);
    addpath(genpath(handles.codepath));
    
    %Add java class, let's remove filter library to see
else   
    pathtofexsetting = which('fexsetting.mat');
    [p,~,~] = fileparts(pathtofexsetting); %Search relative path to ctfroot
    [p,~,~] = fileparts(p);
    handles.codepath = p;
    %Add Default PlotTemplate Path
end




%Functions
handles.addResults = @addResults;
handles.getColId = @getColId; %get column id from tag table.
handles.getSelectedTags = @getSelectedTags;
handles.getAxesnum = @getAxesnum;
handles.drawShade = @drawShade;
handles.updateEditorTags = @updateEditorTags;
handles.getFilteredTags = @getFilteredTags;
handles.isEditInfoValid = @isEditInfoValid;
handles.setValueAtEditor = @setValueAtEditor;
handles.getDefineRegionTags = @getDefineRegionTags;
handles.filterEditor = [];
handles.setValflag = false;
handles.jtableEditor = [];



%Initialize submodules
handles.TagManager = sub_TagManager('DataBrowser',hObject);
handles.subMovingCorrelation = [];
handles.subStationaryPSD = [];
handles.subTVPSD = [];
handles.subFEX = [];



%Initialize GUI
initializeGUI(hObject,handles);
handles = guidata(hObject);

%Initialize shared data
setappdata(0,'hfigmain',handles.figMain);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_DataBrowser wait for user response (see UIRESUME)
% uiwait(handles.figMain);


% --- Outputs from this function are returned to the command line.
function varargout = main_DataBrowser_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --------------------------------------------------------------------
function loadMAT_callback(hObject, ~, handles) %#ok<DEFNU>

%-- Ask user to select data file--
[inputfile,inputpath] = uigetfile('*.mat','Select a MAT-file');
if ~ischar(inputfile)
    return %return if choosing invalid file
end

%-- Assign values/states to handles ---
handles.DB.inputpath = inputpath;
handles.DB.inputfile = inputfile;
handles.DB.inputexptdate = '-'; %Extract experimental date from filename

%-- Update UI objects --
%Display a list of matfiles on handles.listMatfiles
filelist = what(inputpath);
temp = strfind(filelist.mat,inputfile);
ind  = find(~cellfun(@isempty,temp));
set(handles.listMatfiles,'String',filelist.mat,'Value',ind,'Enable','on');

%Display a list of variables in the matfile on handles.listMatvars
allvars = who('-file',fullfile(inputpath,inputfile));
set(handles.listMatvars,'String',allvars,'Value',1,'Enable','on');

%Enable butAllmatvars & chkPlotmatvars
set(handles.butAllmatvars,'Enable','on');
set(handles.chkPlotmatvars,'Value',1,'Enable','on');

%Display event markers on handles.tableEvents
temp = strfind(allvars,'event'); %search for 'event' structure
if any(~cellfun(@isempty,temp)) %#ok<STRCLFH>
    try
        load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'event');
        if ~isempty(event)
            if isempty(event.level_1)
                event.level_1 = cell(length(event.sec),1);
            end
            if isempty(event.level_2)
                event.level_2 = cell(length(event.sec),1);
            end
            handles.DB.events = [event.sec,event.freeTxt,event.level_1,event.level_2];
            markerdata = cell(length(handles.DB.events(:,1)),1);
            markerdata(:,1) = {'off'};
            checkbox = num2cell(true(length(handles.DB.events(:,1)),1));
            %Set new event
            set(handles.tableEvents,'Data',[checkbox,markerdata,handles.DB.events],'Enable','on');
            
            guidata(hObject,handles);
            handles = guidata(hObject);
        else
            set(handles.tableEvents,'Data',{},'Enable','off');
            guidata(hObject,handles);
            handles = guidata(hObject);
            
        end
    catch
        warning(['Loading....' newline 'No event in ',inputfile]);
    end

else
    set(handles.tableEvents,'Data',{},'Enable','off');
    guidata(hObject,handles);
    handles = guidata(hObject);
end

%Display study notes on handles.editStudyNote
if any(strcmp(allvars,'studynote')) %studynote exists in the file
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'studynote');
    try
        ind=find(ismember(studynote,'EVENT LOGGING NOTE'));
        if ~isempty(ind)
            studynote = studynote(1:ind-1);
        end
    catch
       studynote = ''; 
    end

else
    studynote = '';
end
set(handles.editStudyNote,'String',studynote,'HorizontalAlignment','left','Enable','inactive');

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --------------------------------------------------------------------
function toolSelectRegion_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolSelectRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

s = get(handles.toolSelectRegion,'State');

if strcmp(s,'on') %select the tool
    
    %Disable other tools
    set(handles.toolLoadData,'Enable','off');
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');

    
    %Select and highlight the selected axes
    set(gcf,'pointer','cross');
    w = waitforbuttonpress;
    
    ax = gca;
    c = get(ax,'Color');
    set(ax,'Color',[1 0.93 0.93]);
    

    %Define area to be shaded
    
    rect = getrect(ax); %rect = [xmin ymin width height] (unit = unit of x-axis)
    
    %Restore axes color
    set(ax,'Color',c);
    set(gcf,'pointer','arrow');
    
    %Remove instruction
    set(handles.editStatus1,...
        'String','',...
        'BackgroundColor','white','ForegroundColor','black','FontAngle','normal',...
        'Enable','off');
    
    %Check if width = 0. If so, enable other tools & return.
    if rect(3)==0
        
        %Enable tools
        set(handles.toolSelectRegion,'State','off');
        set(handles.toolLoadData,'Enable','on');
        set(handles.toolZoomin,'Enable','on');
        set(handles.toolZoomout,'Enable','on');
        set(handles.toolPan,'Enable','on');
        set(handles.toolDataCursor,'Enable','on');
        set(handles.toolEditPlot,'Enable','on');
        
        return
    end
    
    %Check if selected region is valid
    xmin = rect(1);
        if xmin<0
            xmin = 0;
        end
    xmax = rect(1) + rect(3);
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
    yrange = ylimit(2)-ylimit(1);
    ymin = min(ylimit) + 0.02*yrange;
    ymax = max(ylimit) - 0.02*yrange;
    axes(ax); hold on;
    hshade = fill([xmin xmin xmax xmax],[ymin ymax ymax ymin],[1 1 0.8],'EdgeColor',[1 1 0.8]);
    uistack(hshade,'bottom');


    %Get filename and variable in the selected plot
    try
        axesnum = find(handles.DB.haxes==ax); %selected subplot
        plotvarind = handles.DB.varindex(handles.DB.axesnum == axesnum); %index of plotted variable
        selfile     = handles.DB.filename(plotvarind);
        selexptdate = handles.DB.exptdate(plotvarind);
        selexpttime = handles.DB.expttime(plotvarind);
        selacrostic = handles.DB.acrostic(plotvarind);
        selsubjnum  = handles.DB.subjnum(plotvarind);
        selvar      = handles.DB.varname(plotvarind);
        selfs       = handles.DB.fs(plotvarind);

        %Extract side if selected variable has side info
        rr = strfind(selvar,'right');
        if ~isempty(rr{1})
            side = 'right';
        else
            ll = strfind(selvar,'left');
            if ~isempty(ll{1})
                side = 'left';
            else
                side = '-';
            end
        end
    catch
        warndlg('Error occurs while loading, please reset the GUI and re-open');
        return
    end
    
    %New tags
    nvar = size(selvar,1);
    ncol = 15;
    newtags = cell(nvar,ncol);
    
    %Input will be the cell array
    prompt = {'Enter Tag Name'};
    def = {'TAG'};
    dlg_title = '';
    num_lines = 1;
    tag = newid(prompt,dlg_title,num_lines,def);

    if isempty(tag)
        delete(hshade);
        set(handles.toolSelectRegion,'State','off');
        set(handles.toolLoadData,'Enable','on');
        set(handles.toolZoomin,'Enable','on');
        set(handles.toolZoomout,'Enable','on');
        set(handles.toolPan,'Enable','on');
        set(handles.toolDataCursor,'Enable','on');
        set(handles.toolEditPlot,'Enable','on');
        
        set(handles.butDeletetag,'Enable','on');
        
        %Set context menus
        setContextMenus(hObject,handles);
        handles = guidata(hObject);
        
        %make hmask current axes
        axes(handles.hmask);
        return
    end

    if strcmp(get(handles.tableEditor,'Enable'),'on')
        activeTM = handles;
    else
        handlesTM = guidata(handles.TagManager);
        activeTM = handlesTM;
    end
    % check repeat tag name
    selfilename = {};
    for n=1:nvar
            [pathstr,name,ext] = fileparts(selfile{n});
            selfilename = [selfilename;[name,ext]];
    end
    % get define tag regions for this filename
    dftags = activeTM.getDefineRegionTags(handles,'DefineRegion');
    if ~isempty(dftags)
        tagcol = getColId('tag','file');
        % get logical row indices of this tagname
        tagid = strcmpi(tag{1,1},dftags(:,tagcol));
        if sum(tagid) % check if the tagname exists 
            listfilename = dftags(tagid,1);
            isrepeat = intersect(selfilename,listfilename);
            if ~isempty(isrepeat) % tagname exists in this file already
                warndlg('This tagname already exists');
                set(handles.toolSelectRegion,'State','off');
                set(handles.toolLoadData,'Enable','on');
                set(handles.toolZoomin,'Enable','on');
                set(handles.toolZoomout,'Enable','on');
                set(handles.toolPan,'Enable','on');
                set(handles.toolDataCursor,'Enable','on');
                set(handles.toolEditPlot,'Enable','on');
                
                set(handles.butDeletetag,'Enable','on');
                
                %Set context menus
                setContextMenus(hObject,handles);
                handles = guidata(hObject);
                
                %make hmask current axes
                axes(handles.hmask);
                turnoffLinehighlight(hObject,handles);
                return
            end
        end
    end
    for n=1:nvar
        newtags{n,1}  = selfilename{n};         %Filename
        newtags{n,2}  = 'DataBrowser';          %Module
        newtags{n,3}  = selacrostic{n};         %Acrostic
        newtags{n,4}  = selsubjnum{n};          %SubjID
        newtags{n,5}  = selexptdate{n};         %ExptDate
        newtags{n,6}  = selexpttime{n};         %ExptTime
        newtags{n,7}  = selvar{n};              %Variable
        newtags{n,8}  = side;                   %Side
        newtags{n,9}  = selfs(n);               %Sampling frequency
        newtags{n,10} = xmin;                   %Begin
        newtags{n,11} = xmax;                   %End
        newtags{n,12} = tag{1,1};               %Tag
        newtags{n,13} = 'DefineRegion';         %Operation
        newtags{n,14} = '-';                    %Operation Tag
        newtags{n,15} = [];                     %Value
    end
    
    
    activeTM.updateEditorTags(handles,newtags);
    handles = guidata(hObject); % in case DB is active, retrieve its value for the next save (guidata)

    %% Update tags in children GUIs
%     if ~isempty(handles.subMovingCorrelation)
%         close(handles.subMovingCorrelation);
%     end
    if ~isempty(handles.subStationaryPSD) %% StationaryPSD is openned, update new tags automatically
        subStationaryPSD_handles = guidata(handles.subStationaryPSD);
        %First check if it's a batch processing
        isbatchon = get(subStationaryPSD_handles.panelBatch,'Visible');
        
        if ~strcmpi(isbatchon,'on') %If it's normal mode, update
            butUpdateTag_Callback = get(subStationaryPSD_handles.butUpdateTag,'Callback');
            butUpdateTag_Callback(subStationaryPSD_handles.butUpdateTag,subStationaryPSD_handles);
        end


    end

        
    %Enable tools
    set(handles.toolSelectRegion,'State','off');
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');
    set(handles.butDeletetag,'Enable','on');

    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
    
    %make hmask current axes
    axes(handles.hmask);

else %deselect the tool
    
    %Enable tools
    set(handles.toolSelectRegion,'State','off');
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');

end

guidata(hObject, handles); %update handles structure

% --------------------------------------------------------------------
function toolEditPlot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolEditPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.toolEditPlot,'State'),'on')
   set(handles.toolZoomin,'State','off');
    set(handles.toolZoomout,'State','off');
    set(handles.toolPan,'State','off');
    
    
    set(gcf,'pointer','arrow');
    
    if isfield(handles,'toolzoom') && isvalid(handles.toolzoom)
        handles.toolzoom.Enable = 'off';
    end
    %Disable pan tool
    pan off

end


guidata(hObject, handles); %update handles structure



% --- Executes on selection change in popWindow.
function popWindow_Callback(hObject, eventdata, handles)
% hObject    handle to popWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popWindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popWindow

%Adjust x-limit according to a selected window size

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

maxtime = max((cellfun(@length,handles.DB.signal(handles.DB.varindex)) - 1)./handles.DB.fs(handles.DB.varindex)); %maximum time of all plotted signals (sec)
set(handles.xslider,'Enable','off','Min',0,'Max',maxtime);
oldstepsize = get(handles.xslider,'SliderStep');

%Determine step size (handles.DB.sliderstep) [sec] of the xslider
ind = get(handles.popWindow,'Value');
switch ind
    case 1 %whole segment
        handles.DB.window = maxtime;
        handles.DB.sliderstep = 0;
    case 2 %0.5 sec window
        handles.DB.window = 0.5;
        handles.DB.sliderstep = 0.1;
    case 3 %5 sec window
        handles.DB.window = 5;  
        handles.DB.sliderstep = 0.5; 
    case 4 %10 sec window
        handles.DB.window = 10;
        handles.DB.sliderstep = 1;
    case 5 %20 sec window
        handles.DB.window = 20;
        handles.DB.sliderstep = 3;
    case 6 %30 sec window
        handles.DB.window = 30;
        handles.DB.sliderstep = 5;
    case 7 %1 min window
        handles.DB.window = 60;
        handles.DB.sliderstep = 20;
    case 8 %5 min window
        handles.DB.window = 5*60;
        handles.DB.sliderstep = 60;
    case 9 %7 min window
        handles.DB.window = 7*60;
        handles.DB.sliderstep = 60;
    case 10 %10 min window
        handles.DB.window = 10*60;
        handles.DB.sliderstep = 2*60;
    case 11 %20 min window
        handles.DB.window = 20*60;
        handles.DB.sliderstep = 5*60;
    case 12 %30 min window
        handles.DB.window = 30*60;
        handles.DB.sliderstep = 5*60;
    case 13 %45 min window
        handles.DB.window = 40*60;
        handles.DB.sliderstep = 1*60;
    
end

%% 2016-06-24 New version zoom-in using Pop-up window
%Plot signals
xmin = get(handles.xslider,'Value');
xmax = xmin+handles.DB.window;

if xmax>maxtime % When viewing window is longer than the rest of the signal
    xmax = maxtime;
    xmin = xmax-handles.DB.window;
    set(handles.xslider,'Value',xmin);
end
if xmin<0
    xmin = 0;
    %change slidervalue everytime xmin changes,
    set(handles.xslider,'Value',xmin);
end

%Enable xslider
if (xmax-xmin) < maxtime
    sliderrange = maxtime-handles.DB.window;
    %Step from the slider through is 10% larger than that of the arrow
    set(handles.xslider,'SliderStep',[handles.DB.sliderstep/sliderrange 10*handles.DB.sliderstep/sliderrange]);
    set(handles.xslider,'Enable','on','Min',0,'Max',sliderrange);
else % View full signal
    set(handles.xslider,'Enable','off','Value',0);
    handles.DB.window = maxtime;
    handles.DB.sliderstep = 0;
    set(handles.popWindow,'Value',1);
end


%% Adjust x-limit and y-limt for all subplots
handles.DB.xlimit = [xmin, xmax];
adjustXYlimit(handles);

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function popWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function xslider_Callback(hObject, eventdata, handles)
% hObject    handle to xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

% sliderval = get(handles.xslider,'Value');
xmin = get(hObject,'Value');
xmax = xmin+handles.DB.window;

%Adjust x-limit and y-limt for all subplots
handles.DB.xlimit = [xmin, xmax];
naxes = length(handles.DB.haxes);


for n=1:naxes
    set(handles.DB.haxes(n),'Xlim',handles.DB.xlimit);

    %Set y-limit
    z = find(handles.DB.axesnum==n);
    s = handles.DB.signal(handles.DB.varindex(z)); %signals in current axes
    fs = handles.DB.fs(handles.DB.varindex(z)); %sampling frequencies of signals in current axes
    
    if size(handles.DB.ylimit,1)>=n
        if handles.DB.ylimit(n,1)==0 && handles.DB.ylimit(n,2)==0
            %auto-adjust ylimit of the current axes
            ymin = [];
            ymax = [];
            for k=1:size(s,1)
                indxmin = floor(handles.DB.xlimit(1)*fs(k)); %min x-limit [no. of samples]
                indxmax = ceil(handles.DB.xlimit(2)*fs(k));  %max x-limit [no. of samples]
                if indxmin<1
                    indxmin = 1;
                end
                if indxmax>length(s{k})
                    indxmax = length(s{k});
                end

                %Apply any signal operations to the current signal
                y = signalOperations(handles,handles.DB.varindex(z(k)));
                
                %Replace any NaN with 0
                nanind = isnan(y);
                y(nanind) = 0;

                ymin = min([ymin, min(y(indxmin:indxmax))]);
                ymax = max([ymax, max(y(indxmin:indxmax))]);
            end
            
            if ~isempty(ymin) && ~isempty(ymax)
                yrange = ymax - ymin;
                ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];
                if diff(ylimit)==0 %y is a constant
                    ylimit(1) = ylimit(1) - 1;
                    ylimit(2) = ylimit(2) + 1;
                end
            else
                ylimit(1) = -1;
                ylimit(2) =  1;
            end
 
        else
            %ylimit was manually set
            ylimit = handles.DB.ylimit(n,:); 
        end        
    else
        %auto-adjust ylimit of the current axes
        ymin = [];
        ymax = [];
        for k=1:size(s,1)
            indxmin = floor(handles.DB.xlimit(1)*fs(k)); %min x-limit [no. of samples]
            indxmax = ceil(handles.DB.xlimit(2)*fs(k));  %max x-limit [no. of samples]
            if indxmin<1
                indxmin = 1;
            end
            if indxmax>length(s{k})
                indxmax = length(s{k});
            end

            %Apply any signal operations to the current signal
            y = signalOperations(handles,handles.DB.varindex(z(k)));
            
            %Replace any NaN with 0
            nanind = isnan(y);
            y(nanind) = 0;

            ymin = min([ymin, min(y(indxmin:indxmax))]);
            ymax = max([ymax, max(y(indxmin:indxmax))]);
        end
        
        if ~isempty(ymin) && ~isempty(ymax)
            yrange = ymax - ymin;
            ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];
            if diff(ylimit)==0 %y is a constant
                ylimit(1) = ylimit(1) - 1;
                ylimit(2) = ylimit(2) + 1;
            end
        else
            ylimit(1) = -1;
            ylimit(2) =  1;
        end
        handles.DB.ylimit(n,:) = [0,0]; %[0,0] designates auto-adjust mode of ylimit
        
    end

    set(handles.DB.haxes(n),'Ylim',ylimit);
    
    
end

set(handles.hmask,'Xlim',handles.DB.xlimit);



%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function xslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listMatfiles.
function listMatfiles_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to the listbox showing the list of files
% triggered by double-click on the listbox

% Hints: contents = cellstr(get(hObject,'String')) returns listMatfiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listMatfiles

filelist = cellstr(get(handles.listMatfiles,'String'));
inputfile = filelist{get(handles.listMatfiles,'Value')};

if ~exist(fullfile(handles.DB.inputpath,inputfile),'file')
    warning(['Cannot open ',inputfile]);
    return
end

%Set to take action if double-click
if ~strcmp(get(handles.figMain,'SelectionType'),'open')
    return
end

%Update inputfile (Note: inputpath remains the same)
handles.DB.inputfile = inputfile;

%Extract experimental date from filename
ii = strfind(inputfile,'201'); %search for year
exptdate = inputfile(ii:ii+7);
chk = ismember(exptdate,'0123456789');
if isempty(ii) || ~all(chk) %extraction of exptdate is incorrect
    prompt = ['File = ',inputfile(1:end-4),', enter Experimental Date (YYYYMMDD) e.g. 20140315'];
    dlgtitle = 'Enter Experimental Date';
    numlines = 1;
    answer = inputdlg(prompt,dlgtitle,numlines,{''});
    
    if isempty(answer) || isempty(answer{1})
        exptdate = '-';
    else
        exptdate = answer{1};
    end
    temp_exptdate = num2str(exptdate);
    handles.DB.inputexptdate = [temp_exptdate(1:4),'-',temp_exptdate(5:6),'-',temp_exptdate(7:8)];
    
else %extraction of exptdate is correct
    temp_exptdate = num2str(exptdate);
    handles.DB.inputexptdate = [temp_exptdate(1:4),'-',temp_exptdate(5:6),'-',temp_exptdate(7:8)];
end

%Get a list of variables in the selected file without loading and display in the listbox
allvars = who('-file',fullfile(handles.DB.inputpath,handles.DB.inputfile));
set(handles.listMatvars,'String',allvars,'Value',1);

%Save inputfile first
guidata(hObject,handles);

%Display event markers in the table if there's any
temp = cellfun(@(x) strcmpi(x,'event'),allvars,'UniformOutput',1); %search for 'event' structure
if any(temp)
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'event');
    
    %Fix error
    if isempty(event.level_1)
        event.level_1 = cell(length(event.sec),1);
    end
    if isempty(event.level_2)
        event.level_2 = cell(length(event.sec),1);
    end
    handles.DB.events = [event.sec,event.freeTxt,event.level_1,event.level_2];
   
    %set Event and set marker
    markerdata = cell(length(handles.DB.events(:,1)),1);
    markerdata(:,1) = {'off'};
    checkbox = num2cell(true(length(handles.DB.events(:,1)),1));    
    

    
    %Set new event
    set(handles.tableEvents,'Data',[checkbox,markerdata,handles.DB.events],'Enable','on');
   
else
    set(handles.tableEvents,'Data',{},'Enable','off');

end

%Delete markers if any
markerobj = get(handles.hmask,'Children');
for nmarker=1:length(markerobj)
    if ~isempty(get(markerobj(nmarker),'Tag'))
        delete(markerobj(nmarker)); %Delete line
    end
end

%Study Note
try
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'studynote');
    ind=find(ismember(studynote,'EVENT LOGGING NOTE'));
    if ~isempty(ind)
        studynote = studynote(1:ind-1);
    end
    set(handles.editStudyNote,'String',studynote,'HorizontalAlignment','left','Enable','inactive');
catch
    warning(['Load matfile...' newline 'Study note was not found in ',handles.DB.inputfile]);
end
%Apply the last template to this data
%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function listMatfiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listMatfiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listMatvars.
function listMatvars_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to listMatvars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listMatvars contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listMatvars
%Turn off any line selection highlight
%profile on;
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Set to take action if double-click
if ~strcmp(get(handles.figMain,'SelectionType'),'open')
    return
end


%Get the selected variable
varlist = cellstr(get(handles.listMatvars,'String'));
selvar = varlist{get(handles.listMatvars,'Value')};

%Collect selected variable info
if isfield(handles.DB,'varname') && all(~cellfun('isempty',handles.DB.varname)) %>=1 variables are in Workspace

    handles.DB.filename = [handles.DB.filename; fullfile(handles.DB.inputpath,handles.DB.inputfile)];
    handles.DB.exptdate = [handles.DB.exptdate; handles.DB.inputexptdate];
    handles.DB.expttime = [handles.DB.expttime; '-'];
    handles.DB.varnameorig = [handles.DB.varnameorig; selvar];
    
    %Check for repeated variable name
    newvarname = checkRepeatedVarname(selvar,handles.DB.varname);
    handles.DB.varname = [handles.DB.varname; newvarname];    
    
    %Load selected variable
    matObj = matfile(fullfile(handles.DB.inputpath,handles.DB.inputfile));
    eval(['y = matObj.',selvar,';']);
    
    %Get Acrostic and Subject ID
    handles.DB.acrostic = [handles.DB.acrostic; handles.DB.inputfile(1:5)];

    handles.DB.subjnum = [handles.DB.subjnum; '-'];


    if isvector(y) && isnumeric(y) && ~isscalar(y)
        
        %Collect current signal
        handles.DB.signal = [handles.DB.signal; y];
        
        %Compute mean and standard deviation
        handles.DB.meanstd = [handles.DB.meanstd; [mean(y),std(y)]];
        
        %Get sampling frequency
        fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,selvar);

        handles.DB.fs = [handles.DB.fs; fs];
        handles.DB.flagnorm    = [handles.DB.flagnorm; -1];
        handles.DB.flagdetrend = [handles.DB.flagdetrend; -1];
        handles.DB.detrend     = [handles.DB.detrend; 1];
        handles.DB.scale       = [handles.DB.scale; 1];

        handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
        

        
    else %loaded variable is not numeric
        handles.DB.signal      = [handles.DB.signal; {y}];
        handles.DB.meanstd     = [handles.DB.meanstd; [0,0]];
        handles.DB.fs          = [handles.DB.fs; 0];
        handles.DB.flagnorm    = [handles.DB.flagnorm; 0];
        handles.DB.flagdetrend = [handles.DB.flagdetrend; 0];
        handles.DB.detrend     = [handles.DB.detrend; 0];
        handles.DB.scale       = [handles.DB.scale; 0];
 
        handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
    end
    
else %first variable to be added to the Workspace
    
    handles.DB.varnameorig = {selvar};
    handles.DB.varname  = {selvar};
    handles.DB.filename = {fullfile(handles.DB.inputpath,handles.DB.inputfile)};
    handles.DB.exptdate = {handles.DB.inputexptdate};
    handles.DB.expttime = {'-'};
    
    %Load selected variable
    
    matObj = matfile(fullfile(handles.DB.inputpath,handles.DB.inputfile));
    eval(['y = matObj.',selvar,';']);
    handles.DB.signal = {y};
    
    %Get Acrostic and Subject ID
    handles.DB.acrostic = {handles.DB.inputfile(1:5)};
    handles.DB.subjnum = {'-'};
   
    
    if isvector(y) && isnumeric(y) && ~isscalar(y)
        handles.DB.meanstd = {[mean(y),std(y)]};
        handles.DB.fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,selvar);
        handles.DB.flagnorm    = -1;
        handles.DB.flagdetrend = -1;
        handles.DB.detrend     =  1;
        handles.DB.scale       =  1;
        handles.DB.flagtivpsd  =  0;
        

        
    else %loaded variable is not numeric
        handles.DB.meanstd = {[0,0]};
        handles.DB.fs = 0;
        handles.DB.flagnorm    = 0;
        handles.DB.flagdetrend = 0;
        handles.DB.detrend     = 0;
        handles.DB.scale       = 0;
        handles.DB.flagtivpsd  = 0;
    end

end
%% Add with plot
%% Add selected variable to Workspace and plot if checkbox is checked
varind = length(handles.DB.varname);
set(handles.listWrkspc,'String',handles.DB.varname,'Value',varind,'Enable','on');
 %Total run time ~ 4sec
if get(handles.chkPlotmatvars,'Value') %checkbox is checked --> add new subplot  
    if isvector(y) && isnumeric(y) && ~isscalar(y)
    
        handles.DB.flagcolor = mod(handles.DB.flagcolor,7) + 1; %update color flag

        if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex) %>=1 signals are being plotted
            handles.DB.varindex = [handles.DB.varindex; varind];
            handles.DB.axesnum  = [handles.DB.axesnum; max(handles.DB.axesnum)+1];
            handles.DB.color    = [handles.DB.color; handles.DB.colorcode(handles.DB.flagcolor)];
            handles.DB.style    = [handles.DB.style; '-'];
        else %empty plot
            handles.DB.varindex = varind;
            handles.DB.axesnum  = 1;
            handles.DB.color    = handles.DB.colorcode(handles.DB.flagcolor);
            handles.DB.style    = {'-'};
            
            %Compute x-limit for the first time of loading a variable    
            validsignal = handles.DB.fs>0;
            try
                maxtime = max((cellfun(@length,handles.DB.signal(validsignal)) - 1)./handles.DB.fs(validsignal));
            catch
                error('Cannot identify sampling frequency');
            end
            handles.DB.window = maxtime;
            handles.DB.xlimit = [0, maxtime]; %default x-limit = [0, max. time]
            handles.DB.sliderstep = 0;            
        end

        %Plot signals        
        subplotSignals(hObject,handles); 
        
        handles = guidata(hObject);
        
        
        %Adjust xlimit for hmask
        axes(handles.hmask);
        
        %Update popWindow and xslider
        if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex) %>=1 signals are being plotted
            updateXslider(hObject,handles);
            handles = guidata(hObject);
        else %empty plot
            set(handles.popWindow,'Value',1);
            set(handles.xslider,'Enable','off','Min',0,'Max',maxtime,'SliderStep',[handles.DB.sliderstep/maxtime, 0.1]);
            set(handles.xslider,'Value',0);
        end

        %Update UI controls in Plot Editor
        plotvarind = length(handles.DB.varindex);
        nplot = max(handles.DB.axesnum);
        str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order
        set(handles.listPlotorder,'String',str,'Value',nplot,'Enable','on');
        listPlotorder_Callback(hObject, eventdata, handles); %update enable status of upplot & downplot buttons

        updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
        handles = guidata(hObject);        
        set(handles.butDeleteplotvar,'Enable','on');
        set(handles.butColor,'Enable','on');
        set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
        set(handles.popLinestyle,'Value',1,'Enable','on');
        
        %Set context menus
        setContextMenus(hObject,handles);
        handles = guidata(hObject);        
        
    else
        
        %Set context menus
        setContextMenus(hObject,handles);
        handles = guidata(hObject);
                
        h = warndlg({'Selected variable is not numeric or is a scalar.';...
                      'The variable is added to Workspace but not plotted.'},...
                     'Warning','modal');
    end
    
else %plot checkbox is not checked
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
    
end


%Update UI controls in variable operations in Workspace
updateVariableOperations(hObject,handles,varind);
handles = guidata(hObject);

%Viewing window and toolbar
if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex)
    set(handles.popWindow,'Enable','on');
    
    %Enable tools in the toolbar
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolSelectRegion,'Enable','on');
    set(handles.toolVerticalGuide_push,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');
else
    set(handles.popWindow,'Enable','off');
    
    %Disable tools in the toolbar
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolSelectRegion,'Enable','off');
    set(handles.toolVerticalGuide_push,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');
end
guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function listMatvars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listMatvars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butAllmatvars.
function butAllmatvars_Callback(hObject, eventdata, handles)
% hObject    handle to butAllmatvars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Get the selected variable
varlist = cellstr(get(handles.listMatvars,'String'));

%Collect selected variable info
for n=1:length(varlist)
selvar = varlist{n};

if isfield(handles.DB,'varname') && all(~cellfun('isempty',handles.DB.varname)) %>=1 variables are in Workspace

    handles.DB.filename    = [handles.DB.filename; fullfile(handles.DB.inputpath,handles.DB.inputfile)];
    handles.DB.exptdate    = [handles.DB.exptdate; handles.DB.inputexptdate];
    handles.DB.expttime    = [handles.DB.expttime; '-'];
    handles.DB.varnameorig = [handles.DB.varnameorig; selvar];
    
    %Check for repeated variable name
    newvarname = checkRepeatedVarname(selvar,handles.DB.varname);
    handles.DB.varname = [handles.DB.varname; newvarname];
        
    %Load selected variable
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),selvar);
    eval(['y = ',selvar,';']);
    
    %Get Acrostic and Subject ID
    handles.DB.acrostic = [handles.DB.acrostic; handles.DB.inputfile(1:5)];
    allvars = who('-file',fullfile(handles.DB.inputpath,handles.DB.inputfile));
    temp = strfind(allvars,'SubjectNumber'); %search for 'SubjectNumber'
    if any(~cellfun(@isempty,temp))
        load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'SubjectNumber');
        handles.DB.subjnum = [handles.DB.subjnum; num2str(SubjectNumber)];
    else
        handles.DB.subjnum = [handles.DB.subjnum; '-'];
    end
    
    if isvector(y) && isnumeric(y) && ~isscalar(y) && ~isscalar(y)
        
        %Collect current signal
        handles.DB.signal = [handles.DB.signal; y];
        
        %Compute mean and standard deviation
        handles.DB.meanstd = [handles.DB.meanstd; [mean(y),std(y)]];
        
        %Get sampling frequency
        fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,selvar);
        handles.DB.fs = [handles.DB.fs; fs];        
        handles.DB.flagnorm    = [handles.DB.flagnorm; -1];
        handles.DB.flagdetrend = [handles.DB.flagdetrend; -1];
        handles.DB.detrend     = [handles.DB.detrend; 1];
        handles.DB.scale       = [handles.DB.scale; 1];
        handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
        
        %Check if the current file was cropped
        %--> If yes, crop the newly loaded signal as well
        if ~isscalar(y) && isfield(handles.DB,'croppedfile') && ~isempty(handles.DB.croppedfile)
            k = size(handles.DB.filename,1);
            ind = strcmp(handles.DB.filename{k},handles.DB.croppedfile);
            ind = ind(:,1); %1st column corresponds to filenames
            if any(ind) %the selected file was already cropped
                
                %Crop range
                t1 = handles.DB.croppedfile{ind,2};
                t2 = handles.DB.croppedfile{ind,3};
                
                %Identify the sample indices of the begining and the end of the segment to be cropped
                i1 = round(t1*handles.DB.fs(k)); %beginning sample index to be cropped
                if i1<1
                    i1 = 1;
                end            
                i2 = round(t2*handles.DB.fs(k)); %end sample index to be cropped
                if i2>length(y)
                    i2 = length(y);
                end

                %Crop the signal
                handles.DB.signal{k} = y(i1:i2);
            end
        end
        
    else %loaded variable is not numeric
        handles.DB.signal      = {y};
        handles.DB.meanstd     = [handles.DB.meanstd; [0,0]];
        handles.DB.fs          = [handles.DB.fs; 0];
        handles.DB.flagnorm    = [handles.DB.flagnorm; 0];
        handles.DB.flagdetrend = [handles.DB.flagdetrend; 0];
        handles.DB.detrend     = [handles.DB.detrend; 0];
        handles.DB.scale       = [handles.DB.scale; 0];
  
        handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
    end

else %first variable to be added to the Workspace
    
    handles.DB.varnameorig = {selvar};
    handles.DB.varname     = {selvar};
    handles.DB.filename    = {fullfile(handles.DB.inputpath,handles.DB.inputfile)};
    handles.DB.exptdate    = {handles.DB.inputexptdate};
    handles.DB.expttime    = {'-'};
    
    %Load selected variable
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),selvar);
    eval(['y = ',selvar,';']);
    handles.DB.signal = {y};
    
    %Get Acrostic and Subject ID
    handles.DB.acrostic = {handles.DB.inputfile(1:5)};
    allvars = who('-file',fullfile(handles.DB.inputpath,handles.DB.inputfile));
    temp = strfind(allvars,'SubjectNumber'); %search for 'SubjectNumber'
    if any(~cellfun(@isempty,temp))
        load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'SubjectNumber');
        handles.DB.subjnum = {num2str(SubjectNumber)};
    else
        handles.DB.subjnum = {'-'};
    end
    
    if isvector(y) && isnumeric(y) && ~isscalar(y)
        handles.DB.meanstd = {[mean(y),std(y)]};
        handles.DB.fs = getSamplingFreq(handles.DB.inputpath,handles.DB.inputfile,selvar);
        handles.DB.flagnorm    = -1;
        handles.DB.flagdetrend = -1;
        handles.DB.detrend     =  1;
        handles.DB.scale       =  1;

        handles.DB.flagtivpsd  =  0;
        
        %Check if the current file was cropped
        %--> If yes, crop the newly loaded signal as well
        if ~isscalar(y) && isfield(handles.DB,'croppedfile') && ~isempty(handles.DB.croppedfile)
            k = size(handles.DB.filename,1);
            ind = strcmp(handles.DB.filename{k},handles.DB.croppedfile);
            ind = ind(:,1); %1st column corresponds to filenames
            if any(ind) %the selected file was already cropped
                
                %Crop range
                t1 = handles.DB.croppedfile{ind,2};
                t2 = handles.DB.croppedfile{ind,3};
                
                %Identify the sample indices of the begining and the end of the segment to be cropped
                i1 = round(t1*handles.DB.fs(k)); %beginning sample index to be cropped
                if i1<1
                    i1 = 1;
                end            
                i2 = round(t2*handles.DB.fs(k)); %end sample index to be cropped
                if i2>length(y)
                    i2 = length(y);
                end

                %Crop the signal
                handles.DB.signal{k} = y(i1:i2);
            end
        end
        
    else %loaded variable is not numeric
        handles.DB.meanstd = {[0,0]};
        handles.DB.fs = 0;
        handles.DB.flagnorm    = 0;
        handles.DB.flagdetrend = 0;
        handles.DB.detrend     = 0;
        handles.DB.scale       = 0;

        handles.DB.flagtivpsd  = 0;
    end

end

end %end for n

%Update Workspace listbox
varind = length(handles.DB.varname);
set(handles.listWrkspc,'String',handles.DB.varname,'Value',varind,'Enable','on');

%Update UI controls in variable operations in Workspace
updateVariableOperations(hObject,handles,varind);
handles = guidata(hObject);

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on button press in chkPlotmatvars.
function chkPlotmatvars_Callback(hObject, eventdata, handles)
% hObject    handle to chkPlotmatvars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkPlotmatvars


% --- Executes on selection change in listWrkspc.
function listWrkspc_Callback(hObject, eventdata, handles)
% hObject    handle to listWrkspc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listWrkspc contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listWrkspc

%Turn off any line selection highlight
handles = guidata(hObject);
turnoffLinehighlight(hObject,handles);


varind = get(handles.listWrkspc,'Value');
if isempty(varind)
    return
end

varind = varind(1);
y = handles.DB.signal{varind};

%======= Take the following actions if DOUBLE-click =======================
if strcmp(get(handles.figMain,'SelectionType'),'open')

    if isvector(y) && isnumeric(y) && ~isscalar(y)
        
        %Plot selected variable
        handles.DB.flagcolor = mod(handles.DB.flagcolor,7) + 1; %update color flag

        if isfield(handles.DB,'varindex') && ~isempty(handles.DB.varindex) %>=1 signals are being plotted
            handles.DB.varindex = [handles.DB.varindex; varind];
            handles.DB.axesnum  = [handles.DB.axesnum; max(handles.DB.axesnum)+1];
            handles.DB.color    = [handles.DB.color; handles.DB.colorcode(handles.DB.flagcolor)];
            handles.DB.style    = [handles.DB.style; '-'];

            %Plot signals
            subplotSignals(hObject,handles);
            handles = guidata(hObject);
            axes(handles.hmask);
            
            %Update xslider and x-limit
            updateXslider(hObject,handles);
            handles = guidata(hObject);
        else %empty plot
            handles.DB.varindex = varind;
            handles.DB.axesnum  = 1;
            handles.DB.color    = handles.DB.colorcode(handles.DB.flagcolor);
            handles.DB.style    = {'-'};
            
            %Set popWindow selection to 'Full'
            set(handles.popWindow,'Value',1);
            validsignal = handles.DB.fs>0;
            maxtime = max((cellfun(@length,handles.DB.signal(validsignal)) - 1)./handles.DB.fs(validsignal));
            handles.DB.window = maxtime;
            
            %Compute x-limit for the first time of loading a variable    
            handles.DB.xlimit = [0, maxtime]; %default x-limit = [0, max. time]
            handles.DB.sliderstep = 0;
            set(handles.xslider,'Enable','off','Min',0,'Max',maxtime,'SliderStep',[handles.DB.sliderstep/maxtime, 0.1]);
            set(handles.xslider,'Value',0);

            %Adjust xlimit for hmask
            %Plot signals
            subplotSignals(hObject,handles);
            handles = guidata(hObject);

        end

        %Update UI controls in Plot Editor
        plotvarind = length(handles.DB.varindex);
        nplot = max(handles.DB.axesnum);
        str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order
        set(handles.listPlotorder,'String',str,'Value',nplot,'Enable','on');
        listPlotorder_Callback(hObject, eventdata, handles); %update enable status of upplot & downplot buttons
        set(handles.butDeleteplot,'Enable','on');
        updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
          handles = guidata(hObject);
        set(handles.butDeleteplotvar,'Enable','on');
        set(handles.butColor,'Enable','on');
        set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
        set(handles.popLinestyle,'Value',1,'Enable','on');

        %Update UI controls in variable operations in Workspace
        updateVariableOperations(hObject,handles,varind);
        handles = guidata(hObject);

        %Enable tools in the toolbar
        set(handles.toolLoadData,'Enable','on');
        set(handles.toolZoomin,'Enable','on');
        set(handles.toolZoomout,'Enable','on');
        set(handles.toolPan,'Enable','on');
        set(handles.toolDataCursor,'Enable','on');
        set(handles.toolSelectRegion,'Enable','on');
        set(handles.toolEditPlot,'Enable','on');
        set(handles.popWindow,'Enable','on');

        %Set context menus
        setContextMenus(hObject,handles);
        handles = guidata(hObject);
        
    else
        h = warndlg({'Selected variable is not numeric or is a scalar.';...
                     'The variable cannot be plotted.'},...
                     'Warning','modal');
    end

%======= Take the following actions if SINGLE-click =======================
else

    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

end %end if check for type of mouse click

guidata(hObject, handles); %update handles structure


% --- Executes on key press with focus on listWrkspc and none of its controls.
function listWrkspc_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listWrkspc (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

if strcmp(eventdata.Key,'delete') || strcmp(eventdata.Key,'backspace')
    deleteWorkspaceVariable(hObject, eventdata, handles);
    handles = guidata(hObject);
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
    
    guidata(hObject, handles); %update handles structure
    
else
    
    guidata(hObject, handles); %update handles structure
    return
end


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


% --- Executes on button press in chkNorm.
function chkNorm_Callback(hObject, eventdata, handles)
% hObject    handle to chkNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkNorm

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

varind = get(handles.listWrkspc,'Value'); %index of the currently selected variable in Workspace

%Update flagnorm
if get(handles.chkNorm,'Value') %Normalization is selected
    handles.DB.flagnorm(varind) =  1;
else %Normalization is deselected
    handles.DB.flagnorm(varind) = -1;
end

%Replot signal
replotSelectedSignal(hObject,handles,varind);
handles = guidata(hObject);

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on button press in chkDetrend.
function chkDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to chkDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDetrend

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

varind = get(handles.listWrkspc,'Value'); %index of the currently selected variable in Workspace

%Update flagdetrend
if get(handles.chkDetrend,'Value') %Detrend is selected
    handles.DB.flagdetrend(varind) =  1;
    set(handles.editDetrend,'String',num2str(handles.DB.detrend(varind)),'Enable','on');
else %Detrend is deselected
    handles.DB.flagdetrend(varind) = -1;
    set(handles.editDetrend,'String','','Enable','off');
end

%Replot signal
replotSelectedSignal(hObject,handles,varind);
handles = guidata(hObject);

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


function editDetrend_Callback(hObject, eventdata, handles)
% hObject    handle to editDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDetrend as text
%        str2double(get(hObject,'String')) returns contents of editDetrend as a double

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

val = str2num(get(handles.editDetrend,'String')); %use str2num because it can convert math symbol operating on numbers e.g. 2+3
if ~isempty(val) && isreal(val) && val>=0 && rem(val,1)==0
    set(handles.editDetrend,'String',num2str(val));
    
    varind = get(handles.listWrkspc,'Value'); %index of the currently selected variable in Workspace

    %Update detrend
    handles.DB.detrend(varind) = val;

    %Replot signal
    replotSelectedSignal(hObject,handles,varind);
    handles = guidata(hObject);
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
    
else
    h = warndlg('Input to this field must be an integer >= 0.','Warning!','modal');
    return
end

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function editDetrend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDetrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkScale.
function chkScale_Callback(hObject, eventdata, handles)
% hObject    handle to chkScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkScale

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

varind = get(handles.listWrkspc,'Value');
if get(handles.chkScale,'Value') %Scaling factor is selected
    set(handles.editScale,'String',num2str(handles.DB.scale(varind)),'Enable','on');
else %Scaling factor is deselected
    handles.DB.scale(varind) = 1; %reset scaling factor
    set(handles.editScale,'String','','Enable','off');
    
    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

    %Replot signal
    replotSelectedSignal(hObject,handles,varind);
    handles = guidata(hObject);
end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


function editStatus1_Callback(hObject, eventdata, handles)
% hObject    handle to editStatus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStatus1 as text
%        str2double(get(hObject,'String')) returns contents of editStatus1 as a double


% --- Executes during object creation, after setting all properties.
function editStatus1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStatus1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editScale_Callback(hObject, eventdata, handles)
% hObject    handle to editScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editScale as text
%        str2double(get(hObject,'String')) returns contents of editScale as a double

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

val = str2num(get(handles.editScale,'String')); %use str2num because it can convert math symbol operating on numbers e.g. 2+3
if ~isempty(val) && isreal(val)
    set(handles.editScale,'String',num2str(val));
    
    varind = get(handles.listWrkspc,'Value'); %index of the currently selected variable in Workspace

    %Update scaling factor
    handles.DB.scale(varind) = val;
    
    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

    %Replot signal
    replotSelectedSignal(hObject,handles,varind);
    handles = guidata(hObject);
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);

else
    h = warndlg('Input to this field must be a number.','Warning!','modal');
    return
end

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function editScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








% --- Executes on button press in chkFs.
function chkFs_Callback(hObject, eventdata, handles)
% hObject    handle to chkFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFs

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

varind = get(handles.listWrkspc,'Value');
if get(handles.chkFs,'Value')
    set(handles.editFs,'String',num2str(handles.DB.fs(varind)),'Enable','on');
else
    set(handles.editFs,'String',num2str(handles.DB.fs(varind)),'Enable','off');
end

guidata(hObject, handles); %update handles structure



function editFs_Callback(hObject, eventdata, handles)
% hObject    handle to editFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFs as text
%        str2double(get(hObject,'String')) returns contents of editFs as a double

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Only one variable can be selected at a time
varind = get(handles.listWrkspc,'Value'); %index of the currently selected variable in Workspace

val = str2num(get(handles.editFs,'String')); %use str2num because it can convert math symbol operating on numbers e.g. 2+3
if ~isempty(val) && isreal(val) && val>0
    set(handles.editFs,'String',num2str(val));

    %Update sampling frequency
    handles.DB.fs(varind) = val;

    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

    %Replot signal
    replotSelectedSignal(hObject,handles,varind);
    handles = guidata(hObject);

else
    warndlg('Input to this field must be a number > 0.','Warning!','modal');
    return
end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function editFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listPlotorder.
function listPlotorder_Callback(hObject, eventdata, handles)
% hObject    handle to listPlotorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listPlotorder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listPlotorder

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

plotind = get(handles.listPlotorder,'Value');
if isempty(plotind)
    return
end
plotind = plotind(1);
set(handles.listPlotorder,'Value',plotind);

if isfield(handles.DB,'axesnum') && max(handles.DB.axesnum)>1
    if plotind>1 && plotind<max(handles.DB.axesnum)
        set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
        set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
    elseif plotind==1
        set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
        set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
    elseif plotind==max(handles.DB.axesnum)
        set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
        set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    end
else
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function listPlotorder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listPlotorder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDeleteplot.
function butDeleteplot_Callback(hObject, eventdata, handles)
% hObject    handle to butDeleteplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

selaxes = get(handles.listPlotorder,'Value');
plotvarind = handles.DB.axesnum==selaxes;

%Delete variables in the selected axes
handles.DB.varindex(plotvarind) = [];
handles.DB.axesnum(plotvarind)  = [];
handles.DB.color(plotvarind)    = [];
handles.DB.style(plotvarind)    = [];

%Delete y-limit of the selected axes
handles.DB.ylimit(selaxes,:) = [];

if ~isempty(handles.DB.varindex)
    
    %Update axes number
    z = handles.DB.axesnum>selaxes;
    if ~isempty(z)
        handles.DB.axesnum(z) = handles.DB.axesnum(z) - 1;
    end

    %Plot signals
    subplotSignals(hObject,handles);
    handles = guidata(hObject);
    %Add marker
    axes(handles.hmask);

    %Update UI controls in Plot Editor
    plotvarind = 1;
    nplot = max(handles.DB.axesnum);
    str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order
    set(handles.listPlotorder,'String',str,'Value',handles.DB.axesnum(plotvarind),'Enable','on');
    listPlotorder_Callback(hObject, eventdata, handles); %update enable status of upplot & downplot buttons
    set(handles.butDeleteplot,'Enable','on');
    updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
    handles = guidata(hObject);
    set(handles.butDeleteplotvar,'Enable','on');
    set(handles.butColor,'Enable','on');
    set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
    val = getvalpopLinestyle(handles.DB.style{plotvarind});
    set(handles.popLinestyle,'Value',val,'Enable','on');
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);

else %all axes are deleted
    guidata(hObject,handles);


    
    delete(handles.DB.haxes);
    handles.DB.haxes = [];

    %Plot Editor
    set(handles.listPlotorder,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplot,'Enable','off');
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    set(handles.listPlotvars,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplotvar,'Enable','off');
    set(handles.butColor,'Enable','off');
    set(handles.txtColor,'BackgroundColor',[0,0,0]);
    set(handles.popLinestyle,'Value',1,'Enable','off');
    
    %Viewing window and slider
    set(handles.popWindow,'Value',1,'Enable','off');
    set(handles.xslider,'Min',0,'Max',1,'Value',0,'Enable','off');
    
    %Reset color flag
    handles.DB.flagcolor = 0;
    
    %Tools
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolSelectRegion,'Enable','off');
    set(handles.toolVerticalGuide_push,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');
    
end

% %Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on button press in butUpplot.
function butUpplot_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to butUpplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

selaxes = get(handles.listPlotorder,'Value');
indupper = handles.DB.axesnum==(selaxes-1);
indlower = handles.DB.axesnum==selaxes;

%Update handles.DB.axesnum
handles.DB.axesnum(indlower) = handles.DB.axesnum(indlower) - 1; %move up
handles.DB.axesnum(indupper) = handles.DB.axesnum(indupper) + 1; %move down

%Update handles.DB.ylimit 
selylimit = handles.DB.ylimit(selaxes,:);
handles.DB.ylimit(selaxes,:) = handles.DB.ylimit(selaxes-1,:);
handles.DB.ylimit(selaxes-1,:) = selylimit;

%Plot signals
subplotSignals(hObject,handles);
handles = guidata(hObject);
axes(handles.hmask);

%Update UIcontrols
set(handles.listPlotorder,'Value',selaxes-1);

if (selaxes-1)==1
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end
if max(handles.DB.axesnum)>1 && (selaxes-1)<max(handles.DB.axesnum)
    set(handles.butDownplot,'ForegroundColor',[0 0 0],'Enable','on');
else
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on button press in butDownplot.
function butDownplot_Callback(hObject, ~, handles) %#ok<DEFNU>
% hObject    handle to butDownplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

selaxes = get(handles.listPlotorder,'Value');
indupper = handles.DB.axesnum==selaxes;
indlower = handles.DB.axesnum==(selaxes+1);

%Update handles.DB.axesnum 
handles.DB.axesnum(indupper) = handles.DB.axesnum(indupper) + 1; %move down
handles.DB.axesnum(indlower) = handles.DB.axesnum(indlower) - 1; %move up

%Update handles.DB.ylimit
selylimit = handles.DB.ylimit(selaxes,:);
handles.DB.ylimit(selaxes,:) = handles.DB.ylimit(selaxes+1,:);
handles.DB.ylimit(selaxes+1,:) = selylimit;

%Plot signals
subplotSignals(hObject,handles);
handles = guidata(hObject);
axes(handles.hmask); %Move markers to the front


%Update UIcontrols
set(handles.listPlotorder,'Value',selaxes+1);
if (selaxes+1)==max(handles.DB.axesnum)
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end
if max(handles.DB.axesnum)>1 && (selaxes+1)>1
    set(handles.butUpplot,'ForegroundColor',[0 0 0],'Enable','on');
else
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
end


%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on selection change in listPlotvars.
function listPlotvars_Callback(hObject, eventdata, handles)
% hObject    handle to listPlotvars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listPlotvars contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listPlotvars

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

plotvarind = get(handles.listPlotvars,'Value');
if isempty(plotvarind)
    return
end
plotvarind = plotvarind(1);
set(handles.listPlotvars,'Value',plotvarind);

set(handles.listPlotorder,'Value',handles.DB.axesnum(plotvarind));
listPlotorder_Callback(hObject, eventdata, handles);
set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
val = getvalpopLinestyle(handles.DB.style{plotvarind});
set(handles.popLinestyle,'Value',val,'Enable','on');

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function listPlotvars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listPlotvars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDeleteplotvar.
function butDeleteplotvar_Callback(hObject, eventdata, handles)
% hObject    handle to butDeleteplotvar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

plotvarind = get(handles.listPlotvars,'Value');

%Delete the selected variable
handles.DB.varindex(plotvarind) = [];
handles.DB.axesnum(plotvarind)  = [];
handles.DB.color(plotvarind)    = [];
handles.DB.style(plotvarind)    = [];

if ~isempty(handles.DB.varindex)
    
    %Update axes number
    axesnum = sort(handles.DB.axesnum);
    if min(axesnum)>1
        handles.DB.axesnum = handles.DB.axesnum - min(axesnum) + 1;
    end
    axesnum = sort(handles.DB.axesnum);
    d = [0; diff(axesnum)];
    zgap = find(d>1); %gap in axes number
    if ~isempty(zgap)
        z = handles.DB.axesnum > axesnum(zgap-1);
        handles.DB.axesnum(z) = handles.DB.axesnum(z) - (d(zgap)-1);
    end

    %Plot signals
    subplotSignals(hObject,handles);
    handles = guidata(hObject);
    
    axes(handles.hmask);
    
    %Update UI controls in Plot Editor
    if plotvarind>length(handles.DB.varindex)
        plotvarind = plotvarind - 1;
    end
    str = genlistPlotorder(handles.DB.axesnum); %string to be updated in list of plot order
    set(handles.listPlotorder,'String',str,'Value',handles.DB.axesnum(plotvarind),'Enable','on');
    listPlotorder_Callback(hObject, eventdata, handles); %update enable status of upplot & downplot buttons
    set(handles.butDeleteplot,'Enable','on');
    updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
    handles = guidata(hObject);
    set(handles.butDeleteplotvar,'Enable','on');
    set(handles.butColor,'Enable','on');
    set(handles.txtColor,'BackgroundColor',handles.DB.color{plotvarind});
    val = getvalpopLinestyle(handles.DB.style{plotvarind});
    set(handles.popLinestyle,'Value',val,'Enable','on');

    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);

else %all axes are deleted
    
    %Clear axespanel
    guidata(hObject,handles);    
    
    handles = guidata(hObject);
    
    delete(handles.DB.haxes);
    handles.DB.haxes = [];
    
    
    %Plot Editor
    set(handles.listPlotorder,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplot,'Enable','off');
    set(handles.butUpplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    set(handles.butDownplot,'ForegroundColor',0.5*ones(1,3),'Enable','off');
    set(handles.listPlotvars,'String','','Value',1,'Enable','off');
    set(handles.butDeleteplotvar,'Enable','off');
    set(handles.butColor,'Enable','off');
    set(handles.txtColor,'BackgroundColor',[0,0,0]);
    set(handles.popLinestyle,'Value',1,'Enable','off');
    
    %Viewing window and slider
    set(handles.popWindow,'Value',1,'Enable','off');
    set(handles.xslider,'Min',0,'Max',1,'Value',0,'Enable','off');
    
    %Reset color flag
    handles.DB.flagcolor = 0;
    
    %Tools
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolZoomin,'Enable','off');
    set(handles.toolZoomout,'Enable','off');
    set(handles.toolPan,'Enable','off');
    set(handles.toolDataCursor,'Enable','off');
    set(handles.toolSelectRegion,'Enable','off');
    set(handles.toolVerticalGuide_push,'Enable','off');
    set(handles.toolEditPlot,'Enable','off');
    
end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on button press in butColor.
function butColor_Callback(hObject, eventdata, handles)
% hObject    handle to butColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

c = uisetcolor; %select color

if length(c)==3
    plotvarind = get(handles.listPlotvars,'Value');
    handles.DB.color{plotvarind} = c;
    set(handles.DB.hline(plotvarind),'Color',c); %update color
    set(handles.txtColor,'BackgroundColor',c);
    
    z = handles.DB.axesnum==handles.DB.axesnum(plotvarind); %indices of plotted variable in current axes
    varnames = handles.DB.varname(handles.DB.varindex(z)); %variable names being plotted in current axes
    colors = handles.DB.color(z); %colors of variables being plotted in current axes
    
    strTitle = ['{\color[rgb]{',num2str(colors{1}),'}',varnames{1},'}'];
    for m=2:size(varnames,1)
        strTitle = [strTitle,', ','{\color[rgb]{',num2str(colors{m}),'}',varnames{m},'}'];
    end
    
    ylabel(handles.DB.haxes(handles.DB.axesnum(plotvarind)),strTitle,'FontSize',10,'FontWeight','bold');
    updatelistPlotvars(hObject,handles,plotvarind); %update plotvars listbox
      handles = guidata(hObject);
end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes on selection change in popLinestyle.
function popLinestyle_Callback(hObject, eventdata, handles)
% hObject    handle to popLinestyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popLinestyle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popLinestyle

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

s = get(handles.popLinestyle,'Value'); %get selected style

plotvarind = get(handles.listPlotvars,'Value');

switch s
    case 1
        handles.DB.style{plotvarind} = '-';
    case 2
        handles.DB.style{plotvarind} = '--';
    case 3
        handles.DB.style{plotvarind} = ':';
    case 4
        handles.DB.style{plotvarind} = '-.';
end

set(handles.DB.hline(plotvarind),'LineStyle',handles.DB.style{plotvarind}); %update line style

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --- Executes during object creation, after setting all properties.
function popLinestyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popLinestyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDeletetag.
function butDeletetag_Callback(hObject, eventdata, handles)
% hObject    handle to butDeletetag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 %value is changed from setValueAtEditor 
handles.setValflag = true;
% set the Interruptible of this call back to off 
%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

jScrollPane = findjobj(handles.tableEditor);
jtable = jScrollPane.getViewport.getView;

indfilter = handles.getFilteredTags(jtable);
htable=handles.tableEditor;
data = get(htable,'Data');
ind = handles.getSelectedTags(indfilter,data);
if isempty(ind)
    return
end
% delete tags in DB
data(ind,:) = []; 
handles.editorTags(ind,:) = [];
set(handles.tableEditor,'Data',data);


if isempty(handles.editorTags)
     set(handles.butDeletetag,'Enable','off');
     set(handles.butSavetags,'Enable','off');
     set(handles.chkSelectAll,'Value',0,'Enable','off');
end

%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);
guidata(hObject, handles); %update handles structure



% --- Executes on button press in butSavetags.
function butSavetags_Callback(hObject, eventdata, handles)
% hObject    handle to butSavetags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

htable=handles.tableEditor;
data = get(htable,'Data');
ind = handles.getSelectedTags([],data); % no filter for this table
if isempty(ind)
    return
end

data = handles.editorTags(ind,:);

% check if savepath exists
if ~isempty(handles.tagsavepath)
    tagsavepath = handles.tagsavepath;
else
    tagsavepath = fullfile(handles.codepath,'Tags');
end

% get the selected file/path from users
if ~isequal(tagsavepath,0)
    [file,path] = uiputfile('tag.csv','Save Tags',tagsavepath);
else
    [file,path] = uiputfile('tag.csv','Save Tags');
end



% write file
if ~isequal(file,0)
    filepath = fullfile(path,file);
    colname = {'Filename';'Module';'Acrostic';'SubjectID';'ExptDate';'ExptTime';'Variable';'Side';'Fs';'Begin';'End';'Tag';'Operation';'OperationTag';'Value'};   
    %Check existing file
    
    if exist(filepath,'file') == 2
        try 
            % read .csv file
            fid = fopen(filepath);
            % read header size(c) = 1 x ncol, don't use the header
            textscan(fid,'%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s',1,'delimiter',',');
            % read content
            c = textscan(fid,'%s%s%s%s%s%s%s%s%f%f%f%s%s%s%s','delimiter',',');
            fclose(fid);
            
            % set variables
            nrow = length(c{1,1});
            ncol = length(c);
            temp = cell(nrow,ncol);
            for n=1:ncol
                % Fs,Begin and End column
                if ismember(n,[9,10,11])
                     temp(:,n) = num2cell(c{1,n});
                else
                    temp(:,n) = c{1,n};
                end
            end
            temp = cell2table(temp,'VariableNames',colname);
        catch
           %If there is a problem with reading file
           [path,filename,ext]=fileparts(filepath);
           filepath = fullfile(path,[filename,'_temporary',ext]);
           temp = [];
           warndlg(['Error occurs during the file reading, the new file is saved under ',filename]);
            
        end
            

        %Concatenate the file
       % temp = readtable(filepath);
    else
       temp = [];
    end
    
    %% Before save, check data if contain NaN
    checkdata = cellfun(@(x) (sum(isnan(x))),data,'UniformOutput',0); %This will give cell-array with 0 or 1
    checkdata = logical(cell2mat(checkdata));
    %For any [NaN] cells -> convert to empty
    data(checkdata) = {[]};
       
    T = cell2table(data,'VariableNames',colname);
    writetable([temp;T],filepath);

end
% update savepath
handles.tagsavepath = path;
guidata(hObject, handles); %update handles structure


% --- Executes when selected cell(s) is changed in tableEditor.
function tableEditor_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tableEditor (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

%Get index of editted cell
c = eventdata.Indices;
if isempty(c) || c(2)==1 % don't highlight when select checkboxes
    return
end
row = c(1);

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);
[axesnum]= getAxesnum(handles,row);
drawShade(handles,row,axesnum);


% guidata(hObject, handles); %update handles structure



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
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Get index of editted cell
c = eventdata.Indices;
row = c(1);
col = c(2);

%Get data from the table
tabdata = get(handles.tableEditor,'Data');


jScrollPane = findjobj(handles.tableEditor);
jUITable = jScrollPane.getViewport.getView;
jUITable.setRowSelectionAllowed(0);
jUITable.setColumnSelectionAllowed(0);

[valid,colname] = isEditInfoValid(handles,handles,row,col); %Check what is put in the cell
if valid
    % update editorTags for Tag, Begin and End
    if ~strcmp(colname,'select')
        handles.editorTags{row,getColId(colname,'file')} = tabdata{row,col};
    end
    % update filterEditor in DB
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
[axesnum]= getAxesnum(handles,row);
drawShade(handles,row,axesnum);
end


%Set context menus
setContextMenus(hObject,handles);

guidata(hObject, handles); %update handles structure



% --- Executes when entered data in editable cell(s) in tableEvents.
function tableEvents_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to tableEvents (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in tableEvents.
function tableEvents_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tableEvents (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if isempty(eventdata.Indices) % changing the cell data from code
    return;
end

if ~isfield(handles.DB,'axesnum') || isempty(handles.DB.axesnum)
    return;
end
data = get(handles.tableEvents,'Data');
rowind = eventdata.Indices(1);
time = data{rowind,3};
tag = ['event',num2str(rowind)];
hold(handles.hmask,'on');
hline = line([time time],get(handles.hmask,'YLim'),'LineWidth',2,'LineStyle','--','Color','k','Tag',tag,'Parent',handles.hmask,'ButtonDownFcn',{@lineMarkerCallback});
hline.DisplayName = tag;
hold(handles.hmask,'off');



%Set context menus (Update handles for all context menus)
setContextMenus(hObject,handles);
handles = guidata(hObject);

guidata(hObject,handles);




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



function editVarsize_Callback(hObject, eventdata, handles)
% hObject    handle to editVarsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editVarsize as text
%        str2double(get(hObject,'String')) returns contents of editVarsize as a double


% --- Executes during object creation, after setting all properties.
function editVarsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVarsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure

% --------------------------------------------------------------------
function menuScreenshot_Callback(hObject, eventdata, handles)
% hObject    handle to menuScreenshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

[figfile,figpath] = uiputfile('*.*','Take a Screenshot of the GUI');
if ~ischar(figfile)
    return %return if choosing invalid file
end

pos = get(handles.figMain,'Position');
imgdata = screencapture(0,'Position',pos); %take a screen capture
imwrite(imgdata,fullfile(figpath,[figfile,'.png'])); %save the captured image to file

guidata(hObject, handles); %update handles structure


% --------------------------------------------------------------------
function menuSaveWrkspc_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveWrkspc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);


if ~isfield(handles.DB,'varname') || isempty(handles.DB.varname)
    h = warndlg('Workspace is empty.','Warning!','modal');
    return
end

%Collect data to be exported
nvars = length(handles.DB.varname);
S.variableInfo_headers = {'Varname','Fs (Hz)','Filename','MeanSTD','flagNorm','flagDetrend','DetrendOrder','ScalingFactor','y-shift','x-shift'};
S.variableInfo = cell(nvars,length(S.variableInfo_headers));

%Sampling frequencies
S.fs_high = 250;
S.fs_low  = 30;
S.fs_fnir = 2;

for n=1:nvars

    y = handles.DB.signal{n};

    if isvector(y) && isnumeric(y) && ~isscalar(y)

        %Collect variable information
        S.variableInfo{n,1} = handles.DB.varname{n};
        S.variableInfo{n,2} = handles.DB.fs(n);
        [pathstr, name, ext] = fileparts(handles.DB.filename{n});
        S.variableInfo{n,3} = strcat(name,ext);
        S.variableInfo{n,4} = handles.DB.meanstd{n,:};
        S.variableInfo{n,5} = handles.DB.flagnorm(n);
        S.variableInfo{n,6} = handles.DB.flagdetrend(n);
        S.variableInfo{n,7} = handles.DB.detrend(n);
        S.variableInfo{n,8} = handles.DB.scale(n);

        %Perform any selected operations on the signal
        y = signalOperations(handles,n);

        %Store variable into S structure
        eval(['S.',handles.DB.varname{n},' = y;']); 

        clear y;

    else %current variable is NOT a number vector

        %Collect variable information
        S.variableInfo{n,1} = handles.DB.varname{n};
        S.variableInfo{n,2} = [];
        [pathstr, name, ext] = fileparts(handles.DB.filename{n});
        S.variableInfo{n,3} = strcat(name,ext);
        S.variableInfo{n,4} = [];
        S.variableInfo{n,5} = [];
        S.variableInfo{n,6} = [];
        S.variableInfo{n,7} = [];
        S.variableInfo{n,8} = [];
        S.variableInfo{n,9} = [];
        S.variableInfo{n,10}= [];

        %Store unmodified variable into S structure
        eval(['S.',handles.DB.varname{n},' = y;']);
    end

end %end for n

%Get file name and path
[savename,pathstr] = uiputfile('myworkspace.mat','Save workspace');
if ~ischar(savename)
    return %return if choosing invalid file
end

save(fullfile(pathstr,savename), '-struct', 'S');

guidata(hObject, handles); %update handles structure


% --------------------------------------------------------------------
function menuReset_Callback(hObject, eventdata, handles)
% hObject    handle to menuReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    close(handles.TagManager);
   
    % Delete active submodules
    if ~isempty(handles.subMovingCorrelation)
        close(handles.subMovingCorrelation);
    end
    if ~isempty(handles.subStationaryPSD)
        close(handles.subStationaryPSD);
    end
    
    if ~isempty(handles.subTVPSD)
        close(handles.subTVPSD);
    end
    
    if ~isempty(handles.subFEX)
        close(handles.subFEX); %Call figFEX_CloseRequestFcn
    end
    handles = guidata(handles.output);

    
catch
    warning('Cannot delete one of the sub modules');
end
   

%Initialize GUI
initializeGUI(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --------------------------------------------------------------------
function menuAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to menuAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

guidata(hObject, handles); %update handles structure


% --------------------------------------------------------------------
function menuMovingCorrelation_Callback(hObject, eventdata, handles)
% hObject    handle to menuMovingCorrelation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

% if ~isfield(handles.DB,'varname') || isempty(handles.DB.varname)
%     h = warndlg('Workspace is empty.','Warning!','modal');
%     return
% end

hfigmain = getappdata(0, 'hfigmain');
if ~isfield(handles.DB,'varname') || isempty(handles.DB.varname)
    setappdata(hfigmain,'FlagEmptyWorkspace',true);
else
    setappdata(hfigmain,'FlagEmptyWorkspace',false);
    setappdata(hfigmain,'SDvarname',handles.DB.varname);
    setappdata(hfigmain,'SDfilename',handles.DB.filename);
    setappdata(hfigmain,'SDacrostic',handles.DB.acrostic);
    setappdata(hfigmain,'SDsubjnum',handles.DB.subjnum);
    setappdata(hfigmain,'SDexptdate',handles.DB.exptdate);
    setappdata(hfigmain,'SDexpttime',handles.DB.expttime);
    setappdata(hfigmain,'SDsignal',handles.DB.signal);
    setappdata(hfigmain,'SDfs',handles.DB.fs);
    setappdata(hfigmain,'SDflagnorm',handles.DB.flagnorm);
    setappdata(hfigmain,'SDflagdetrend',handles.DB.flagdetrend);
    setappdata(hfigmain,'SDdetrend',handles.DB.detrend);
    setappdata(hfigmain,'SDscale',handles.DB.scale);
    setappdata(hfigmain,'SDtag',handles.editorTags);
end

%Call GUI function in new window to compute moving correlation
%handles.output is the hObject to the figure
handles.subMovingCorrelation = sub_MovingCorrelation('DataBrowser',handles.output);


guidata(hObject, handles); %update handles structure


% --------------------------------------------------------------------
function menuStationaryPSD_Callback(hObject, eventdata, handles)
% hObject    handle to menuStationaryPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Update shared data
hfigmain = getappdata(0, 'hfigmain');

if ~isfield(handles.DB,'varname') || isempty(handles.DB.varname)
    setappdata(hfigmain,'FlagEmptyWorkspace',true);
else
    setappdata(hfigmain,'FlagEmptyWorkspace',false);
    setappdata(hfigmain,'SDvarname',handles.DB.varname);
    setappdata(hfigmain,'SDfilename',handles.DB.filename);
    setappdata(hfigmain,'SDacrostic',handles.DB.acrostic);
    setappdata(hfigmain,'SDsubjnum',handles.DB.subjnum);
    setappdata(hfigmain,'SDexptdate',handles.DB.exptdate);
    setappdata(hfigmain,'SDexpttime',handles.DB.expttime);
    setappdata(hfigmain,'SDsignal',handles.DB.signal);
    setappdata(hfigmain,'SDfs',handles.DB.fs);
    setappdata(hfigmain,'SDflagnorm',handles.DB.flagnorm);
    setappdata(hfigmain,'SDflagdetrend',handles.DB.flagdetrend);
    setappdata(hfigmain,'SDdetrend',handles.DB.detrend);
    setappdata(hfigmain,'SDscale',handles.DB.scale);
end

if ~isfield(handles.DB,'flagtivpsd')
    handles.DB.flagtivpsd = [];
end

% %Call GUI function in new window to compute moving correlation
handles.subStationaryPSD = sub_StationaryPSD('DataBrowser',handles.output);

guidata(hObject, handles); %update handles structure

% --------------------------------------------------------------------
function menuTimeVaryingPSD_Callback(hObject, eventdata, handles)
% hObject    handle to menuTimeVaryingPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);


if isempty(handles.subTVPSD)
    handles.subTVPSD = sub_TimeVaryingPSD('DataBrowser',handles.output);
else
    figure(handles.subTVPSD);
end


guidata(hObject,handles);

% --------------------------------------------------------------------
function menuFEX_Callback(hObject, eventdata, handles)
% hObject    handle to menuFEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);


if isempty(handles.subFEX)
    handles.subFEX = sub_FEX('DataBrowser',handles.output);
else
    figure(handles.subFEX);
end


guidata(hObject,handles);


% --------------------------------------------------------------------
function menuLayout_Callback(hObject, eventdata, handles)
% hObject    handle to menuLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% users' functions
function addResults(hObject,handles,module)
if strcmp(module,'MC')
    hfigmain = getappdata(0,'hfigmain');
    filename = getappdata(hfigmain,'rfilename');
    fresamp = getappdata(hfigmain,'fresamp');
    r = getappdata(hfigmain,'r');
    lci95 = getappdata(hfigmain,'lci95');
    uci95 = getappdata(hfigmain,'uci95');
    if license('test','Statistics_Toolbox')
        rs = getappdata(hfigmain,'rs');
        lci95s = getappdata(hfigmain,'lci95s');
        uci95s = getappdata(hfigmain,'uci95s');
        varlist = {'r','lci95','uci95','rs','lci95s','uci95s'};
    else
        varlist = {'r','lci95','uci95'};
    end
    total = size(r,1);
elseif strcmp(module,'PSD')
    hfigmain = getappdata(0,'hfigmain');
    psdname = getappdata(hfigmain,'psdname');
    psd     = getappdata(hfigmain,'psd');
    fresamp  = getappdata(hfigmain,'psdfs');
    filename = getappdata(hfigmain,'psdfile');
    varlist = {'psd'};
    total = size(psd,1);
end

if total>0 %result is not empty
    for k=1:total %loop based on no. of computations    
        for v=1:length(varlist) %create a structure of each variable
            %Get Acrostic and Subject ID
            [pathstr,name,ext] = fileparts(filename{k}); 
            handles.DB.acrostic = [handles.DB.acrostic; name(1:5)];
            allvars = who('-file',filename{k});
            temp = strfind(allvars,'SubjectNumber'); %search for 'SubjectNumber'
            if any(~cellfun(@isempty,temp))
                load(filename{k},'SubjectNumber');
                handles.DB.subjnum = [handles.DB.subjnum; num2str(SubjectNumber)];
            else
                handles.DB.subjnum = [handles.DB.subjnum; '-'];
            end
            
            handles.DB.filename    = [handles.DB.filename; filename{k}];
            handles.DB.varnameorig = [handles.DB.varnameorig; '-'];            

            if strcmp(module,'MC')
                %MoveCorr
                selvar = [varlist{v}];
            elseif strcmp(module,'PSD')
                %PSD
                selvar = psdname{k};
            end
            %Check for repeated variable name
            newvarname = checkRepeatedVarname(selvar,handles.DB.varname);
            handles.DB.varname = [handles.DB.varname; newvarname];
            
            %MoveCorr & PSD
            eval(['y = ',varlist{v},'{k};']); 
            
            % results don't have exptdate and expttime
            handles.DB.exptdate = [handles.DB.exptdate;'-'];
            handles.DB.expttime = [handles.DB.expttime;'-'];
            handles.DB.signal      = [handles.DB.signal; y];
            handles.DB.meanstd     = [handles.DB.meanstd; [mean(y),std(y)]];
            handles.DB.fs          = [handles.DB.fs; fresamp(k)];        
            handles.DB.flagnorm    = [handles.DB.flagnorm; -1];
            handles.DB.flagdetrend = [handles.DB.flagdetrend; -1];
            handles.DB.detrend     = [handles.DB.detrend; 1];
            handles.DB.scale       = [handles.DB.scale; 1];
            handles.DB.flagtivpsd  = [handles.DB.flagtivpsd; 0];
    
        end %end for v

    end %end for k
    
    %Add new variables to Workspace
    varind = length(handles.DB.varname);
    set(handles.listWrkspc,'String',handles.DB.varname,'Value',varind,'Enable','on');

    %Update UI controls in variable operations in Workspace
    updateVariableOperations(hObject,handles,varind);
    handles = guidata(hObject);

    %Reset shared data MoveCorr
    if strcmp(module,'MC')
        setappdata(hfigmain,'rfilename',{});
        setappdata(hfigmain,'r',{});
        setappdata(hfigmain,'lci95',{});
        setappdata(hfigmain,'uci95',{});
        if license('test','Statistics_Toolbox')
            setappdata(hfigmain,'rs',{});
            setappdata(hfigmain,'lci95s',{});
            setappdata(hfigmain,'uci95s',{});
        end
    elseif strcmp(module,'PSD') %Reset shared data PSD
        
        setappdata(hfigmain,'psdname','');
        setappdata(hfigmain,'psd',[]);
        setappdata(hfigmain,'psdfs',[]);
        setappdata(hfigmain,'psdfile','');
    end
    
    
    
    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);
    
guidata(hObject,handles);
end 

function [valid,colname] = isEditInfoValid(handlesDB,handlesEditor,row,col)
% handlesEditor --> handles of the table that is editted
% handlesDB --> handles of Data Browser
% convert java.lang.string to matlab string using char
% then convert string to lower case
jScrollPane = findjobj(handlesEditor.tableEditor);
jtable = jScrollPane.getViewport.getView;
colname = lower(char(jtable.getColumnName(col-1))); 
tabdata = get(handlesEditor.tableEditor,'Data');
switch colname
    case 'tag'
        % check operation == defineregion
        operation = tabdata{row,handlesEditor.getColId('operation','display')};
        if ~strcmp(operation,'DefineRegion')
            valid = false;
            errormsg = 'Only defineRegion tags can be changed';
            warndlg(errormsg,'Warning!','modal');
        else
            valid = true;
        end
    case {'begin','end'}
        % variables
        operation = tabdata{row,handlesEditor.getColId('operation','display')};
        begincol = handlesEditor.getColId('begin','display');
        endcol = handlesEditor.getColId('end','display');
        info = tabdata{row,col};
        % users attempt to edit cell when there is no plot.
        if isfield(handlesDB.DB,'fs') && ~isempty(handlesDB.DB.fs)
            validsignal = handlesDB.DB.fs>0;
            maxtime = max((cellfun(@length,handlesDB.DB.signal(validsignal)) - 1)./handlesDB.DB.fs(validsignal));
            disp('Attempt to edit the tag when there is no plot');
        else
            maxtime = 0;
        end
        % Check if the type of input is invalid
        if ~strcmp(operation,'DefineRegion')
            errormsg = 'Only defineRegion tags can be changed';
            valid = false;
        elseif isnan(info) || ~isnumeric(info)
            errormsg = 'Input to this field must be a number.';
            valid = false;
        elseif info<0 % Check if the range of input is invalid
            errormsg = 'Time must be greater than 0.';
            valid = false;
        elseif strcmp(colname,'begin') && info>tabdata{row,endcol}
            errormsg = 'Begin time must be smaller than End time.'; 
            valid = false;
        elseif strcmp(colname,'end') 
            if info<tabdata{row,begincol}
                errormsg = 'End time must be larger than Begin time.';
                valid = false;
            elseif maxtime == 0
                errormsg = 'Plot the signal before making changes in End column';
                valid = false;
            elseif info>maxtime
                errormsg = 'End time must be smaller than the maximum time';
                valid = false;
            else
                valid = true;
            end
            
        else 
            valid = true;
        end
        
    otherwise
        valid = true;
end
if ~valid
    warndlg(errormsg,'Warning!','modal');
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
jtable.setValueAt(value,row-1,col-1);

handles.setValflag = true;

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

function updateEditorTags(handles,newtags,varargin)
if ~isempty(newtags)
    % sort later
    handles.editorTags = [handles.editorTags;newtags]; %Add new tags the existing tags

    displaytags = [newtags(:,3),newtags(:,12),newtags(:,10:11),newtags(:,5),newtags(:,7:9),newtags(:,13:15)];
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
    set(handles.tableEditor,'Data',displaytags,'Enable','on'); %display tags users are working on
   
   if ~isempty(handles.editorTags)
        set(handles.butDeletetag,'Enable','on');
        set(handles.butSavetags,'Enable','on');
        set(handles.chkSelectAll,'Enable','on');
   else
        set(handles.butDeletetag,'Enable','off');
        set(handles.butSavetags,'Enable','off');
        set(handles.chkSelectAll,'Value',0,'Enable','off');

   end
   guidata(handles.output,handles);
end

function drawShade(handles,row,axesnum,varargin)
if ~isempty(varargin)
    tabdata = varargin{1};
else
    tabdata = handles.editorTags;
end
%Draw a shade to display the selected region     
if ~isempty(axesnum)
    xmin = tabdata{row,getColId('begin','file')}; %begin
    xmax = tabdata{row,getColId('end','file')}; %end 
    ylimit = get(handles.DB.haxes(axesnum),'Ylim');
    yrange = ylimit(2)-ylimit(1);
    ymin = min(ylimit) + 0.02*yrange;
    ymax = max(ylimit) - 0.02*yrange;
    axes(handles.DB.haxes(axesnum)); hold on;
    hshade = fill([xmin xmin xmax xmax],[ymin ymax ymax ymin],[1 1 0.8],'EdgeColor',[1 1 0.8]);
    uistack(hshade,'bottom');
    axes(handles.hmask);
end

function [axesnum] = getAxesnum(handles,row,varargin)
axesnum = [];
if ~isempty(varargin)
    tabdata = varargin{1};
else
    tabdata = handles.editorTags;
end
% Check if the selected variable is plotted
selfile = tabdata{row,getColId('filename','file')}; %filename
%% 2016-06-24
%datei = regexp(selfile,'201')+7; %Search the ending position of the exptdate
%selfile = selfile(1:datei); %Exclude Consolidated or Processed word
%%
selvar  = tabdata{row,getColId('variable','file')}; %variable
if  ~isfield(handles.DB,'axesnum') || isempty(handles.DB.axesnum)
    return
end
try
    if isfield(handles.DB,'filename') && ~isempty(handles.DB.filename)
        %% Search filename if acrostic & exptdate are matched 2016-06-24
        fileind = strfind(handles.DB.filename,selfile);
        varind  = strfind(handles.DB.varname,selvar);
        commonind = cellfun(@times,fileind,varind,'Uni',0); %multiply 2 index arrays to find the row with matching filename & varname
        ind  = find(~cellfun(@isempty,commonind)); %indices of the matching filename & varname
        if ~isempty(ind)
            ind = ind(1); %find >1 matched index, only draw a shade on in 1 subplot
            plotvarind = find(handles.DB.varindex==ind,1,'first'); %index of the selected region
            axesnum = handles.DB.axesnum(plotvarind);
            %Shade one plot (first) from that filename insread
        elseif ~isempty(fileind)
            fileind = cellfun(@(x) ~isempty(x),fileind,'UniformOutput',1);
            availableindex =  find(double(fileind)); %array
            indmemberoffile = ismember(handles.DB.varindex,availableindex); %Is there any plotted variable from the selected file
            
            axesnum = min(handles.DB.axesnum(indmemberoffile));
        end
    end
catch
    warning('Unavailable plots');
    return
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

dispHeader = {'select','acrostic','tag','begin','end','exptdate','variable','side','fs','operation','operationtag','value'};
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
    
  

function lineMarkerCallback(src,evt)
    delete(src);





% --- Executes when user attempts to close figMain.
function figMain_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
    close(handles.TagManager);
    % Delete active submodules
    if ~isempty(handles.subMovingCorrelation)
        close(handles.subMovingCorrelation);
    end
    if ~isempty(handles.subStationaryPSD)
        close(handles.subStationaryPSD);
    end
    
    if ~isempty(handles.subTVPSD)
        close(handles.subTVPSD);
    end
    
    if ~isempty(handles.subFEX)
        close(handles.subFEX); %Call figFEX_CloseRequestFcn
    end
    
    
    %Close all settings
    obj = findobj('Tag','DataBrowser_Templatesetting');
    if ~isempty(obj)
        close(obj);
    end
    
    %Close all settings
    obj = findobj('Tag','sub_b2b');
    if ~isempty(obj)
        close(obj);
    end
    

    
catch
    warning('Cannot delete one of the sub modules');
end
   
delete(hObject);


% --- Executes on button press in butTagManager.
function butTagManager_Callback(hObject, eventdata, handles)
% hObject    handle to butTagManager (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% update Tag Manager
handlesTM = guidata(handles.TagManager); 
set(handlesTM.tableEditor,'Data',{});
handlesTM.editorTags = [];

data = get(handles.tableEditor,'Data'); %Get data from the tag table in main_databrowser

if ~isempty(data)
    checkbox = data(:,1);
    handlesTM.updateEditorTags(handlesTM,handles.editorTags,checkbox);
end

% set checkbox
set(handlesTM.output,'Visible','on');
set(handlesTM.tableEditor,'Visible','on','Enable','on');

% Disable Tag Editor in DB
set(handles.tableEditor,'Visible','off','Enable','off');
% 1. remove filter
%removeFilter(handles);
guidata(hObject,handles);





% --- Executes on button press in chkSelectAll.
function chkSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to chkSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSelectAll
tabdata = get(handles.tableEditor,'Data');
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
set(handles.tableEditor,'Data',tabdata);
guidata(hObject,handles);



function editStudyNote_Callback(hObject, eventdata, handles)
% hObject    handle to editStudyNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStudyNote as text
%        str2double(get(hObject,'String')) returns contents of editStudyNote as a double


% --- Executes during object creation, after setting all properties.
function editStudyNote_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStudyNote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butInsertEvent.
function butInsertEvent_Callback(hObject, eventdata, handles)
% hObject    handle to butInsertEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Get x-position of the line relative to the old xlimit
%Insert event without vertical guide
hguidestatus = get(handles.DB.vertguide.hl,'Visible');

if strcmpi(hguidestatus,'on')
    pt = get(handles.DB.vertguide.hl,'XData'); %value in relation to the old xlimit
    ptnew = pt(1);
else
    ptnew =  0;
    
end
prompt = {'Time(sec)','Free Text','Level1','Level2'};
dlg_title = 'Insert Event';
num_lines = 1;
def = {num2str(ptnew,'%.2f'),'','',''};
answer = inputdlg(prompt,dlg_title,num_lines,def);

if isempty(answer)
    return;
end

%Insert into handles.DB.event
eventtime = cell2mat(handles.DB.events(:,1));
loc = find(eventtime>=str2double(answer{1}),1,'first');
newrow = {str2double(answer{1}),answer{2},answer{3},answer{4}};

if ~isempty(loc)
    if loc==1
        handles.DB.events = [newrow;handles.DB.events];
    else
        tempevent1 = handles.DB.events(1:loc-1,:);
        tempevent2 = handles.DB.events(loc:end,:);
        handles.DB.events = [tempevent1;newrow;tempevent2];
    end
    %Update Table
    
else %less than
    handles.DB.events = [handles.DB.events;newrow];
    %         loc = length(handles.DB.events);
end

markerdata = cell(length(handles.DB.events(:,1)),1);
markerdata(:,1) = {'off'};
checkbox = num2cell(true(length(handles.DB.events(:,1)),1));

%Set new event
set(handles.tableEvents,'Data',[checkbox,markerdata,handles.DB.events],'Enable','on');
guidata(hObject,handles);


% --- Executes on button press in butDeleteEvent.
function butDeleteEvent_Callback(hObject, eventdata, handles)
% hObject    handle to butDeleteEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);


% --- Executes on button press in butSaveEvents.
function butSaveEvents_Callback(hObject, eventdata, handles)
% hObject    handle to butSaveEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.tableEvents,'Data');
cselect = 1;
%select size = # rows -->logical array
select = cellfun(@(x) x==1, data(:,cselect), 'UniformOutput', 1); %row indices
if any(select)
    load(fullfile(handles.DB.inputpath,handles.DB.inputfile),'event');
    exportevent.sec = handles.DB.events(select,1);
    temp = handles.DB.events(select,3);
    if any(cellfun(@(x) ~isempty(x),temp,'UniformOutput',1)) %Check if they are all empty
        exportevent.level_1 = temp;
    else
        exportevent.level_1 = {};
    end
    temp = handles.DB.events(select,4);
    if any(cellfun(@(x) ~isempty(x),temp,'UniformOutput',1)) %Check if they are all empty
        exportevent.level_2 = temp;
    else
        exportevent.level_2 = {};
    end
    exportevent.freeTxt = handles.DB.events(select,2);
    exportevent.freeTxt_raw = event.freeTxt_raw;
    
    % get the selected file/path from users
    [file,path] = uiputfile('event.mat','Save Events into .mat variable');
    if ischar(file) && ischar(path)
        save(fullfile(path,file),'-struct','exportevent');
    end  
else
    warndlg('There are no events to save','Warning');
end




guidata(hObject,handles);


% --- Executes on button press in butOpenEvents.
function butOpenEvents_Callback(hObject, eventdata, handles)
% hObject    handle to butOpenEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[inputfile,inputpath] = uigetfile('*.mat','Select an EVENT MAT-file');
if ~ischar(inputfile)
    return %return if choosing invalid file
end

eventvar = load(fullfile(inputpath,inputfile));
eventfields = fields(eventvar);
event = eval(['eventvar.',eventfields{1}]);
freeTxt = [];
level_1 = [];
level_2 = [];
sec = [];
if isfield(event,'freeTxt')
    freeTxt = event.freeTxt;
end

if isfield(event,'level_1')
    level_1 = event.level_1;
end
if isfield(event,'level_2')
    level_2 = event.level_2;
end

if isfield(event,'sec')
    sec = event.sec;
end

if isempty(level_1)
    level_1 = cell(length(sec),1);
end
if isempty(level_2)
    level_2 = cell(length(sec),1);
end
handles.DB.events = [sec,freeTxt,level_1,level_2];
markerdata = cell(length(handles.DB.events(:,1)),1);
markerdata(:,1) = {'off'};
checkbox = num2cell(true(length(handles.DB.events(:,1)),1));
%Set new event
set(handles.tableEvents,'Data',[checkbox,markerdata,handles.DB.events],'Enable','on');

guidata(hObject,handles);
handles = guidata(hObject);

guidata(hObject,handles);





% --------------------------------------------------------------------
function toolVerticalGuide_push_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolVerticalGuide_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Take no action (return) if nothing is plotted
if ~isfield(handles.DB,'haxes') || isempty(handles.DB.haxes)
    return
end

hguidestatus = get(handles.DB.vertguide.hl,'Visible');
if strcmpi(hguidestatus,'off') % Make it visible
    xlimit = get(handles.hmask,'XLim');
    xrange = xlimit(2)-xlimit(1);
    pt = min(xlimit) + xrange/2;
    set(handles.DB.vertguide.hl,'XData',pt(1)*[1 1]);
    set(handles.DB.vertguide.hl,'Visible','on');
else
   set(handles.DB.vertguide.hl,'Visible','off');
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function toolZoomin_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolZoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'toolzoom') && isvalid(handles.toolzoom)
    handles.toolzoom.Enable = 'on';
    handles.toolzoom.Motion = 'both';
    handles.toolzoom.direction = 'in';

else
    h = zoom;
    h.ActionPreCallback = @myprecallback;
    h.ActionPostCallback = @mypostcallback;
    h.Enable = 'on';
    h.Motion = 'both';
    handles.toolzoom = h;
end

guidata(hObject,handles);






% --------------------------------------------------------------------
function toolZoomout_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolZoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'toolzoom') && isvalid(handles.toolzoom)
    handles.toolzoom.Enable = 'on';
    handles.toolzoom.Motion = 'both';
    handles.toolzoom.direction = 'out';

else
    h = zoom;
    h.ActionPreCallback = @myprecallback;
    h.ActionPostCallback = @mypostcallback;
    h.Enable = 'on';
    h.Motion = 'both';
    h.direction = 'out';
    handles.toolzoom = h;
end

guidata(hObject,handles);



% --------------------------------------------------------------------
function toolPan_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolPan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'toolpanmodifled') && isvalid(handles.toolpanmodified)
    handles.toolpanmodified.Enable = 'on';
    handles.toolpanmodified.Motion = 'both';

else
    h = pan;
    h.ActionPreCallback = @myprecallback;
    h.ActionPostCallback = @mypostcallback;
    h.Enable = 'on';
    h.Motion = 'both';
    handles.toolpanmodified = h;
    setAxesPanMotion(h,handles.hmask,'horizontal');
end
guidata(hObject,handles);




% --------------------------------------------------------------------
function toolDataCursor_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolDataCursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Comment out by Toey 27Oct2017
%{
if isfield(handles.DB,'haxes') && ~isempty(handles.DB.haxes)
    ind = find(isgraphics(handles.DB.haxes),1,'first');
    if ~isempty(ind)       %Remove vertical guide
       %{
        if isfield(handles.DB,'vertguide') && isfield(handles.DB.vertguide,'hl') && ~isempty(handles.DB.vertguide.hl),
            ind = isgraphics(handles.DB.vertguide.hl);
            if ~isempty(ind)
                delete(handles.DB.vertguide.hl(ind));
                handles.DB = rmfield(handles.DB,'vertguide');
            end
       end 
        %}
       set(handles.DB.vertguide.hl,'Visible','off');
       uistack(handles.hmask,'bottom');
       
    end

end
%Set context menus
setContextMenus(hObject,handles);
handles = guidata(hObject);
guidata(hObject,handles);
%}


% --------------------------------------------------------------------
function toolSelectRegion_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolSelectRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function toolZoomin_OffCallback(hObject, eventdata, handles)
% hObject    handle to toolZoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.hmask);
guidata(hObject,handles);

function editFromToJMP_Callback(hObject, eventdata, handles)
% hObject    handle to editFromToJMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFromToJMP as text
%        str2double(get(hObject,'String')) returns contents of editFromToJMP as a double
if isempty(get(handles.editFromToJMP,'String'))
    return
end

timeinput = str2double(get(handles.editFromToJMP,'String'));

    
if isnan(timeinput) 
    %warning
    msgbox('Please enter the begining time & end time','Warning','warn');
    return;
end

lookAt(handles,timeinput);
handles = guidata(hObject);
get(handles.xslider,'Value')
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editFromToJMP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFromToJMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butJMP.
function butJMP_Callback(hObject, eventdata, handles)
% hObject    handle to butJMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%        str2double(get(hObject,'String')) returns contents of editFromToJMP as a double
if isempty(get(handles.editFromToJMP,'String'))
    return
end

timeinput = str2double(get(handles.editFromToJMP,'String'));

    
if isnan(timeinput) 
    %warning
    msgbox('Please enter the begining time & end time','Warning','warn');
    return;
end

lookAt(handles,timeinput);
handles = guidata(hObject);
guidata(hObject,handles);


function myprecallback(obj,evd) %Use this to move hmask to top and bottom
handles = guidata(obj);
uistack(handles.hmask,'bottom');



function mypostcallback(obj,evd)
handles = guidata(obj);
uistack(handles.hmask,'top');


% --------------------------------------------------------------------
function toolZoomin_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolZoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function toolZoomin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toolZoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --------------------------------------------------------------------
function toolprogram_zoomIn_OffCallback(hObject, eventdata, handles)
% hObject    handle to toolprogram_zoomIn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function toolEditPlot_OnCallback(hObject, eventdata, handles)
% hObject    handle to toolEditPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    %Disable other tools



% --------------------------------------------------------------------
function toolEditPlot_OffCallback(hObject, eventdata, handles)
% hObject    handle to toolEditPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function toolPan_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolPan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menuB2B_Callback(hObject, eventdata, handles)
% hObject    handle to menuB2B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);


% %Call GUI function in new window to compute moving correlation
%Close all settings
obj = findobj('Tag','sub_b2b');
if ~isempty(obj)
    figure(obj);
else
    sub_B2B('DataBrowser',handles.output);
end


handles = guidata(hObject);
guidata(hObject, handles); %update handles structure
