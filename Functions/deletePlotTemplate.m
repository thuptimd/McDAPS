function deletePlotTemplate(hObject, eventdata, handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% get path
if ispc
    fntsize = 10;
else
    fntsize = 16; 
end

%Check if there is a template in the folder
templatepath = fullfile(handles.codepath,'PlotTemplate'); 


if exist(templatepath,'dir') && isfield(handles.DB,'inputfile')
    
    templatelist = what(templatepath); %Search files in the PlotTemplate folders
    templatelist = templatelist.mat; %get a list of Mat file in Template folder
    if ~isempty(templatelist)
        %Check if hf exists before creating a new one
        hf = findobj('Tag','Delete Template Figure v141');
        
        if ~isempty(hf)
            close(hf);
        end

        %Create a figure if there is
        hf = figure('Name','Delete Template','NumberTitle','off','Tag','Delete Template Figure v141');
        hp = uipanel('Title','Select Templates','FontSize',fntsize,...
            'Position',[0.1 0.1 0.8 0.8]);
        

        
        hlist = uicontrol('Parent',hp,'Style','listbox',...
            'FontSize',fntsize,...
            'Unit','normalized',...
            'Position',[0.1 0.35 0.8 0.55],...
            'String',templatelist,...
            'Tag','templatelist_databrowser_v141',...
            'Callback',@listtemplate);
        
        data.ind = 1; %Automatically assign the first template as unwanted
        data.currentlist = templatelist;
        hlist.UserData = data;
        
        hcbut = uicontrol('Parent',hp,'String','Cancel',...
            'FontSize',fntsize,...
            'Unit','normalized',...
            'Position',[0.25 0.1 0.3 0.2],...
            'Callback',@cancelbut);
                
        
        hdbut = uicontrol('Parent',hp,'String','Delete',...
            'FontSize',fntsize,...
            'Unit','normalized',...
            'Position',[0.6 0.1 0.3 0.2],...
            'Callback',@deletebut);
        
        hdbut.UserData = templatepath;
        
        
        


    else
        opts = struct('WindowStyle','modal',... 
              'Interpreter','tex');
        warndlg(['\fontsize{',num2str(fntsize),'} There is no template to be deleted!'],'Warnding Delete Template',opts);
        return;
        
    end


end




    

end


function cancelbut(src,event)
hf = findobj('Tag','Delete Template Figure v141');
close(hf);

end

function deletebut(src,event)
h = findobj('Tag','templatelist_databrowser_v141');
data = h.UserData;
currentlist = data.currentlist;
ind = data.ind;

if isempty(currentlist)
    return;
end

disp(['Test delete',currentlist{ind}]);
delete(fullfile(src.UserData,currentlist{ind}));

%Update listbox
currentlist(ind) = [];
set(h,'String',currentlist,'Value',1);

%Update UserData
data.currentlist = currentlist;
data.ind = 1;
h.UserData = data;


end

function listtemplate(src,event)

data.ind = get(src,'Value');
data.currentlist = get(src,'String');
src.UserData = data;


end



