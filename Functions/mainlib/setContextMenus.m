function setContextMenus(hObject,handles)

%% Plotorder listbox
str = get(handles.listMatvars,'String');
if ~isempty(str)
    hcmenu = uicontextmenu('Parent',handles.output);
    item1 = uimenu(hcmenu,'Label','Set y-limit...','Callback',{@setYlimitManual handles});
    item2 = uimenu(hcmenu,'Label','Auto-adjust y-limit','Callback',{@setYlimitAuto2 handles});

    set(handles.listPlotorder,'uicontextmenu',hcmenu);
end



%% Marvars listbox

matvars = get(handles.listMatvars,'String');
if ~isempty(matvars)
    [nvar,~] = size(matvars);
    hcmenu = uicontextmenu('Parent',handles.output);
    item1 = uimenu(hcmenu,'Label','Add to Workspace','Callback',{@addVartoWorkspace handles});

    set(handles.listMatvars,'uicontextmenu',hcmenu);

end



%% Workspace listbox

hcmenu = uicontextmenu('Parent',handles.output);
if isfield(handles.DB,'axesnum') && ~isempty(handles.DB.axesnum)
    
    for n=1:max(handles.DB.axesnum)
        eval(['item',num2str(n),' = uimenu(hcmenu,''Label'',''Add to Plot ',num2str(n),''',''Callback'',{@addSignaltoaxes handles n});']); %add to existing plot
    end
    eval(['item',num2str(n+1),' = uimenu(hcmenu,''Label'',''New Plot'',''Callback'',{@addSignaltoaxes handles (n+1)});']); %add as new plot
    eval(['item',num2str(n+2),' = uimenu(hcmenu,''Label'',''Rename'',''Callback'',{@renameWorkspaceVariable handles},''Separator'',''on'');']); %rename variable in workspace
    eval(['item',num2str(n+3),' = uimenu(hcmenu,''Label'',''Delete'',''Callback'',{@deleteWorkspaceVariable handles});']); %delete variable from workspace

else
    hcmenu = uicontextmenu('Parent',handles.output);
    item1 = uimenu(hcmenu,'Label','New Plot','Callback',{@addSignaltoaxes handles 1}); %add as new plot
    item2 = uimenu(hcmenu,'Label','Rename...','Callback',{@renameWorkspaceVariable handles},'Separator','on'); %rename variable in workspace
    item3 = uimenu(hcmenu,'Label','Delete','Callback',{@deleteWorkspaceVariable handles}); %delete variable from workspace

end
set(handles.listWrkspc,'uicontextmenu',hcmenu);



%% Plot template menu
%Default (hidden path)
default_templatepath =  fullfile(handles.codepath,'PlotTemplate'); %Default is relative to handles.codepath

%User-defined
load(fullfile(handles.codepath,'Setting','userdefinedtemplatepath.mat'),'userdefinedtemplatepath');%somewhere in a user's local pc, could be empty

%Check if user-defined path exists
if ~isempty(userdefinedtemplatepath)
    templatepath = userdefinedtemplatepath;
else
    templatepath = default_templatepath;   
end

if exist(templatepath,'dir') && isfield(handles.DB,'inputfile')   
    [templatelist,~] = getTemplateInTheFolder(templatepath);
    if ~isempty(templatelist)      
        delete(get(handles.menuPlotTemplate,'Children'));        
        %Repopulate submenu under Plot Template
        maxTemplates = 7;
        if size(templatelist,1)<maxTemplates
            maxTemplates = size(templatelist,1);
        end
        for n=1:maxTemplates
          load(fullfile(templatepath,templatelist{n}),'template'); %Load template
          uimenu(handles.menuPlotTemplate,'Label',templatelist{n},'Callback',{@subplotTemplate handles template});           
        end
    end
    set(handles.menuPlotTemplate,'Enable','on');

end

if isempty(handles.menuDefineTemplate.Children)
    uimenu(handles.menuDefineTemplate,'Label','Define Template...','Callback',{@definePlotTemplate handles},'Separator','on');
    uimenu(handles.menuDefineTemplate,'Label','Save Screen As Template...','Callback',{@capturePlotTemplate handles});
    uimenu(handles.menuDefineTemplate,'Label','Setting...','Callback',{@plottemplate_setting handles});
    set(handles.menuDefineTemplate,'Enable','on');

else
    %Re-assign callbacks because handles are changing based on plots
    set(handles.menuDefineTemplate.Children(1),'Callback',{@definePlotTemplate handles});
    set(handles.menuDefineTemplate.Children(2),'Callback',{@capturePlotTemplate handles});
    set(handles.menuDefineTemplate.Children(3),'Callback',{@plottemplate_setting handles});

    
end

%% Subplots

if isfield(handles.DB,'axesnum') && ~isempty(handles.DB.axesnum)

    hcmenu = uicontextmenu('Parent',handles.output);
    item1 = uimenu(hcmenu,'Label','Set y-limit','Callback',{@setYlimitRect handles}); %set y-limit by drawing a rectangle
    item2 = uimenu(hcmenu,'Label','Auto-adjust y-limit','Callback',{@setYlimitAuto2 handles}); %set y-limit to auto-adjust
    item3 = uimenu(hcmenu,'Label','Move Plot Up','Callback',{@movePlotUp handles},'Separator','on'); %move plot up

    %  item3 = uimenu(hcmenu,'Label','Move Plot Up','Callback',@(hObject,eventdata)main_DataBrowser('butUpplot_Callback',hObject,eventdata,guidata(hObject))); %move plot up

    item4 = uimenu(hcmenu,'Label','Move Plot Down','Callback',{@movePlotDown handles}); %move plot down
    item5 = uimenu(hcmenu,'Label','Delete Plot','Callback',{@deleteSelectedSubplot handles}); %delete plot
    item6 = uimenu(hcmenu,'Label','Pan','Callback','pan on'); %pan
    item7 = uimenu(hcmenu,'Label','Zoom','Callback','zoom on'); %zoom
    item8 = uimenu(hcmenu,'Label','Data Cursor','Callback','datacursormode on'); %data cursor
    item9 = uimenu(hcmenu,'Label','Select Region','Callback',{@selectRegion handles}); %select region
    set(handles.DB.haxes(2:end-1),'uicontextmenu',hcmenu);
    
    %First plot
    hcmenu = uicontextmenu('Parent',handles.output);
    item1 = uimenu(hcmenu,'Label','Set y-limit','Callback',{@setYlimitRect handles}); %set y-limit by drawing a rectangle
    item2 = uimenu(hcmenu,'Label','Auto-adjust y-limit','Callback',{@setYlimitAuto2 handles}); %set y-limit to auto-adjust
    item3 = uimenu(hcmenu,'Label','Move Plot Down','Callback',{@movePlotDown handles},'Separator','on'); %move plot down
    item4 = uimenu(hcmenu,'Label','Delete Plot','Callback',{@deleteSelectedSubplot handles}); %delete plot
    item5 = uimenu(hcmenu,'Label','Pan','Callback','pan on'); %pan
    item6 = uimenu(hcmenu,'Label','Zoom','Callback','zoom on'); %zoom
    item7 = uimenu(hcmenu,'Label','Data Cursor','Callback','datacursormode on'); %data cursor
    item8 = uimenu(hcmenu,'Label','Select Region','Callback',{@selectRegion handles}); %select region
    set(handles.DB.haxes(1),'uicontextmenu',hcmenu);
    
    %Last plot
    hcmenu = uicontextmenu('Parent',handles.output);
    item1 = uimenu(hcmenu,'Label','Set y-limit','Callback',{@setYlimitRect handles}); %set y-limit by drawing a rectangle
    item2 = uimenu(hcmenu,'Label','Auto-adjust y-limit','Callback',{@setYlimitAuto2 handles}); %set y-limit to auto-adjust
    item3 = uimenu(hcmenu,'Label','Move Plot Up','Callback',{@movePlotUp handles},'Separator','on'); %move plot up

    %  item3 = uimenu(hcmenu,'Label','Move Plot Up','Callback',@(hObject,eventdata)main_DataBrowser('butUpplot_Callback',hObject,eventdata,guidata(hObject))); %move plot up

    %  item3 = uimenu(hcmenu,'Label','Move Plot Up','Callback',{@movePlotUp handles},'Separator','on'); %move plot up
    item4 = uimenu(hcmenu,'Label','Delete Plot','Callback',{@deleteSelectedSubplot handles}); %delete plot
    item5 = uimenu(hcmenu,'Label','Pan','Callback','pan on'); %pan
    item7 = uimenu(hcmenu,'Label','Zoom','Callback','zoom on'); %zoom
    item7 = uimenu(hcmenu,'Label','Data Cursor','Callback','datacursormode on'); %data cursor
    item8 = uimenu(hcmenu,'Label','Select Region','Callback',{@selectRegion handles}); %select region 
    set(handles.DB.haxes(end),'uicontextmenu',hcmenu);
 
end


%% Update handles structure
guidata(hObject, handles);

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
        
        load(fullfile(templatepath,what_in_the_folder(n).name)); %Load template to workspace
        
        if exist('template','var') %Is template in Workspace?
           
            
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
