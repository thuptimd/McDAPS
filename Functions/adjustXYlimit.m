function [] = adjustXYlimit(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
naxes = length(handles.DB.haxes);

for n=1:naxes
    set(handles.DB.haxes(n),'Xlim',handles.DB.xlimit);

    %Set y-limit
    z = find(handles.DB.axesnum==n);
    s = handles.DB.signal(handles.DB.varindex(z)); %signals in current axes
    fs = handles.DB.fs(handles.DB.varindex(z)); %sampling frequencies of signals in current axes
    
    if size(handles.DB.ylimit,1)>=n
        if handles.DB.ylimit(n,1)==0 && handles.DB.ylimit(n,2)==0
            %auto-adjust ylimit of the current axes
            ymin = [];
            ymax = [];
            for k=1:size(s,1)
                indxmin = floor(handles.DB.xlimit(1)*fs(k)); %min x-limit [no. of samples]
                indxmax = ceil(handles.DB.xlimit(2)*fs(k));  %max x-limit [no. of samples]
                if indxmin<1
                    indxmin = 1;
                end
                if indxmax>length(s{k})
                    indxmax = length(s{k});
                end

                %Apply any signal operations to the current signal
                y = signalOperations(handles,handles.DB.varindex(z(k)));
                
                %Replace any NaN with 0
                nanind = isnan(y);
                y(nanind) = 0;

                ymin = min([ymin, min(y(indxmin:indxmax))]);
                ymax = max([ymax, max(y(indxmin:indxmax))]);
            end
            
            if ~isempty(ymin) && ~isempty(ymax)
                yrange = ymax - ymin;
                ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];
                if diff(ylimit)==0 %y is a constant
                    ylimit(1) = ylimit(1) - 1;
                    ylimit(2) = ylimit(2) + 1;
                end
            else
                ylimit(1) = -1;
                ylimit(2) =  1;
            end
                
        else
            %ylimit was manually set
            ylimit = handles.DB.ylimit(n,:); 
        end        
    else
        %auto-adjust ylimit of the current axes
        ymin = [];
        ymax = [];
        for k=1:size(s,1)
            indxmin = floor(handles.DB.xlimit(1)*fs(k)); %min x-limit [no. of samples]
            indxmax = ceil(handles.DB.xlimit(2)*fs(k));  %max x-limit [no. of samples]
            if indxmin<1
                indxmin = 1;
            end
            if indxmax>length(s{k})
                indxmax = length(s{k});
            end

            %Apply any signal operations to the current signal
            y = signalOperations(handles,handles.DB.varindex(z(k)));
            
            %Replace any NaN with 0
            nanind = isnan(y);
            y(nanind) = 0;

            ymin = min([ymin, min(y(indxmin:indxmax))]);
            ymax = max([ymax, max(y(indxmin:indxmax))]);
        end
        
        if ~isempty(ymin) && ~isempty(ymax)
            yrange = ymax - ymin;
            ylimit = [ymin-0.03*yrange, ymax+0.03*yrange];
            if diff(ylimit)==0 %y is a constant
                ylimit(1) = ylimit(1) - 1;
                ylimit(2) = ylimit(2) + 1;
            end
        else
            ylimit(1) = -1;
            ylimit(2) =  1;
        end
        handles.DB.ylimit(n,:) = [0,0]; %[0,0] designates auto-adjust mode of ylimit
        
    end

    set(handles.DB.haxes(n),'Ylim',ylimit);
    
end


end

