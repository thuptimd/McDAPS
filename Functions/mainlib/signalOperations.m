function y = signalOperations(handles,varind)

%This function applies the following operations in order on the signal:
% 1. Normalization (such that mean = 0 and std = 1)
% 2. Detrend -- remove polynomial trend from the signal
%    Detrend order must be >=0. 0:demean, 1:linear detrend, >=2:polynomial detrend
% 3. x-shift -- shift along time-axis (x-axis) [sec]
% 4. scaling -- scale the signal by factor g
% 5. y-shift -- shift along y-axis [unit of y]

yorig = handles.DB.signal{varind}; %original selected signal

%Transpose signal into a column vector
if isrow(yorig)
    y = yorig(:);
    flagrow = 1;
else
    y = yorig;
end

%Normalize
if handles.DB.flagnorm(varind)>0
   % meanstd = handles.DB.meanstd{varind}; %meanstd(1) = mean, meanstd(2) = std
   % y = (y - meanstd(1))/meanstd(2); %normalized signal
   y = y/prctile(y,95);
end

%Detrend
if handles.DB.flagdetrend(varind)>0
    y = detrendPoly(y,handles.DB.detrend(varind)); %detrended signal
end


%scale
y = handles.DB.scale(varind)*y;



%Transpose signal back to its original form
if exist('flagrow','var') && flagrow==1
    y = y';
end