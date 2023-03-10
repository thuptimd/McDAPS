function  [x,y] = ginputax(huiax,N)
%GINPUTUIAX Graphical input from mouse with custum cursor pointer.
%   [X,Y] = ginputuiax(huiax,N) gets N points from the uiaxes, huiax and returns 
%   the X- and Y-coordinates in length N vectors X and Y.  
%   GINPUTUIAX is similar to Matlab's original GINPUT, except
%   that it works with UIFIGURE & UIAXES
%   Example:
%   ax=uiaxes; plot(ax,rand(1,100))
%   [x,y] = ginputuiax(ax,2)
%
%   Adapted from GINPUTC by Jiro Doke
%   Wanwara Thuptimdang
%   Date: 1July2020



%Check if uiax is from uiaxes
if ~isvalid(huiax) && ~strcmpi('matlab.ui.control.Axes',class(huiax))
    return; %Not uiaxes   
end

%Activate line that moves for the whole fig



%Loop until hFig
hFig = ancestor(huiax,'figure');
if isempty(hFig)
    return
end

parent = huiax.Parent;
axPos = huiax.Position;
while true
    if parent == hFig
        break;
    else
        axPos = axPos + [parent.Position(1) parent.Position(2) 0 0];
        parent = parent.Parent;
    end

end

% Save current window functions
hWBDF = get(hFig, 'WindowButtonDownFcn');
hWBMF = get(hFig, 'WindowButtonMotionFcn');
hWBUF = get(hFig, 'WindowButtonUpFcn');
try % for newer versions of MATLAB
    hWKPF = get(hFig, 'WindowKeyPressFcn');
    hWKRF = get(hFig, 'WindowKeyReleaseFcn');
catch
    
end

% Save current pointer
curPointer = get(hFig, 'Pointer');
curPointerShapeCData = get(hFig, 'PointerShapeCData');

% Change window functions
set(hFig, 'WindowButtonDownFcn', @mouseClickFcn);
set(hFig, 'WindowButtonMotionFcn', @mouseMoveFcn);
set(hFig, 'WindowButtonUpFcn', '');

% Change actual cursor to blank

set(hFig, ...
    'Pointer', 'custom', ...
    'PointerShapeCData', nan(16, 16));


color = [1 0 0]; %crosshair color

%Create full crosshair lines
hCursor = line(nan, nan, ...
    'Parent', huiax, ...
    'Color', color, ...
    'LineWidth', 1, ...
    'LineStyle', '-', ...
    'HandleVisibility', 'off', ...
    'HitTest', 'off');


x = [];
y = [];
uiwait(hFig);
%--------------------------------------------------------------------------
    function mouseMoveFcn(varargin)
        % This function updates cursor location based on pointer location
        cursorPt = huiax.CurrentPoint;
        
        %Prevent cursor from moving beyond XLim
        if cursorPt(1)>huiax.XLim(2)
            cursorPt(1) = huiax.XLim(2);            
        elseif cursorPt(1)<huiax.XLim(1)
            cursorPt(1)=huiax.XLim(1);            
        end
        
        %Prevent cursor from moving beyond YLim
        if cursorPt(3)>huiax.YLim(2)
            cursorPt(3) = huiax.YLim(2);            
        elseif cursorPt(3)<huiax.YLim(1)
            cursorPt(3)=huiax.YLim(1);            
        end
       
        set(hCursor, ...
            'XData', [huiax.XLim(1) huiax.XLim(2) nan cursorPt(1) cursorPt(1)], ...
            'YData', [cursorPt(3) cursorPt(3) nan huiax.YLim(1) huiax.YLim(2)]);
    end

%--------------------------------------------------------------------------
    function mouseClickFcn(varargin)
        % This function captures mouse clicks.
        pos = hFig.CurrentPoint;
             
        %Click on huiax
        if pos(1)>=axPos(1) && pos(1)<=axPos(1)+axPos(3)
           %&& pos(2)>=axPos(2) && pos(2)<=axPos(2)+axPos(4)    
           
            % This function captures the information for the selected point 
            pt = huiax.CurrentPoint;
            x = [x; pt(1)];
            y = [y; pt(3)];
            
            % If captured all points, exit
            if length(x) == N
                exitFcn();
            end
        else %If click on other graphic objects
            x = [];
            y = [];
            exitFcn();
        end


    end



%--------------------------------------------------------------------------
    function exitFcn()
        % Exit GINPUTUIAX and restores previous figure settings        
        % Restore window functions and pointer
        set(hFig, 'WindowButtonDownFcn', hWBDF);
        set(hFig, 'WindowButtonMotionFcn', hWBMF);
        set(hFig, 'WindowButtonUpFcn', hWBUF); 
        set(hFig, 'Pointer', curPointer);
        set(hFig, 'PointerShapeCData', curPointerShapeCData);

        try 
            set(hFig, 'WindowKeyPressFcn', hWKPF);
            set(hFig, 'WindowKeyReleaseFcn', hWKRF);
        catch
  
        end

        % Delete invisible axes and return control
        delete(hCursor);
        uiresume(hFig);
    end
%--------------------------------------------------------------------------


end

