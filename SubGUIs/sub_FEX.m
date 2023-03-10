function varargout = sub_FEX(varargin)
% SUB_FEX MATLAB code for sub_FEX.fig
%      SUB_FEX, by itself, creates a new SUB_FEX or raises the existing
%      singleton*.
%
%      H = SUB_FEX returns the handle to a new SUB_FEX or the handle to
%      the existing singleton*.
%
%      SUB_FEX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUB_FEX.M with the given input arguments.
%
%      SUB_FEX('Property','Value',...) creates a new SUB_FEX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sub_FEX_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sub_FEX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sub_FEX

% Last Modified by GUIDE v2.5 25-May-2020 19:22:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sub_FEX_OpeningFcn, ...
                   'gui_OutputFcn',  @sub_FEX_OutputFcn, ...
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


% --- Executes just before sub_FEX is made visible.
function sub_FEX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sub_FEX (see VARARGIN)

% Choose default command line output for sub_FEX
figw = 1280; %width of figure
figh = 720;  %height of figure

set(handles.figFEX,'Unit','pixels','Position',[511 100 figw figh],'Name','Feature Extraction Ultra 02/07/2019');
handles.output = hObject;
% Set handles property to point at Data Browser
handles.DataBrowser = [];
handles.subfex_filtersetting=[];
handles.subfex_analyzesetting = [];

%Setting path
if ~isdeployed
    handles.subfexsettingpath = mfilename('fullpath');
    handles.subfexsettingpath  = fileparts(handles.subfexsettingpath);
    handles.subfexsettingpath  = fileparts(handles.subfexsettingpath);
    handles.subfexsettingpath = fullfile(handles.subfexsettingpath,'Setting');
else %For a standalone version, use ctfroot as a path to Setting folder
    pathtofexsetting = which('fexsetting.mat');
    [p,~,~] = fileparts(pathtofexsetting); %Search relative path to ctfroot
    handles.subfexsettingpath = p;

end

%Setting filter
load(fullfile(handles.subfexsettingpath,'fexsetting.mat'));

handles.subfexsetting.descriptiveflag = descriptiveflag;
handles.subfexsetting.filtertype = filtertype;
handles.subfexsetting.medianfilterwindow = medianfilterwindow;
handles.subfexsetting.descriptivename = descriptivename;
handles.subfexsetting.curvefittingtype = curvefittingtype;


% Check if hObject of the main_DataBrowser is passed in varargin
DataBrowserInput = find(strcmp(varargin, 'DataBrowser'));
if ~isempty(DataBrowserInput)
   handles.DataBrowser = varargin{DataBrowserInput+1};
end




init(hObject,handles);
handles = guidata(hObject);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sub_FEX wait for user response (see UIRESUME)
% uiwait(handles.figFEX);


% --- Outputs from this function are returned to the command line.
function varargout = sub_FEX_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%============================= Non-callback Functions  ====================================
function init(hObject,handles)


if ispc %Set the fontSize for windows & mac
    fntsize = 10;
else
    fntsize = 14;
end
figw = 1280; %width of figure
figh = 720;  %height of figure


%Pixels 
pnp_width = 217.6;
pnp_workspace_height = 144; %normalized = 0.2
pnp_signal_height = 144; %0.2
pnp_roi_height = 216; %0.3
pnp_roitoolbox_height = 80; 
pnp_axe2_height =  704;% 616;
pnp_axe2_width = 1046.7;
left_margin = 3.84; %0.003 %Normalized unit, margin from the figure
top_margin = 8; % 0.01 Normalized unit, margin from the figure
space_between_panels = 8; %Normalized unit, 0.001
space_between_objects = 0.72; %Normalized unit=0.005, 0.72 pixel
list_roi_width = 136.374;

axe2_height = 354;
axe2_width =  785.3260;
table_height = 200;


%panelAxe2
left_margin_panelAxe2 = 50;
top_margin_panelAxe2 = 30;

%Other panels
left_margin_panel = 6.528; 
top_margin_panel = 6.528;
list_workspace_height = 106.56;
list_roi_height = 146.88;

txt_height = 21.6;
txt_viewing_width = 100;
but_width = 67.45; %0.31 %Relative to panelWorkspace, 
but_height = 21.6; %Relative to panelWorkspace ,21.6 pixels


edit_roiname_width = 136.37;


 %% Set GUI objects
     %Figure
     %set(handles.figFEX,'Unit','pixels','Position',[0 0 figw figh]);
     
     %% Panel Workspace
     %========Workspace Panel==========


     ypos = 1-(top_margin/figh)-(pnp_workspace_height/figh);
     set(handles.panelWorkspace,...
    'Unit','normalized',...
    'Position',[left_margin/figw,ypos,pnp_width/figw,pnp_workspace_height/figh],... %Margin left and top from the figure = 1% or 0.01
        'FontSize',fntsize,...
    'SelectionHighlight','off');
    
    %listWrkspc
    ypos = 1-(top_margin_panel/pnp_workspace_height)-(list_workspace_height/pnp_workspace_height);
    set(handles.listWrkspc,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,0.94,list_workspace_height/pnp_workspace_height],...
    'String','',...
    'FontSize',fntsize,...
    'Value',1,...
    'BackgroundColor',[1,1,1],...
    'Enable','off',...
    'SelectionHighlight','off');

    %txtFilename
    set(handles.txtFilename,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,(top_margin_panel/pnp_workspace_height),0.1,txt_height/pnp_workspace_height],...
    'String','File:',...
    'FontSize',fntsize);

    %editFilename : Same height as txtFilename
    xpos = (left_margin_panel/pnp_width)+0.1+(space_between_objects/pnp_width);
    set(handles.editFilename,...
    'Unit','normalized',...
    'Position',[xpos,(top_margin_panel/pnp_workspace_height),0.835,txt_height/pnp_workspace_height],...
    'String','',...
    'FontSize',fntsize,...
    'Enable','inactive',...
    'SelectionHighlight','off');
        
% 
    %% Panel signal
     ypos = handles.panelWorkspace.Position(2)-(space_between_panels/figh)-(pnp_signal_height/figh);
     set(handles.panelSignal,...
    'Unit','normalized',...
    'Position',[left_margin/figw,ypos,0.17,pnp_signal_height/figh],... %Margin between panels = 0.001, the formula = ypos_panelWorkspace-margin-height_panelSignal= 0.89-0.001-0.1
        'FontSize',fntsize,...
    'Title','Selected Signals',...
    'SelectionHighlight','off');

    %listSignal2
    ypos = 1-(top_margin_panel/pnp_signal_height)-handles.listWrkspc.Position(4);
    set(handles.listSignal2,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,0.94,handles.listWrkspc.Position(4)],...
    'String','',...
    'FontSize',fntsize,...
    'Value',1,...
    'BackgroundColor',[1,1,1],...
    'Enable','off',...
    'SelectionHighlight','off');

    %butPlot    
    set(handles.butPlot,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,top_margin_panel/pnp_signal_height,but_width/pnp_width,but_height/pnp_signal_height],...
    'FontSize',fntsize,...
    'TooltipString','Plot a signal in the current axis',...
    'Enable','off',...
    'SelectionHighlight','off');
    
    
    %butDeleteSignal2
    xpos = handles.butPlot.Position(1)+but_width/pnp_width+space_between_objects/pnp_width;
    set(handles.butDeleteSignal2,...
    'Unit','normalized',...
    'Position',[xpos,top_margin_panel/pnp_signal_height,but_width/pnp_width,but_height/pnp_signal_height],...
    'FontSize',fntsize,...
    'TooltipString','Remove the selected signal from the analysis',...
    'Enable','off',...
    'SelectionHighlight','off');
    
    %butSignal2
    xpos = handles.butDeleteSignal2.Position(1)+but_width/pnp_width+space_between_objects/pnp_width;
    set(handles.butSignal2,...
    'Unit','normalized',...
    'Position',[xpos,top_margin_panel/pnp_signal_height,but_width/pnp_width,but_height/pnp_signal_height],...
    'FontSize',fntsize,...
    'TooltipString','Add a signal from Workspace',...
    'Enable','on',...
    'SelectionHighlight','off');
    


     %% Panel ROI
     ypos = handles.panelSignal.Position(2)-(2*space_between_panels/figh)-(pnp_roi_height/figh);
     set(handles.panelROI,...
    'Unit','normalized',...
    'Position',[left_margin/figw,ypos,0.17,pnp_roi_height/figh],... %Margin between panels = 0.001, the formula = ypos_panelSignal-margin-height_panelROI= 0.789-0.001-0.1
        'FontSize',fntsize,...
    'SelectionHighlight','off');


    %editROI
    ypos = 1-top_margin_panel/pnp_roi_height-txt_height/pnp_roi_height;
    set(handles.editROI,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,but_width/pnp_width,but_height/pnp_roi_height],...
    'String','',...
    'FontSize',fntsize,...
    'Enable','off',...
    'SelectionHighlight','off');


    %butROIName
    xpos = handles.editROI.Position(1)+handles.editROI.Position(3)+space_between_objects/pnp_width; %Normalize but_height to panelROI's height
    set(handles.butROIName,...
    'Unit','normalized',...
    'Position',[xpos,ypos,but_width/pnp_width,but_height/pnp_roi_height],...
    'FontSize',fntsize,...
    'TooltipString','Press the button to update the name',...
    'Enable','off',...
    'SelectionHighlight','off');

    %butUpdateTag
    xpos = handles.butROIName.Position(1)+handles.butROIName.Position(3)+space_between_objects/pnp_width; %Normalize but_height to panelROI's height
    set(handles.butUpdateTag,...
    'Unit','normalized',...
    'Position',[xpos,ypos,but_width/pnp_width,but_height/pnp_roi_height],...
    'FontSize',fntsize,...
    'TooltipString','Retrieve new defined tags from the main browser',...
    'Enable','off',...
    'SelectionHighlight','off');

     %listROI
     ypos =  handles.editROI.Position(2)-top_margin_panel/pnp_roi_height-list_roi_height/pnp_roi_height;
     set(handles.listROI,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,list_roi_width/pnp_width,list_roi_height/pnp_roi_height],...
    'String','',...
    'FontSize',fntsize,...
    'Value',1,...
    'BackgroundColor',[1,1,1],...
    'Enable','off',...
    'SelectionHighlight','off');


    
    %butDROI
    %xpos = handles.butDBase.Position(1)+but_width/pnp_width+space_between_objects/pnp_width; 
    xpos = 1-left_margin_panel/pnp_width-but_width/pnp_width;
    set(handles.butDROI,...
    'Unit','normalized',...
    'Position',[xpos,handles.listROI.Position(2),but_width/pnp_width,but_height/pnp_roi_height],...
    'FontSize',fntsize,...
    'FontWeight','bold',...
    'TooltipString','Add an ROI segment',...
    'Enable','off',...
    'SelectionHighlight','off');

    %butDBase
    %xpos = left_margin_panel/pnp_width+but_width/pnp_width+space_between_objects/pnp_width;
    ypos = handles.butDROI.Position(2)+space_between_objects/pnp_roi_height+but_height/pnp_roi_height;
    set(handles.butDBase,...
    'Unit','normalized',...
    'Position',[xpos,ypos,but_width/pnp_width,but_height/pnp_roi_height],...
    'FontSize',fntsize,...
    'TooltipString','Add a baseline segment',...
    'String','Baseline',...
    'Enable','off',...
    'SelectionHighlight','off');


    %butDeleteROI
    ypos = handles.listROI.Position(2)-space_between_objects/pnp_roi_height-but_height/pnp_roi_height;
    set(handles.butDeleteROI,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,(0.5*but_width/pnp_width),but_height/pnp_roi_height],...
    'FontSize',fntsize,...
    'TooltipString','Delete ROI',...
    'Enable','off',...
    'SelectionHighlight','off');

     %butAdd
     xpos = handles.butDROI.Position(1)-space_between_objects/pnp_width-but_width/pnp_width;
     set(handles.butAdd,...
    'Unit','normalized',...
    'Position',[xpos,handles.butDeleteROI.Position(2),but_width/pnp_width,but_height/pnp_roi_height],...
    'FontSize',fntsize,...
    'String','New ROI',...
    'TooltipString','Add a new ROI',...
    'Enable','off',...
    'SelectionHighlight','off');
    

     %% Panel ROI toolbox
     ypos = handles.panelROI.Position(2)-space_between_panels/figh-pnp_roitoolbox_height/figh;
     set(handles.panelROItoolbox,...
    'Unit','normalized',...
    'Position',[left_margin/figw,ypos,0.17,pnp_roitoolbox_height/figh],... %Margin between panels = 0.001, the formula = ypos_panelSignal-margin-height_panelROI= 0.789-0.001-0.1
        'FontSize',fntsize,...
    'Title','',...
    'SelectionHighlight','off');

     %txtViewing
     ypos = 1-(top_margin_panel/pnp_roitoolbox_height)-(txt_height/pnp_roitoolbox_height);
     set(handles.txtViewing,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,txt_viewing_width/pnp_width,txt_height/pnp_roitoolbox_height],...
    'String','Viewing window:',...
    'FontSize',fntsize);
     
     
     %popWindow
     xpos = handles.txtViewing.Position(1)+txt_viewing_width/pnp_width+2*space_between_objects/pnp_width;
     objwidth = 1-xpos-left_margin_panel/pnp_width;
     set(handles.popWindow,...
    'Unit','normalized',...
    'Position',[xpos,ypos,objwidth,but_height/pnp_roitoolbox_height],...
    'FontSize',fntsize,...
    'Value',1,...
    'Enable','off',...
    'SelectionHighlight','off');
     

     %editFrom
     ypos = handles.txtViewing.Position(2)-top_margin_panel/pnp_roitoolbox_height-txt_height/pnp_roitoolbox_height;
     set(handles.editFrom,...
    'Unit','normalized',...
    'Position',[left_margin_panel/pnp_width,ypos,(0.8*but_width)/pnp_width,but_height/pnp_roitoolbox_height],...
    'String','',...
    'FontSize',fntsize,...
    'Enable','off',...
    'SelectionHighlight','off');
    
     %txtColon
     xpos = handles.editFrom.Position(1)+handles.editFrom.Position(3)+space_between_objects/pnp_width;
     set(handles.txtColon,...
    'Unit','normalized',...
    'Position',[xpos,ypos,(0.1*txt_viewing_width)/pnp_width,txt_height/pnp_roitoolbox_height],...
    'String',':',...
    'FontSize',fntsize);


     %editTo
     xpos = handles.txtColon.Position(1)+handles.txtColon.Position(3)+space_between_objects/pnp_width;
     set(handles.editTo,...
    'Unit','normalized',...
    'Position',[xpos,handles.editFrom.Position(2),(0.8*but_width)/pnp_width,but_height/pnp_roitoolbox_height],...
    'String','',...
    'FontSize',fntsize,...
    'Enable','off',...
    'SelectionHighlight','off');


     
     
     %butJump
     xpos = 1-but_width/pnp_width-left_margin_panel/pnp_width;
     set(handles.butJump,...
    'Unit','normalized',...
    'Position',[xpos,handles.editFrom.Position(2),but_width/pnp_width,but_height/pnp_roitoolbox_height],...
    'FontSize',fntsize,...
    'TooltipString','Direct to a specified time location',...
    'Enable','off',...
    'SelectionHighlight','off');
        

    
    %% panelAxe2
    xpos = handles.panelWorkspace.Position(1)+(pnp_width/figw)+(space_between_panels/figw);
    ypos = 1-top_margin/figh-pnp_axe2_height/figh;
    set(handles.panelAxe2,...
    'Unit','normalized',...
    'Position',[xpos,ypos,pnp_axe2_width/figw,pnp_axe2_height/figh],... %Margin left and top from the figure = 1% or 0.01
        'FontSize',fntsize,...
    'Title','Plot',...    
    'SelectionHighlight','off');

     %Axe2
     xpos = left_margin_panelAxe2/pnp_axe2_width;
     ypos = 1-top_margin_panelAxe2/pnp_axe2_height-axe2_height/pnp_axe2_height;
     set(handles.axes2,...
         'Unit','normalized',...
         'Position',[xpos,ypos,axe2_width/pnp_axe2_width,axe2_height/pnp_axe2_height],...
         'FontSize',fntsize,...
         'Box','off');
    
     %xslider
     ypos = handles.axes2.Position(2)-(1.5*top_margin_panelAxe2)/pnp_axe2_height-txt_height/pnp_axe2_height;
     set(handles.xslider,...
    'Unit','normalized',...
    'Position',[handles.axes2.Position(1),ypos,handles.axes2.Position(3),txt_height/pnp_axe2_height],...
    'Min',0,'Max',1,'Value',0,...
    'Enable','off',...
    'SelectionHighlight','off');

    %editDBase
    xpos = handles.axes2.Position(1)+handles.axes2.Position(3)+(0.5*left_margin_panelAxe2)/pnp_axe2_width;
    ypos = 1-top_margin_panelAxe2/pnp_axe2_height-but_height/pnp_axe2_height;
    set(handles.editDBase,...
    'Unit','normalized',...
    'Position',[xpos,ypos,list_roi_width/pnp_axe2_width,but_height/pnp_axe2_height],...
    'String','',...
    'FontSize',fntsize,...
    'Enable','off',...
    'SelectionHighlight','off');
    
    %editDROI
    ypos = handles.editDBase.Position(2)-space_between_objects/pnp_axe2_height-(3*but_height/pnp_axe2_height);
    set(handles.editDROI,...
    'Unit','normalized',...
    'Position',[xpos,ypos,list_roi_width/pnp_axe2_width,(3*but_height/pnp_axe2_height)],...
    'String','',...
    'FontSize',fntsize,...
    'Enable','off',...
    'SelectionHighlight','off');
    
    
    %chkDTrend
    ypos = handles.editDROI.Position(2)-space_between_objects/pnp_axe2_height-(but_height/pnp_axe2_height);
    set(handles.chkDTrend,...
    'Unit','normalized',...
    'Position',[xpos,ypos,list_roi_width/pnp_axe2_width,but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'Value',0,...
    'Enable','off',...
    'SelectionHighlight','off');
    
    
    %chkNorm
    ypos = handles.chkDTrend.Position(2)-space_between_objects/pnp_axe2_height-(but_height/pnp_axe2_height);
    set(handles.chkNorm,...
    'Unit','normalized',...
    'Position',[xpos,ypos,list_roi_width/pnp_axe2_width,but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'Value',0,...
    'Enable','off',...
    'SelectionHighlight','off');


    %butExtract
    ypos = handles.chkNorm.Position(2)-space_between_objects/pnp_axe2_height-but_height/pnp_axe2_height;
    set(handles.butExtract,...
    'Unit','normalized',...
    'Position',[xpos,ypos,but_width/pnp_axe2_width,but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'TooltipString','Extract descriptive features from the selected ROIs',...
    'Enable','off',...
    'SelectionHighlight','off');
    
    
       
    
    %butClear
    xpos = handles.butExtract.Position(1)+space_between_objects/pnp_axe2_height+but_width/pnp_axe2_width;
    set(handles.butClear,...
    'Unit','normalized',...
    'Position',[xpos,ypos,but_width/pnp_axe2_width,but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'TooltipString','Clear the selected baseline and ROIs. ',...
    'Enable','off',...
    'SelectionHighlight','off');

    %tableDTags
    ypos = top_margin_panelAxe2/pnp_axe2_height;
    set(handles.tableDTags,'Data',{},...
    'Enable','on',...
    'Unit','normalized',...
    'Position',[handles.axes2.Position(1) ypos handles.axes2.Position(3) table_height/pnp_axe2_height],...
    'FontSize',fntsize);
 
    %butSaveOutput
        set(handles.butSaveOutput,...
    'Unit','normalized',...
    'Position',[handles.butExtract.Position(1),handles.tableDTags.Position(2),(0.5*but_width/pnp_axe2_width),but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'TooltipString','Save the results from the table',...
    'Enable','off',...
    'SelectionHighlight','off');
    
    %butDeleteTags
    xpos = handles.butSaveOutput.Position(1)+space_between_objects/pnp_axe2_width+(0.5*but_width/pnp_axe2_width);
     set(handles.butDeleteTags,...
    'Unit','normalized',...
    'Position',[xpos,handles.tableDTags.Position(2),(0.5*but_width/pnp_axe2_width),but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'TooltipString','Delete the selected rows from the table',...
    'Enable','off',...
    'SelectionHighlight','off');

    %chkSelectAll
    ypos = handles.butSaveOutput.Position(2)+space_between_objects/pnp_axe2_height+but_height/pnp_axe2_height;
    set(handles.chkSelectAll,...
    'Unit','normalized',...
    'Position',[handles.butSaveOutput.Position(1),ypos,list_roi_width/pnp_axe2_width,but_height/pnp_axe2_height],...
    'FontSize',fntsize,...
    'TooltipString','Select all rows in the table',...
    'Enable','off',...
    'SelectionHighlight','off');
     
     
    %Output Tags
    set(handles.tableDTags,'Fontsize',10,'Data',{},'Enable','off');    
    
    %Edit Box
    set(handles.editDBase,'Enable','off');
    set(handles.editDROI,'Enable','off');
    
    
    %ToolBox Buttons
    set(handles.butExtract,'Enable','off');
    set(handles.butClear,'Enable','off');
    set(handles.butDeleteTags,'Enable','off');
    
    %UI Context menu
    handles.ylimit = [];
    hcmenu = uicontextmenu('Parent',handles.output); %Set parent figure to sub_FEX
    handles.axes2.UIContextMenu = hcmenu;
    item1 = uimenu('Parent',hcmenu,'Label','Set y-limit...','Callback',{@adjustYlimit});
    item2 = uimenu('Parent',hcmenu,'Label','Auto-adjust y-limit...','Callback',{@autoadjustYlimit});
    
    
    %% Batch processing

    panelbatch_analysis_width = 426;
    panelbatch_analysis_height = 445;
    panelbatch_signal_width = 312;
    panelbatch_signal_height = 0.5*(panelbatch_analysis_height-space_between_objects);
    panelbatch_result_height = 410;
    %panelBatch
    %set(handles.panelBatch,'Unit','normalized','Position',[0 0 1 1]); %The same size as the figure
    %txtMatDirectory
    xpos = left_margin_panelAxe2/figw;
    ypos = 1-top_margin_panelAxe2/figh-txt_height/figh;
    set(handles.txtMatDirectory,'Unit','normalized','Position',[xpos ypos list_roi_width/figw txt_height/figh],'FontSize',fntsize,'String','Data Folder');
   
    %butSelectMatpath
    ypos =  handles.txtMatDirectory.Position(2)-space_between_objects/figh-but_height/figh;
    xpos = 1-left_margin_panelAxe2/figw-list_roi_width/figw;
    set(handles.butSelectMatpath,'Unit','normalized','Position',[xpos ypos list_roi_width/figw but_height/figh],...
        'FontSize',fntsize,'String','Browse');

    %editMatpath
    ypos = handles.butSelectMatpath.Position(2);
    editMatpath_width = figw-list_roi_width-2*left_margin_panelAxe2-space_between_objects;
    xpos = handles.txtMatDirectory.Position(1);
    set(handles.editMatpath,'Unit','normalized','Position',[xpos ypos editMatpath_width/figw but_height/figh],'FontSize',fntsize,'String','.MAT directory');

    
    %txtTagDirectory
    ypos = handles.editMatpath.Position(2)-top_margin_panel/figh-txt_height/figh;
    set(handles.txtTagDirectory,'Unit','normalized','Position',[handles.txtMatDirectory.Position(1) ypos list_roi_width/figw txt_height/figh],'FontSize',fntsize,'String','Tag Folder');
    
    
    
    
    %editTagpath
    ypos = handles.txtTagDirectory.Position(2)-space_between_objects/figh-but_height/figh;
    set(handles.editTagpath,'Unit','normalized','Position',[handles.txtMatDirectory.Position(1) ypos editMatpath_width/figw but_height/figh],'FontSize',fntsize,'String','.CSV directory');
   
    %butSelectTagPath
    set(handles.butSelectTagPath,'Unit','normalized','Position',[handles.butSelectMatpath.Position(1) handles.editTagpath.Position(2) list_roi_width/figw but_height/figh],'FontSize',fntsize,'String','Browse');

    
    %% panelSelectVariables
    ypos = handles.editTagpath.Position(2)-top_margin_panel/figh-panelbatch_signal_height/figh;
    set(handles.panelSelectVariables,'Unit','normalized','Position',[handles.txtMatDirectory.Position(1) ypos panelbatch_signal_width/figw panelbatch_signal_height/figh],'FontSize',fntsize);
    
        
    %butAddVar
    xpos = 1-but_width/panelbatch_signal_width-left_margin_panel/panelbatch_signal_width;
    ypos = left_margin_panel/panelbatch_signal_height;
    set(handles.butAddVar,'Unit','normalized',...
        'Position',[xpos ypos but_width/panelbatch_signal_width but_height/panelbatch_signal_height],...
        'FontSize',fntsize,'String','Add','Enable','off')
    
    %listVars
    xpos = left_margin_panel/panelbatch_signal_width;
    ypos = 1-left_margin_panel/panelbatch_signal_height-4*but_height/panelbatch_signal_height;
    set(handles.listVars,'Unit','normalized',...
        'Position',[xpos ypos list_roi_width/panelbatch_signal_width 4*but_height/panelbatch_signal_height],...
        'FontSize',fntsize);
    
    
    %chk2Hz
    xpos = handles.listVars.Position(1)+handles.listVars.Position(3)+left_margin_panel/panelbatch_signal_width;
    ypos = 1-left_margin_panel/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.chk2Hz,'Unit','normalized',...
        'Position',[xpos ypos list_roi_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'Enable','off','Value',0);
    
    
    %chk30Hz
    ypos = handles.chk2Hz.Position(2)-left_margin_panel/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.chk30Hz,'Unit','normalized',...
        'Position',[handles.chk2Hz.Position(1) ypos list_roi_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'Enable','off','Value',0);
    
    
    %chk250Hz
    ypos = handles.chk30Hz.Position(2)-left_margin_panel/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.chk250Hz,'Unit','normalized',...
        'Position',[handles.chk2Hz.Position(1) ypos list_roi_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'Enable','off','Value',0);
    
    
    %chkOther
    ypos = handles.chk250Hz.Position(2)-left_margin_panel/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.chkOther,'Unit','normalized',...
        'Position',[handles.listVars.Position(1) ypos list_roi_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'String','Enter value','Enable','off','Value',0);
    
    
    %editFS
    %xpos = handles.chk2Hz.Position(1)+list_roi_width/panelbatch_signal_width+left_margin_panel/panelbatch_signal_width;
    %ypos = handles.chkOther.Position(2)-space_between_objects/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.editFS,'Unit','normalized',...
        'Position',[handles.chk2Hz.Position(1) handles.chkOther.Position(2) but_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'String','','Enable','off');
    
    
    
    
    
    %% panelTags
    ypos = handles.panelSelectVariables.Position(2)-space_between_objects/figh-panelbatch_signal_height/figh;
    set(handles.panelTags,'Unit','normalized',...
        'Position',[handles.panelSelectVariables.Position(1) ypos panelbatch_signal_width/figw panelbatch_signal_height/figh],...
        'FontSize',fntsize);
    
    %butSelectSubRegion
    ypos = left_margin_panel/panelbatch_signal_height;
    set(handles.butSelectSubRegion,...
    'Unit','normalized',...
    'Position',[handles.butAddVar.Position(1),ypos,but_width/panelbatch_signal_width,but_height/panelbatch_signal_height],...
    'FontSize',fntsize,...
    'TooltipString','Add an ROI segment',...
    'String','ROI',...
    'Enable','off',...
    'SelectionHighlight','off');

    %butSelectBaseline
    ypos = handles.butSelectSubRegion.Position(2)+but_height/panelbatch_signal_height+top_margin_panel/panelbatch_signal_height;
    set(handles.butSelectBaseline,...
    'Unit','normalized',...
    'Position',[handles.butAddVar.Position(1),ypos,but_width/panelbatch_signal_width,but_height/panelbatch_signal_height],...
    'FontSize',fntsize,...
    'TooltipString','Add a baseline segment',...
    'String','Baseline',...
    'Enable','off',...
    'SelectionHighlight','off');

   %listAllTags
    xpos = left_margin_panel/panelbatch_signal_width;
    ypos = 1-left_margin_panel/panelbatch_signal_height-4*but_height/panelbatch_signal_height;
    set(handles.listAllTags,'Unit','normalized',...
        'Position',[xpos ypos list_roi_width/panelbatch_signal_width 4*but_height/panelbatch_signal_height],...
        'FontSize',fntsize);
    
    %chkEnterROIName
    ypos = handles.listAllTags.Position(2)-left_margin_panel/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.chkEnterROIName,'Unit','normalized',...
        'Position',[handles.listVars.Position(1) ypos list_roi_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'String','Enter name','Value',0,'Enable','off');
    
    
    %editEnterROIName
    ypos = handles.chkEnterROIName.Position(2)-left_margin_panel/panelbatch_signal_height-txt_height/panelbatch_signal_height;
    set(handles.editEnterROIName,'Unit','normalized',...
        'Position',[handles.listAllTags.Position(1) ypos list_roi_width/panelbatch_signal_width txt_height/panelbatch_signal_height],...
        'FontSize',fntsize,'String','','Enable','off');
 
    
    %% panelbatchInitial
    xpos = handles.panelTags.Position(1)+space_between_objects/figw+handles.panelTags.Position(3);
    set(handles.panelbatchInitial,'Unit','normalized','Position',[xpos handles.panelTags.Position(2) panelbatch_analysis_width/figw panelbatch_analysis_height/figh],...
        'Title','Analysis','FontSize',fntsize);
    
    

    
    %textBaselineRegions
    xpos = 1-left_margin_panel/panelbatch_analysis_width-list_roi_width/panelbatch_analysis_width;
    ypos = 1-left_margin_panel/panelbatch_analysis_height-txt_height/panelbatch_analysis_height;
    set(handles.textBaselineRegions,'Unit','normalized',...
        'Position',[xpos ypos list_roi_width/panelbatch_analysis_width txt_height/panelbatch_analysis_height],...
        'FontSize',fntsize,'String','Baseline');
    
    

    %listBaseline
    ypos = handles.textBaselineRegions.Position(2)-left_margin_panel/panelbatch_analysis_height-4*but_height/panelbatch_analysis_height;
    set(handles.listBaseline,'Unit','normalized',...
        'Position',[handles.textBaselineRegions.Position(1) ypos list_roi_width/panelbatch_analysis_width 4*but_height/panelbatch_analysis_height],...
        'FontSize',fntsize);
    
    %butDBatchBaseline
    ypos = handles.listBaseline.Position(2)-space_between_objects/panelbatch_analysis_height-but_height/panelbatch_analysis_height;
    set(handles.butDBatchBaseline,'Unit','normalized',...
        'Position',[handles.listBaseline.Position(1) ypos 0.5*but_width/panelbatch_analysis_width but_height/panelbatch_analysis_height],...
        'FontSize',fntsize,'Enable','off');
    
    %listSelectedVar
    xpos = left_margin_panel/panelbatch_analysis_width;
    set(handles.listSelectedVar,'Unit','normalized',...
        'Position',[xpos handles.listBaseline.Position(2) list_roi_width/panelbatch_analysis_width 4*but_height/panelbatch_analysis_height],...
        'FontSize',fntsize);
    
    %butDBatchVar
    ypos = handles.listSelectedVar.Position(2)-but_height/panelbatch_analysis_height-space_between_objects/panelbatch_analysis_height;
    set(handles.butDBatchVar,'Unit','normalized',...
        'Position',[handles.listSelectedVar.Position(1) ypos  0.5*but_width/panelbatch_analysis_width but_height/panelbatch_analysis_height],...
        'FontSize',fntsize,'Enable','off');

    %textSubRegions
    ypos = handles.butDBatchBaseline.Position(2)-left_margin_panel/panelbatch_analysis_height-txt_height/panelbatch_analysis_height;
    set(handles.textSubRegions,'Unit','normalized',...
        'Position',[handles.textBaselineRegions.Position(1) ypos list_roi_width/panelbatch_analysis_width txt_height/panelbatch_analysis_height],...
        'FontSize',fntsize,'String','ROIs');
    
    %listSubRegion
    ypos = handles.textSubRegions.Position(2)-left_margin_panel/panelbatch_analysis_height-4*but_height/panelbatch_analysis_height;
    set(handles.listSubRegion,'Unit','normalized',...
        'Position',[handles.textBaselineRegions.Position(1) ypos list_roi_width/panelbatch_analysis_width 4*but_height/panelbatch_analysis_height],...
        'FontSize',fntsize);
    
    %butDBatchROI
    ypos = handles.listSubRegion.Position(2)-space_between_objects/panelbatch_analysis_height-but_height/panelbatch_analysis_height;
    set(handles.butDBatchROI,'Unit','normalized',...
        'Position',[handles.listSubRegion.Position(1) ypos 0.5*but_width/panelbatch_analysis_width but_height/panelbatch_analysis_height],...
        'FontSize',fntsize,'Enable','off');
    
    %butBatchCompute
    set(handles.butBatchCompute,...
    'Unit','normalized',...
    'Position',[handles.listSelectedVar.Position(1),handles.butDBatchROI.Position(2),but_width/panelbatch_analysis_width,but_height/panelbatch_analysis_height],...
    'FontSize',fntsize,...
    'TooltipString','Extract descriptive features from the selected ROIs',...
    'Enable','off',...
    'String','Extract',...
    'SelectionHighlight','off');
    
    
    %butBatchClear
    xpos = handles.butBatchCompute.Position(1)+handles.butBatchCompute.Position(3)+space_between_panels/panelbatch_analysis_width;
    set(handles.butBatchClear,...
    'Unit','normalized',...
    'Position',[xpos,handles.butDBatchROI.Position(2),but_width/panelbatch_analysis_width,but_height/panelbatch_analysis_height],...
    'FontSize',fntsize,...
    'TooltipString','Clear the selections',...
    'Enable','off',...
    'String','Clear',...
    'SelectionHighlight','off');

    
    %chk95Norm
    ypos = handles.butBatchCompute.Position(2)+but_height/panelbatch_analysis_height+left_margin_panel/panelbatch_analysis_height;
    set(handles.chk95Norm,'Unit','normalized',...
        'Position',[handles.butBatchCompute.Position(1) ypos 2*list_roi_width/panelbatch_analysis_width txt_height/panelbatch_analysis_height],...
        'Enable','off',...
        'Value',0,...
        'FontSize',fntsize,'String','Normalize to 95%');
    
    %chkApplyFilter
    ypos = handles.chk95Norm.Position(2)+txt_height/panelbatch_analysis_height+left_margin_panel/panelbatch_analysis_height;
    set(handles.chkApplyFilter,'Unit','normalized',...
        'Position',[handles.butBatchCompute.Position(1) ypos 2*list_roi_width/panelbatch_analysis_width txt_height/panelbatch_analysis_height],...
        'Enable','off',...
        'Value',0,...
        'FontSize',fntsize,'String','Apply a filter');

    
    
    %% Result
    %butSaveBatch
    xpos = 1-left_margin_panelAxe2/figw-but_width/figw;
    set(handles.butSaveBatch,'Unit','normalized',...
        'Position',[xpos handles.panelbatchInitial.Position(2) but_width/figw but_height/figh],...
        'FontSize',fntsize,'String','Save','Enable','off');
     
   %editBatchStat
   ypos = handles.butSaveBatch.Position(2)+space_between_objects/figh+but_height/figh;
   xpos = 1-left_margin_panelAxe2/figw-panelbatch_analysis_width/figw;
   
   set(handles.editBatchStat,'Unit','normalized',...
       'Position',[xpos ypos panelbatch_analysis_width/figw panelbatch_result_height/figh],...
       'FontSize',fntsize);

%Retrieve the opened signals from Data Browser
h = guidata(handles.DataBrowser); %Get handles(struct) of DataBrowser
 
 %% Check if there is no variable existing in workspace
 if ~isfield(h.DB,'varname') || isempty(h.DB.varname) %Allow only batch processing
     set(handles.panelBatch,'Position',[0 0 1 1]);
     set(handles.panelBatch,'Visible','on');
     set(handles.axes2,'Visible','off');
     
     %% Disable menu normal
     set(handles.submenuNormalFEX,'Enable','off');
     guidata(hObject,handles);
 else
     handles.varname     = h.DB.varname;
     handles.filename    = h.DB.filename;
     handles.acrostic    = h.DB.acrostic;
     handles.subjnum     = h.DB.subjnum;
     handles.exptdate    = h.DB.exptdate;
     handles.expttime    = h.DB.expttime;
     handles.signal      = h.DB.signal;
     handles.fs          = h.DB.fs;
     
     
     
     %Store and initialize variables, ordered by the selection
     nsig = 2; %Two axes for two signals (stimuli & response)
     handles.y = cell(nsig,1);
     handles.yvarname = cell(nsig,1);
     handles.yfs = zeros(nsig,1);
     handles.yfilename = cell(nsig,1);
     handles.yacrostic = cell(nsig,1);
     handles.ysubjnum  = cell(nsig,1);
     handles.yexptdate = cell(nsig,1);
     handles.yexpttime = cell(nsig,1);
     handles.ytime = cell(nsig,1);
     handles.plot = 0; %Keep track what variable is being plotted
     handles.tagrec = []; %Keep a rectangular object that marks the selected ROI on the plot.
     
     
     
     % This is for the second signal
     handles.tagname = [];
     handles.tagtime = -1*ones(2,1);
     handles.roiname = {[]};
     %Region rois
     handles.roiind1 = [];
     handles.roiind2 = [];
     
     %Points roi
     handles.proiind = [];
     handles.proiname = {[]};
     
     %Keys to roilist
     set(handles.listROI,'String',{});
     set(handles.editROI,'Enable','on');
     handles.keyroi = [];
     handles.keyproi = [];
     
     %Trend
     handles.trend = [];
     handles.movingwindow = [];
     
     handles.droiind = [];
     handles.dbase = [];

     
     %Output
     handles.fextags = [];
     
     
     varind = 1;
     [pathstr,name,ext] = fileparts(handles.filename{varind});
     
     set(handles.listWrkspc,'String',handles.varname,'Value',1,'Enable','on');
     set(handles.editFilename,'String',[name,ext]);
     
    
   
   
   

     
 end
 guidata(hObject,handles);

 


function plotSignalTrace(handles,varargin)
    if ~isempty(varargin) % zoom in
        xrange = varargin{1,1};
    else
        xrange = [];
    end
    if ispc %Set the fontSize for windows & mac
        fntsize = 10;
    else
        fntsize = 16;
    end
    
    
    %Plot signal2
    if ~isempty(handles.y{2})
        varind = handles.plot;

        if ~isempty(xrange) % zoom in
            xminid = round(handles.yfs(varind)*xrange(1))+1; % no. of points = id
            xmaxid = round(handles.yfs(varind)*xrange(2)); % no. of points = id
            if xmaxid>length(handles.ytime{varind})
                xmaxid = length(handles.ytime{varind});
            end
        else
            xminid = 1;
            xmaxid = length(handles.ytime{varind}); % all traces must have the same fs 
            
        end
    
        time = handles.ytime{varind};
        signal = handles.y{varind};
        t = time(xminid:xmaxid);
        s = signal(xminid:xmaxid);
        
        %Plot the original signal       
        plot(handles.axes2,t,s,'Color',[0.04 0.52 0.78]); 
        
        %Plot trend,filtered,normalized signal
        if ~isempty(handles.trend) && get(handles.chkDTrend,'Value')
            hold(handles.axes2,'on');
            %Is normalized
            if get(handles.chkNorm,'Value')
                pct95 = prctile(signal,95); %Percentile from the original signal
                temp = (handles.trend{varind}(xminid:xmaxid))/pct95;
                plot(handles.axes2,t,temp,'Color',[0 0 0.8],'LineWidth',1);
            else
                plot(handles.axes2,t,handles.trend{varind}(xminid:xmaxid),'Color',[0 0 0.8],'LineWidth',1);
            end
            hold(handles.axes2,'off');

        elseif get(handles.chkNorm,'Value')
            hold(handles.axes2,'on');

            pct95 = prctile(signal,95); %Percentile from the original signal
            temp = s/pct95;
            plot(handles.axes2,t,temp,'Color',[0 0 0.8],'LineWidth',1);
            hold(handles.axes2,'off');

        end
     


        %Clear tagrec, a rectangular object created when selecting an
        %element from listROI
        handles.tagrec = [];
        
        ymin = prctile(s,2);
        ymax = prctile(s,98);
        
        ytickval = get(handles.axes2,'YTick');
        ytickval = ytickval(2)-ytickval(1); %The increasing step of the y-axis
        
        xlimit = [time(xminid),time(xmaxid)];
        if isempty(handles.ylimit)
            ylimit = [ymin-0.5*ytickval ymax+0.5*ytickval];
        else
            ylimit = handles.ylimit;
        end
        
        if any(ylimit)
            set(handles.axes2,'Ylim',ylimit,'Xlim',xlimit);
        else
            set(handles.axes2,'Xlim',xlimit);
        end

        title(handles.axes2,handles.yvarname{varind},'FontSize',10,'FontWeight','bold');
        

    xlabel(handles.axes2,'Time(sec)'); set(handles.axes2,'FontSize',fntsize); 
        
    end
guidata(handles.output,handles);
    
    
function [] = lookAt(handles,from,to)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% from = the beginning of modification
% to = the end of modification
% set of window size
if to<from
    return
end
window = [30,50,60,180,300,420,600,900,1200,1800]; %start from Value = 5
sliderstep = [5,10,20,20,30,60,100,100,120,180];
look_up_range = to-from;

if ~isempty(handles.ytime{1})
    maxtime = handles.ytime{1}(end);
elseif ~isempty(handles.ytime{2})
    maxtime = handles.ytime{2}(end);
end

% Change viewing window 
ind = find(window>look_up_range,1,'first');
if isempty(ind)
        val = 1; %full window
        handles.window = maxtime;
        handles.sliderstep = 0;
else
        val = ind+4;
        handles.window = window(ind);
        handles.sliderstep = sliderstep(ind);
end

set(handles.popWindow,'Value',val);
    
%Adjust the plot and change slider position to make the range places in the middle
adj_width = round(0.5*(handles.window-look_up_range));
xmax = to+adj_width;
if xmax > maxtime
    xmax = maxtime;
end

xmin = xmax - handles.window;
if xmin<0
    xmin = 0;
    xmax = xmin+handles.window;
end


%Set xslider
%Enable xslider
if val > 1
    sliderrange = maxtime-handles.window;
    set(handles.xslider,'Enable','on','Min',0,'Max',sliderrange);
    set(handles.xslider,'SliderStep',[handles.sliderstep/sliderrange 10*handles.sliderstep/sliderrange]);
    set(handles.xslider,'Value',xmin);
else % View full signal
    set(handles.xslider,'Enable','off','Value',0);
end

% Plot again
plotSignalTrace(handles,[xmin xmax]);
handles = guidata(handles.output);

guidata(handles.output,handles);

function [handlesTE] = getActiveTagEditor(handles)
h = guidata(handles.DataBrowser);
handlesTM = guidata(h.TagManager);

if strcmp(get(h.tableEditor,'Enable'),'on')
    handlesTE = h;
else
    handlesTE = handlesTM;
end

function [tabdata,ind,select] = getSelectedTags(handles)
%function output
%select : indices to the selected rows
%ind : indices to the set
%------------------Get Selected Tag Rows--------------------%
tabdata = get(handles.tableDTags,'Data');
cselect = 1;
select = cellfun(@(x) x==1, tabdata(:,cselect), 'UniformOutput', 1); %logical array
select = find(select);
ind = [];

% cspearman = 17;
% % check if spearman is there
% if ~isempty(tabdata(:,cspearman))
%     nrow = 10;
% else
%     nrow = 6;
% end
% ind = [];
% for n=1:length(select),
%     row = select(n);
%     indstart = nrow*(row-1)+1;
%     indend = indstart+nrow-1; 
%     ind = [ind;(indstart:indend)];
% end   

function adjustYlimit(hObject,EventData)
handles = guidata(hObject);
if isempty(handles.y{2})
    return
end
%Highlight selected axes
ax = gca;

%Define area to be shaded
rect = getrect(ax); %rect = [xmin ymin width height] (unit = unit of x-axis)


%Adjust y-limit
ymin = rect(2);
ymax = ymin + rect(4);

handles.ylimit = [ymin,ymax];

xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
if get(handles.popWindow,'Value')>1
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end

handles = guidata(hObject);
guidata(hObject,handles);

function autoadjustYlimit(hObject,EventData)
handles = guidata(hObject);
if isempty(handles.y{2})
    return
end

xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
handles.ylimit = [];
if get(handles.popWindow,'Value')>1
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end





handles = guidata(hObject);
guidata(hObject,handles);
%============================= Callback Functions  ====================================

% --- Executes on slider movement.
function xslider_Callback(hObject, eventdata, handles)
% hObject    handle to xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
xmin = get(hObject,'Value');
xmax = xmin+handles.window;

plotSignalTrace(handles,[xmin xmax]);
handles = guidata(hObject);


guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in butAdd.
function butAdd_Callback(hObject, eventdata, handles)
% hObject    handle to butAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update xlimit
set(handles.xslider,'Enable','off');
xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;


varind = handles.plot;

c = get(handles.axes2,'Color');
set(handles.axes2,'Color',[1 0.93 0.93]);

rect = getrect(handles.axes2); %rect = [xmin ymin width height] (unit = unit of x-axis)


set(handles.axes2,'Color',c);

if rect(3) == 0
    set(handles.xslider,'Enable','on');

    return
end

%Check if selected region is valid
x = zeros(2,1);
if rect(1)<0
    x(1) = 0;
else
    x(1) = rect(1);
end
x(2) = rect(1) + rect(3);

if x(2)>xmax
    x(2) = xmax;
end

ind1 = ceil(x(1)*handles.yfs(varind));
ind2 = floor(x(2)*handles.yfs(varind));



handles.roiind1 = [handles.roiind1;ind1];
handles.roiind2 = [handles.roiind2;ind2];
handles.roiname = [handles.roiname;{[]}];


str = ['',' (',...
    num2str(ind1/handles.yfs(varind),'%10.2f'),' - ',...
    num2str(ind2/handles.yfs(varind),'%10.2f'),' sec)'];

temp = get(handles.listROI,'String');
temp = [temp;str];
set(handles.listROI,'String',temp,'Value',length(temp));

handles.keyroi = [handles.keyroi;length(temp)];


   



%Draw the ROI
%Call listROI_Callback
listROI_Callback(handles.listROI, eventdata, handles);
 
set(handles.listROI,'Enable','on');
set(handles.butROIName,'Enable','on');
set(handles.butDeleteROI,'Enable','on');
set(handles.butDBase,'Enable','on');
set(handles.butDROI,'Enable','on');
set(handles.editDBase,'Enable','on');
set(handles.editDROI,'Enable','on');

guidata(hObject,handles);






% --- Executes on selection change in popWindow.
function popWindow_Callback(hObject, eventdata, handles)
% hObject    handle to popWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popWindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popWindow
selectWindow = get(handles.popWindow,'Value');
if ~isempty(handles.ytime{1})
    maxtime = handles.ytime{1}(end);
elseif ~isempty(handles.ytime{2})
    maxtime = handles.ytime{2}(end);
else
    disp('Signals have not been selected');
    return;
end
switch selectWindow
    case 1
        handles.window = maxtime;
        handles.sliderstep = 0;
    case 2 
        handles.window = 5; % 5sec
        handles.sliderstep = 0.5; % 0.5sec
    case 3
        handles.window = 10; % 10sec
        handles.sliderstep = 1;
    case 4
        handles.window = 20; % 20sec
        handles.sliderstep = 3;
    case 5
        handles.window = 30; % 30sec
        handles.sliderstep = 5;
    case 6
        handles.window = 50; % 50sec
        handles.sliderstep = 10;
    case 7
        handles.window = 60; % 1mins
        handles.sliderstep = 20; 
    case 8
        handles.window = 3*60; % 3mins
        handles.sliderstep = 20;
    case 9
        handles.window = 5*60; % 5mins
        handles.sliderstep = 30;
    case 10
        handles.window = 7*60; % 7mins
        handles.sliderstep = 60;
    case 11
        handles.window = 10*60; % 10mins
        handles.sliderstep = 100;
    case 12
        handles.window = 15*60; % 15mins
        handles.sliderstep = 100;
        
    case 13
        handles.window = 20*60; % 20mins
        handles.sliderstep = 120;
    case 14
        handles.window = 30*60; % 30mins
        handles.sliderstep = 180;
     
end

%Plot signals
xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;

if xmax>maxtime % When viewing window is longer than the rest of the signal
    xmax = maxtime;
    xmin = xmax-handles.window;
    set(handles.xslider,'Value',xmin);
end
if xmin<0
    xmin = 0;
    %change slidervalue everytime xmin changes,
    set(handles.xslider,'Value',xmin);
end

%Enable xslider

if handles.window == maxtime % View full signal
    set(handles.xslider,'Enable','off','Value',0);
    handles.sliderstep = 0;
    set(handles.popWindow,'Value',1);
else
    sliderrange = maxtime-handles.window;
    %Step from the slider through is 10% larger than that of the arrow
    set(handles.xslider,'SliderStep',[handles.sliderstep/sliderrange 10*handles.sliderstep/sliderrange]);
    set(handles.xslider,'Enable','on','Min',0,'Max',sliderrange);    
end

plotSignalTrace(handles,[xmin xmax]);
handles = guidata(hObject);

figure(handles.output);

guidata(hObject,handles);


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




% --- Executes on button press in chkFindMin.
function chkFindMin_Callback(hObject, eventdata, handles)
% hObject    handle to chkFindMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFindMin
if get(hObject,'Value')
    set(handles.chkFindMax,'Value',0);
end
guidata(hObject,handles);

% --- Executes on button press in chkFindMax.
function chkFindMax_Callback(hObject, eventdata, handles)
% hObject    handle to chkFindMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkFindMax
if get(hObject,'Value')
    set(handles.chkFindMin,'Value',0);
end
guidata(hObject,handles);
% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4





% --- Executes on button press in butSignal2.
function butSignal2_Callback(hObject, eventdata, handles)
% hObject    handle to butSignal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load(fullfile(handles.subfexsettingpath,'fexsetting'));
varind = get(handles.listWrkspc,'Value');
h = waitbar(0,'Please wait...');
steps = length(varind);
for n=1:length(varind)
   y = handles.signal{varind(n)}; %selected signal
   if isvector(y) && isnumeric(y) && ~isscalar(y) 
       
       %Save previous filename of the 2nd signal, The 1st signal for axes1
       tempfile = handles.yfilename{2};
       
       if ~strcmp(handles.filename{varind(n)},tempfile) %If the selected signal does not belong to the same file as other signals
           if length(handles.y)>2
               handles.y(3:end,:) = [];
               handles.yvarname(3:end,:) = [];
               handles.yfs(3:end,:) = [];
           end
           handles.y{2} = y;
           handles.yvarname{2} = handles.varname{varind(n)};
           handles.yfs(2) = handles.fs(varind(n));
           handles.yfilename{2} =  handles.filename{varind(n)}; %Two signals should come from the same file
           handles.yacrostic{2} = handles.acrostic{varind(n)};
           handles.ysubjnum{2}  = handles.subjnum{varind(n)};
           handles.yexptdate{2} =  handles.exptdate{varind(n)};
           handles.yexpttime{2} = handles.expttime{varind(n)};
           
           time = 0:1:length(y)-1;
           handles.ytime{2} = time/handles.yfs(2);
           
           
           
           set(handles.listSignal2,'String',handles.yvarname{2});
           set(handles.popWindow,'Enable','on');
           
           handles.roiind1 = [];
           handles.roiind2 = [];
           handles.roiname = {[]};
           %Points roi
           handles.proiind = [];
           handles.proiname = {[]};
           %Keys to roi
           handles.keyroi = [];
           handles.keyproi = [];
           handles.plot = 2;
           
           %ROI list
           set(handles.listROI,'String',{},'Value',1); %Clear ROI list
           set(handles.editROI,'Enable','on');
           
           handles.tagname = [];
           handles.tagtime(1) = -1;
           handles.tagtime(2) = -1;
           

           
           %Reset for new signal
           handles.trend = cell(2,1);
           
           %Automatically get trend
            switch filtertype
            case 1 %median filter window
                trend = getTrend(y,'window',round(medianfilterwindow*handles.yfs(2)));
            case 2
                trend = lowfilterHamming10(y);
            end
          
           handles.trend{2} = trend;
           

           handles.movingwindow = 5;
           
           %Features
           handles.dbase = [];
           handles.droiind = [];
           set(handles.editDBase,'String','','Enable','off');
           set(handles.editDROI,'String','','Enable','off');
           set(handles.editROI,'String','');
           set(handles.butExtract,'Enable','off');
           set(handles.butDBase,'Enable','off');
           set(handles.butDROI,'Enable','off');
           set(handles.butDeleteSignal2,'Enable','on');
           set(handles.butPlot,'Enable','on');
           set(handles.butUpdateTag,'Enable','on');
           
           %Call butUpdateTag callback
           butUpdateTag_Callback(hObject, eventdata, handles);
           handles = guidata(hObject);
       else
           if ismember(handles.varname{varind(n)},handles.yvarname(2:end))
               warndlg('The signal already exists','Warning!');
               close(h);
               return;
           end
           handles.y = [handles.y;y];
           handles.yvarname = [handles.yvarname;handles.varname{varind(n)}];
           handles.yfs = [handles.yfs;handles.fs(varind(n))];
           
           time = 0:1:length(y)-1;
           handles.ytime = [handles.ytime;{time/handles.yfs(end)}];
          
           %Automatically get trend
            switch filtertype
                case 1 %median filter window
                    trend = getTrend(y,'window',round(medianfilterwindow*handles.yfs(end)));
                case 2
                    trend = lowfilterHamming10(y);
            end
          
           handles.trend = [handles.trend;trend];
           
           

           str = get(handles.listSignal2,'String');
           set(handles.listSignal2,'String',[str;handles.yvarname(end)]);
           set(handles.butPlot,'Enable','on');
           set(handles.butDeleteSignal2,'Enable','on');
           set(handles.butUpdateTag,'Enable','on');
           
       end
       
       
       %Plot
       if ~isempty(handles.ytime{1})
           maxtime = max(handles.ytime{1}(end),handles.ytime{2});
       else
           maxtime = handles.ytime{2}(end);
       end
       
       handles.window = maxtime;
       plotSignalTrace(handles);
       set(handles.popWindow,'Value',1);
       set(handles.xslider,'Value',0,'Enable','off');
       set(handles.butJump,'Enable','on');
       set(handles.editFrom,'Enable','on'); 
       set(handles.editTo,'Enable','on');
       set(handles.butAdd,'Enable','on');
       set(handles.listSignal2,'Enable','on');


       
       
       handles = guidata(hObject);

       
   else
       warndlg('Selected variable is invalid for computing stationary PSD.','Warning','modal');
       return
       
   end
   
   waitbar(n/steps);
    
end
close(h); 



guidata(hObject,handles);



function editSignal2_Callback(hObject, eventdata, handles)
% hObject    handle to editSignal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSignal2 as text
%        str2double(get(hObject,'String')) returns contents of editSignal2 as a double


% --- Executes during object creation, after setting all properties.
function editSignal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSignal2 (see GCBO)
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

% contents = cellstr(get(hObject,'String')); % returns listWrkspc contents as cell array
temp = handles.filename{get(hObject,'Value')}; % returns selected item from listWrkspc
[pathstr,name,ext] = fileparts(temp);
set(handles.editFilename,'String',[name,ext]);
guidata(hObject,handles);

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


% --- Executes when user attempts to close figFEX.
function figFEX_CloseRequestFcn(hObject, eventdata, handles)
% figFEX_CloseRequestFcn closes Feature extraction and its children 

% hObject    handle to figFEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
h = guidata(handles.DataBrowser);
h.subFEX = [];
guidata(handles.DataBrowser,h);
%Delete children
if ~isempty(handles.subfex_filtersetting) && isvalid(handles.subfex_filtersetting)
    close(handles.subfex_filtersetting);
end

%Delete children
if ~isempty(handles.subfex_analyzesetting) && isvalid(handles.subfex_analyzesetting)
    close(handles.subfex_analyzesetting);
end

handles.subfex_filtersetting = [];
delete(hObject);



function editFrom_Callback(hObject, eventdata, handles)
% hObject    handle to editFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFrom as text
%        str2double(get(hObject,'String')) returns contents of editFrom as a double
% butJump_Callback(hObject,eventdata,handles);
% handles = guidata(hObject);
% guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editFrom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFrom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in butJump.
function butJump_Callback(hObject, eventdata, handles)
% hObject    handle to butJump (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% users insert (uncheck all boxes)
from = str2double(get(handles.editFrom,'String'));
to = str2double(get(handles.editTo,'String'));
    
if isnan(from) && isnan(to)
    %warning
    msgbox('Please enter the begining time & end time','Warning','warn');
    return;
elseif isnan(from),
        from = to;
elseif isnan(to),
        to = from;
end

lookAt(handles,from,to);
handles = guidata(hObject);
guidata(hObject,handles);


function editTo_Callback(hObject, eventdata, handles)
% hObject    handle to editTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTo as text
%        str2double(get(hObject,'String')) returns contents of editTo as a double
% butJump_Callback(hObject,eventdata,handles);
% handles = guidata(hObject);
% guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function editTo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on slider movement.
function yslider2_Callback(hObject, eventdata, handles)
% hObject    handle to yslider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function yslider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yslider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function yslider1_Callback(hObject, eventdata, handles)
% hObject    handle to yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function yslider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yslider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes during object creation, after setting all properties.
function listTag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in butUpdateTag.
function butUpdateTag_Callback(hObject, eventdata, handles)
% hObject    handle to butUpdateTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update listbox
handlesTE = getActiveTagEditor(handles);
definetags = handlesTE.getDefineRegionTags(handlesTE,'DefineRegion');
 
if ~isempty(definetags) && ~isempty(handles.yfilename{2}) %Check filename
   str = {};
   tagcol = 12; % name of tags
   begincol = 10;
   endcol = 11;
   timestamp = [];
   tagname = {};
  
   [pathstr,name,ext] = fileparts(handles.yfilename{2});
    
    tagid = find(ismember(definetags(:,1),[name,ext])); %Search tags defined from yfilename{2}
   
    %Quick fix, how much it matches 9September2018
    for n=1:length(definetags(:,1)) %Loop all tags
        %How much it matches
        if length(name) > 10
            existing_tag = definetags{n,1}(1:10); %Use 10 characters
            existing_name = name(1:10);
        else %Assume definetags longer than name
           l_name = length(name);
           existing_tag = definetags{n,1}(1:l_name);
            existing_name = name;
        end
        %Check similarity
        result = existing_tag-existing_name;
        %Count how many non-zeros
        if any(result) %If there is one position does not match
            continue
        else %Match
             tag = [definetags{n,tagcol},' (',...
             num2str(definetags{n,begincol},'%10.2f'),' - ',... %get begin time
             num2str(definetags{n,endcol},'%10.2f'),' sec)']; %get end time
             str = [str; tag];
             timestamp = [timestamp;definetags{n,begincol},definetags{n,endcol}];
             tagname = [tagname;definetags{n,tagcol}];
        end
        
    end
    
    
      
   %% Update listROI 
   temp = get(handles.listROI,'String'); 
   
   %Extract str elements that are not a member of temp
   ind = ~ismember(str,temp);
   newmembers = str(ind);
   timestamp = timestamp(ind,:);
   tagname = tagname(ind);
   
   varind = handles.plot;

   for ntag=1:length(tagname)
       ind1 = ceil(timestamp(ntag,1)*handles.yfs(varind));
       ind2 = floor(timestamp(ntag,2)*handles.yfs(varind));
       
       
       handles.roiind1 = [handles.roiind1;ind1]; %ind1 has to use sampling freq
       handles.roiind2 = [handles.roiind2;ind2]; %ind2 has to use sampling freq
       handles.roiname = [handles.roiname;tagname{ntag}];
   end
   temp = [temp;newmembers];
   set(handles.listROI,'String',temp,'Value',length(temp));
   
   handles.keyroi = [handles.keyroi;length(handles.keyroi)+(1:length(newmembers))'];
   %Let's change this to listROI 13Jan2019
   %set(handles.listROI,'String',str,'Value',1); %New tags from data browser + defined tags in FEX
   
   if ~isempty(handles.keyroi)
      set(handles.listROI,'Enable','on'); 
      set(handles.butROIName,'Enable','on');
      set(handles.butDeleteROI,'Enable','on');
      
      set(handles.butDBase,'Enable','on');
      set(handles.butDROI,'Enable','on');
      set(handles.editDBase,'Enable','on');
      set(handles.editDROI,'Enable','on');
 
   else
      set(handles.listROI,'Enable','off'); 
      set(handles.butROIName,'Enable','off');
      set(handles.butDeleteROI,'Enable','off');
      
      set(handles.butDBase,'Enable','off');
      set(handles.butDROI,'Enable','off');
      set(handles.editDBase,'Enable','off');
      set(handles.editDROI,'Enable','off');
      
   end
   
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




% --- Executes on selection change in listROI.
function listROI_Callback(hObject, eventdata, handles)
% hObject    handle to listROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listROI contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listROI
%Patch an object to handles.axes2
hold(handles.axes2,'on');
if isfield(handles,'tagrec') && ~isempty(handles.tagrec)
    if isempty(handles.y{2})
        return; %Axes2 is empty
    end
    
    varind = get(hObject,'Value');
    if length(varind)>1
        varind = varind(1);
    end
    
    ind(1) = handles.roiind1(varind); %No need to convert the frequency because it is done when click butPlot
    ind(2) = handles.roiind2(varind);
    
    time = handles.ytime{handles.plot};    
    ylim = get(handles.axes2,'YLim');
    
    %Reset position
    set(handles.tagrec,'Position',[time(ind(1)) ylim(1) time(ind(2))-time(ind(1)) ylim(2)-ylim(1)],'EdgeColor','r','LineWidth',2);
else
        

    if isempty(handles.y{2})
        return; %Axes2 is empty
    end
    varind = get(hObject,'Value');
    if length(varind)>1
        varind = varind(1);
    end
    ind(1) = handles.roiind1(varind); %No need to convert the frequency because it is done when click butPlot
    ind(2) = handles.roiind2(varind);
    time = handles.ytime{handles.plot};    
    ylim = get(handles.axes2,'YLim');
    
    
    %Get the current variable and sampling frequency
    handles.tagrec = rectangle(handles.axes2,'Position',[time(ind(1)) ylim(1) time(ind(2))-time(ind(1)) ylim(2)-ylim(1)],'EdgeColor','r','LineWidth',2);

    
    
end
hold(handles.axes2,'off');
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function listROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butROIName.
function butROIName_Callback(hObject, eventdata, handles)
% hObject    handle to butROIName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = get(handles.editROI,'String');
if ~isempty(name)
    currentstr = get(handles.listROI,'String');
    varind = get(handles.listROI,'Value');
    str= currentstr{varind}; %selected signal

   %roiname
   i1 = strfind(str,'(');
   name = [name,str(i1-1:end)];
   currentstr{varind} = name;
   set(handles.listROI,'String',currentstr);  
   set(handles.editROI,'String','');
end

guidata(hObject,handles);



function editROI_Callback(hObject, eventdata, handles)
% hObject    handle to editROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editROI as text
%        str2double(get(hObject,'String')) returns contents of editROI as a double


% --- Executes during object creation, after setting all properties.
function editROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDBase.
function butDBase_Callback(hObject, eventdata, handles)
% hObject    handle to butDBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Average baseline and put it in the editbox
contents = get(handles.listROI,'String');
ind = get(handles.listROI,'Value');
ind = ind(1); %Always choose the first baseline when users select multiples ones


if ~isempty(contents)
    %Search roi from keyroi and keyproi
    varind = handles.plot;
    handles.dbase = zeros(length(handles.y),1);
    if sum(handles.keyroi==ind)==1 %always assume only one roi occupies that ind
        loc = find(handles.keyroi==ind);
        ind1 = handles.roiind1(loc);
        ind2 = handles.roiind2(loc);
        basetime = [ind1,ind2]./(handles.yfs(varind));
        handles.dbase = basetime;

    else
        ind1 = handles.proiind(handles.keyproi==ind);
        ind2 = ind1;
        basetime = [ind1,ind2]./(handles.yfs(varind));
        handles.dbase = basetime;
    end
    seltag = contents{ind};
    i1 = strfind(contents{ind},'(');
    roiname = seltag(1:i1-2);
    if isempty(roiname)
        roiname = 'Baseline';
    end
    set(handles.editDBase,'String',roiname,'Enable','inactive');
    %Disable Move/Add/Delete buttons
    set(handles.butDeleteROI,'Enable','off');

end

xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
if get(handles.popWindow,'Value')>1
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);


function editDBase_Callback(hObject, eventdata, handles)
% hObject    handle to editDBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDBase as text
%        str2double(get(hObject,'String')) returns contents of editDBase as a double


% --- Executes during object creation, after setting all properties.
function editDBase_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDBase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end









% --- Executes on button press in butDROI.
function butDROI_Callback(hObject, eventdata, handles)
% hObject    handle to butDROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.listROI,'String');
ind = get(handles.listROI,'Value');
if isempty(contents)
    return
end

seltag = contents(ind);
i1 = cellfun(@(x) strfind(x,'('),seltag);

%%%%Set Feature Edit Box%%%%%
oldstr = get(handles.editDROI,'String');
if ~isempty(oldstr)
    [r,c] = size(oldstr);
    newstr = [];
    oldstr = cellstr(oldstr);
    for n=1:r
        if ~(sum(isspace(oldstr{n}))==length(oldstr{n}))
            newstr = [newstr,sprintf('%s\n',oldstr{n})];
        end
    end
    for m=1:length(ind)-1 %In case, multiple ROIs are selected
        roiname = seltag{m}(1:i1(m)-2);
        if isempty(roiname)
            roiname = 'roi(default)';
        end
            if sum(handles.keyroi==ind(m))==1 %always assume only one roi occupies that ind
                loc = find(handles.keyroi==ind(m));
                ind1 = handles.roiind1(loc)/handles.yfs(handles.plot);
                ind2 = handles.roiind2(loc)/handles.yfs(handles.plot);
                if ~isempty(handles.tagname) %Only when the global tag is selected
                    if (ind1>=handles.tagtime(1) && ind2<=handles.tagtime(2))
                        handles.droiind = [handles.droiind;ind1,ind2];
                        newstr = [newstr,sprintf('%s\n',roiname)];
                    else
                        warndlg('Please select ROI inside the selected TAG','Warning','Modal');
                        continue;
                    end
                else
                     handles.droiind = [handles.droiind;ind1,ind2];
                     newstr = [newstr,sprintf('%s\n',roiname)];
                    
                end
            else
                ind1 = (handles.proiind(handles.keyproi==ind(m)))/handles.yfs(handles.plot);
                if ~isempty(handles.tagname)
                    if ind1>=handles.tagtime(1) && ind1<=handles.tagtime(2)
                        handles.droiind = [handles.droiind;ind1,ind1];
                        newstr = [newstr,sprintf('%s\n',roiname)];
                    else
                        warndlg('Please select ROI inside the selected TAG','Warning','Modal');
                        continue;
                    end
                else
                    handles.droiind = [handles.droiind;ind1,ind1];
                    newstr = [newstr,sprintf('%s\n',roiname)];
                    
                end
            end
              

        
    end
    roiname = seltag{end}(1:i1(end)-2);
    if isempty(roiname)
        roiname = 'roi(default)';
    end
    
    if sum(handles.keyroi==ind(end))==1 %always assume only one roi occupies that ind
        loc = find(handles.keyroi==ind(end));
        ind1 = handles.roiind1(loc)/handles.yfs(handles.plot);
        ind2 = handles.roiind2(loc)/handles.yfs(handles.plot);
        if ~isempty(handles.tagname)
            if ind1>=handles.tagtime(1) && ind2<=handles.tagtime(2)
                handles.droiind = [handles.droiind;ind1,ind2];
                newstr = [newstr,sprintf('%s\n',roiname)];
            else
                warndlg('Please select ROI inside the selected TAG','Warning','Modal');
            end
        else
            handles.droiind = [handles.droiind;ind1,ind2];
            newstr = [newstr,sprintf('%s\n',roiname)];
        end
    else
        ind1 = (handles.proiind(handles.keyproi==ind(end)))/handles.yfs(handles.plot);
        if ~isempty(handles.tagname)
            if ind1>=handles.tagtime(1) && ind1<=handles.tagtime(2)
                handles.droiind = [handles.droiind;ind1,ind1];
                newstr = [newstr,sprintf('%s',roiname)];
            else
                warndlg('Please select ROI inside the selected TAG','Warning','Modal');
            end
        else
            handles.droiind = [handles.droiind;ind1,ind1];
            newstr = [newstr,sprintf('%s',roiname)];
        end
    end

   
  
    set(handles.editDROI,'String',newstr,'Enable','inactive');
else
    newstr = [];
    for m=1:length(ind)-1
        roiname = seltag{m}(1:i1(m)-2);
        if isempty(roiname)
            roiname = 'roi(default)';
        end
        if sum(handles.keyroi==ind(m))==1 %always assume only one roi occupies that ind
                loc = find(handles.keyroi==ind(m));
                ind1 = handles.roiind1(loc)/handles.yfs(handles.plot);
                ind2 = handles.roiind2(loc)/handles.yfs(handles.plot);
                if ~isempty(handles.tagname)
                    if ind1>=handles.tagtime(1) && ind2<=handles.tagtime(2)
                        handles.droiind = [handles.droiind;ind1,ind2];
                        newstr = [newstr,sprintf('%s\n',roiname)];
                    else
                        warndlg('Please select ROI inside the selected TAG','Warning','Modal');
                    end
                else
                    handles.droiind = [handles.droiind;ind1,ind2];
                    newstr = [newstr,sprintf('%s\n',roiname)];
                end
        else
                ind1 = (handles.proiind(handles.keyproi==ind(m)))/handles.yfs(handles.plot);
                if ~isempty(handles.tagname)
                    if ind1>=handles.tagtime(1) && ind1<=handles.tagtime(2)
                        handles.droiind = [handles.droiind;ind1,ind1];
                        newstr = [newstr,sprintf('%s\n',roiname)];
                    else
                        warndlg('Please select ROI inside the selected TAG','Warning','Modal');
                    end
                else
                    handles.droiind = [handles.droiind;ind1,ind1];
                    newstr = [newstr,sprintf('%s\n',roiname)];
                end
        end
       
    end
    %current roi
    roiname = seltag{end}(1:i1(end)-2);
    if isempty(roiname)
        roiname = 'roi(default)';
    end
    if sum(handles.keyroi==ind(end))==1 %always assume only one roi occupies that ind
       loc = find(handles.keyroi==ind(end));
       ind1 = handles.roiind1(loc)/handles.yfs(handles.plot);
       ind2 = handles.roiind2(loc)/handles.yfs(handles.plot);
       if ~isempty(handles.tagname)
           if ind1>=handles.tagtime(1) && ind2<=handles.tagtime(2)
               handles.droiind = [handles.droiind;ind1,ind2];
               newstr = [newstr,sprintf('%s\n',roiname)];
           else
               warndlg('Please select ROI inside the selected TAG','Warning','Modal');
           end
       else
            handles.droiind = [handles.droiind;ind1,ind2];
            newstr = [newstr,sprintf('%s\n',roiname)];
       end

     else
         ind1 = (handles.proiind(handles.keyproi==ind(end)))/handles.yfs(handles.plot);
         if ~isempty(handles.tagname)
             if ind1>=handles.tagtime(1) && ind1<=handles.tagtime(2)
                 handles.droiind = [handles.droiind;ind1,ind1];
                 newstr = [newstr,sprintf('%s',roiname)];
                 
             else
                 warndlg('Please select ROI inside the selected TAG','Warning','Modal');
             end
         else
             handles.droiind = [handles.droiind;ind1,ind1];
             newstr = [newstr,sprintf('%s',roiname)];
         end
    end
    set(handles.editDROI,'String',newstr,'Enable','inactive');
end
%%%%%%%%%%%%%
set(handles.butExtract,'Enable','on');
set(handles.butClear,'Enable','on');
set(handles.chkDTrend,'Enable','on','Value',0);
set(handles.chkNorm,'Enable','on','Value',0);

xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
if get(handles.popWindow,'Value')>1
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end

handles = guidata(hObject);


%Disable Move/Add/Delete buttons
set(handles.butDeleteROI,'Enable','off');
guidata(hObject,handles);

function editDROI_Callback(hObject, eventdata, handles)
% hObject    handle to editDROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDROI as text
%        str2double(get(hObject,'String')) returns contents of editDROI as a double


% --- Executes during object creation, after setting all properties.
function editDROI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butExtract.
function butExtract_Callback(hObject, eventdata, handles)
% hObject    handle to butExtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Enable Move/Add/Delete buttons

set(handles.butAdd,'Enable','on');
set(handles.butDeleteROI,'Enable','on');

if isempty(handles.y{2}) || isempty(handles.droiind)
    return
end


%Load fexsetting.mat to get no. parameters to be extract
load(fullfile(handles.subfexsettingpath,'fexsetting'));
feature = descriptivename(logical(descriptiveflag)); %List of features
ncol_info = 7; %(Fixed no of other information e.g. filename, acrostic 


tabdata = get(handles.tableDTags,'Data'); %old tags data
roiname = get(handles.editDROI,'String');
nfeature = length(feature); %This will include enablecurvefitting too
curvefeature = []; %Add later when the curve fitting is used
vasocfeature = []; %Add vasoc later when vasoc is enable

% Total no. of columns exported by FEX = ncol_info+nfeature+ncol_curvefeature

% Curve fitting features
% R-square
% Coefficients , polynomial has up to ten
% Determine no. features (ncol_curvefeature) given by each curve type
ncol_curvefeature = 0;
if descriptiveflag(9) %Is curvefitting enable?
    switch curvefittingtype
        case 1
            ncol_curvefeature = 2; %Time-to-halfmax, halfmax
        case 2 %Exponential
            ncol_curvefeature = 4; %Time-to-halfmax,halfmax,scaling,time-constant
        case 3 %Polynormial
            ncol_curvefeature = 1+polycurve.order; %Intercept, coefficients
        case 4 %Sigmoid
            ncol_curvefeature = 4; %Upper,lower,slope,midpoint
    end
    nfeature = nfeature-1;
    ind =strcmpi(feature,'enablecurvefitting');
    feature(ind) = []; 
end
ncol_mvasoc = 0; %No of parameters given by mvasoc = [mvasoc,tvasoc,avasoc,nvasoc]
if descriptiveflag(10) %If mvasoc is enable
    ncol_mvasoc = 4; %No. of features given by mvasoc = 4
    ind =strcmpi(feature,'vasoc');
    feature(ind) = []; 
    nfeature = nfeature-1;

end

%% LOOP no. signals
for n=2:length(handles.y) 
    
    %Calculate 95% of the original flow
    pct95 =  prctile(handles.y{n},95); %Percentile from the signal (can be trend or signal)
    
    %Filter if required                                   
    if get(handles.chkDTrend,'Value')
        switch filtertype
            case 1 %median filter window
                signal = getTrend(handles.y{n},'window',round(medianfilterwindow*handles.yfs(n)));
            case 2
                signal = lowfilterHamming10(handles.y{n});
        end
    else
        signal = handles.y{n};
        
    end
    
    
    %Normalized signal, normalized after filtering
    if get(handles.chkNorm,'Value')
        signal = (signal)/pct95; %Normalize by 95% maxflow
    end
    
    
    ind = round(handles.droiind.*handles.yfs(n)+1);  %Change from Time to indices
    baseline_med = [];
    baseline_mean = [];
    if ~isempty(handles.dbase) %Calculate mean of baseline ROI if selected
        ind1 = round(handles.dbase(1)*handles.yfs(n));
        ind2 = round(handles.dbase(2)*handles.yfs(n));
        baseline_med = median(signal(ind1:ind2));
        baseline_mean = mean(signal(ind1:ind2));
    end
    
    %% LOOP ROI
    for i=1:length(handles.droiind(:,1)) 
       %=================Generate Output===========================
       newtag = cell(1,ncol_info+nfeature+ncol_curvefeature+ncol_mvasoc); %Basic info, descriptive features, curve fitting features, mvasoc features
       [path,filename,ext] = fileparts(handles.yfilename{2});
       newtag{1,1} = filename;
       newtag{1,2} = handles.yacrostic{2};
       newtag{1,3} = handles.yexptdate{2};
       newtag{1,4} = handles.yvarname{n};
       newtag{1,5} = 'Imported from the Browser'; %Global Tag
       newtag{1,6} = roiname(i,:);%Subregion
       newtag{1,7} = get(handles.editDBase,'String');
       
  
        y = signal(ind(i,1):ind(i,2)); %this signal may be normalized & detrended
    
        %% LOOP FEATURE
        for m=1:nfeature 
            if strcmpi(feature{m},'area')
                if ~isempty(baseline_med)

                    
                    dt = (1/(60*handles.yfs(n)));
                    temp = dt*cumtrapz(y);

                    time_y = (length(y)-1)*(dt); %min
                    output = (baseline_med*time_y)-temp(end);
                    newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
                else
                    newtag{1,ncol_info+m} = 0; %num2str(output,'%10.2f'); 
                end
            elseif strcmpi(feature{m},'mean')
                output = mean(y);  
                newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f');           
            elseif strcmpi(feature{m},'median')
                output = median(y);
                newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f'); 
            elseif strcmpi(feature{m},'min')
                output = min(y); 
                newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f'); 
            elseif strcmpi(feature{m},'max')
                output = max(y);
                newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output)); %num2str(output,'%10.4f'); 
            elseif strcmpi(feature{m},'duration')
                output = handles.droiind(i,2)-handles.droiind(i,1); 
                newtag{1,ncol_info+m} = str2double(sprintf('%0.2f',output)); %num2str(output,'%10.2f');
            elseif strcmpi(feature{m},'maxflow')    
                 newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',pct95)); %num2str(output,'%10.4f');
            elseif strcmpi(feature{m},'cv')
                %output = var(y);
                if mean(y)~=0
                    output = std(y)./(mean(y)); %Coefficient of variation
                else
                    output = 0;
                end
                newtag{1,ncol_info+m} = str2double(sprintf('%0.4f',output));           
            end
 
                                        
        end
        
        %Add curve fitting features
        if descriptiveflag(9) %is curve fitting enabled?, add curve fitting features to the output
            try
                x = (0:length(y)-1)/handles.yfs(n); x = x';
                %Initial parameters
                %Expo = scaling,timeconstant
                %Poly = order
                %Sigmoid = upper,lower
                switch curvefittingtype
                    case 1 %Just use whatever there is, for simplicity 
                        initpar = [];
                        
                    case 2 
                        initpar = expocurve;
                    case 3
                        initpar = polycurve;
                    case 4
                        initpar = sigmoidcurve;
                        
                end
                
                curvefitting_result = fex_fitcurve(y,x,'AnalysisRegion',analysisregion,'Curvetype',curvefittingtype,'Init',initpar,'ROIname',roiname(i,:),'Varname',handles.yvarname{n},'Filename',filename);
                curvefeature = curvefitting_result.feature;
                
                %Add output from the curvefitting, after LOOP FEATURE
                %% Add values
                offset = ncol_info+nfeature;
                for nc=1:ncol_curvefeature
                    newtag{1,offset+nc} = str2double(sprintf('%0.4f',curvefitting_result.par(nc)));                  
                end
                
            
            catch ME %Catch an error           
                disp(ME); %Display error               
                %Handle error by assining empty values to newtag
                curvefeature = repmat({'Empty'},1,ncol_curvefeature); %Empty features
                
            end
        end
        
        if descriptiveflag(10) %mvasoc enabled
            offset = ncol_info+nfeature+ncol_curvefeature;
            [Mvasoc, Avasoc, Tvasoc, Nvasoc] = get_vasoc_features(y, handles.yfs(n)); 
            newtag{1,offset+1} = str2double(sprintf('%0.4f',Mvasoc));
            newtag{1,offset+2} = str2double(sprintf('%0.4f',Avasoc));
            newtag{1,offset+3} = str2double(sprintf('%0.4f',Tvasoc));
            newtag{1,offset+4} = str2double(sprintf('%0.4f',Nvasoc));
            vasocfeature = {'mvasoc','avasoc','tvasoc','nvasoc'};
        end
                        

   
        checkbox = num2cell(false(1,1)); 
        display = [checkbox,newtag];
        
        %% Prepare output for the table
        %Check colum name of the table if they match feature
        columnname = get(handles.tableDTags,'ColumnName');
        columnname = lower(columnname(9:end)); % column 1-7 = select,patient info, 8 = baseline

            
        allfeature = [feature,curvefeature,vasocfeature];

        if length(columnname) ~= (nfeature+ncol_curvefeature+ncol_mvasoc)
            newfeature ={'yes'};
        else
            newfeature = {};
            for m=1:(nfeature+ncol_curvefeature+ncol_mvasoc)
                if ~strcmpi(columnname{m},allfeature{m}) %Check if new features are added or not
                    newfeature = {'yes'};
                    break;
                end
            end
                    
        end
        

        if isempty(newfeature) %No need to add new features
            %Append the data
            tabdata = [tabdata; display]; %updated table data
            handles.fextags = [handles.fextags;newtag];
           
            
        else %Re create table to match the features
            %Create a new table
            set(handles.tableDTags,'Data',cell(size(display)));
            set(handles.tableDTags,'ColumnName',[{'Select','Filename','Acrostic','Exptdate','Variable','CSVTagfile','Taskname','Baseline'},allfeature]); 
            set(handles.tableDTags,'Units','pixels');
            pos = get(handles.tableDTags,'Position');
            width = round(pos(3)/(2+size(display,2)));
            
            if width >30 %use width
                columnwidth = repmat({width},1,length(display));
                columnwidth{2}= round(0.5*width);
                columnwidth{2}= 2*width; %mat filename
                columnwidth{6}= 2*width; %tag filename
                set(handles.tableDTags,'ColumnWidth',columnwidth,'Units','normalized');
            end
            
            tabdata =display; %updated table data
            handles.fextags = newtag;
            set(handles.tableDTags,'Units','normalized');

        end
    end
end

handles.feature = allfeature;
set(handles.tableDTags,'Data',tabdata,'Enable','on');
set(handles.chkSelectAll,'Enable','on','Value',0);
set(handles.butSaveOutput,'Enable','on');

set(handles.butDeleteTags,'Enable','on');
set(handles.butExtract,'Enable','off');

%Remove baseline&roi
handles.dbase = [];
handles.droiind = [];

%Remove global tag
handles.tagname = [];
handles.tagtime(1) = -1;
handles.tagtime(2) = -1;
set(handles.editDROI,'String','');
set(handles.editDBase,'String','');

guidata(hObject,handles);




function editFeature_Callback(hObject, eventdata, handles)
% hObject    handle to editFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFeature as text
%        str2double(get(hObject,'String')) returns contents of editFeature as a double


% --- Executes during object creation, after setting all properties.
function editFeature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFeature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in chkDTrend.
function chkDTrend_Callback(hObject, eventdata, handles)
% hObject    handle to chkDTrend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkDTrend

%Plot Trend
xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
if get(handles.popWindow,'Value')>1
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);


% --- Executes on button press in butDeleteTags.
function butDeleteTags_Callback(hObject, eventdata, handles)
% hObject    handle to butDeleteTags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Get selected tag rows
[tabdata,ind,select] = getSelectedTags(handles);

if isempty(select)
    return
end

handles.fextags(select,:) = []; %updated tag list
tabdata(select,:) = [];
set(handles.tableDTags,'Data',tabdata);

if isempty(handles.fextags)
    set(handles.butDeleteTags,'Enable','off');
    set(handles.chkSelectAll,'Value',0);
end


guidata(hObject,handles);




% --- Executes on button press in chkSelectAll.
function chkSelectAll_Callback(hObject, eventdata, handles)
% hObject    handle to chkSelectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkSelectAll
tabdata = get(handles.tableDTags,'Data');
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
set(handles.tableDTags,'Data',tabdata);
guidata(hObject,handles);


% --- Executes on selection change in listSignal2.
function listSignal2_Callback(hObject, eventdata, handles)
% hObject    handle to listSignal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listSignal2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listSignal2


% --- Executes during object creation, after setting all properties.
function listSignal2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listSignal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butDeleteSignal2.
function butDeleteSignal2_Callback(hObject, eventdata, handles)
% hObject    handle to butDeleteSignal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.plot = varind+1 because it points to handles.y which includes  therm in the first cell
varind = get(handles.listSignal2,'Value')+1;

if varind<handles.plot %Shift all variables upward
    handles.plot = handles.plot-1;
elseif varind == handles.plot %
    oldfs = handles.yfs(handles.plot);
    if varind>2
        handles.plot = handles.plot-1; 
        newfs = handles.yfs(handles.plot);
    elseif length(handles.y)>2
        newfs = handles.yfs(handles.plot+1);
    else
        newfs = oldfs;
    end
    % %Correct roiind
    if ~isempty(handles.roiind1)
        handles.roiind1 = round(handles.roiind1.*(newfs/oldfs));
    end
    if ~isempty(handles.roiind2)
        handles.roiind2 = round(handles.roiind2.*(newfs/oldfs));
    end
    if ~isempty(handles.proiind)
        handles.proiind = round(handles.proiind.*(newfs/oldfs));
    end
        
end



str = get(handles.listSignal2,'String');
if ~isempty(str)
    str(varind-1) = [];
end

    
if varind>0
   if length(handles.y)==2 && varind==2
       handles.y{2} = [];
       handles.yfs(2) = 0;
       handles.yvarname{2} = [];
       handles.ytime{2} = [];
       handles.plot = 0;
       handles.roiind1 = [];
       handles.roiind2 = [];
       handles.proiind = [];
       handles.yfilename{2} =  []; %Two signals should come from the same file
       handles.yacrostic{2} = [];
       handles.ysubjnum{2}  = [];
       handles.yexptdate{2} = [];
       handles.yexpttime{2} = [];
             
        handles.roiind1 = [];
        handles.roiind2 = [];
        handles.roiname = {[]};
        %Points roi
        handles.proiind = [];
        handles.proiname = {[]};
        %Keys to roi
        handles.keyroi = [];
        handles.keyproi = [];
        
        %ROI list
        set(handles.listROI,'String',{},'Value',1);
        set(handles.editROI,'Enable','on');

        handles.tagname = [];
        handles.tagtime(1) = -1;
        handles.tagtime(2) = -1;
               
 
        %Features
        handles.dbase = [];
        handles.droiind = [];
        set(handles.editDBase,'String','','Enable','inactive');
        set(handles.editDROI,'String','','Enable','inactive');
        set(handles.editROI,'String','');
        set(handles.butExtract,'Enable','off');
        set(handles.butDBase,'Enable','on');
        set(handles.butDROI,'Enable','on');
        set(handles.butDeleteSignal2,'Enable','off');
        set(handles.butPlot,'Enable','off');
        set(handles.butUpdateTag,'Enable','off');
        
        set(handles.listSignal2,'String',[],'Value',1);  
        
        %Clear plot
        cla(handles.axes2);
        title(handles.axes2,'');
       
   else
        handles.y(varind) = [];
        handles.yfs(varind) = [];
        handles.yvarname(varind) = [];
        handles.ytime(varind) = [];
        set(handles.listSignal2,'String',str,'Value',handles.plot-1);
   end
   
   
   if ~isempty(handles.trend)
          handles.trend(varind) = []; % handles.roiind1 = round(handles.roiind1.*(handles.yfs(varind)/tempfs));
   end
   
   
end
if get(handles.popWindow,'Value')>1
    xmin = get(handles.xslider,'Value');
    xmax = xmin+handles.window;
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);


% --- Executes on button press in butPlot.
function butPlot_Callback(hObject, eventdata, handles)
% hObject    handle to butPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(handles.y{2})
    return
end
tempfs = handles.yfs(handles.plot);
handles.plot = get(handles.listSignal2,'Value')+1;
varind = handles.plot;
%Correct roiind
if ~isempty(handles.roiind1)
 handles.roiind1 = round(handles.roiind1.*(handles.yfs(varind)/tempfs));
end
if ~isempty(handles.roiind2)
 handles.roiind2 = round(handles.roiind2.*(handles.yfs(varind)/tempfs));
end
if ~isempty(handles.proiind)
 handles.proiind = round(handles.proiind.*(handles.yfs(varind)/tempfs));
end
 

 %Plot Trend
if get(handles.popWindow,'Value')>1
    xmin = get(handles.xslider,'Value');
    xmax = xmin+handles.window;
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);


% --- Executes on button press in butClear.
function butClear_Callback(hObject, eventdata, handles)
% hObject    handle to butClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.butAdd,'Enable','on');


% handles.feature = [];
handles.dbase = [];
handles.droiind = [];
set(handles.editDROI,'String','');
set(handles.editDBase,'String','');
set(handles.chkDTrend,'Enable','on','Value',0);
set(handles.chkNorm,'Enable','on','Value',0);
set(handles.butExtract,'Enable','off');
set(handles.butDeleteROI,'Enable','on');

if get(handles.popWindow,'Value')>1
    xmin = get(handles.xslider,'Value');
    xmax = xmin+handles.window;
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);


% --------------------------------------------------------------------
function toolScreenshot_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to toolScreenshot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Turn off any line selection highlight

[figfile,figpath] = uiputfile('*.*','Take a Screenshot of the GUI');
if ~ischar(figfile)
    return %return if choosing invalid file
end

pause(0.3); %to ensure that the uiputfile figure is already closed

pos = get(handles.figFEX,'Position');
imgdata = screencapture(0,'Position',pos); %take a screen capture
imwrite(imgdata,fullfile(figpath,[figfile,'.png'])); %save the captured image to file

guidata(hObject, handles); %update handles structure












% --- Executes on button press in butSaveOutput.
function butSaveOutput_Callback(hObject, eventdata, handles)
% hObject    handle to butSaveOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Turn off any line selection highlight
[tabdata,ind,select] = getSelectedTags(handles);
if isempty(select)
    return
end

data = handles.fextags(select,:);
allresults_feature = handles.feature;
% get the selected file/path from users
[file,path] = uiputfile('results.csv','Save Output');

% write file
if ~isequal(file,0)
    filepath = fullfile(path,file);
    colname = [{'Filename','Acrostic','ExptDate','Variable','CSVTagfile','Taskname','Baseline'},allresults_feature];
    %Check existing file
    if exist(filepath,'file') == 2       
        [pp,ff,ext] =fileparts(file);
        filepath = fullfile(path,[ff,'_temporary',ext]);
        T = cell2table(data,'VariableNames',colname);
        % writetable([temp;T],filepath);
        writetable(T,filepath);
        warndlg(['The file is being opened, results are saved under ',ff,'_temporary.csv instead']);
    else
       temp = [];
       T = cell2table(data,'VariableNames',colname);
       writetable([temp;T],filepath);
    end
    

    
end

guidata(hObject,handles);


% --- Executes on button press in butDeleteROI.
function butDeleteROI_Callback(hObject, eventdata, handles)
% hObject    handle to butDeleteROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
locs = get(handles.listROI,'Value');
if ~isempty(locs)
    handles.roiind1(locs) = [];
    handles.roiind2(locs) = [];
    handles.roiname(locs) = [];
    
    temp = get(handles.listROI,'String');
    temp(handles.keyroi(locs)) = [];
    set(handles.listROI,'String',temp,'Value',1);
    
    %Update Key
    temp = zeros(length(handles.keyroi),1);
    temp(locs) = -1;
    handles.keyroi = handles.keyroi+cumsum(temp);
    temp = handles.keyroi(locs);
    handles.keyroi(locs) = [];
    
    %Update keyproi
    for n=1:length(temp)
        ind = find(handles.keyproi>temp(n));
        if ~isempty(ind)
            handles.keyproi(ind) = handles.keyproi(ind)-1;
        end
    end
    
    if isempty(handles.keyroi) && isempty(handles.keyproi)
        set(handles.listROI,'Enable','off');
        set(handles.butROIName,'Enable','off');
        set(handles.butDeleteROI,'Enable','off');
        set(handles.butDBase,'Enable','off');
        set(handles.butDROI,'Enable','off');
        set(handles.editDBase,'Enable','off');
        set(handles.editDROI,'Enable','off');
        
    end
end

if get(handles.popWindow,'Value')>1

    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);


% --------------------------------------------------------------------
function fextool_zoomin_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to fextool_zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in chkNorm.
function chkNorm_Callback(hObject, eventdata, handles)
% hObject    handle to chkNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkNorm
xmin = get(handles.xslider,'Value');
xmax = xmin+handles.window;
if get(handles.popWindow,'Value')>1
    plotSignalTrace(handles,[xmin xmax]);
else
    plotSignalTrace(handles);
end
handles = guidata(hObject);

guidata(hObject,handles);



% --------------------------------------------------------------------
function menuMode_Callback(hObject, eventdata, handles)
% hObject    handle to menuMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function submenuNormalFEX_Callback(hObject, eventdata, handles)
% hObject    handle to submenuNormalFEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Visible','off');
set(handles.panelBatch,'Position',[0.152 0.537 0.846 0.461]);
%set(handles.axes1,'Visible','on');
set(handles.axes2,'Visible','on');
guidata(hObject,handles);

% --------------------------------------------------------------------
function submenuBatchFEX_Callback(hObject, eventdata, handles)
% hObject    handle to submenuBatchFEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.panelBatch,'Position',[0 0 1 1]);
set(handles.panelBatch,'Visible','on');

set(handles.axes2,'Visible','off');

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

folder_name = uigetdir;
handles.batch.matpath = folder_name;
if ~ischar(folder_name)
    return
end
set(handles.editMatpath,'String',folder_name);


%Set listVar
temp = what(folder_name);
handles.batch.matfiles = temp.mat; %Get a cell storing mat filenames
try
    matobj = matfile(fullfile(folder_name,handles.batch.matfiles{1})); %Create matobj to look at a variable property inside one matfile
catch
    warndlg('Oops! The folder does not have starndard matfiles','Error Load'); 
    return
end
details = whos(matobj); %Get all properties including size
names = {details.name}; 
sizes = {details.size};
logind = cellfun(@(x) x(1)>10 & x(2)==1,sizes,'UniformOutput',1); %Logical ind to elements that are time-series
logind = logind | cellfun(@(x) x(2)>10 & x(1)==1,sizes,'UniformOutput',1);
names = names(logind);

if isempty(logind)
    return   
end
%Exclude ind variables
logind = cellfun(@(x) isempty(strfind(x,'ind')),names,'UniformOutput',1); %Logical ind to elements that are not indices.
names = names(logind);
handles.batch.varlist = names;
handles.batch.fslist = 2*ones(length(names),1);
handles.batch.normlist = zeros(length(names),1);

%% Enable panelVariables
set(handles.listVars,'String',names,'Value',1);
set(handles.butAddVar,'Enable','on');
set(handles.chk2Hz,'Enable','on');
set(handles.chk30Hz,'Enable','on');
set(handles.chk250Hz,'Enable','on');
set(handles.chkOther,'Enable','on');



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
handles.batch.fslist(logind_30) = 30;

guidata(hObject,handles);

% --- Executes on button press in butSelectTagPath.
function butSelectTagPath_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectTagPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder_name = uigetdir;
if ~ischar(folder_name)
    return
end
handles.batch.tagpath = folder_name;
set(handles.editTagpath,'String',folder_name);
try %% Load a sample tag
    listtag = dir(folder_name);
    listtag = {listtag.name}; %List of the file
    % Remove wrong elements (length(filename)<5)
    cellind = strfind(listtag,'.csv');
    ind = cellfun(@(x) ~isempty(x),cellind,'UniformOutput',1);
    listtag = listtag(ind); listtag = listtag'; %Change to a column vector
    handles.batch.listtag = listtag;
    
    %Show all the tags inside the first file
    tagpath = handles.batch.tagpath;
    filename = listtag{1};
catch
    warndlg('Make sure the tag folder contains .csv tags','Tag Error');
    
end
% csvtext = importdata(fullfile(tagpath,filename));
% %Get tag column
% subregions = csvtext(2:end,12); %Discard the header

content = tagreader(fullfile(tagpath,filename));
if ~isempty(content.tagcol{1}) %Check if the function is able to read the file
   subregions = content.tagcol; 
else
   disp(['CANNOT READ THE FILE FROM ,',tagpath]);
   return;   
end
set(handles.listAllTags,'String',subregions);
handles.batch.alltags = subregions;
%Enable chkEnterROIName,butSelectBaseline,butSelectSubRegion
set(handles.chkEnterROIName,'Enable','on','Value',0);
set(handles.butSelectBaseline,'Enable','on');
set(handles.butSelectSubRegion,'Enable','on');


guidata(hObject,handles);

% --- Executes on selection change in listVars.
function listVars_Callback(hObject, eventdata, handles)
%% Description 
% Show the sampling frequency of the signal after selection
% hObject    handle to listVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listVars contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listVars


%Set to take action if double-click
% if strcmp(get(handles.figFEX,'SelectionType'),'open')
%     disp('Open');
% end
% Show the signal property
varind = get(handles.listVars,'Value');
fs = handles.batch.fslist(varind);
set(handles.editFS,'Enable','off','String','Enter Fs');
switch fs
    case 2
        set(handles.chk2Hz,'Value',1);
        set(handles.chk30Hz,'Value',0);
        set(handles.chk250Hz,'Value',0);
        set(handles.chkOther,'Value',0);
    case 30
        set(handles.chk2Hz,'Value',0);
        set(handles.chk30Hz,'Value',1);
        set(handles.chk250Hz,'Value',0);
        set(handles.chkOther,'Value',0);
    case 250
        set(handles.chk250Hz,'Value',1);
        set(handles.chk2Hz,'Value',0);
        set(handles.chk30Hz,'Value',0);
        set(handles.chkOther,'Value',0);
    
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listVars_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listVars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk30Hz.
function chk30Hz_Callback(hObject, eventdata, handles)
% hObject    handle to chk30Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk30Hz
if get(hObject,'Value'),
   set(handles.chk250Hz,'Value',0);
   set(handles.chk2Hz,'Value',0);
   set(handles.chkOther,'Value',0);
end

guidata(hObject,handles);

% --- Executes on button press in chk250Hz.
function chk250Hz_Callback(hObject, eventdata, handles)
% hObject    handle to chk250Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk250Hz
if get(hObject,'Value'),
   set(handles.chk30Hz,'Value',0);
   set(handles.chk2Hz,'Value',0);
   set(handles.chkOther,'Value',0);
end
guidata(hObject,handles);

% --- Executes on button press in chk2Hz.
function chk2Hz_Callback(hObject, eventdata, handles)
% hObject    handle to chk2Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk2Hz
if get(hObject,'Value'),
   set(handles.chk30Hz,'Value',0);
   set(handles.chk250Hz,'Value',0);
   set(handles.chkOther,'Value',0);
end
guidata(hObject,handles);

% --- Executes on button press in chkOther.
function chkOther_Callback(hObject, eventdata, handles)
% hObject    handle to chkOther (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkOther
if get(hObject,'Value'),
   set(handles.chk30Hz,'Value',0);
   set(handles.chk2Hz,'Value',0);
   set(handles.chk250Hz,'Value',0);
   set(handles.editFS,'Enable','on');
else
    set(handles.editFS,'Enable','off');
end
guidata(hObject,handles);


function editFS_Callback(hObject, eventdata, handles)
% hObject    handle to editFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFS as text
%        str2double(get(hObject,'String')) returns contents of editFS as a double


% --- Executes during object creation, after setting all properties.
function editFS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk95Norm.
function chk95Norm_Callback(hObject, eventdata, handles)
% hObject    handle to chk95Norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk95Norm
%Plot normalized signal




% --- Executes on button press in butAddVar.
function butAddVar_Callback(hObject, eventdata, handles)
% hObject    handle to butAddVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listSelectedVar,'String');
allvars = get(handles.listVars,'String');
ind = get(handles.listVars,'Value');
ind = ind(1);
newvar = allvars{ind};
if get(handles.chk250Hz,'Value')
    fs = 250;
elseif get(handles.chk30Hz,'Value')
    fs = 30;
elseif get(handles.chk2Hz,'Value')
    fs = 2;
else
      fs = str2double(get(handles.editFS,'String'));
end
%Update listSelectedVar
if isempty(oldlist)
   oldlist = {newvar}; 
   newfs = fs;
   set(handles.listSelectedVar,'String',oldlist,'Value',1);
else
    check = cellfun(@(x) strcmp(x,newvar),oldlist,'UniformOutput',1);
    if any(check)
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newvar}];
        newfs = [handles.batch.fsvar;fs];
        set(handles.listSelectedVar,'String',oldlist,'Value',1,'Enable','on');
    end
end
%Enable butDBatchVar
set(handles.butDBatchVar,'Enable','on');
handles.batch.varlist = oldlist;
handles.batch.fsvar = newfs;
guidata(hObject,handles);

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


% --- Executes on selection change in listBaseline.
function listBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to listBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listBaseline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listBaseline


% --- Executes during object creation, after setting all properties.
function listBaseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listBaseline (see GCBO)
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


% --- Executes on selection change in listSubRegion.
function listSubRegion_Callback(hObject, eventdata, handles)
% hObject    handle to listSubRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listSubRegion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listSubRegion


% --- Executes during object creation, after setting all properties.
function listSubRegion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listSubRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in butSelectBaseline.
function butSelectBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listBaseline,'String');
ind = get(handles.listAllTags,'Value');
newtag = handles.batch.alltags{ind};

if get(handles.chkEnterROIName,'Value') %Checkbox is selected
   temp = get(handles.editEnterROIName,'String');
   if ~isempty(temp)
       newtag = temp;
       set(handles.chkEnterROIName,'Value',0);
   end
end
if isempty(oldlist)
      oldlist = [oldlist;{newtag}];  
      set(handles.listBaseline,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmp(x,newtag),oldlist,'UniformOutput',1);
    if any(check)
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newtag}];
        set(handles.listBaseline,'String',oldlist,'Value',1,'Enable','on');
    end
end

handles.batch.baselineRegions = oldlist;
%Update butDBatchBaseline
set(handles.butDBatchBaseline,'Enable','on');
guidata(hObject,handles);


% --- Executes on button press in butSelectSubRegion.
function butSelectSubRegion_Callback(hObject, eventdata, handles)
% hObject    handle to butSelectSubRegion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldlist = get(handles.listSubRegion,'String');
ind = get(handles.listAllTags,'Value');
newtag = handles.batch.alltags{ind};
if get(handles.chkEnterROIName,'Value') %Checkbox is selected
   temp = get(handles.editEnterROIName,'String');
   if ~isempty(temp)
       newtag = temp;
       set(handles.chkEnterROIName,'Value',0);
   end
end
if isempty(oldlist)
      oldlist = [oldlist;{newtag}];  
      set(handles.listSubRegion,'String',oldlist,'Value',1,'Enable','on'); 
else
    check = cellfun(@(x) strcmp(x,newtag),oldlist,'UniformOutput',1);
    if any(check)
        %That tag already exists
        return
    else
        oldlist = [oldlist;{newtag}];
        set(handles.listSubRegion,'String',oldlist,'Value',1,'Enable','on');
    end
end

handles.batch.taskRegions = oldlist;
set(handles.butDBatchROI,'Enable','on');
set(handles.chkApplyFilter,'Enable','on','Value',0);
set(handles.chk95Norm,'Enable','on','Value',0);
set(handles.butBatchCompute,'Enable','on');
set(handles.butBatchClear,'Enable','on');
guidata(hObject,handles);


% --- Executes on button press in butBatchCompute.
function butBatchCompute_Callback(hObject, eventdata, handles)
% hObject    handle to butBatchCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.batch,'matpath')
    matpath = handles.batch.matpath;
else
    warndlg('PLEASE SELECT A MAT DIRECTORY'); 
end
if isfield(handles.batch,'tagpath')
    tagpath = handles.batch.tagpath;
else
    warndlg('PLEASE SELECT A TAG DIRECTORY'); 
end
if isfield(handles.batch,'listtag')
    %Update listtag again in case, users change .csv in the tag folder
    listtag = dir(tagpath);
    listtag = {listtag.name}; %List of the file
    % Remove wrong elements (length(filename)<5)
    cellind = strfind(listtag,'.csv');
    ind = cellfun(@(x) ~isempty(x),cellind,'UniformOutput',1);
    listtag = listtag(ind); listtag = listtag'; %Change to a column vector
    handles.batch.listtag = listtag;
else
    warndlg('PLEASE SELECT A PROCESSING TAG'); 
end
if isfield(handles.batch,'varlist')
    varlist = handles.batch.varlist;
else
   warndlg('PLEASE SELECT A PROCESSING VARIABLE');  
end
if isfield(handles.batch,'fsvar')
    fslist = handles.batch.fsvar;
else
   warndlg('PLEASE SELECT A SAMPLING FREQUENCY FOR THE LIST OF SELECTED VARIABLES');   
    
end
%% Check if input arguments are valid
if isempty(listtag) || isempty(varlist) || isempty(fslist)   
    return
end
if isfield(handles.batch,'taskRegions')
    taskRegions = handles.batch.taskRegions;
else
    warning('ROIs are not selected');
    return;
    
end

if isfield(handles.batch,'baselineRegions')
    baselineRegions = handles.batch.baselineRegions;
else
    disp('Baselines are not selected');
    baselineRegions = [];
end

isnorm = get(handles.chk95Norm,'Value'); %Normalize to 95 percentile
isfilter = get(handles.chkApplyFilter,'Value');
fexinp.matpath = matpath;
fexinp.tagpath = tagpath;
fexinp.listtag = listtag;
fexinp.taskRegions = taskRegions;
fexinp.baselineRegions = baselineRegions;
fexinp.varlist = varlist;
fexinp.fslist = fslist;
fexinp.isnorm = isnorm;
fexinp.isfilter = isfilter;
fexinp.settingpath = handles.subfexsettingpath;
fexinp.resultbox = handles.editBatchStat;

%% Reset result editbox
set(handles.editBatchStat,'String','Processing......');


out = batchFEX(fexinp);
handles.batch.allresults = out.allresults;
handles.batch.allresults_feature = out.feature;
missing_signals = out.missing_signals; %A counter
missing_tags = out.missing_tags; %A counter
signals_files = out.missing_signals_files; %mat files that do not have the selected variables
tags_files = out.missing_tags_files; %mat files that do not have predefined .CSV files
total = out.rounds;


lastcomputestr = datestr(datetime);


stat = ['Processing Summary::',lastcomputestr,newline,'#Total:',num2str(total),newline,'#Files with missing variables:',num2str(missing_signals),sprintf('\n'),'#Files with missing tags:',num2str(missing_tags)];

%Missing signals
statFiles = 'List of .MAT files missing the selected signals';
for n=1:length(signals_files)
   statFiles = [statFiles,newline,'>> ',signals_files{n}];
end

%Missing .CSV
statFiles = [statFiles,newline,'---------------------------------',newline,'List of .MAT files missing the .CSV files'];
for n=1:length(tags_files)
    statFiles = [statFiles,newline,'>> ',tags_files{n}];
end

%Missing ROIs
statFiles = [statFiles,newline,'---------------------------------',newline,'List of .CSV files missing the selected baseline or ROIs'];
for n=1:length(out.missing_roi_csvfiles)
    statFiles = [statFiles,newline,'>> ',out.missing_roi_csvfiles{n}];
end

stat = [stat,newline,statFiles];


set(handles.editBatchStat,'String',stat);
set(handles.butSaveBatch,'Enable','on');

guidata(hObject,handles);


% --- Executes on button press in chk250Hz.
function checkbox32_Callback(hObject, eventdata, handles)
% hObject    handle to chk250Hz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk250Hz

guidata(hObject,handles);


% --- Executes on button press in butSaveBatch.
function butSaveBatch_Callback(hObject, eventdata, handles)
% hObject    handle to butSaveBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles.batch,'allresults') || isempty(handles.batch.allresults)
    return;
else
    data = handles.batch.allresults;
    allresults_feature = handles.batch.allresults_feature;

    % get the selected file/path from users
    [file,path] = uiputfile('results.csv','Save Output');
    
    if ~isequal(file,0) 
        filepath = fullfile(path,file);
        
        
        colname = [{'Filename','Acrostic','ExptDate','Variable','CSVTagfile','Taskname','Baseline'},allresults_feature];
        %Check existing file
        if exist(filepath,'file') == 2
            %Comment out 15Oct, too many errors caused by this part
            %{
            % read .csv file
            fid = fopen(filepath);
            % read header size(c) = 1 x ncol, don't use the header
            textscan(fid,repmat('%s',1,length(colname)),1,'delimiter',',');
            % read content
            if strcmpi(allresults_feature{end},'curvetype')
                typeofinp = repmat('%f',1,length(allresults_feature)-1);
                typeofinp = [typeofinp,'%s'];
            else
                typeofinp = repmat('%f',1,length(allresults_feature));
            end
            
            try %If error occurs, then #columns of the original file do not match the output
                c = textscan(fid,['%s%s%s%s%s%s%s',typeofinp],'delimiter',',');
                fclose(fid);
                
                % set variables
                nrow = length(c{1,1});
                ncol = length(c);
                temp = cell(nrow,ncol);
                for n=1:ncol
                    % Fs,Begin and End column
                    if n>7 && ~strcmpi(colname{n},'curvetype') %Change data from the column that stores numbers to cell array
                        temp(:,n) = num2cell(c{1,n});
                    else
                        temp(:,n) = c{1,n};
                    end
                end
                temp = cell2table(temp,'VariableNames',colname);
            catch
                warndlg('Error occurs while reading the original file! results are saved under filename_temporary.csv instead');
                [pp,ff,ext] =fileparts(file);
                filepath = fullfile(path,[ff,'_temporary',ext]);
                temp = [];
            end
             %}
            [pp,ff,ext] =fileparts(file);
            filepath = fullfile(path,[ff,'_temporary',ext]);
            T = cell2table(data,'VariableNames',colname);
           % writetable([temp;T],filepath);
           writetable(T,filepath);
           warndlg(['The file is being opened, results are saved under ',ff,'_temporary.csv instead']);

            
        else
            temp = [];
            T = cell2table(data,'VariableNames',colname);
            writetable([temp;T],filepath);
        end
       
        %Comment out 15Oct2017
        %{ 
        try
            T = cell2table(data,'VariableNames',colname);
            writetable([temp;T],filepath);
        catch %If filename is wrong, or file is opened
            [pp,ff,ext] =fileparts(file);
            filepath = fullfile(path,[ff,'_temporary',ext]);
            T = cell2table(data,'VariableNames',colname);
            writetable([temp;T],filepath);   
            warndlg('The file is being opened, results are saved under filename_temporary.csv instead');
        end
        %}
    end
    
end



guidata(hObject,handles);


% --- Executes on button press in butBatchClear.
function butBatchClear_Callback(hObject, eventdata, handles)
% hObject    handle to butBatchClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.batch.varlist = [];
handles.batch.fsvar = [];
handles.batch.taskRegions = [];
handles.batch.baselineRegions = [];
handles.batch.allresults = {};

set(handles.listBaseline,'String',[]);
set(handles.listSubRegion,'String',[]);
set(handles.listSelectedVar,'String',[]);
set(handles.editBatchStat,'String',[]);
set(handles.editEnterROIName,'String',[]);

%Disable buttons
set(handles.butDBatchVar,'Enable','off');
set(handles.butDBatchBaseline,'Enable','off');
set(handles.butDBatchROI,'Enable','off');
set(handles.chkApplyFilter,'Enable','off','Value',0);
set(handles.chk95Norm,'Enable','off','Value',0);
set(handles.butBatchCompute,'Enable','off');

guidata(hObject,handles);


% --- Executes on button press in butDBatchBaseline.
function butDBatchBaseline_Callback(hObject, eventdata, handles)
% hObject    handle to butDBatchBaseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listBaseline,'Value');
oldlist = get(handles.listBaseline,'String');
if ~isempty(oldlist)
   oldlist(ind) = [];
   if isempty(oldlist)
    set(handles.listBaseline,'String',oldlist,'Value',0);
   else
    set(handles.listBaseline,'String',oldlist,'Value',1);   
   end
   handles.batch.baselineRegions(ind) = [];
end
guidata(hObject,handles);
% --- Executes on button press in butDBatchROI.
function butDBatchROI_Callback(hObject, eventdata, handles)
% hObject    handle to butDBatchROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listSubRegion,'Value');
oldlist = get(handles.listSubRegion,'String');
if ~isempty(oldlist)
   oldlist(ind) = [];
   if isempty(oldlist)
    set(handles.listSubRegion,'String',oldlist,'Value',0); %Always set listbox value, so it renders
   else
    set(handles.listSubRegion,'String',oldlist,'Value',1); %Always set listbox value, so it renders 
   end
   handles.batch.taskRegions(ind) = [];
end
guidata(hObject,handles);

% --- Executes on button press in butDBatchVar.
function butDBatchVar_Callback(hObject, eventdata, handles)
% hObject    handle to butDBatchVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ind = get(handles.listSelectedVar,'Value');
oldlist = get(handles.listSelectedVar,'String');
if ~isempty(oldlist)
   oldlist(ind) = [];
   if isempty(oldlist)
    set(handles.listSelectedVar,'String',oldlist,'Value',0);
   else
    set(handles.listSelectedVar,'String',oldlist,'Value',1); %Always set listbox value, so it renders
   end
   handles.batch.varlist(ind) = [];
   handles.batch.fsvar(ind) = [];
end

guidata(hObject,handles);



function editBatchStat_Callback(hObject, eventdata, handles)
% hObject    handle to editBatchStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBatchStat as text
%        str2double(get(hObject,'String')) returns contents of editBatchStat as a double


% --- Executes during object creation, after setting all properties.
function editBatchStat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBatchStat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editEnterROIName_Callback(hObject, eventdata, handles)
% hObject    handle to editEnterROIName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEnterROIName as text
%        str2double(get(hObject,'String')) returns contents of editEnterROIName as a double


% --- Executes during object creation, after setting all properties.
function editEnterROIName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEnterROIName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chkEnterROIName.
function chkEnterROIName_Callback(hObject, eventdata, handles)
% hObject    handle to chkEnterROIName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkEnterROIName
if get(hObject,'Value')
    set(handles.editEnterROIName,'Enable','on','String',[]);
else
    set(handles.editEnterROIName,'Enable','off','String','Enter ROI Name');
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function menuFEXSetting_Callback(hObject, eventdata, handles)
% hObject    handle to menuFEXSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject,handles);


% --------------------------------------------------------------------
function submenuFEXSettingFilter_Callback(hObject, eventdata, handles)
% hObject    handle to submenuFEXSettingFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if isempty(handles.subfex_filtersetting) || ~isvalid(handles.subfex_filtersetting)
    handles.subfex_filtersetting = subfex_filtersetting;
else
    figure(handles.subfex_filtersetting);
end

guidata(hObject,handles);


% --- Executes on button press in chkApplyFilter.
function chkApplyFilter_Callback(hObject, eventdata, handles)
% hObject    handle to chkApplyFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkApplyFilter


% --------------------------------------------------------------------
function submenuFEXSettingAnalyses_Callback(hObject, eventdata, handles)
% hObject    handle to submenuFEXSettingAnalyses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.subfex_analyzesetting) || ~isvalid(handles.subfex_analyzesetting)
    handles.subfex_analyzesetting = subfex_analyzesetting;
else
    figure(handles.subfex_analyzesetting);
end
guidata(hObject,handles);


% --- Executes when figFEX is resized.
function figFEX_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figFEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fextool_zoomin_OnCallback(hObject, eventdata, handles)
% hObject    handle to fextool_zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%zoom on;
% --------------------------------------------------------------------
function fextool_zoomout_OnCallback(hObject, eventdata, handles)
% hObject    handle to fextool_zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function figFEX_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figFEX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Delete children
if ~isempty(handles.subfex_filtersetting) && isvalid(handles.subfex_filtersetting)
    close(handles.subfex_filtersetting);
end

%Delete children
if ~isempty(handles.subfex_analyzesetting) && isvalid(handles.subfex_analyzesetting)
    close(handles.subfex_analyzesetting);
end
