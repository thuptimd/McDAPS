function varargout = subfex_analyzesetting(varargin)
% SUBFEX_ANALYZESETTING MATLAB code for subfex_analyzesetting.fig
%      SUBFEX_ANALYZESETTING, by itself, creates a new SUBFEX_ANALYZESETTING or raises the existing
%      singleton*.
%
%      H = SUBFEX_ANALYZESETTING returns the handle to a new SUBFEX_ANALYZESETTING or the handle to
%      the existing singleton*.
%
%      SUBFEX_ANALYZESETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUBFEX_ANALYZESETTING.M with the given input arguments.
%
%      SUBFEX_ANALYZESETTING('Property','Value',...) creates a new SUBFEX_ANALYZESETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before subfex_analyzesetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to subfex_analyzesetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help subfex_analyzesetting

% Last Modified by GUIDE v2.5 04-Jun-2020 12:46:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @subfex_analyzesetting_OpeningFcn, ...
                   'gui_OutputFcn',  @subfex_analyzesetting_OutputFcn, ...
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


% --- Executes just before subfex_analyzesetting is made visible.
function subfex_analyzesetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to subfex_analyzesetting (see VARARGIN)

% Choose default command line output for subfex_analyzesetting
handles.output = hObject;
if ~isdeployed
    handles.subfexanalyzepath = mfilename('fullpath');
    %Setting path
    handles.subfexanalyzepath  = fileparts(handles.subfexanalyzepath);
    handles.subfexanalyzepath  = fileparts(handles.subfexanalyzepath);
    handles.subfexanalyzepathsettingpath = fullfile(handles.subfexanalyzepath,'Setting');
else    
    handles.subfexanalyzepathsettingpath = which('fexsetting.mat');
end




%Setting Analyzer
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'descriptiveflag');
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'descriptivename');
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'curvefittingtype');
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'analysisregion');
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'sigmoidcurve');
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'polycurve');
load(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'expocurve');






handles.subfexanalyze.descriptiveflag = descriptiveflag;
handles.subfexanalyze.descriptivename = descriptivename;

set(handles.chkFexsettingDescriptive_Variance,'Value',descriptiveflag(1));
set(handles.chkFexsettingDescriptive_Mean,'Value',descriptiveflag(2)); 
set(handles.chkFexsettingDescriptive_Median,'Value',descriptiveflag(3)); 
set(handles.chkFexsettingDescriptive_Min,'Value',descriptiveflag(4)); 
set(handles.chkFexsettingDescriptive_Max,'Value',descriptiveflag(5)); 
set(handles.chkFexsettingDescriptive_Area,'Value',descriptiveflag(6)); 
set(handles.chkFexsettingDescriptive_Duration,'Value',descriptiveflag(7)); 
set(handles.chkFexsettingDescriptive_95Maxflow,'Value',descriptiveflag(8)); 

set(handles.chkFexsettingDescriptive_Vasoc,'Value',descriptiveflag(10)); 


%% Save curve fitting - setting
handles.enablecurvefitting = descriptiveflag(9);
handles.polycurve.order = polycurve.order;
handles.expocurve.scaling = expocurve.scaling;
handles.expocurve.timeconstant = expocurve.timeconstant;
handles.sigmoidcurve.upperoption = sigmoidcurve.upperoption;
handles.sigmoidcurve.loweroption = sigmoidcurve.loweroption;
handles.sigmoidcurve.upperprctile = sigmoidcurve.upperprctile;
handles.sigmoidcurve.upperenter = sigmoidcurve.upperenter;
handles.sigmoidcurve.lowerprctile = sigmoidcurve.lowerprctile;
handles.sigmoidcurve.lowerenter = sigmoidcurve.lowerenter;
handles.analysisregion = analysisregion;


%% init
%figure
if ispc
    fntsize = 10;
else
    fntsize = 14;
end
figw = 720; %in pixels
figh = 560; %in pixels
left_margin = 40; %in pixels
top_margin = 30; % in pixels
but_panel_width = 100;
but_panel_height =35;

but_width = 80;
but_height = 21.6;
txt_height = 21.6;
txt_width = 100;
txt_par_width = 130;
space_between_panels = 15; %Normalized unit, 0.001
space_between_objects = 1.5; %Normalized unit=0.005, 0.72 pixel
space_between_lines = 8;

set(handles.subfex_analyzesetting,'Unit','pixels','Position',[100 100 figw figh]);

%% Button location
xpos = 1-but_width/figw-left_margin/figw; %Margin away from the right
ypos = top_margin/figh+but_height/figh; %Margin away from the bottom
%butApply
set(handles.butApply,'Unit','normalized','Position',[xpos ypos but_width/figw but_panel_height/figh],...
    'String','Apply','FontSize',fntsize,'Enable','on');

%% Change background color
xpos = left_margin/figw;
ypos = 1-top_margin/figh-but_height/figh;
set(handles.butDescriptives_panel,'Enable','inactive','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor',[0.502 0.502 0.502],...
    'Unit','normalized','Position',[xpos ypos but_panel_width/figw but_panel_height/figh],...
    'FontSize',fntsize,'String','Descriptive'); %Descriptives button becomes inactive, it is the current panel

xpos = handles.butDescriptives_panel.Position(1)+but_panel_width/figw+space_between_objects/figw;
ypos = handles.butDescriptives_panel.Position(2);
set(handles.butCurveFitting_panel,'Enable','on','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor',[0 0 0],...
    'Unit','normalized','Position',[xpos ypos but_panel_width/figw but_panel_height/figh],...
    'FontSize',fntsize,'String','Curve Fitting'); %Curve fitting button is enabled. [0.94 0.94 0.94]

%% Panel location
xpos = handles.butDescriptives_panel.Position(1);
panel_nmlheight = handles.butDescriptives_panel.Position(2)-handles.butApply.Position(4)-handles.butApply.Position(2)-top_margin/figh-space_between_objects/figh; %The panels are between butDescriptive & butApply
panel_nmlwidth = 1-2*left_margin/figw;
ypos = handles.butDescriptives_panel.Position(2)-space_between_objects/figh-panel_nmlheight;

set(handles.panelFexsettingDescriptive,'Unit','Normalized','Position',[xpos ypos panel_nmlwidth panel_nmlheight],...
    'Visible','on','Title','Descriptive','TitlePosition','centertop','FontSize',fntsize);

set(handles.panelFexsettingCurvefitting,'Visible','off','Unit','Normalized','Position',handles.panelFexsettingDescriptive.Position,...
    'Title','Curve Fitting','TitlePosition','centertop','FontSize',fntsize);

%% Objects in the panel
%Descriptive features

%chkFexsettingDescriptive_Mean
xpos = left_margin/(panel_nmlwidth*figw);
ypos = 1-left_margin/(panel_nmlheight*figh);
set(handles.chkFexsettingDescriptive_Mean,'Unit','normalized','Position',[xpos ypos txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],...
    'FontSize',fntsize,'String','Mean','HorizontalAlignment','left');

%chkFexsettingDescriptive_Median
set(handles.chkFexsettingDescriptive_Median,'Unit','normalized',...
    'String','Median',...
    'HorizontalAlignment','left',...
    'Position',[0.5 handles.chkFexsettingDescriptive_Mean.Position(2) txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);


%chkFexsettingDescriptive_Min
ypos = handles.chkFexsettingDescriptive_Mean.Position(2)-left_margin/(panel_nmlheight*figh);
set(handles.chkFexsettingDescriptive_Min,'Unit','normalized',...
    'String','Min',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Mean.Position(1) ypos txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);

%chkFexsettingDescriptive_Max
set(handles.chkFexsettingDescriptive_Max,'Unit','normalized',...
    'String','Max',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Median.Position(1) ypos txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);


ypos = handles.chkFexsettingDescriptive_Min.Position(2)-left_margin/(panel_nmlheight*figh);

%chkFexsettingDescriptive_Area
set(handles.chkFexsettingDescriptive_Area,'Unit','normalized',...
    'String','Area',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Mean.Position(1) ypos txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);

%chkFexsettingDescriptive_Duration
set(handles.chkFexsettingDescriptive_Duration,'Unit','normalized',...
    'String','Duration',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Median.Position(1) ypos txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);


ypos = handles.chkFexsettingDescriptive_Min.Position(2)-left_margin/(panel_nmlheight*figh);
%chkFexsettingDescriptive_Variance
set(handles.chkFexsettingDescriptive_Variance,'Unit','normalized',...
    'String','Coefficient of variation',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Median.Position(1) ypos 3*txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);


%chkFexsettingDescriptive_95Maxflow
ypos = handles.chkFexsettingDescriptive_Variance.Position(2)-left_margin/(panel_nmlheight*figh);
set(handles.chkFexsettingDescriptive_95Maxflow,'Unit','normalized',...
    'String','95 percentile of the maximum',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Mean.Position(1) ypos 3*txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);



%chkFexsettingDescriptive_Vasoc
set(handles.chkFexsettingDescriptive_Vasoc,'Unit','normalized',...
    'String','Mvasoc',...
    'HorizontalAlignment','left',...
    'Position',[handles.chkFexsettingDescriptive_Median.Position(1) ypos txt_width/(panel_nmlwidth*figw) txt_height/(panel_nmlheight*figh)],'FontSize',fntsize);



%Curve Fitting
%popCurvetype
popheight = but_height/(panel_nmlheight*figh);
xpos = space_between_panels/(panel_nmlwidth*figw);
ypos = 1-space_between_panels/(panel_nmlheight*figh)-popheight;
set(handles.popCurvetype,'Unit','normalized','Position',[xpos ypos 1/3 popheight],...
    'String',{'None (use a filter)','Exponential','Polynomial','Sigmoid'},...
    'FontSize',fntsize,'ForegroundColor',[0.3 0.6 0.83]);

%chkCurveFitting
xpos = handles.popCurvetype.Position(1)+handles.popCurvetype.Position(3)+space_between_panels/(panel_nmlwidth*figw);
set(handles.chkCurveFitting,'Unit','normalized',...
    'Position',[xpos ypos txt_par_width/(panel_nmlwidth*figw) popheight],...
    'FontSize',fntsize,'Value',handles.enablecurvefitting);

%% ROI panel
xpos = handles.popCurvetype.Position(1);
panel_roi_height = (panel_nmlheight*figh)-2*space_between_panels-but_height-space_between_objects;
ypos = handles.popCurvetype.Position(2)-space_between_objects/(panel_nmlheight*figh)-panel_roi_height/(panel_nmlheight*figh);
panel_roi_width = 0.5*((panel_nmlwidth*figw)-2*space_between_panels-space_between_objects); %in pixels
set(handles.panelROI_underCurveFitting,'Unit','normalized','Position',[xpos ypos panel_roi_width/(panel_nmlwidth*figw) panel_roi_height/(panel_nmlheight*figh)],...
    'Title','Analysis Region','FontSize',fntsize);




%Initial parameters panel
xpos = handles.panelROI_underCurveFitting.Position(1)+handles.panelROI_underCurveFitting.Position(3)+space_between_objects/(panel_nmlwidth*figw);
set(handles.panelInitialParameters_underCurveFitting,'Unit','normalized','Position',[xpos handles.panelROI_underCurveFitting.Position(2) panel_roi_width/(panel_nmlwidth*figw) panel_roi_height/(panel_nmlheight*figh)],...
    'Title','Initial Parameters','FontSize',fntsize,'ForegroundColor',[0.3 0.6 0.83]);

%% Objects in Initial Parameters
%% Parameter 1

xpos = (0.5*space_between_panels)/panel_roi_width;
ypos = 1-txt_height/panel_roi_height-space_between_panels/panel_roi_height;
set(handles.txt_initialPar1,'Unit','normalized','Position',[xpos ypos txt_par_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize,'HorizontalAlignment','left','FontWeight','bold');

%txtPar1_option1
xpos = 1-but_width/panel_roi_width-space_between_objects/panel_roi_width;
ypos = handles.txt_initialPar1.Position(2)-space_between_lines/panel_roi_height-txt_height/panel_roi_height;
set(handles.txtPar1_option1,'Unit','normalized','Position',[xpos ypos but_width/panel_roi_width txt_height/panel_roi_height],'FontSize',fntsize);

%xsliderPar1, I cannot change the height of the slider
xpos = handles.txt_initialPar1.Position(1)+1.5*space_between_objects/panel_roi_width;
ypos = handles.txtPar1_option1.Position(2)-(0.2*txt_height/panel_roi_height);
edit_width = 1/2*(panel_roi_width-2*but_width-2*space_between_objects-space_between_objects);
if ispc
    set(handles.xsliderPar1,'Unit','normalized','Position',[xpos handles.txtPar1_option1.Position(2) txt_width/panel_roi_width txt_height/panel_roi_height]);
else
    set(handles.xsliderPar1,'Unit','normalized','Position',[xpos ypos txt_width/panel_roi_width txt_height/panel_roi_height]);
end

%editPar1_option1
xpos = handles.txtPar1_option1.Position(1)-edit_width/panel_roi_width-space_between_objects/panel_roi_width;
set(handles.editPar1_option1,'Unit','normalized','Position',[xpos handles.txtPar1_option1.Position(2) edit_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize-2,'Enable','inactive','BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',[0.8 0.6 0.3],'String',[]);

%editPar1_option2
ypos = handles.editPar1_option1.Position(2)-handles.editPar1_option1.Position(4)-space_between_lines/panel_roi_height;
set(handles.editPar1_option2,'Unit','normalized',...
    'Position',[handles.editPar1_option1.Position(1) ypos handles.editPar1_option1.Position(3) handles.editPar1_option1.Position(4)],...
    'FontSize',fntsize-2,'String',[],'Enable','off');

%chkPar1
xpos = handles.txt_initialPar1.Position(1);
set(handles.chkPar1,'Unit','normalized','Position',[xpos handles.editPar1_option2.Position(2) txt_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize,'String','Enter value','HorizontalAlignment','left');

%% Parameter 2
xpos = handles.txt_initialPar1.Position(1);
ypos = handles.chkPar1.Position(2)-2*space_between_panels/panel_roi_height-txt_height/panel_roi_height;
set(handles.txt_initialPar2,'Unit','normalized','Position',[xpos ypos txt_par_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize,'HorizontalAlignment','left','FontWeight','bold');

xpos = handles.txtPar1_option1.Position(1);
ypos = handles.txt_initialPar2.Position(2)-space_between_lines/panel_roi_height-txt_height/panel_roi_height;
set(handles.txtPar2_option1,'Unit','normalized','Position',[xpos ypos but_width/panel_roi_width txt_height/panel_roi_height],'FontSize',fntsize);


%xsliderPar2, I cannot change the height of the slider
xpos = handles.xsliderPar1.Position(1);
ypos = handles.txtPar2_option1.Position(2)-(0.2*txt_height/panel_roi_height);
if ispc
   set(handles.xsliderPar2,'Unit','normalized','Position',[xpos handles.txtPar2_option1.Position(2) txt_width/panel_roi_width txt_height/panel_roi_height]);
else
    set(handles.xsliderPar2,'Unit','normalized','Position',[xpos ypos txt_width/panel_roi_width txt_height/panel_roi_height]);

end

%editPar2_option1
xpos = handles.txtPar2_option1.Position(1)-edit_width/panel_roi_width-space_between_objects/panel_roi_width;
set(handles.editPar2_option1,'Unit','normalized','Position',[xpos handles.txtPar2_option1.Position(2) edit_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize-2,'Enable','inactive','BackgroundColor',[0.8 0.8 0.8],'ForegroundColor',[0.8 0.6 0.3],'String',[]);


%editPar2_option2
ypos = handles.editPar2_option1.Position(2)-handles.editPar2_option1.Position(4)-space_between_lines/panel_roi_height;
set(handles.editPar2_option2,'Unit','normalized',...
    'Position',[handles.editPar2_option1.Position(1) ypos handles.editPar2_option1.Position(3) handles.editPar2_option1.Position(4)],...
    'FontSize',fntsize-2,'String',[],'Enable','off');

%chkPar2
xpos = handles.chkPar1.Position(1);
ypos = handles.editPar2_option2.Position(2);
set(handles.chkPar2,'Unit','normalized','Position',[xpos ypos txt_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize,'String','Enter value','HorizontalAlignment','left');

%% Parameter 3
xpos = handles.txt_initialPar1.Position(1);
ypos = handles.chkPar2.Position(2)-2*space_between_panels/panel_roi_height-txt_height/panel_roi_height;
set(handles.txt_initialPar3,'Unit','normalized','Position',[xpos ypos txt_par_width/panel_roi_width txt_height/panel_roi_height],...
    'FontSize',fntsize,'HorizontalAlignment','left','FontWeight','bold');

%% Parameters under ROI
groupbutton_width = panel_roi_width-2*space_between_panels;
groupbutton_height = panel_roi_height-2*space_between_panels;
xpos = (0.5*space_between_panels)/panel_roi_width;
ypos = space_between_panels/panel_roi_height;
set(handles.groupbutton_roi,'Unit','normalized','Position',[xpos ypos groupbutton_width/panel_roi_width groupbutton_height/panel_roi_height],...
    'BackgroundColor',[0.94 0.94 0.94],'BorderType','none',...
    'Title',[],'FontSize',fntsize);

%radiobut_roioption1
temp = handles.txt_initialPar1.Position;
temp(3) =2*temp(3);
set(handles.radiobut_roioption1,'Unit','normalized','Position', temp,...
'FontSize',fntsize,'FontWeight','normal','BackgroundColor',[0.94 0.94 0.94],'String','Entire segment');

%radiobut_roioption2
temp = handles.txt_initialPar2.Position;
temp(3) =2*temp(3);
set(handles.radiobut_roioption2,'Unit','normalized','Position',temp,...
'FontSize',fntsize,'FontWeight','normal','BackgroundColor',[0.94 0.94 0.94],'String','Percentile ranks');

%txt_radiobut_roioption2
xpos = handles.radiobut_roioption2.Position(1)+2*space_between_panels/groupbutton_width;
ypos = handles.radiobut_roioption2.Position(2)-space_between_panels/groupbutton_height-2*txt_height/groupbutton_height;
set(handles.txt_radiobut_roioption2,'Unit','normalized','Position',[xpos ypos txt_width/groupbutton_width 2*txt_height/groupbutton_height],...
    'FontSize',fntsize-2,'Backgroundcolor',[0.94 0.94 0.94],'Foregroundcolor',[0 0 0],'String',{'Fit between', '(%tile)'},'HorizontalAlignment','left');

%editFrom_radiobut_roioption2
xpos = handles.txt_radiobut_roioption2.Position(1)+handles.txt_radiobut_roioption2.Position(3);
ypos = ypos+0.5*txt_height/groupbutton_height;
set(handles.editFrom_radiobut_roioption2,'Unit','normalized','Position',[xpos ypos 0.5*edit_width/groupbutton_width txt_height/groupbutton_height],...
    'FontSize',fntsize-2,'String',num2str(analysisregion.prctile1),'Enable','off');

%editTo_radiobut_roioption2
xpos = handles.editFrom_radiobut_roioption2.Position(1)+handles.editFrom_radiobut_roioption2.Position(3)+space_between_objects/groupbutton_width;
set(handles.editTo_radiobut_roioption2,'Unit','normalized','Position',[xpos ypos 0.5*edit_width/groupbutton_width txt_height/groupbutton_height],...
    'FontSize',fntsize-2,'String',num2str(analysisregion.prctile2),'Enable','off');

%% Keep the positions of the objects
handles.objposition.txt_initialPar1 = handles.txt_initialPar1.Position;
handles.objposition.txt_initialPar2 = handles.txt_initialPar2.Position;


%% Set the layout to match the setting
set(handles.popCurvetype,'Value',curvefittingtype);

popCurvetype_Callback(handles.popCurvetype, eventdata, handles);
handles = guidata(hObject);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes subfex_analyzesetting wait for user response (see UIRESUME)
% uiwait(handles.subfex_analyzesetting);


% --- Outputs from this function are returned to the command line.
function varargout = subfex_analyzesetting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chkFexsettingDescriptive_Duration.
function chkFexsettingDescriptive_Duration_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Duration


% --- Executes on button press in chkFexsettingDescriptive_Area.
function chkFexsettingDescriptive_Area_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Area


% --- Executes on button press in chkFexsettingDescriptive_Mean.
function chkFexsettingDescriptive_Mean_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Mean


% --- Executes on button press in chkFexsettingDescriptive_Median.
function chkFexsettingDescriptive_Median_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Median (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Median


% --- Executes on button press in chkFexsettingDescriptive_Min.
function chkFexsettingDescriptive_Min_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Min


% --- Executes on button press in chkFexsettingDescriptive_Max.
function chkFexsettingDescriptive_Max_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Max


% --- Executes on button press in chkFexsettingDescriptive_95Maxflow.
function chkFexsettingDescriptive_95Maxflow_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_95Maxflow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_95Maxflow



% --- Executes on button press in fexanalyze_checkdefault.
function fexanalyze_checkdefault_Callback(hObject, eventdata, handles)
% hObject    handle to fexanalyze_checkdefault (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fexanalyze_checkdefault


% --- Executes when user attempts to close subfex_analyzesetting.
function subfex_analyzesetting_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to subfex_analyzesetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure



delete(hObject);








% --- Executes on button press in chkFexsettingDescriptive_Variance.
function chkFexsettingDescriptive_Variance_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Variance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Variance





% --- Executes on button press in butDescriptives_panel.
function butDescriptives_panel_Callback(hObject, eventdata, handles)
% hObject    handle to butDescriptives_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Change background color
set(hObject,'BackgroundColor',[0.94 0.94 0.94],'Enable','inactive','ForegroundColor',[0.502 0.502 0.502]);
set(handles.butCurveFitting_panel,'BackgroundColor',[0.94 0.94 0.94],'Enable','on','ForegroundColor',[0 0 0]);

%% Show descriptives_panel
set(handles.panelFexsettingDescriptive,'Visible','on');
set(handles.panelFexsettingCurvefitting,'Visible','off');

guidata(hObject,handles);

% --- Executes on button press in butCurveFitting_panel.
function butCurveFitting_panel_Callback(hObject, eventdata, handles)
% hObject    handle to butCurveFitting_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Change background color
set(hObject,'BackgroundColor',[0.94 0.94 0.94],'Enable','inactive','ForegroundColor',[0.502 0.502 0.502]);
set(handles.butDescriptives_panel,'Enable','on','BackgroundColor',[0.94 0.94 0.94],'ForegroundColor',[0 0 0]);

%% Show Curve fitting panel
set(handles.panelFexsettingDescriptive,'Visible','off');
set(handles.panelFexsettingCurvefitting,'Visible','on');
guidata(hObject,handles)


% --- Executes on selection change in popCurvetype.
function popCurvetype_Callback(hObject, eventdata, handles)
% hObject    handle to popCurvetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popCurvetype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popCurvetype
% positions
%% When users change the curvetype, show corresponding parameters
curvetype = get(hObject,'Value');
switch curvetype
    case 1 %None
        set(handles.panelInitialParameters_underCurveFitting,'Visible','off'); %No initial parameters for None option

    case 2 %Exponential
         %Visible objects
         set(handles.panelInitialParameters_underCurveFitting,'Visible','on');
         set(handles.txt_initialPar1,'String','Scaling factor','Visible','on','Position', [handles.txt_initialPar1.Position(1) handles.txtPar1_option1.Position(2) handles.txt_initialPar1.Position(3) handles.txt_initialPar1.Position(4)]);
         set(handles.txt_initialPar2,'String',{'Time constant','(seconds)'},'Visible','on',...
             'Position',[handles.txt_initialPar2.Position(1) handles.txtPar2_option1.Position(2) handles.txt_initialPar2.Position(3) handles.txt_initialPar2.Position(4)]);
         set(handles.editPar1_option2,'Visible','on','Enable','off','String',num2str(handles.expocurve.scaling));
         set(handles.editPar2_option2,'Visible','on','Enable','off','String',num2str(handles.expocurve.timeconstant));
        
         set(handles.chkPar1,'Visible','on','Value',0);
         set(handles.chkPar2,'Visible','on','Value',0);
         
        %Invisible objects
        set(handles.txtPar1_option1,'Visible','off');
        set(handles.txtPar2_option1,'Visible','off');
        set(handles.txt_initialPar3,'Visible','off');      
        set(handles.editPar1_option1,'Visible','off');
        set(handles.editPar2_option1,'Visible','off');
        set(handles.xsliderPar1,'Visible','off');
        set(handles.xsliderPar2,'Visible','off');


         
         %Invisible objects
    case 3 %Polynomial
       
        %Visible texts, objects
        set(handles.panelInitialParameters_underCurveFitting,'Visible','on');
        set(handles.txt_initialPar1,'String','Polynomial order','Visible','on','Position',handles.objposition.txt_initialPar1);        
        set(handles.txtPar1_option1,'Visible','on','String','Order','HorizontalAlignment','left');
        %Calculate sliderstep
        maxorder = 10; minorder = 1;
        smallstep = 1/(maxorder-minorder); %always one but adjusted to the range
        set(handles.xsliderPar1,'Visible','on','Max',10,'Min',1,'Sliderstep',[smallstep smallstep],'Value',handles.polycurve.order)%Poly order uses slider bar
        set(handles.editPar1_option1,'Visible','on','String',num2str(handles.polycurve.order));

        
       
        %Invisible objects
        set(handles.txt_initialPar2,'Visible','off');
        set(handles.txt_initialPar3,'Visible','off');      
        set(handles.txtPar2_option1,'Visible','off');
        set(handles.chkPar1,'Visible','off');
        set(handles.chkPar2,'Visible','off');
        set(handles.editPar1_option2,'Visible','off');
        set(handles.xsliderPar2,'Visible','off');
        set(handles.editPar2_option1,'Visible','off');
        set(handles.editPar2_option2,'Visible','off');

    case 4 %Sigmoid
        %Texts
        set(handles.panelInitialParameters_underCurveFitting,'Visible','on');
        set(handles.txt_initialPar1,'String','Upper plateau','Position',handles.objposition.txt_initialPar1);
        set(handles.txt_initialPar2,'String','Lower plateau','Visible','on','Position',handles.objposition.txt_initialPar2);
        set(handles.txt_initialPar3,'String','Slope','Visible','off');
        set(handles.txtPar1_option1,'String','percentile','Visible','on','HorizontalAlignment','left');
        set(handles.txtPar2_option1,'String','percentile','Visible','on','HorizontalAlignment','left');
        
        %Input objects
        set(handles.xsliderPar1,'Visible','on','Max',1,'Min',0,'Sliderstep',[0.01 0.1],'Value',0.01*handles.sigmoidcurve.upperprctile); %Percentile
        set(handles.xsliderPar2,'Visible','on','Max',1,'Min',0,'Sliderstep',[0.01 0.1],'Value',0.01*handles.sigmoidcurve.lowerprctile); %Percentile
        set(handles.editPar1_option1,'Visible','on','String',num2str(handles.sigmoidcurve.upperprctile),'Enable','inactive');
        set(handles.editPar2_option1,'Visible','on','String',num2str(handles.sigmoidcurve.lowerprctile),'Enable','inactive');
        
        set(handles.editPar1_option2,'Visible','on','String',num2str(handles.sigmoidcurve.upperenter),'Enable','off');
        set(handles.editPar2_option2,'Visible','on','String',num2str(handles.sigmoidcurve.lowerenter),'Enable','off');
        
        set(handles.chkPar1,'Visible','on','Value',handles.sigmoidcurve.upperoption);
        set(handles.chkPar2,'Visible','on','Value',handles.sigmoidcurve.loweroption);

        
        
    
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popCurvetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popCurvetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butApply.
function butApply_Callback(hObject, eventdata, handles)
% hObject    handle to butApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Apply changes to the analysis setting but do not close the analyze window
% 

descriptiveflag = zeros(1,15);
descriptiveflag(1) = get(handles.chkFexsettingDescriptive_Variance,'Value'); %Change to coefficient of variation on 4Jun2020
descriptiveflag(2) = get(handles.chkFexsettingDescriptive_Mean,'Value');
descriptiveflag(3) = get(handles.chkFexsettingDescriptive_Median,'Value');
descriptiveflag(4) = get(handles.chkFexsettingDescriptive_Min,'Value');
descriptiveflag(5) = get(handles.chkFexsettingDescriptive_Max,'Value');
descriptiveflag(6) = get(handles.chkFexsettingDescriptive_Area,'Value');
descriptiveflag(7) = get(handles.chkFexsettingDescriptive_Duration,'Value');
descriptiveflag(8) = get(handles.chkFexsettingDescriptive_95Maxflow,'Value');



descriptiveflag(9) = get(handles.chkCurveFitting,'Value');
descriptiveflag(10) = get(handles.chkFexsettingDescriptive_Vasoc,'Value'); %mvasoc

%% Curve fitting
%Analysis region
prctile1 = str2double(get(handles.editFrom_radiobut_roioption2,'String'));
prctile2 = str2double(get(handles.editTo_radiobut_roioption2,'String'));
if ~(isnan(prctile1) && isnan(prctile2))
    analysisregion.prctile1 = prctile1;
    analysisregion.prctile2 = prctile2;
    
    if get(handles.radiobut_roioption1,'Value')
        analysisregion.option = 1;
    elseif get(handles.radiobut_roioption2,'Value')
        analysisregion.option = 2;
        
    end
    save(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'analysisregion','-append');

end



%Get curve type
c = get(handles.popCurvetype,'Value');
switch c
    case 1 %None
        curvefittingtype = 1;
    case 2 %Exponential decay
        curvefittingtype = 2;
    case 3 %Polynomial
        curvefittingtype = 3;
    case 4 %Sigmoid
        curvefittingtype = 4;

end

save(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'descriptiveflag','-append');
save(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'curvefittingtype','-append');

%Initial parameters
polycurve.order = handles.polycurve.order;
expocurve.scaling = handles.expocurve.scaling;
expocurve.timeconstant = handles.expocurve.timeconstant;
sigmoidcurve.upperprctile = handles.sigmoidcurve.upperprctile;
sigmoidcurve.upperenter = handles.sigmoidcurve.upperenter;
sigmoidcurve.lowerprctile = handles.sigmoidcurve.lowerprctile;
sigmoidcurve.lowerenter = handles.sigmoidcurve.lowerenter; 
sigmoidcurve.upperoption = handles.sigmoidcurve.upperoption;
sigmoidcurve.loweroption = handles.sigmoidcurve.loweroption;

save(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'polycurve','-append');
save(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'expocurve','-append');
save(fullfile(handles.subfexanalyzepathsettingpath,'fexsetting.mat'),'sigmoidcurve','-append');



% --- Executes on slider movement.
function xsliderPar1_Callback(hObject, eventdata, handles)
% hObject    handle to xsliderPar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
curvetype = get(handles.popCurvetype,'Value');
switch curvetype
    case 3 %Poly
        value = round(get(hObject,'Value'));
        handles.polycurve.order = value;
    case 4 %Sigmoid
        value = round(100*get(hObject,'Value'));
        handles.sigmoidcurve.upperprctile = value;

    otherwise
        return
end

set(handles.editPar1_option1,'String',num2str(value),'Enable','inactive');
guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function xsliderPar1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xsliderPar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editPar1_option2_Callback(hObject, eventdata, handles)
% hObject    handle to editPar1_option2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPar1_option2 as text
%        str2double(get(hObject,'String')) returns contents of editPar1_option2 as a double
if isempty(get(handles.editPar1_option2,'String'))
    return
end

userinput = str2double(get(handles.editPar1_option2,'String'));
curvetype = get(handles.popCurvetype,'Value');
    
if isnan(userinput) 
    %warning
    msgbox('Please enter time in seconds','Warning','warn');
    set(hObject,'String',[]);
    return;
else
   %Save the value
   switch curvetype
       case 2 %Expo
              handles.expocurve.scaling = userinput;
       case 4 %Sigmoid
              handles.sigmoidcurve.upperenter = userinput;  
              handles.sigmoidcurve.upperoption = 1;
   end

    
    
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editPar1_option2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPar1_option2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPar1_option1_Callback(hObject, eventdata, handles)
% hObject    handle to editPar1_option1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPar1_option1 as text
%        str2double(get(hObject,'String')) returns contents of editPar1_option1 as a double


% --- Executes during object creation, after setting all properties.
function editPar1_option1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPar1_option1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkPar1.
function chkPar1_Callback(hObject, eventdata, handles)
% hObject    handle to chkPar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkPar1
curvetype = get(handles.popCurvetype,'Value');

if get(hObject,'Value')
    %Enable Edit Box, editPar1_option2
    set(handles.editPar1_option2,'Enable','on');
    if curvetype==4
        handles.sigmoidcurve.upperoption = 1;
    end
        
    
else
    set(handles.editPar1_option2,'Enable','off');
    if curvetype==4
        handles.sigmoidcurve.upperoption = 0;
    end
    
end
guidata(hObject,handles);


% --- Executes on slider movement.
function xsliderPar2_Callback(hObject, eventdata, handles)
% hObject    handle to xsliderPar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

value = round(100*get(hObject,'Value'));
handles.sigmoidcurve.lowerprctile = value;

set(handles.editPar2_option1,'String',num2str(value),'Enable','inactive');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xsliderPar2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xsliderPar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function editPar2_option2_Callback(hObject, eventdata, handles)
% hObject    handle to editPar2_option2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPar2_option2 as text
%        str2double(get(hObject,'String')) returns contents of editPar2_option2 as a double
if isempty(get(handles.editPar2_option2,'String'))
    return
end

userinput = str2double(get(handles.editPar2_option2,'String'));
curvetype = get(handles.popCurvetype,'Value');
    
if isnan(userinput) 
    %warning
    msgbox('Please enter time in seconds','Warning','warn');
    set(hObject,'String',[]);
    return;
else
    switch curvetype
        case 2 %Expo
           handles.expocurve.timeconstant = userinput;

            
        case 4 %Sigmoid
           handles.sigmoidcurve.lowerenter = userinput;  
           handles.sigmoidcurve.loweroption = 1; %Use user input


    end

    
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editPar2_option2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPar2_option2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPar2_option1_Callback(hObject, eventdata, handles)
% hObject    handle to editPar2_option1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPar2_option1 as text
%        str2double(get(hObject,'String')) returns contents of editPar2_option1 as a double
value = 100*get(hObject,'Value');
set(handles.editPar2_option1,'String',num2str(value),'Enable','inactive');
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editPar2_option1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPar2_option1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkPar2.
function chkPar2_Callback(hObject, eventdata, handles)
% hObject    handle to chkPar2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkPar2
curvetype = get(handles.popCurvetype,'Value');

if get(hObject,'Value')
    %Enable Edit Box, editPar1_option2
    set(handles.editPar2_option2,'Enable','on');
    if curvetype==4
        handles.sigmoidcurve.loweroption = 1;
    end
else
    set(handles.editPar2_option2,'Enable','off');
    if curvetype==4
        handles.sigmoidcurve.loweroption = 0;
    end
end
guidata(hObject,handles);



function editFrom_radiobut_roioption2_Callback(hObject, eventdata, handles)
% hObject    handle to editFrom_radiobut_roioption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFrom_radiobut_roioption2 as text
%        str2double(get(hObject,'String')) returns contents of editFrom_radiobut_roioption2 as a double

if isempty(get(handles.editFrom_radiobut_roioption2,'String'))
    return
end

prctileinput = str2double(get(handles.editFrom_radiobut_roioption2,'String'));

    
if isnan(prctileinput) 
    %warning
    msgbox('Please enter a valid percentile','Warning','warn');
    set(hObject,'String',[]);
    return;
else
   handles.analysisregion.prctile1 = prctileinput;

end

guidata(hObject,handles)
% --- Executes during object creation, after setting all properties.
function editFrom_radiobut_roioption2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFrom_radiobut_roioption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTo_radiobut_roioption2_Callback(hObject, eventdata, handles)
% hObject    handle to editTo_radiobut_roioption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTo_radiobut_roioption2 as text
%        str2double(get(hObject,'String')) returns contents of editTo_radiobut_roioption2 as a double
if isempty(get(handles.editTo_radiobut_roioption2,'String'))
    return
end

prctileinput = str2double(get(handles.editTo_radiobut_roioption2,'String'));

    
if isnan(prctileinput) 
    %warning
    msgbox('Please enter a valid percentile','Warning','warn');
    set(hObject,'String',[]);
    return;
else
    handles.analysisregion.prctile2 = prctileinput;
    
    
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function editTo_radiobut_roioption2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTo_radiobut_roioption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobut_roioption2.
function radiobut_roioption2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobut_roioption2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% radiobut_roioption2_Callback enables editFrom - editTo allow users to
% input the start and end of the fit
% Hint: get(hObject,'Value') returns toggle state of radiobut_roioption2
% Disable Editboxes
if get(hObject,'Value')

set(handles.editFrom_radiobut_roioption2,'Enable','on');
set(handles.editTo_radiobut_roioption2,'Enable','on');

end
guidata(hObject,handles);


% --- Executes on button press in radiobut_roioption1.
function radiobut_roioption1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobut_roioption1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% radiobut_roioption1_Callback disables editFrom - editTo 
% Hint: get(hObject,'Value') returns toggle state of radiobut_roioption1
if get(hObject,'Value')
    set(handles.editFrom_radiobut_roioption2,'Enable','off');
    set(handles.editTo_radiobut_roioption2,'Enable','off');
end

guidata(hObject,handles);


% --- Executes on button press in chkCurveFitting.
function chkCurveFitting_Callback(hObject, eventdata, handles)
% hObject    handle to chkCurveFitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkCurveFitting


% --- Executes on button press in chkFexsettingDescriptive_Vasoc.
function chkFexsettingDescriptive_Vasoc_Callback(hObject, eventdata, handles)
% hObject    handle to chkFexsettingDescriptive_Vasoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFexsettingDescriptive_Vasoc
