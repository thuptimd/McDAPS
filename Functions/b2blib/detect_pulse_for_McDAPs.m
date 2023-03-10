function [indmin,indmax,minval,maxval] = detect_pulse_for_McDAPs(signal,fs,minhr,maxhr,obj)
%   [indmin,indmax] = detect_pulse_for_McDAPs(signal,fs,minhr,maxhr) 
%   Function "detect_pulse" detect peaks and troughs of pressure signals e.g. PPG, BP
%   Input parameters:                                                     %
%       - data:         PPG signal. [1xN]                                 %
%       - fs:           Sampling frequency.                               %
%       - minhr:        minimum heart rate.                               %
%       - maxhr:        max heart rate.                                   %
%       - obj:          obj to status bar
%                                                                         %
%   Output variables:                                                     %
%       - indmin:       The locations of the pulse onset
%       - indmax:       The locations of the peaks
% ----------------------------------------------------------------------- %
%   Versions:                                                             %
%       - 1.0:          (10/14/2021) Original script.                     %
% ----------------------------------------------------------------------- %
%   Script information:                                                   %
%       - Version:      1.0.                                              %
%       - Author:       Wanwara Thuptimdang                               %
%       - Date:         10/14/2021                                        %
% ----------------------------------------------------------------------- %
%   References:                                                           %
%  [1] avsaoğlu, Ahmet Reşit, Kemal Polat, and Mehmet Recep Bozkurt. 
%      "An innovative peak detection algorithm for photoplethysmography 
%      signals: an adaptive segmentation method." 
%      Turkish Journal of Electrical Engineering & Computer Sciences 24.3 (2016): 1782-1796.           %
% ----------------------------------------------------------------------- %
set(obj,'String','Searching the optimal window...');
drawnow;

segment = optimum_segment(signal,fs,minhr,maxhr);
peak_values = zeros(length(signal),1);
peak_locations = zeros(length(signal),1);
[peak_value,peak_location]=max(signal(1:segment-1));
i = segment+1;
j = 0;
rounds = length(signal)-segment-1;
while i<=length(signal)-segment-1
    set(obj,'String',['Detecting peaks......',num2str(round((100*i)/rounds)),'%']);
    drawnow;


    if peak_value<max(signal(i:i+segment-1)) %up trend
        [peak_value, peak_location] = max(signal(i:i+segment-1));
        peak_location = peak_location+i-1; %calculate offset
        direction = 1;
    elseif exist('direction','var') && direction==1 %down trend
        j = j+1;
        peak_values(j) = peak_value;
        peak_locations(j) = peak_location;
        [peak_value, peak_location] = max(signal(i:i+segment-1));
        peak_location = peak_location+i-1; %calculate offset

        direction = 2; 
    else
        [peak_value, peak_location] = max(signal(i:i+segment-1));
        peak_location = peak_location+i-1; %calculate offset
        direction = 2;
    end
    i = i+segment;
    
end
%--- Search corresponding min values --
peak_locations = peak_locations(1:j);
peak_values = peak_values(1:j);
min_locations = zeros(size(peak_locations));
min_values = zeros(size(peak_locations));
i = 1;
rounds = length(peak_locations);
for n=1:length(peak_locations)
    set(obj,'String',['Detecting troughs......',num2str(round((100*n)/rounds)),'%']);
    drawnow;
   j = peak_locations(n);   
   [min_value,min_location] = min(signal(i:j-1));
   min_locations(n) = min_location+i-1;
   min_values(n) = min_value;
   i = j;     
end

set(obj,'String','Complete!......');
drawnow;

%-- Output --
indmin = min_locations;
indmax = peak_locations;
minval = min_values;
maxval = peak_values;

end

