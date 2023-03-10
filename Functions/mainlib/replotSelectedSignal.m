function replotSelectedSignal(hObject,handles,varind)
%varind = index of the currently selected variable in Workspace --> one variable selected at a time
%Last modified - 2016-12-15 by Toey
%After replotting, I delete the original line object because matlab still
%keeps Xdata of the original plot even it's invisible. The auto-adjust xlimit is affected by the invisible plot


y = signalOperations(handles,varind); % y is an operated signal
x = (0:length(y)-1)/handles.DB.fs(varind);

plotvarind = find(handles.DB.varindex==varind); %If the same variable is plotted multiple times, plotvarind will be an array
if ~isempty(plotvarind) %If it cannot find the selected variable, then it's not being plotted 
    
    ax = handles.DB.axesnum(plotvarind); %Get the axis that the variable is being plotted
    naxes = length(ax); %In case there are more variables selected, there will be more than one axis
    
    set(handles.DB.hline(plotvarind),'Visible','off'); %Make the original one invisible and delete later
    
    for n=1:naxes %More than one axis to replot
        
        %strTitle = get(get(handles.DB.haxes(ax(n)),'Title'),'String');
        
        ind = handles.DB.varindex(handles.DB.axesnum==ax(n)); %Get the index of the variable plotting on ax(n) (ax(n) is a number)
        sig = handles.DB.signal(ind); %sig is a cell
        fs  = handles.DB.fs(ind); %fs is a vector
        
        %Replot signal
        subplot(handles.DB.haxes(ax(n))); hold on;
        old_line_obj = handles.DB.hline(plotvarind(n)); %Delete the original object
        handles.DB.hline(plotvarind(n)) = plot(handles.DB.haxes(ax(n)),x,y,'Color',handles.DB.color{plotvarind(n)},'LineStyle',handles.DB.style{plotvarind(n)});
        delete(old_line_obj);
        ymin = [];
        ymax = [];
        
        for m=1:size(sig,1) %More than 1 loop, if two or more lines are plotted on the axis              
            yy = signalOperations(handles,ind(m)); %apply any operations on the current signal
            
            i1 = round(fs(m)*handles.DB.xlimit(1));
            if i1<1
                i1 = 1;
            end
            i2 = round(fs(m)*handles.DB.xlimit(2));
            if i2>length(yy)
                i2 = length(yy);
            end
            ymin = min([ymin, min(yy(i1:i2))]);
            ymax = max([ymax, max(yy(i1:i2))]);

        end %end for m
        
        %Set y-limit of the current axes
        if size(handles.DB.ylimit,1)>=ax(n)
            if handles.DB.ylimit(ax(n),1)==0 && handles.DB.ylimit(ax(n),2)==0
                %auto-adjust ylimit of the current axes
                yrange = ymax - ymin;
                ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];    
                if diff(ylimit)==0 %y is a constant
                    ylimit(1) = ylimit(1) - 1;
                    ylimit(2) = ylimit(2) + 1;
                end
            else
                %ylimit was manually set
                ylimit = handles.DB.ylimit(ax(n),:);            
            end
        else %auto-adjust ylimit of the current axes
            yrange = ymax - ymin;
            ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];
            handles.DB.ylimit(ax(n),:) = [0,0]; %[0,0] designates auto-adjust mode of ylimit
        end
        
        set(handles.DB.haxes(ax(n)),'Ylim',ylimit);
        

    end %end for n
end

guidata(hObject, handles); %update handles structure