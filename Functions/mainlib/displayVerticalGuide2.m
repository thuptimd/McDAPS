function [hl] = displayVerticalGuide2(hf,hax,ht,c,xval)
%Modified 2017-
% c = get(hf,'Color');
% ha = axes('Xlim',[0,1],'Ylim',[0,1],'Color','none');
% set(ha,'Unit','normalized',...
%     'Position',pos,...
%     'XTick',[],...
%     'YTick',[],...
%     'Box','off');
% set(ha,'XColor',c);
% set(ha,'YColor',c);

if nargin<5
    xlimit = get(hax,'Xlim');
    xrange = range(xlimit);
    xval = min(xlimit) + xrange/2;
end
ylimit = get(hax,'Ylim');

%axes(hax); %set current axes
hl = line(hax,xval*ones(2,1),ylimit,...
          'Color',c,...
          'LineWidth',2,...
          'LineStyle','-',...
          'ButtonDownFcn',@startDragFcn);

set(hf,'WindowButtonUpFcn',@stopDragFcn);

%%
function startDragFcn(varargin)
    set(hf,'WindowButtonMotionFcn',@draggingFcn);
end

%%
function draggingFcn(varargin)
    xlimit = get(hax,'XLim');
    pt = get(hax,'CurrentPoint');  
    if pt(1) > xlimit(2) || pt(1) < xlimit(1)
        return
    end
    set(hl,'XData',pt(1)*[1 1]);
    set(ht,'String',['Current Point: ', num2str(pt(1),'%10.3f')]);
end

%%
function stopDragFcn(varargin)
    set(hf,'WindowButtonMotionFcn','');
end


end