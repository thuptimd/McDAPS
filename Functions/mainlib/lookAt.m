function [] = lookAt(handles,timeinput)
%UNTITLED Summary of this function goes here
%2016-06-29
%Modified from B2B version
%Always set the window to be 1 minute.
%Jump to the specific position via time input (s)

% window = [30,50,60,180,300,420,600,900,1200,1800]; %start from Value = 5
% sliderstep = [5,10,20,20,30,60,100,100,120,180];

handles.DB.window = 60;
handles.DB.sliderstep = 20;
maxtime = max((cellfun(@length,handles.DB.signal(handles.DB.varindex)) - 1)./handles.DB.fs(handles.DB.varindex)); %maximum time of all plotted signals (sec)


set(handles.popWindow,'Value',7); %Set the popupwindow
    
%Adjust the plot and change slider position to make the range places in the middle
adj_width = round(0.5*handles.DB.window);
xmax = timeinput+adj_width;
if xmax > maxtime
    xmax = maxtime;
end

xmin = xmax - handles.DB.window;
if xmin<0
    xmin = 0;
    xmax = xmin+handles.DB.window;
end

handles.DB.xlimit = [xmin,xmax];
sliderrange = maxtime-handles.DB.window;
set(handles.xslider,'SliderStep',[handles.DB.sliderstep/sliderrange 10*handles.DB.sliderstep/sliderrange]);
set(handles.xslider,'Enable','on','Min',0,'Max',sliderrange);
set(handles.xslider,'Value',xmin);

%% Adjust XY limit to 1 min window
adjustXYlimit(handles)



guidata(handles.output,handles);

end

