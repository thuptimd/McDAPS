function editPlotTemplate(hObject, eventdata, handles)

%Turn off any line selection highlight
turnoffLinehighlight(hObject,handles);
handles = guidata(hObject);

%Load template
deftppath = fullfile(handles.codepath,'PlotTemplate'); %default template folder
[tpfile,tppath] = uigetfile('*.mat','Load plot template',deftppath);
if ~ischar(tpfile)
    return %return if choosing invalid file
end
load(fullfile(tppath,tpfile));

%Prepare template
if ~exist('template','var')
    if exist('varname','var')
        template = cell(size(varname,1),3);
        template(:,1) = varname;
    else
        h = warndlg('The plot template cannot be loaded.','Warning!','modal');
        return
    end
end

%Update shared data
hfigmain = getappdata(0, 'hfigmain');
setappdata(hfigmain,'figname','Edit Plot Template');
setappdata(hfigmain,'template',template);

%Call GUI function in new window to compute moving correlation
sub_editTemplate;
uiwait(gcf);

hfigmain = getappdata(0,'hfigmain');
template = getappdata(hfigmain,'template');

if ~isempty(template)
    temp = cellstr(template); %list of variable names and axis-limits
    
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
            ymin = str2num(c{2});
        end
        
        ymax = []; %initialize ymax
        if ~isempty(c{3})
            ymax = str2num(c{3});
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

    save(fullfile(tppath,tpfile), 'template');
    
    %Reset shared data
    setappdata(hfigmain,'figname',{});
    setappdata(hfigmain,'template',{});
    
    %Set context menus
    setContextMenus(gcf,handles);
    handles = guidata(gcf);
    
else
    return
end

guidata(gcf, handles); %update handles structure