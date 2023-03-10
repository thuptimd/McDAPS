%% Find_Threshold (developed by Winston)

%Algorithm:  Find an adaptive threshold to isolate the R_peaks from other wave components.  
%Within each frame, sort the frequency of ECG values into 10 histogram bins.  Begin at bin with the 
%most frequent component indicating that it is the mean value of the ECG signal.  Progressively move
%to higher bin value by checking the occurrence of ECG trace until it is less than the maximum 
%expected number of R_stems within each frame.  This has the effect of increasing the threshold until
%it is higher than all ECG wave components except the R_stems.

function [Effective_threshold] = find_threshold(ECG_sampled,Expected_MaxRpeaks)
    
    [histN_ECG, histX_ECG] = hist(ECG_sampled);         %Calculate the histogram of low resolution ECG of each cycle.
    [bin_freq, bin_index] = max(histN_ECG);             %Find the highest frequency and index to begin adaptively adjust threshold.

%     %Uncomment this to see selection of adaptive threshold choices and selection.
%     figure; bar(histX_ECG, histN_ECG);                  %Display the histogram of each ECG frame.
    
    %Adaptively search for the effective threshold that is located at a bin index value with histogram
    %bin frequency that is just below the maximum expected number of R_stems within each frame. 
    
    while (histN_ECG(bin_index) > Expected_MaxRpeaks) 
        bin_index = bin_index+1;                        %Three bin over is an empirical value.
        
        %If cannot find any bins with no. of peaks < Expected_MaxRpeaks,
        %let the Expected_MaxRpeaks = the value of the last (10th) bin
        %(Modified by Sang Aug-12-2010)
        if bin_index > 10
            bin_index = 10;
            break
        end
        
    end

    Effective_threshold = histX_ECG(bin_index);         %The effective threshold is found adaptively for each ECG frame.