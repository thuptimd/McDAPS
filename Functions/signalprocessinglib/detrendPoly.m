function out = detrendPoly(data,n)

%Sang 5-Jun-2014: modified from function Javier Jo's 'detrend_high2.m' function.

%Transpose data into a column vector
[nrow,ncol] = size(data);
if nrow<ncol %originally a row vector
    data = data(:); %transpose to column vector
end

if n>1 %polynomial order > 1 --> remove polynomial trend of nth-order from data
    x = (0:length(data)-1)';
    [p,S,mu] = polyfit(x,data,n);
    trend = polyval(p,x,[],mu); %mu(1)=mean, mu(2)=std <-- scaling to improve numerical methods
    out = data - trend;
elseif n==1 %remove linear trend from data
    out = detrend(data);
elseif n==0 %remove mean level from data
    out = data - mean(data);
end

%Transpose data back to its original form
if nrow<ncol %originally a row vector
    out = out'; %transpose output back to row vector
end