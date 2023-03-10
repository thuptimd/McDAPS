function [result] = fex_fitcurve(y,x,varargin)
%UNTITLED2 Summary of this function goes here
% Fit four curves
% 1.None
% 2.Exponential
% Input: scaling, time constant
% 3.Polynomial
% Input: order
% 4.Sigmoid
% Input : upper,lower


% Fit polynomial order 1 or 3
% Input
% y = output
% x = time-axis (sec,min,hr)
% order
% x1 and x2 for fitting
% option1 : 1st and last samples
% option2 : minimum and maximum (min-max or max-min)
% option3 : pct5 and pct95

% Output 
% Delay time
% Response time
% Time to half
% Coefficients
% R-square

%% Check x,y if they are empty
minnumpoints = 30;

if isempty(y) || length(y)<minnumpoints
    return
    
end


theInputs = varargin;
Ninput = length(varargin)-1;
initpar = [];
yorig = y;
xorig = x;
showfigure = 1;
%% Default variable
for i=1:2:Ninput %y,x are not included in varargin
   inputField = theInputs{i};
   inputElement = theInputs{i+1};
   if ischar(inputField)
      switch inputField          
          case 'AnalysisRegion' %How to analyze this segment, the analysis region determines a type of response (decaying or growing)
              %option1 = use the entire segment
              %option2 = from pct->pct
              if inputElement.option == 2
                     pct1 = inputElement.prctile1; 
                     pct2 = inputElement.prctile2;
                     
                     val1 = prctile(y,pct1);
                     val2 = prctile(y,pct2);
                     
                     if val1>val2 %Decaying
                        ind1 = find(y<=val1,1,'first'); %Starts to decay
                        ind2 = find(y<=val2,1,'first'); %Starts to die off
                        y = y(ind1:ind2);
                        x = x(ind1:ind2);
                     
                     elseif val2>val1 %Growing
                        ind1 = find(y>=val1,1,'first'); %Starts to increase
                        ind2 = find(y>=val2,1,'first'); %Starts to saturate
                        y = y(ind1:ind2);
                        x = x(ind1:ind2);

                         
                     else
                        return; %Error, this case should not exist 
                         
                     end
                     
                     %I might need to check the length of the signals
              end
          case 'Curvetype'
              curvetype = inputElement;
          case 'Init' 
                 initpar = inputElement;       
          case 'xUnit'
                switch inputElement
                    case 'msec'
                        xunit = 'msec';
                        x = x/(10^-3);
                    case 'sec'
                        xunit = 'sec'; %Do nothing
                    case 'min'
                        xunit = 'min';
                        x = x/(60);
                    case 'hr'
                        xunit = 'hr';
                        x = x/(3600);                       
                    otherwise
                         error('Time axis must be in msec, sec, min or hr');
                end
                
          case 'ROIname'
              roiname = inputElement;
          
          case 'Varname'
              varname = inputElement;
              
          case 'Filename'
               filename = inputElement;
               
          case 'ShowFigure'
              showfigure = inputElement;
                    
          
      end
          
          
   end
   
    
    
end


%% Fitting
%% None
if curvetype ==1 %Use with a filter option
    prediction = y; %Use the original signal as it is
    Rsquare = [];
    
    [timetohalfmax,halfmax,min_x,min_y,max_x,max_y] = calculateTimeToHalfMax(y,x);

    ylabelstr = 'None( use with a filter )';

    %Output str
    outputstr_a = ['Summary of Fit' newline 'Half max' newline 'Time to half max =' newline 'Max coordinate' newline 'Min coordinate'];
    outputstr_b = [newline sprintf('%0.2f',halfmax) newline sprintf('%0.2f',timetohalfmax) newline '[' sprintf('%0.1f',max_x) ',' sprintf('%0.1f',max_y) ']' newline '[' sprintf('%0.1f',min_x) ',' sprintf('%0.1f',min_y) ']' ];

    outputfeature = {'timetohalfmax','halfmax'};

    par = [timetohalfmax,halfmax];

%% Exponential
elseif curvetype==2
    f_vaso = @(par) sum((y-par(1)*exp(-x*par(2))).^2); %Define the cost function = least square
    x0 = [initpar.scaling,initpar.timeconstant]; %Initial parameters, this is from the fex setting
    %x0 = [1 1];                         %Initial parameters, this is test
    [par,Jmin] = fminsearch(f_vaso,x0); %Search for the best parameters using fminsearch
    nmse = Jmin/(length(y)*var(y));     %Calculate the error
    Rsquare = 1-nmse;                   %Rsquare    
    prediction = par(1)*exp(-x*par(2)); %prediction

    
    %% Output
    [timetohalfmax,halfmax,min_x,min_y,max_x,max_y] = calculateTimeToHalfMax(prediction,x);

    
    
    ylabelstr = 'Exponential';
    %Output str, parameters
    outputstr_a = ['Summary of Fit' newline 'R-square' newline 'Half max' newline 'Time to half max =' newline 'Max coordinate' newline ... 
        'Min coordinate' newline 'Scaling factor =' newline 'Time constant =' ];
    
    outputstr_b = [newline sprintf('%0.2f',Rsquare) newline sprintf('%0.2f',halfmax) newline ...
        sprintf('%0.2f',timetohalfmax) newline '[' sprintf('%0.1f',max_x) ',' ...
        sprintf('%0.1f',max_y) ']' newline '[' sprintf('%0.1f',min_x) ',' sprintf('%0.1f',min_y) ']' ...
        newline sprintf('%0.2f',par(1)) newline sprintf('%0.2f',par(2))];
    
    
    outputfeature = {'timetohalfmax','halfmax','scaling','timeconstant'};
    par = [timetohalfmax,halfmax,par];


%% Polynomial
elseif curvetype == 3
    p = polyfit(x,y,initpar.order);
    prediction = polyval(p,x);
    Rsquare = 1-var(y-prediction)/var(y);
    par = flip(p); %Coefficients , #coefficients = order+1, Make intercept the first element

    [timetohalfmax,halfmax,min_x,min_y,max_x,max_y] = calculateTimeToHalfMax(prediction,x);

    
    ylabelstr = 'Polynomial';
   %{
    outputstr_a = ['Summary of Fit' newline 'Rsquare' newline ...
        'Half max' newline 'Time to half max =' newline 'Max coordinate' newline 'Min coordinate' newline...        
        'Intercept ' newline 'Coefficients (p1->p' num2str(length(par)-1) ')'];
    outputstr_b = [newline sprintf('%0.2f',Rsquare) newline sprintf('%0.2f',halfmax) newline sprintf('%0.2f',timetohalfmax) newline '[' sprintf('%0.1f',max_x) ',' ...
        sprintf('%0.1f',max_y) ']' newline '[' sprintf('%0.1f',min_x) ',' sprintf('%0.1f',min_y) ']'];
    %}  
    outputstr_a = ['Summary of Fit' newline 'R-square' newline ...      
        'Intercept ' newline 'Coefficients (p1->p' num2str(length(par)-1) ')'];
    outputstr_b = [newline sprintf('%0.2f',Rsquare)];
    
    for np=1:length(p)
        outputstr_b = [outputstr_b newline sprintf('%0.5f',par(np))];
    end
    
    outputfeature = repmat({'p'},length(par)-1,1); 
    order = num2str((1:length(p)-1)'); 
    order = cellstr(order);
    outputfeature = strcat(outputfeature,order); outputfeature = outputfeature'; %Change to a row vector
    
    %Add intercept 
    outputfeature = ['intercept',outputfeature];

%% Sigmoid
elseif curvetype == 4
    %% init
    %Check options for initial parameters
    if initpar.upperoption == 1 % 1 -> uses user input
        upper_plateau = initpar.upperenter; %Absolute value for upper_plateau
               
    elseif initpar.upperoption ==0
        %upper plateau
    	upper_plateau = prctile(y,95); 
        
    end

    if initpar.loweroption == 1 
        lower_plateau = initpar.lowerenter; %Raw value in a signal
        
    elseif initpar.loweroption ==0 
        %lower plateau
        lower_plateau = prctile(y,5); %Raw value in a signal
    
    end
    
    %Are upper_plateau and lower_plateau valid?
    % not empty
    if isempty(upper_plateau) || isempty(lower_plateau)
        return
    elseif upper_plateau<=lower_plateau
        return
    end
    
    %Initial slope, linear slope
    temp = find(y>=upper_plateau);
    x2 = round(median(temp));

    
    temp = find(y<=lower_plateau);
    x1 = round(median(temp));


    if x1<x2
        %x1 must be before x2 time-wise
        p = polyfit(x(x1:x2),y(x1:x2),1); %Estimate an initial slope for sigmoid
    elseif x2<x1
        p = polyfit(x(x2:x1),y(x2:x1),1);
    end
    
    
    %Mid point = middle of the linear slope
    x0 = x(round(x1+0.5*(x2-x1)));
       
    
    initpar = [p(1),x0,lower_plateau,upper_plateau];
    
    %Optimization
    tempmyfun = @(optx) sum((y-mysigmoid(x,optx)).^2);
    [par,Jmin] = fminsearch(tempmyfun,initpar);
    
    %Prediction
    prediction = mysigmoid(x,par);
    nmse = Jmin/(length(y)*var(y));
    Rsquare = 1-nmse;                   %Rsquare
    
    [timetohalfmax,halfmax,min_x,min_y,max_x,max_y] = calculateTimeToHalfMax(prediction,x);


    outputstr_a = ['Summary of Fit' newline 'R-Square' newline 'Upper plateau =' newline 'Lower plateau =' newline 'Midpoint =' newline 'Slope =' ];
    outputstr_b = [newline sprintf('%0.2f',Rsquare) newline sprintf('%0.2f',par(4)) newline sprintf('%0.2f',par(3)) newline sprintf('%0.2f',par(2)) newline sprintf('%0.3f',par(1))];
    outputfeature = {'slope','midpoint','lower','upper'};
    ylabelstr = 'Sigmoid';
end




%% Result
result.par = par; %Final parameters
result.feature = outputfeature;


 %% Create a figure and show all of the parameters in text
 if ispc
     fntsize = 10;
 else
     fntsize = 16;
 end
 if showfigure
     fig = figure;
     set(fig,'Position',[680   180   560   720]); %In pixel I believe
     
     %create axe
     left_margin = 40;
     top_margin = 30;
     xpos = (1.8*left_margin)/fig.Position(3);
     
     axewidth = (fig.Position(3)-3*left_margin)/fig.Position(3);
     axeheight = 0.5*(fig.Position(4)-2*top_margin)/fig.Position(4);
     ypos = 1-top_margin/fig.Position(4)-axeheight;
     fnax = axes(fig,'Unit','normalized','Position',[xpos ypos axewidth axeheight],'FontSize',fntsize,'Box','on','BoxStyle','full');
     
     plot(xorig,yorig); hold on;
     plot(x,y,'k','LineWidth',1); hold on;
     plot(x,prediction,'--r','LineWidth',2);
     xlabel('Time(sec)'); ylabel(ylabelstr); title([filename,',',varname,':',roiname]);
     set(fnax,'FontSize',fntsize);
     
     
     %% Create Text boxes
     %Location a [x(firstcrossing_index), prediction(firstcrossing_index)
     txt_height = axeheight-2*top_margin/fig.Position(4);
     txt_width = 0.4*axewidth;
     txt_location_a = uicontrol(fig,'Style','text','String',outputstr_a,...
         'Unit','normalized','Position',[xpos top_margin/fig.Position(4) 0.4*axewidth txt_height],...
         'FontSize',fntsize,...
         'BackgroundColor',[0.94 0.94 0.94],...
         'HorizontalAlignment','left');
     
     xpos = xpos+txt_width+0.2*axewidth;
     txt_location_b = uicontrol(fig,'Style','text','String',outputstr_b,...
         'Unit','normalized','Position',[xpos top_margin/fig.Position(4) txt_width txt_height],...
         'FontSize',fntsize,...
         'BackgroundColor',[0.94 0.94 0.94],...
         'ForegroundColor',[0.3 0.6 0.83],...
         'HorizontalAlignment','right');
 end
 
 
end

function [y] = mysigmoid(x,par)

% Inputs:
% x = input value
% par(1) = slope = gain or slope at the inflextion point. The higher the value, the
%         steeper the slope.
% par(2) = x0    = the midpoint (x-axis) of linear slope
% par(3) = ymin  = minimum saturation value of the function
% par(4) = ymax  = maximum saturation value of the function

ymin = par(3); ymax = par(4); slope = par(1); x0 = par(2);

k = (ymax - ymin)/(4*slope);
y = (ymin + ymax.*exp((x-x0)./k))./(1 + exp((x-x0)./k));



end

function [timetohalfmax,halfmax,min_x,min_y,max_x,max_y] = calculateTimeToHalfMax(y,x)
%% Calculate time to half max
pctmax =  prctile(y,95);
pctmin =  prctile(y,5);

pctmax_indexes = find(y>=pctmax,30,'first'); %search 30 points, better if use with sampling frequency
pctmin_indexes = find(y>=pctmin,30,'first');

med_pctmax_indexes = median(pctmax_indexes);
med_pctmin_indexes = median(pctmin_indexes);

if med_pctmax_indexes>med_pctmin_indexes
    %Growing response
    %Since I assume, None option is applied on a filter, use the maximum
    
    [maxvalue,maxind] = max(y); %Search for the maximum
    minvalue = y(1); %min value is the value of the fist point
    h = maxvalue-minvalue;
    
    %Time to half max = the time in seconds it takes to reach half of h
    %from the minimum point (the first point)
    halfmax = minvalue+0.5*h;
    halfmax_index = find(y>=halfmax,1,'first');
    timetohalfmax = x(halfmax_index)-x(1);
    
    
    %Coordinates
    max_x = x(maxind);
    max_y = maxvalue;
    min_x = x(1);
    min_y = minvalue;
    
else
    %Decaying response
    maxvalue = y(1); %Assume that the first value is the maximum
    [minvalue,minind] = min(y);
    h = maxvalue-minvalue;
    halfmax = maxvalue-0.5*h;
    halfmax_index = find(y<=halfmax,1,'first');
    timetohalfmax = x(halfmax_index)-x(1);
    
    %Coordinates
    max_x = x(1);
    max_y = maxvalue;
    min_x = x(minind);
    min_y = minvalue;
    
end




end

