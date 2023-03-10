function subtivpsd_setting(settingpath,settingfile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ispc
    fntsize = 10;
else
    fntsize = 14;
end


figw = 620;
figh = 376;
left_margin = 40; %in pixels
top_margin = 30; % in pixels
but_panel_width = 100;
but_panel_height =35;
left_margin_in_panel = 15; %
txt_height = 21.6;
txt_width = 150;
but_width = 25;
but_height = 25;
space_between_lines = 8;
panel_height = figh-2*left_margin; 
panel_width = figw-2*left_margin;
table_height = panel_height - 3*left_margin_in_panel-space_between_lines-txt_height; 
table_width = 0.5*(panel_width - 2*left_margin_in_panel); %Half of the panel's size

%% TIVPSD & TVPSD will share this figures
fig = figure; set(fig,'Name','Stationary PSD Setting','NumberTitle','off','Unit','pixels','Position',[300 300 figw figh],'Resize','off','Tag','DataBrowser_TIVPSDsetting','MenuBar','none','ToolBar','none');


settingvariables = load(fullfile(settingpath,settingfile));
df = settingvariables.df;
detrendorder = settingvariables.detrendorder;
freqname = settingvariables.freqname;
freqreg = settingvariables.freqreg;
fs = settingvariables.fs;
isnorm = settingvariables.isnorm;
selectedfreq = settingvariables.selectedfreq;
%% Create panel
         
xpos = left_margin;
ypos = left_margin;


hp = uipanel('Title','Stationary PSD: Analyze Setting','TitlePosition','centertop','FontSize',fntsize,...
             'Unit','normalized',...
             'Position',[xpos/figw ypos/figh panel_width/figw panel_height/figh]);




%% Create a button beneath the table
uibutdelete = uicontrol(hp,'Style','pushbutton','String','-','FontSize',fntsize);
xpos = left_margin_in_panel+table_width-but_width;
set(uibutdelete,'Position',[xpos left_margin_in_panel but_width but_height]);
uibutdelete.Callback = @butdeleteCallback;

uibutadd = uicontrol(hp,'Style','pushbutton','String','+','FontSize',fntsize);
xpos = uibutdelete.Position(1)-but_width;
set(uibutadd,'Position',[xpos left_margin_in_panel but_width but_height]);
uibutadd.Callback = @butaddCallback;

%% Create table

ypos = uibutdelete.Position(2)+but_height;
uit = uitable(hp);
d = cell(length(freqname),3);
for nf=1:length(freqname)
    d{nf,1} = freqname{nf};
    d{nf,3} = selectedfreq(nf);
    d{nf,2} = [num2str(freqreg(nf,1)),'-',num2str(freqreg(nf,2))];
end




uit.Data = d;
set(uit,'Position', [left_margin_in_panel ypos table_width table_height],'Tag','TIVPSDsetting_uit');
uit.ColumnName = {'Name','Range','Selected'};
uit.ColumnEditable = [false,false,true];

%How to change fontSize of the table
set(uit,'FontSize',fntsize);

%How to change the columnWidth 
uitborder = 35;
uit_column_width = round((table_width-uitborder)/3);
set(uit,'ColumnWidth',{uit_column_width, uit_column_width, uit_column_width});
set(uit,'Unit','normalized','CellSelectionCallback',@uitcellselectionCallback);
%Disable resize the column
set(uit,'Enable','on');



%% Create texts on the right
ypos = left_margin_in_panel+table_height-txt_height;
xpos = 2*left_margin_in_panel+table_width;

% txt = Time series:
txtTimeSeries = uicontrol(hp,'Style','text','String','Time series:','FontSize',fntsize,'FontWeight','bold','HorizontalAlignment','left');
set(txtTimeSeries,'Position',[xpos ypos txt_width txt_height]);

%Downsample to frequency
ypos = txtTimeSeries.Position(2)-space_between_lines-txt_height;
txtDownsample = uicontrol(hp,'Style','text','String','Downsample to:','FontSize',fntsize,'HorizontalAlignment','left');
set(txtDownsample,'Position',[xpos ypos txt_width txt_height]);
%Editbox for new sampling frequency
xpos_edit = txtDownsample.Position(1)+txt_width;
uieditDownsample = uicontrol(hp,'Style','edit','String',num2str(fs),'FontSize',fntsize,'Tag','TIVPSDsetting_uieditDownsample');
set(uieditDownsample,'Position',[xpos_edit ypos 0.5*txt_width txt_height]);
uieditDownsample.Callback = @downsampleCallback;


%Detrendingn order
ypos = txtDownsample.Position(2)-space_between_lines-txt_height;
txtDetrend = uicontrol(hp,'Style','text','String','Detrending order:','FontSize',fntsize,'HorizontalAlignment','left');
set(txtDetrend,'Position',[xpos ypos txt_width txt_height]);

uieditDetrend = uicontrol(hp,'Style','edit','String',num2str(detrendorder),'FontSize',fntsize);
set(uieditDetrend,'Position',[xpos_edit ypos 0.5*txt_width txt_height]);
uieditDetrend.Callback = @detrendCallback;


%Normalization
ypos = txtDetrend.Position(2)-space_between_lines-txt_height;
txtNormalization = uicontrol(hp,'Style','text','String','Normalize to 95%tile','FontSize',fntsize,'HorizontalAlignment','left');
set(txtNormalization,'Position',[xpos ypos txt_width txt_height]);
uichkboxNormalization = uicontrol(hp,'Style','checkbox','Value',isnorm,'FontSize',fntsize);
set(uichkboxNormalization,'Position',[xpos_edit ypos 0.5*txt_width txt_height]);

% Power spectra
ypos = left_margin_in_panel+0.4*table_height-txt_height;
txtPowerspectra = uicontrol(hp,'Style','text','String','Power spectra:','FontSize',fntsize,'HorizontalAlignment','left','FontWeight','bold');
set(txtPowerspectra,'Position',[xpos ypos txt_width txt_height]);


% Frequency resolution
ypos = txtPowerspectra.Position(2)-space_between_lines-txt_height;
txtFrequenyResolution = uicontrol(hp,'Style','text','String','Frequency resolution:','FontSize',fntsize,'HorizontalAlignment','left');
set(txtFrequenyResolution,'Position',[xpos ypos txt_width txt_height]);

uieditFrequencyRes= uicontrol(hp,'Style','edit','String',num2str(df),'FontSize',fntsize);
set(uieditFrequencyRes,'Position',[xpos_edit ypos 0.5*txt_width txt_height],'Tag','TIVPSDsetting_uieditFrequencyRes');
uieditFrequencyRes.Callback = @freqresolutionCallback;


%% Normalize txtobjects
set(txtTimeSeries,'Unit','normalized');
set(txtDownsample,'Unit','normalized');
set(txtDetrend,'Unit','normalized');
set(txtPowerspectra,'Unit','normalized');
set(txtFrequenyResolution,'Unit','normalized');

%Normalize editboxes
set(uieditDownsample,'Unit','normalized');
set(uieditDetrend,'Unit','normalized');

%% Cancel & Apply button
ypos = uibutadd.Position(2);
uibutapply = uicontrol(hp,'Style','pushbutton','String','Apply','FontSize',fntsize,'HorizontalAlignment','left','FontWeight','bold');
set(uibutapply,'Position',[xpos_edit ypos 0.5*txt_width but_height]);
uibutapply.Callback = @butapplyCallback;


xpos = xpos_edit-left_margin_in_panel-0.5*txt_width;
uibutcancel = uicontrol(hp,'Style','pushbutton','String','Cancel','FontSize',fntsize,'HorizontalAlignment','left','FontWeight','bold');
set(uibutcancel,'Position',[xpos ypos 0.5*txt_width but_height]);


%% Callback functions
function butcancelCallback(obj,event)
close(fig);

end

function butapplyCallback(obj,event)
    %save changes to the psdsetting.mat
    df = str2double(get(uieditFrequencyRes,'String'));
    detrendorder = str2double(get(uieditDetrend,'String'));
    fs = str2double(get(uieditDownsample,'String'));
    isnorm = get(uichkboxNormalization,'Value');
    data = get(uit,'Data');
    freqname = data(:,1);
    selectedfreq = zeros(length(freqname),1); %logical
    freqreg = zeros(length(freqname),2);
    freqregstr = data(:,2);
    for nf =1:length(freqname)
        temp = strsplit(freqregstr{nf},'-');
        freqreg(nf,1) = str2double(temp{1});
        freqreg(nf,2) = str2double(temp{2});   
        selectedfreq(nf) = data{nf,3};
    end
    selectedfreq = logical(selectedfreq);
save(fullfile(settingpath,settingfile),'df','-append');
save(fullfile(settingpath,settingfile),'detrendorder','-append');
save(fullfile(settingpath,settingfile),'fs','-append');
save(fullfile(settingpath,settingfile),'isnorm','-append');
save(fullfile(settingpath,settingfile),'selectedfreq','-append');
save(fullfile(settingpath,settingfile),'freqreg','-append');
save(fullfile(settingpath,settingfile),'freqname','-append');

%Update figStationaryPSD
obj = findobj('Tag','figStationaryPSD');
handles = guidata(obj);
handles.fregion = freqreg;
handles.fregname = freqname;
%Set listbox
set(handles.listFreRange,'FontSize',fntsize,'String',handles.fregname,'Value',1,'Enable','on');
guidata(obj,handles);
end
function downsampleCallback(obj,event)

%Sampling frequency should be more than 0
%and be positive

str = get(obj,'String');
value = str2double(str);
if isnan(value)
    warndlg('Please enter a valid frequency','Warning');
    set(obj,'String','2')
    
elseif value<1
    warndlg('Please enter a valid frequency','Warning');
    set(obj,'String','2')
    
elseif floor(value) ~= value 
    warndlg('Please enter a valid frequency','Warning');
    set(obj,'String','2') 
end

end

function detrendCallback(obj,event)

str = get(obj,'String');
value = str2double(str);

%Check integer
if isnan(value)
    warndlg('Please enter 0,1,2,3,4 or 5','Warning');
    set(obj,'String','5')
elseif value>5 || value<0
    warndlg('Please enter 0,1,2,3,4 or 5','Warning');
    set(obj,'String','5')
elseif floor(value) ~= value 
    warndlg('Please enter 0,1,2,3,4 or 5','Warning');
    set(obj,'String','5')    
end

end


function freqresolutionCallback(obj,event)

str = get(obj,'String');
value = str2double(str);

uiteditDownsample = findobj('Tag','TIVPSDsetting_uieditDownsample');
fs_new = str2double(get(uiteditDownsample,'Value'));
min_df = fs_new/100;
%Check integer
if isnan(value) %Check if a user enters a number
    warndlg('Please enter a real number','Warning');
    set(obj,'String','0.001')
    
elseif value>min_df 
    warndlg(['The resolution must be less than or equal ',num2str(min_df)],'Warning');
    set(obj,'String','0.001');    
end


end


function  uitcellselectionCallback(src,event)
if ~isempty(event.Indices)

    row = event.Indices(:,1); %The last row of selection, event.Indices can be empty

    %Don't allow users to remove row 1-3
    ind = find(row==1 | row==2 | row==3);
    if ~isempty(ind)
        row(ind) = [];
    end
    set(src,'UserData',row);
 
end


end


function butdeleteCallback(src,event)


%Get current selection and delete
data = get(uit,'Data');
row = get(uit,'UserData');

if ~isempty(row) && ~isempty(data)
    %Update the table
    data(row,:) = [];
    set(uit,'Data',data); 
    %Update UserDara
    set(uit,'UserData',[])
end


end

function butaddCallback(src,event)


%% What to be checked
% The name is empty
% Repeated frequency ranges or names
% Maximum number of rows
maxnumrow = 20;

%uit= findobj('Tag','TIVPSDsetting_uit');
x = inputdlg({'Name','Begin (Hz)','End (Hz)'},...
              'Define Frequency Range', [1 50; 1 25; 1 25]); 
          
df_new = str2double(get(uieditFrequencyRes,'String'));

if isnan(df_new)  
    return
end

data = get(uit,'Data');
logical_array_chk = strcmpi(x{1},data(:,1));
if any(logical_array_chk) %The freq name is repeated
    opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
    f = warndlg('\color{black} \fontsize{14} The name is already used',...
             'Warning', opts);
    return
end
          
%Conditions for frequency range
if ~isempty(x) && ~isempty(x{1}) && ~isempty(x{2}) && ~isempty(x{3}) %All info are acquired
    
    x2 = str2double(x{2});
    x3 = str2double(x{3});
    
    %x{2} & x{3}
    if isnan(x2) || isnan(x3)
       %Not numbers
        return 
    end
    
    %Begin >0 & Begin<End
    if x2<=0 || x3<=0
        return
    end
    
    %Begin-End must be larger than frequency resolution
    if x2>=x3
        return
    end
    
    %Range must be enough to use trapz
    npoints = floor((x3-x2)/df_new);
    if npoints<2
        return
    end
    

    
    %If it reaches this point, add the new row
    %Store strings
    data = [data;{x{1},[x{2},'-',x{3}],true}];

    set(uit,'Data',data);
    





end

end

end







