function [pearson,spearman] = compareRvsBaseNullR(varargin)

% compareRvsBaseNullR returns correlation coefficient (r) and the p-value 
% of the comparison between r in the test region (r_test) and null 
% distribution of r's in the baseline region.
%
% r_test is obtained by correlating the input (stimulus) with the output 
% signal in the test region. A search window is applied on the output
% signal such that it slides through the output signal by 1 sample at a
% time and for each shift, the correlation coefficient between the input
% and the 'delayed' output signal is computed. r_test is the most positive
% (or negative) correlation coefficient in that search window.
%
% In order to determine if r_test (correlation caused by stimulus) is
% different from baseline correlations (reflecting fluctuations NOT caused
% by stimulus), a null distribution of baseline correlation coefficients
% (r_base) is constructed. This null distribution is constructed by
% correlating the input in the test region (i.e. the same stimulus) with
% the output signal in the baseline region. Once the null distribution is
% obtained, the r_test is compared to that null distribution and the
% p-value is obtained.
%
% Syntax:
% [pearson,spearman] = compareRvsBaseNullR(x,y,ndelay,base,test)
% [pearson,spearman] = compareRvsBaseNullR(x,y,ndelay,base,test,roption,testtype)
%
% Inputs:
% x      = input signal
% y      = output signal (must have the same sampling frequency as x)
% ndelay = search window size          [no. of samples]
% base   = baseline region [from,to]   [no. of samples]
% test   = test region [from,to]       [no. of samples]
%
% Optional inputs:
% roption = sign of expected r
%   - 'positive' = maximum positive r (default)
%   - 'negative' = most negative r
%   - 'absolute' = maximum absolute value of r
% testtype = type of test to obtain p-value
%   - 'one-sided' = returns one-tailed p-value (default)
%   - 'two-sided' = returns two-tailed p-value
%
% Outputs:
% pearson = output struct containing results of Pearson correlation
%   - r        = correlation coefficient in test region
%   - p        = p-value
%   - d        = delay to maximum correlation [no. of samples]
%   - N        = number of shifts performed when constructing null distribution
%   - roption  = selected roption
%   - testtype = selected p-value type
%   - basecdf  = cumulative distribution function of baseline null
%                distribution: col1 = x-axis of CDF, col2 = y-axis of CDF
% spearman = output struct containing results of Spearman correlation
%            This requires Statistics toolbox. If the toolbox is not
%            available, spearman is returned as an empty matrix [].
%
% Examples:
% [pearson,spearman] = compareRvsBaseNullR(therm,patamp,20,[1,1000],[1500,2000])
% [pearson,spearman] = compareRvsBaseNullR(therm,patamp,20,[1,1000],[1500,2000],'negative','one-sided')




%Check input arguments
try
    [x,y,ndelay,base,test,roption,testtype] = checkInputs(varargin);
catch
   return 
end

%Check if statistics toolbox is available (for Spearman correlation)
flagStattool = 1;
if ~license('test','Statistics_Toolbox')
    flagStattool = 0;
end

base = (base(1):base(2));
test = (test(1):test(2));
lgthbase = length(base);
lgthtest = length(test);

%% Compute correlation between test_x and y in base region

nshift = lgthbase - lgthtest - ndelay + 1;
dshift = (0:ndelay); %no. of shifts (delays) of each column in ymat
corrBasePearson  = zeros(nshift,1);
if flagStattool, corrBaseSpearman = zeros(nshift,1); end

hwait = waitbar(0,'1','Name','Computing correlation coefficients'); %create waitbar
%% This part is added by Toey 2016-05-14
if nshift<1 %cannot compute null distribution
    pearson = [];
    spearman = [];
    return
end
%hwait = waitbar(0,'Please Wait');

for k=1:nshift
    
    waitbar((k-1)/nshift,hwait,sprintf('%3.0f%%',(k-1)/nshift*100)); %update waitbar
    
    if flagStattool
        i1 = base(1) + (k - 1);
        i2 = i1 + lgthtest - 1 + ndelay;
        ymat = repmat(y(i1:i2),1,ndelay);
        [nrow,ncol] = size(ymat);
        ymatshift = zeros(nrow,ncol);
        for d=1:ncol
            ymatshift(:,d) = [ymat(dshift(d)+1:nrow, d); ymat(1:dshift(d), d)];
        end
        ymatshift = ymatshift(1:lgthtest,:);

        tempcorrPearson  = corr(x(test),ymatshift,'Type','Pearson');
        tempcorrSpearman = corr(x(test),ymatshift,'Type','Spearman');
        
        clear i1 i2 ymat nrow ncol ymatshift;
    else
        for d=1:ndelay+1 %+1 to account for delay=0
            i1 = base(1) + (k - 1) + (d - 1);
            i2 = i1 + lgthtest - 1;
            rr = corrcoeff(x(test),y(i1:i2));
            tempcorrPearson(d) = rr(1,2);
            clear i1 i2 rr;
        end
    end
    
    switch roption
        case 'positive'
            corrBasePearson(k)  = max(tempcorrPearson);
            if flagStattool, corrBaseSpearman(k) = max(tempcorrSpearman); end
        case 'negative'
            corrBasePearson(k)  = min(tempcorrPearson);
            if flagStattool, corrBaseSpearman(k) = min(tempcorrSpearman); end
        case 'absolute'
            corrBasePearson(k)  = max(abs(tempcorrPearson));
            if flagStattool, corrBaseSpearman(k) = max(abs(tempcorrSpearman)); end
    end
    
    clear tempcorrPearson tempcorrSpearman;
end %end for k

%% Compute correlation between test_x and y in test region

tempcorrPearson  = zeros(ndelay+1,1);
if flagStattool, tempcorrSpearman = zeros(ndelay+1,1); end

if flagStattool
    i1 = test(1);
    i2 = i1 + lgthtest - 1 + ndelay;
    ymat = repmat(y(i1:i2),1,ndelay);
    [nrow,ncol] = size(ymat);
    ymatshift = zeros(nrow,ncol);
    for d=1:ncol
        ymatshift(:,d) = [ymat(dshift(d)+1:nrow, d); ymat(1:dshift(d), d)];
    end
    ymatshift = ymatshift(1:lgthtest,:);
    
    tempcorrPearson  = corr(x(test),ymatshift,'Type','Pearson');
    tempcorrSpearman = corr(x(test),ymatshift,'Type','Spearman');
    
    clear i1 i2 ymat nrow ncol ymatshift;
else
    for d=1:ndelay+1  %+1 to account for delay=0
        i1 = test(1) + (d - 1);
        i2 = i1 + lgthtest - 1;
        rr = corrcoef(x(test),y(i1:i2));
        tempcorrPearson(d) = rr(1,2); %tempcorrPearson(1) = delay 0
        clear i1 i2 rr;
    end
end

waitbar(1,hwait,sprintf('%3.0f%%',100)); %update waitbar
delete(hwait); %delete waitbar

switch roption
    case 'positive'
        [corrTestPearson,ii]  = max(tempcorrPearson);
        if flagStattool, [corrTestSpearman,jj] = max(tempcorrSpearman); end
    case 'negative'
        [corrTestPearson,ii]  = min(tempcorrPearson);
        if flagStattool, [corrTestSpearman,jj] = min(tempcorrSpearman); end
    case 'absolute'
        [corrTestPearson,ii]  = max(abs(tempcorrPearson));
        if flagStattool, [corrTestSpearman,jj] = max(abs(tempcorrSpearman)); end
end

dPearson  = ii - 1;
if flagStattool, dSpearman = jj - 1; end

clear tempcorrPearson tempcorrSpearman i1 i2 ii jj;


%% Compute slope and y-intercept between test_x and y at optimal response

%======= Use delay from PEARSON correlation ============================
%Select data in test region with delay for y
xx = x(test);
i1 = test(1)+dPearson;
i2 = i1 + lgthtest - 1;
yy = y(i1:i2);

%Exclude data close to zero (5% of the range)
th = min(xx) + 0.05*range(xx);
ii = xx>th;

%Polyfit: p(1) = slope, p(2) = intercept
p0Pearson = polyfit(xx,yy,1); %use all points
pxPearson = polyfit(xx(ii),yy(ii),1); %exclude data close to zero

%Compute goodness of fit (using correlation coefficient calculation)
[rf0Pearson,pf0Pearson] = corrcoef(xx,yy);
[rfxPearson,pfxPearson] = corrcoef(xx(ii),yy(ii));

clear xx i1 i2 yy th ii rf0 rfx;


%======= Use delay from SPEARMAN correlation ============================
if flagStattool

%Select data in test region with delay for y
xx = x(test);
i1 = test(1)+dSpearman;
i2 = i1 + lgthtest - 1;
yy = y(i1:i2);

%Exclude data close to zero (5% of the range)
th = min(xx) + 0.05*range(xx);
ii = xx>th;

%Polyfit: p(1) = slope, p(2) = intercept
p0Spearman = polyfit(xx,yy,1); %use all points
pxSpearman = polyfit(xx(ii),yy(ii),1); %exclude data close to zero

%Compute goodness of fit (using correlation coefficient calculation)
[rf0Spearman,pf0Spearman] = corrcoef(xx,yy);
[rfxSpearman,pfxSpearman] = corrcoef(xx(ii),yy(ii));

clear xx i1 i2 yy th ii rf0 rfx;

end


%% Construct cumulative distribution function (CDF) from correlations in base regions

corrBasePearson_sort  = sort(corrBasePearson);
if flagStattool, corrBaseSpearman_sort = sort(corrBaseSpearman); end

%Construct CDF
if flagStattool
    rr = (-1:1e-4:1)'; %correlation vector for CDF
    
    %Fit kernel density estimator to the CDF (requires statistics toolbox).
    %Then evaluate CDF at corrTest
    ecdfBasePearson  = ksdensity(corrBasePearson_sort,  rr,'function','cdf');
    ecdfBaseSpearman = ksdensity(corrBaseSpearman_sort, rr,'function','cdf');

    switch roption
        case {'positive','absolute'}
            cdfTestPearson  = ecdfBasePearson(find(rr<=corrTestPearson,1,'last'));
            cdfTestSpearman = ecdfBaseSpearman(find(rr<=corrTestSpearman,1,'last'));
        case 'negative'
            cdfTestPearson  = ecdfBasePearson(find(rr>=corrTestPearson,1,'first'));
            cdfTestSpearman = ecdfBaseSpearman(find(rr>=corrTestSpearman,1,'first'));
    end

else
    rr = corrBasePearson_sort; %correlation vector for CDF
    
    %Construct CDF from available corrBase:
    %min(corrBase) --> CDF = 0
    %max(corrBase) --> CDF = 1
    ecdfBasePearson = linspace(0,1,nshift)';

    %If corrTest is outside of corrBase range, we can conclude that p < 1/N
    if corrTestPearson > corrBasePearson_sort(end-1)
        cdfTestPearson = 1 - 1/nshift;
    elseif corrTestPearson < corrBasePearson_sort(2)
        cdfTestPearson = 1/nshift;
    else
        %Determind CDF at corrTest by interpolation
        ind = find(corrBasePearson_sort<corrTestPearson,1,'last');
        rlo = corrBasePearson_sort(ind);    clo = ecdfBasePearson(ind);
        rhi = corrBasePearson_sort(ind+1);  chi = ecdfBasePearson(ind+1);
        m = (chi - clo)/(rhi - rlo);
        cdfTestPearson = clo + m*(corrTestPearson - clo);
    end

end

%Compute p-value
switch testtype
    case 'one-tailed' %check only 1 end of CDF, depends on the sign of r
        switch roption
            case {'positive','absolute'}
                pPearson = 1 - cdfTestPearson;
                if flagStattool, pSpearman = 1 - cdfTestSpearman; end
            case 'negative'
                pPearson = cdfTestPearson;
                if flagStattool, pSpearman = cdfTestSpearman; end
        end
        
    case 'two-tailed' %check both ends of CDF
        if cdfTestPearson > 0.5
            pPearson = 2*(1 - cdfTestPearson);
        else
            pPearson = 2*cdfTestPearson;
        end
        
        if flagStattool
            if cdfTestSpearman > 0.5
                pSpearman = 2*(1 - cdfTestSpearman);
            else
                pSpearman = 2*cdfTestSpearman;
            end
        end
end

%Outputs
pearson.r        = corrTestPearson;
pearson.p        = pPearson;
pearson.d        = dPearson;
pearson.N        = nshift;
pearson.roption  = roption;
pearson.testtype = testtype;
pearson.basecdf  = [rr,ecdfBasePearson(:)];
pearson.slope       = p0Pearson(1);
pearson.yint        = p0Pearson(2);
pearson.slopefitr2  = rf0Pearson(1,2)^2;
pearson.slopex      = pxPearson(1);
pearson.yintx       = pxPearson(2);
pearson.slopefitxr2 = rfxPearson(1,2)^2;

if flagStattool
    spearman.r        = corrTestSpearman;
    spearman.p        = pSpearman;
    spearman.d        = dSpearman;
    spearman.N        = nshift;
    spearman.roption  = roption;
    spearman.testtype = testtype;
    spearman.basecdf  = [rr,ecdfBaseSpearman(:)];
    spearman.slope       = p0Spearman(1);
    spearman.yint        = p0Spearman(2);
    spearman.slopefitr2  = rf0Spearman(1,2)^2;
    spearman.slopex      = pxSpearman(1);
    spearman.yintx       = pxSpearman(2);
    spearman.slopefitxr2 = rfxSpearman(1,2)^2;
else
    spearman = [];
end





function [x,y,ndelay,base,test,roption,testtype] = checkInputs(varargin)

%Check number of input arguments
varargin = varargin{1,1};
nargin = length(varargin);
minargs = 5;
maxargs = 7;
if nargin<minargs
    error('Not enough input arguments.');
end
if nargin>maxargs
    error('Too many input arguments.');
end

x      = varargin{1};
y      = varargin{2};
ndelay = varargin{3};
base   = varargin{4};
test   = varargin{5};

%Check roption and testtype
roption  = 'positive';    %default
testtype = 'one-tailed';  %default
switch nargin
    case 6
        if any(strcmpi(varargin{6},{'positive','negative','absolute'}))
            roption = lower(varargin{6});
        elseif any(strcmpi(varargin{7},{'one-tailed','two-tailed'}))
            testtype = lower(varargin{7});
        else
            error('Invalid input argument(s).');
        end
        
    case 7
        if any(strcmpi(varargin{6},{'positive','negative','absolute'}))
            roption = lower(varargin{6});
        else
            error('Invalid input argument(s).');
        end
        if any(strcmpi(varargin{7},{'one-tailed','two-tailed'}))
            testtype = lower(varargin{7});
        else
            error('Invalid input argument(s).');
        end
end %end switch

% % %Check no. of shifts (N)
% % Nmin = 100; %minimum N required to get good CDF
% % if ((range(base)+1) - (range(test)+1) - ndelay + 1) < Nmin
% %     error('Number of shifts (N) is too small. Consider lengthen baseline or shorten ndelay.');
% % end

%Check ndelay
if rem(ndelay,1) || ndelay<=0
    error('ndelay must be a real positive integer.');
end
if (ndelay + max(base))>length(y)
    error('ndelay is too large for the selected base range.');
end
if (ndelay + max(test))>length(y)
    error('ndelay is too large for the selected test range.');
end

%Check base and test ranges
if length(base)~=2 || base(1)>base(2)
    error('Invalid base range.');
end
if length(test)~=2 || test(1)>test(2)
    error('Invalid test range.');
end
if rem(base(1),1) || rem(base(2),1)
    error('base range must be real positive integers [from,to].');
end
if rem(test(1),1) || rem(test(2),1)
    error('base range must be real positive integers [from,to].');
end
if max(base)>length(x)
    error('base range exceeds length of x.');
end
try
    if max(base)>length(y) || max(test)>length(y)
        error('base and/or test range(s) exceeds length of y.');
    end
catch
    disp('Toey');
end
if range(test)>range(base)
    error('test duration must be shorter than base duration.');
end