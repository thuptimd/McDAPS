function s = optimum_segment(data,fs,minhr,maxhr)
% ----------------------------------------------------------------------- %
% s = optimum_segment(data,fs,minhr,maxhr) 
%   calculates the optimal segmentation of data                           %
%   Input parameters:                                                     %
%       - data:         PPG signal. [1xN]                                 %
%       - fs:           Sampling frequency.                               %
%       - minhr:        minimum heart rate.                               %
%       - maxhr:        max heart rate.                                   %
%                                                                         %
%   Output variables:                                                     %
%       - s:            segment size in samples
% ----------------------------------------------------------------------- %
%   Versions:                                                             %
%       - 1.0:          (10/10/2021) Original script.                     %
% ----------------------------------------------------------------------- %
%   Script information:                                                   %
%       - Version:      1.0.                                              %
%       - Author:       Wanwara Thuptimdang                               %
%       - Date:         10/10/2021                                        %
% ----------------------------------------------------------------------- %
%   References:                                                           %
%  [1] avsaoğlu, Ahmet Reşit, Kemal Polat, and Mehmet Recep Bozkurt. 
%      "An innovative peak detection algorithm for photoplethysmography 
%      signals: an adaptive segmentation method." 
%      Turkish Journal of Electrical Engineering & Computer Sciences 24.3 (2016): 1782-1796.           %
% ----------------------------------------------------------------------- %
first_value = fs*60/maxhr/3; %Smallest segment
last_value = fs*60/minhr/3; %Biggest period = Biggest segment 
x = length(data);
ii = 0; criterion = 0.1;

segment = round(first_value); %the size of a segment
hr = [];
segment_values = [];
while segment<=last_value %Loop different sizes of segment
    [peak_value,peak_location] = max(data(1:segment-1));
    j=0;
    i = segment+1;
    peak_values = zeros(length(data),1);
    peak_locations = zeros(length(data),1);
    while i<=x-segment-1 %Move segment along the data to detect peaks
        %Check up trend 
        %by checking if the max value of this segment 
        %is lower than the max value of the next segment
        if peak_value<max(data(i:i+segment-1))
            [peak_value,peak_location] = max(data(i:i+segment-1));
            direction = 1; %Going up
            
        elseif exist('direction','var') && direction==1 %This segment is down trend
            j = j+1;
            %-- Keep peak value & location --
            peak_values(j) = peak_value; 
            peak_locations(j) = peak_location;
           [peak_value,peak_location] = max(data(i:i+segment-1));
            
            %-- Flag downtrend --
            direction = 2;
            
        else
            [peak_value,peak_location] = max(data(i:i+segment-1)); %Add this myself to update the current peak

            direction = 2;
        end
        i = i+segment;
        
    end
    
    %-- After collected all the peak_value and peak_location --
    t1 = peak_locations(1:j)/fs;
    rri_values = t1(2:length(t1))-t1(1:length(t1)-1);
    hrf = 1/rri_values;
    std_deviation = std(rri_values);
    segment = segment+fix(fs*0.01);
    
    if std_deviation < criterion
        ii = ii+1; %Update no. of segment sizes
        hr = [hr;fix(mean(hrf)*60)];
        segment_values = [segment_values;segment];
    end


end

%Search the optimal segment
M = mode(hr); 
ind = find(hr==M,1,'first');
s = segment_values(ind);



end

