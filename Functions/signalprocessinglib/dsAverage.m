function out = dsAverage(data,n)

%dsAverage returns data that was downsampled by averaging by integer factor n.
%Inputs:
%  data = data vector to be downsampled
%  n = integer factor that the sampling rate will be decreased by e.g.
%      n = orig_fs/new_fs where orig_fs > new_fs
%Output:
%  out = downsampled data

[nrow,ncol] = size(data);

lgth = floor((length(data)-1)/n) + 1; %data length after downsampling
out = zeros(lgth,1);
out(1) = data(1); %let the first downsampled data point = first orignal data point
z1 = 2;          %initial starting index
z2 = z1 + n - 1; %initial end index
for k=2:lgth
    out(k) = mean(data(z1:z2));
    
    %Update range of samples to be averaged
    z1 = z1 + n; %update starting index
    z2 = z2 + n; %update end index
end

if ncol>nrow %original data = row vector
    out = out'; %transpose output back to row vector
end