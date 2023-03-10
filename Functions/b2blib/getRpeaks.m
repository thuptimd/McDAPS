function maxind = getRpeaks(ecg,fs,window)

% getRpeaks returns the indices where R-peaks occur. User defines the
% length of the window [sec] for which at least one peak will occur.

% Algorithm (Jul-15-2010)
% 1. Differentiates the ECG signal, amplifies the differentiated signal,d. 
% 2. Within the specified window length, find the first element of d that 
%    exceeds the threshold (minpeakht) to signify that there is a peak in
%    the current window. Identify that first element = y.
% 3. Within the pre-defined max. width of ECG peak (starting from y), find
%    the actual ECG peak, maxind, within the new ECG peak window.
% 4. Start the new window 1 index after the identified maxind.
% 5. Keep looping until no more peak can be identified.

% Syntax:
% maxind = getRpeaks(ecg,fs,window) where
% maxind = indices where R-peaks occur
% ecg = ECG signal
% fs = sampling frequency
% window = User-defined window length [sec] for which >= 1 peak will occur

%Transpose ECG into a column-vector
[nrow,ncol] = size(ecg);
if nrow<ncol
    ecg = ecg';
end

% % %Differentiate ECG then amplify the differentiated signal
% % d = 1000*diff(ecg).^3; d = [d(1); d];

range = round(window*fs); %convert unit of window [sec] to no. of points
maxpeakwd = round(0.2*fs); %max. width of ECG peak ~= 0.2 sec
expectedMaxRpeaks = 6; %maximum no. of R peaks that may occur within the specified window
from = 1; %initialize starting point of the window
m = zeros(length(ecg),1); %initialize vector to store max indices

%Keep finding the ecg peaks until no more peak is found
while 1
    to = from + range - 1; %specify the end of the window
    if from>=length(ecg)
            break
    
    elseif to<=length(ecg)
        
% %         temp = d(from:to); %current window
        temp = ecg(from:to); %ecg in current window
        
        %Find threshold for ECG peak identification
        minpeakht = find_threshold(temp,expectedMaxRpeaks); %function developed by Winston to determine the treshold
        
        x = find(temp>minpeakht,1,'first'); %find the 1st element in the current window that exceeds the threshold (minpeakht) i.e. whether there's a peak in the current window

        if ~isempty(x) %if there's a peak in the current window
            y = from + (x-1); %define the starting point of window to find the real R peak
            %Assume that R peak will occur within maxpeakwd from the identified first value > threshold in the specified window
            if (y+maxpeakwd)<=length(ecg) %if the end of the new window length still < length of ECG then
                temp = ecg(y:y+maxpeakwd); %re-define new current window
                [junk,ind] = max(temp); %find ECG peak within the window
                maxind = y + (ind-1); %get the actual max index
                m(maxind) = maxind; %store max index
                from = maxind + maxpeakwd; %re-define the starting point of the window and continue looping (find the next peaks)

            else %if the end of the new window length > length of ECG (i.e. last peak) then
                temp = ecg(y:end); %current window ends at the length of ECG
                [junk,ind] = max(temp); %find ECG peak within the window
                maxind = y + (ind-1); %get the actual max index
                m(maxind) = maxind; %store max index
                break %break from the while loop
            end

        else %no more peak
            from = from+1;
            continue;
        end
    
    else %if length of pre-defined window > length of ECG then
        
        to = length(ecg); %let the window end at length of ECG
%         temp = d(from:to); %current window
        temp = ecg(from:to); %ecg in current window
        x = find(temp>minpeakht,1,'first'); %find the 1st element in the current window that exceeds the threshold (minpeakht from previous beat) i.e. whether there's a peak in the current window

        if ~isempty(x) %if there's a peak in the current window
            y = from + (x-1); %define the starting point of window to find the real ECG peak
            %Assume that ECG peak will occur within maxpeakwd from the max. slope (y) identified earlier
            if (y+maxpeakwd)<=length(ecg) %if the end of the new window length still < length of ECG then
                temp = ecg(y:y+maxpeakwd); %re-define new current window
                [junk,ind] = max(temp); %find ECG peak within the window
                maxind = y + (ind-1); %get the actual max index
                m(maxind) = maxind; %store max index
                from = maxind + maxpeakwd; %re-define the starting point of the window and continue looping (find the next peaks)

            else %if the end of the new window length > length of ECG (i.e. last peak) then
                temp = ecg(y:end); %current window ends at the length of ECG
                [junk,ind] = max(temp); %find ECG peak within the window
                maxind = y + (ind-1); %get the actual max index
                m(maxind) = maxind; %store max index
                break %break from the while loop
            end

        else %no more peak
            from = from+1;  
            continue;
        end
        
    end    
       
end

%Get rid of zero elements
x = m~=0;
maxind = m(x);

% %Discard wrong peaks-Toey
% trend = getTrend(ecg);
% peaks = ecg(maxind)-trend(maxind);
% maxind(abs(peaks)<0.3) = [];






