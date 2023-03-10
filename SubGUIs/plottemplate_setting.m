function plottemplate_setting(hObject, eventdata, handles)
%UNTITLED Summary of this function goes here
%1. In data browser, go to plot template > Setting... > this script is called
%2. The script accesses codepath to get default or user-defined path template
%3. Browse a new directory to read defined-templates
%4. Update list of templates to the most recent one (NOT YET)
%5. Restore the path to default directory which is hidden in the pc
%Check if the setting window is being opened
obj = findobj('Tag','DataBrowser_Templatesetting');
if ~isempty(obj)
    figure(obj);
    return
end
% Positions
if ispc
    fntsize = 10;
else
    fntsize = 14;
end

figh = 420;
figw = 676;
left_margin = 40; %in pixels
newline_margin_in_panel = 5; %between lines margin (vertical direction)
newspace_margin_in_panel = 10; %horizontal margin

panel_height = figh-1.5*left_margin; 
panel_width = figw-2*left_margin;
txt_height = 21.6;
txt_width = 150;

%% Where is template path?
%Default (hidden path)
default_templatepath =  fullfile(handles.codepath,'PlotTemplate'); %Default is relative to handles.codepath

%User-defined
load(fullfile(handles.codepath,'Setting','userdefinedtemplatepath.mat'),'userdefinedtemplatepath');%somewhere in a user's local pc, could be empty

%Now check if user-defined path exists
if ~isempty(userdefinedtemplatepath)
    templatepath = userdefinedtemplatepath;
else
    templatepath = default_templatepath;
    
end
%Get list_of_templates
[templatelist,templatelist_date] = getTemplateInTheFolder(templatepath);

%% Create figure&panel
xpos = left_margin;
ypos = left_margin;

fig = figure; set(fig,'Name','Data Browser : Template Setting','NumberTitle','off','Unit','pixels','Position',[300 300 figw figh],'Resize','off','Tag','DataBrowser_Templatesetting', 'MenuBar', 'none','ToolBar','none');

hp = uipanel('Title','Plot Template:Setting','TitlePosition','centertop','FontSize',fntsize,...
             'Unit','normalized',...
             'Position',[xpos/figw ypos/figh panel_width/figw panel_height/figh]);

         

%% Look in & Default path (txt & editbox)
txtLookin = uicontrol(hp,'Style','text','String','Look in:','FontSize',fntsize,'FontWeight','bold','HorizontalAlignment','left');
set(txtLookin,'Position',[left_margin left_margin+txt_height+newline_margin_in_panel txt_width txt_height]);


uieditPlotTemplatePath = uicontrol(hp,'Style','edit','String',templatepath,'FontSize',fntsize,'Tag','PlotTemplatesetting_uieditPlotTemplatePath');
set(uieditPlotTemplatePath,'Position',[left_margin left_margin panel_width-2*left_margin txt_height]);


%% Listbox
uilistTemplate = uicontrol(hp,'Style','listbox','String',templatelist,'FontSize',fntsize,'Tag','PlotTemplatesetting_uilistTemplate');
set(uilistTemplate,'Position',[left_margin txtLookin.Position(2)+txtLookin.Position(4)+newline_margin_in_panel 0.5*panel_width panel_height-2*txt_height-2*left_margin]);
uilistTemplate.Callback = @listboxcallback;


%% Edit template & Delete template
space_left = panel_width-uilistTemplate.Position(3)-2*left_margin-2*newspace_margin_in_panel;

uibutdelete = uicontrol(hp,'Style','pushbutton','String','Delete','FontSize',fntsize);
set(uibutdelete,'Position',[uilistTemplate.Position(1)+uilistTemplate.Position(3)+newspace_margin_in_panel uilistTemplate.Position(2) 0.5*space_left txt_height]);
uibutdelete.Callback = @deletebut;

uibutedit = uicontrol(hp,'Style','pushbutton','String','Save','FontSize',fntsize);
set(uibutedit,'Position',[uibutdelete.Position(1)+uibutdelete.Position(3)+newspace_margin_in_panel uibutdelete.Position(2) 0.5*space_left txt_height]);
uibutedit.Callback = @savebut;

%% editTPList, position = listbox-right, above delete,edit buttons
editTPList = uicontrol(hp,'Style','edit','Max',2,'String','Select an item on the list to see what is inside.','ForegroundColor',[0 0.5 0.7],'FontSize',fntsize,'Tag','PlotTemplatesetting_editboxTemplate');
set(editTPList,'Position',[uibutdelete.Position(1) newspace_margin_in_panel+txt_height+uilistTemplate.Position(2) newspace_margin_in_panel+2*uibutdelete.Position(3) uilistTemplate.Position(4)-newspace_margin_in_panel-txt_height]);

%% Txt last save
txtLastSave = uicontrol(hp,'Style','text','String','','FontSize',8,'ForegroundColor',[1 0.4 0],'FontAngle','italic','HorizontalAlignment','left');
set(txtLastSave,'Position',[uibutedit.Position(1) uibutdelete.Position(2)-txt_height-newspace_margin_in_panel txt_width txt_height]);

%% Browse default path
uibutbrowse = uicontrol(hp,'Style','pushbutton','String','Browse','FontSize',fntsize);
set(uibutbrowse,'Position',[uibutedit.Position(1) uieditPlotTemplatePath.Position(2)-txt_height-newline_margin_in_panel 0.5*space_left txt_height]);
uibutbrowse.Callback = @butbrowseCallback;


%% Callbacks are inside the mother function
function listboxcallback(obj, event)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns contents
% contents{get(hObject,'Value')} returns selected item from listbox1
items = get(obj,'String');
index_selected = get(obj,'Value');
item_selected = items{index_selected};
set(editTPList,'String',item_selected);

load(fullfile(templatepath,item_selected),'template');
if ~isempty(template)
    template = cellfun(@num2str,template,'UniformOutput',0);
    nrow = size(template,1);
    cstr = cell(nrow,1);
    for n=1:nrow
        cstr{n} = [template{n,1},', ',template{n,2},', ',template{n,3}];
    end
    set(editTPList,'String',cstr,'Enable','on');
    
else
    set(editTPList,'String',[],'Enable','off');  
end    
end
function butbrowseCallback(obj,event)

    %Update figStationaryPSD
    obj = findobj('Tag','figMain'); %Find Data Browser object to get its handle
    handles = guidata(obj);
    
    %Update template path
    templatepath = uigetdir; %If users hit cancel, templatepath will be 0
    
    
    if ~isnumeric(templatepath) && exist(templatepath,'dir') %Check if the path is selected
        
        [templatelist,~] = getTemplateInTheFolder(templatepath); %Struct with name,folder,date,bytes
        
        if ~isempty(templatelist) %If the list is not empty, update menuLayout, listbox
            repopulateMenuLayout;
            set(uilistTemplate,'String',templatelist,'FontSize',fntsize,'Value',1);
        else %If it's empty update anyway
            repopulateMenuLayout;
            set(uilistTemplate,'String',[],'FontSize',fntsize,'Value',1);
            set(editTPList,'String',[]);
            
        end
        
        userdefinedtemplatepath = templatepath;
        %update user-defined path and save
        save(fullfile(handles.codepath,'Setting','userdefinedtemplatepath.mat'),'userdefinedtemplatepath');
        
        %Set editTemplate
        set(uieditPlotTemplatePath,'FontSize',fntsize,'String',templatepath,'Value',1,'Enable','inactive');
        
        
        %Update handles
        guidata(obj,handles); %Always update handles no matter what
        
    end

end


function deletebut(src,event)

    currentlist = get(uilistTemplate,'String'); %Get the list of the template from the listbox
    ind = get(uilistTemplate,'Value'); %Get user's selection
    
    if isempty(currentlist) %No template in the listbox
        return;
    end
    

    delete(fullfile(templatepath,[currentlist{ind},'.mat'])); %Delete the chosen template file
    
    %Notify via txtLastSave   
    lastsavestr = datestr(datetime);
    set(txtLastSave,'String',['Deleted: ',lastsavestr]);
    
    %Update listbox
    currentlist(ind) = [];
    if ~isempty(currentlist)
        set(uilistTemplate,'String',currentlist,'Value',1); 
    
        %Update editbox according to the list
        listboxcallback(uilistTemplate, []);
    else %The template folder is empty
        set(uilistTemplate,'String',currentlist,'Value',1); 
        set(editTPList,'String',[]);
    end
    
    %Repopulate the templates
    [templatelist,~] = getTemplateInTheFolder(templatepath); %Update templatelist   
    repopulateMenuLayout;   %Repopulate no. of templates
    set(uilistTemplate,'String',templatelist,'Value',1); 
    

end

function savebut(src,event)
    %% New, overwrite the template with new values
    currentlist = get(uilistTemplate,'String'); %Get the list of the template from the listbox
    ind = get(uilistTemplate,'Value'); %Get user's selection
        
    if isempty(currentlist) %No template in the listbox
         return;
    end
    
    newtemplate_filename = fullfile(templatepath,currentlist{ind});
    newtemplatestr = get(editTPList,'String');
    
    if ~isempty(newtemplatestr)
        temp = cellstr(newtemplatestr); %list of variable names and axis-limits
        
        %Get rid of any empty rows
        ind = ~cellfun(@isempty,temp); %indices of non-empty rows
        temp = temp(ind);
        if isempty(temp)
            return
        end
        
        %Split strings into cells and check if the values are valid
        nrow = size(temp,1);
        template = cell(nrow,3);
        for n=1:nrow
            c = strtrim(strsplit(temp{n},',')); %split string by delimiter and remove white spaces
            
            %Check no. of columns
            ncol = size(c,2);
            if ncol>3
                c = c(1:3);
            elseif ncol<3
                tempc = cell(1,3);
                tempc(1:ncol) = c;
                c = tempc;
                clear tempc;
            end
            
            %varname
            template{n,1} = c{1};
            
            %ymin and ymax
            ymin = []; %initialize ymin
            if ~isempty(c{2})
                ymin = str2double(c{2});
            end
            
            ymax = []; %initialize ymax
            if ~isempty(c{3})
                ymax = str2double(c{3});
            end
            
            if ~isempty(ymin) && ~isempty(ymax)
                if isnumeric(ymin) && isnumeric(ymax)
                    if ymin >= ymax %invalid ylimit
                        ymin = [];
                        ymax = [];
                    end
                end
            end
            
            template{n,2} = ymin;
            template{n,3} = ymax;
            
        end %end for n
    end
    
    %Save template to file
    lastsavestr = datestr(datetime);
   
    save(newtemplate_filename,'template');
    
    set(txtLastSave,'String',['Saved: ',lastsavestr]);
   
    %Repopulate
    repopulateMenuLayout;
    
end


function repopulateMenuLayout %Return actual template list
    %Assume the templatelist is not empty    
    delete(get(handles.menuLayout,'Children'));
    handles.menuPlotTemplate = uimenu('Parent',handles.menuLayout,'Label','Plot Template');
    %Repopulate submenu under Plot Template
    for n=1:size(templatelist,1) %The pop up shouldn't exceed a certain number.
        load(fullfile(templatepath,templatelist{n}),'template'); %Load template
        uimenu(handles.menuPlotTemplate,'Label',templatelist{n},'Callback',{@subplotTemplate handles template});
        
    end
    uimenu(handles.menuPlotTemplate,'Label','Define Template...','Callback',{@definePlotTemplate handles},'Separator','on'); %Separator creates a line
    uimenu(handles.menuPlotTemplate,'Label','Save Screen As Template...','Callback',{@capturePlotTemplate handles});
    uimenu(handles.menuPlotTemplate,'Label','Setting...','Callback',{@plottemplate_setting handles});

    
end


end

function [templatelist,templatelist_date] = getTemplateInTheFolder(templatepath)
%Templatepath = path to the folder storing templates
%Inside the folder, there may be other types of files
%This function checks which file isn't a template, and return a list of
%actual templates
templatelist = {};
templatelist_date = [];
what_in_the_folder = dir(templatepath); %Struct with name,folder,date,bytes
for n=1:size(what_in_the_folder,1)
    name = what_in_the_folder(n).name;
    if regexp(name,'.mat') %Is this a matfile? -> Yes, go inside IF
        clear template; %Clear loaded template from previous iter.
        
        variableinfo = who('-file', fullfile(templatepath,what_in_the_folder(n).name));
        
        if ismember('template',variableinfo) 
           
           load(fullfile(templatepath,what_in_the_folder(n).name),'template'); %Load template to workspace

            
            if iscell(template) && 3==size(template,2) %Is template a cell with size Nx3{name,ymin,ymax}
                if ~iscellstr(template(:,1)) %The first column is not variable name, continue
                    continue;
                end
                
                ind = cellfun(@(x) ~isnumeric(x),template(:,2),'UniformOutput',1); %ymin is not numeric
                if any(ind)
                    continue;
                end
                
                ind = cellfun(@(x) ~isnumeric(x),template(:,3),'UniformOutput',1);
                if any(ind)
                    continue;
                end
                
                %At this point, the template passes all the criteria
                %Get date
                dv = datevec(what_in_the_folder(n).date); %a vector of date = [y,m,d,hh,mm,sec];
                if isempty(templatelist) %Detect the first template
                    templatelist = {what_in_the_folder(n).name(1:end-4)};
                    templatelist_date = dv;
                    continue
                end
                buffer_date = templatelist_date; %buffer shrinks down every loop, to reduce the amount of search
                offset = 0;
                for nd=1:6
                    try
                        dv_difference = buffer_date(:,nd)-dv(nd);
                    catch
                        disp('What');
                    end
                    lgc_ind = (dv_difference==0); %Search for templates from the same year, month,date
                    if sum(lgc_ind)==0 %No template from the same yr,m,d
                        
                        put_in_ind = offset+sum(dv_difference>0); %The index of the last file more recent in the buffer, the template must be put after put_in_ind                  
                        
                        if put_in_ind == length(templatelist) %This case, the template is put last
                             templatelist = [templatelist(1:put_in_ind);what_in_the_folder(n).name(1:end-4)];  
                             templatelist_date = [templatelist_date(1:put_in_ind,:);dv];

                        else
                             templatelist = [templatelist(1:put_in_ind);what_in_the_folder(n).name(1:end-4);templatelist(put_in_ind+1:end)];
                             templatelist_date = [templatelist_date(1:put_in_ind,:);dv;templatelist_date(put_in_ind+1:end,:)];

                        end
                        break; %put_in_ind is identified           
                    
                    else %There are files created in the same year, narrow down the search and use offset
                        buffer_date = templatelist_date(lgc_ind,:); %This is where to search                      
                        offset = offset+sum(dv_difference>0);%update offset, offset = #files that are newer    
                        if nd==6 %everything is the same, put it on top of the buffer
                            %What is buffer?
                            %What is not in the buffer
                            templatelist = [templatelist(1:offset);what_in_the_folder(n).name(1:end-4);templatelist(offset+1:end)];
                            templatelist_date = [templatelist_date(1:offset,:);dv;templatelist_date(offset+1:end,:)];

                        end
                    end
                end
                            
            else
                continue;
            end
        else
            continue; %Template is not in the matfile
        end
    end
    
end


end


