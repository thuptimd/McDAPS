function selectRegion( hObject,eventdata,handles )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

set(handles.toolSelectRegion,'State','on');

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
    [x,y] = ginputCross(1);
    ax = gca;
    c = get(ax,'Color');
    set(ax,'Color',[1 0.93 0.93]);
    


    %Define area to be shaded
    rect = getrect(ax); %rect = [xmin ymin width height] (unit = unit of x-axis)
    
    %Restore axes color
    set(ax,'Color',c);
    

    
    %Check if width = 0. If so, enable other tools & return.
    if rect(3)==0
        
        %Enable tools
        set(handles.toolSelectRegion,'State','off');
        set(handles.toolLoadData,'Enable','on');
        set(handles.toolScreenshot,'Enable','on');
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
    yrange = range(ylimit);
    ymin = min(ylimit) + 0.02*yrange;
    ymax = max(ylimit) - 0.02*yrange;
    axes(ax); hold on;
    hshade = fill([xmin xmin xmax xmax],[ymin ymax ymax ymin],[1 1 0.8],'EdgeColor',[1 1 0.8]);
    uistack(hshade,'bottom');


    %Get filename and variable in the selected plot
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
        newtags{n,14} = '';                     %Operation Tag
        newtags{n,15} = [];                     %Value
    end
    
    
    activeTM.updateEditorTags(handles,newtags);
    handles = guidata(hObject); % in case DB is active, retrieve its value for the next save (guidata)


        
    %Enable tools
    set(handles.toolSelectRegion,'State','off');
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolScreenshot,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');

    set(handles.butDeletetag,'Enable','on');
    set(handles.butUptag,'ForegroundColor',[0 0 0],'Enable','on');
    set(handles.butDowntag,'ForegroundColor',[0 0 0],'Enable','on');

    %Set context menus
    setContextMenus(hObject,handles);
    handles = guidata(hObject);

else %deselect the tool
    
    %Enable tools
    set(handles.toolSelectRegion,'State','off');
    set(handles.toolLoadData,'Enable','on');
    set(handles.toolScreenshot,'Enable','on');
    set(handles.toolZoomin,'Enable','on');
    set(handles.toolZoomout,'Enable','on');
    set(handles.toolPan,'Enable','on');
    set(handles.toolDataCursor,'Enable','on');
    set(handles.toolEditPlot,'Enable','on');

end

guidata(hObject, handles); %update handles structure

end

