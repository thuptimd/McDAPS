function out = TIVPSD(y,fs,varargin)
% TIVPSD returns stationary one-sided power spectral density (i.e. from
%        freq = 0 to fs/2), which already accounts for the negative frequencies.
% Syntax:
% out = TIVPSD(y,fs);
% out = TIVPSD(y,fs,'method','welch');
% out = TIVPSD(y,fs,'method','welch','df',0.001,'detrendorder',5)


% Inputs:
% y = signal for PSD calculation
% fs = sampling frequency of y [Hz]
 
% Optional inputs (specified in pair):
% Pair 1: 'method'
%  	'arprewhite' = use AR model with prewhitening (default)
%  	'ar'         = use AR model with maximum model order of 20 allowed
%  	'fft'        = FFT method
%  	'welch'      = Welch method (Matlab function) with hanning window =
%                  300sec
% Pair 2: 'df' - frequency resolution e.g. 0.001, 0.0001
% Pair 3: 'detrendorder' - polynomial order, default is 5
%
% Output
% out = struct containing info below
% Sy  = one-sided PSD, accounted for -ve frequencies
% f   = frequency vector for PSD
% model = struct containing information of the AR model
%       model.a      = AR model parameters
%       model.ypred  = predicted output
%       model.errvar = variance of residuals
%       model.Se     = one-sided PSD of residuals (if method = 'arprewhite')


flagRowvector = 0;
if size(y,1)<size(y,2)    
    flagRowvector = 1;
end

%Check optional input arguments
optinputs = varargin;
inputarg = chkInputarg(optinputs);
method = inputarg.method;
na = inputarg.na;
if isempty(inputarg.df)
    df = 0.001;             %%frequency spacing [Hz]
else
    df = inputarg.df;   
end

if isempty(inputarg.detrendorder)   
   detrendorder = 5; 
else
   detrendorder = inputarg.detrendorder; 
end
    

T = 1/fs;        %sampling interval [sec]
f = (0:df:fs/2)'; %frequency vector for positive freqs [Hz]
% sample_lf = (f > 0.04) & (f < 0.15); %low-frequency range [Hz]
% sample_hf = (f > 0.15) & (f < 0.4);  %high-frequency range [Hz]
lgth = length(y);

na_max = 20;     %maximum allowed AR model order

clear optinputs;


%% Prepare signal

%Remove 5th-order polynomial from signal
%Note: 'detrendPoly' function is called within this 'TIVPSD' function
y = detrendPoly(y,detrendorder);

%Column vectors
y = y(:);


%% Determine optimal AR model order and AR coefficients (as applicable)
%Specified method = 'arprewhite' or 'ar'
%Use 'lpc' Matlab function (linear prediction filter coefficients) to 
%estimate AR coefficients.

if any(strcmp({'arprewhite','ar'},method)) 
    if isempty(na) %choose optimal AR model order
    
        %Estimate AR models starting from order = 1 to na_max
        AIC = zeros(na_max,1); %initialize AIC values
        for nna=1:na_max
            a = lpc(y,nna);
            ypred = filter([0 -a(2:end)],1,y); %predicted output
            AIC(nna) = 2*(nna) + lgth*log(var(y - ypred));
            clear a ypred;
        end

        %Optimal AR model
        [AICmin,na] = min(AIC); %find AR model order that minimizes AIC
        
    end %end if isempty(na)
        
    %Determine AR coefficients and predicted output
    a = lpc(y,na); %a = model coefficients
    ypred = filter([0 -a(2:end)],1,y); %predicted output
    errvar = var(y - ypred); %variance of residuals
    
    %Collect estimated AR model
    model.a = a;
    model.ypred = ypred;
    model.errvar = errvar;
end


%% Compute one-sided stationary PSD
switch method
    case 'arprewhite'       
        %'Transfer function' between y and residuals (e)
        He = freqz(1,a,f,fs); %this is equal to 1/(1 + sumaz)
        Hemag = abs(He); %get magnitude

        %PSD of residuals (use FFT method)
        e = y - model.ypred;
        nfft = length(f)*2;
        dft = fft(e,nfft);
        dft = dft(1:nfft/2);
        Se = (1/(fs*lgth)).*abs(dft).^2;
        Se(2:end-1) = 2*Se(2:end-1); %times 2 to acct for -ve freq. (exclude DC power, freq=0)
        model.Se = Se; %one-sided PSD of residuals
        clear e nfft dft;
          
        %PSD of y with prewhitening
        Sy = (Hemag.^2).*Se; %since Se already accounted for -ve freq, Sy is thus also one-sided.
        Sy = Sy(:); %column vector
        
        %Scale total power to signal variance
        K = var(y)/trapz(f,Sy); %scaling factor: equate total power to signal variance
        Sy = K*Sy; %scale PSD to signal variance


    case 'ar'
               
        %'Transfer function' between y and residuals (e)
        He = freqz(1,a,f,fs); %this is equal to 1/(1 + sumaz)
        Hemag = abs(He); %get magnitude
        
        %PSD of residuals
        %Assumes that residuals is white i.e. has flat PSD such that
        %Se can be approximated by errvar*2*T (for one-sided PSD).
        Se = errvar*T;
        Se(2:end) = 2*Se(2:end); %times 2 to acct for -ve freq. (exclude DC power, freq=0)
          
        %PSD of y
        Sy = (Hemag.^2).*Se; %since Se already accounted for -ve freq, Sy is thus also one-sided.
        Sy = Sy(:); %column vector
        
        %Scale total power to signal variance
        K = var(y)/trapz(f,Sy); %scaling factor: equate total power to signal variance
        Sy = K*Sy; %scale PSD to signal variance
        
        
    case 'fft'
        %Note: total power is NOT scaled to signal variance       
        nfft = 2^nextpow2(lgth);
        dft = fft(y,nfft);
        dft = dft(1:nfft/2);
        Sy = (1/(fs*lgth)).*abs(dft).^2;
        Sy(2:end-1) = 2*Sy(2:end-1); %times 2 to acct for -ve freq. (exclude DC power, freq=0)
        Sy = Sy(:); %colume vector
        
              
    case 'welch'
        %Use 'pwelch' Matlab function
        if length(y)<(300*fs) 
            [Sy,~] = pwelch(y,length(y),[],f,fs);
        else
            [Sy,~] = pwelch(y,300*fs,[],f,fs); %Use hanning window = 300sec
        end
        Sy = 2*Sy; %Scale to make total power = variance
        
    
end %end switch method



%% Prepare outputs
%Change output to its original vector form
if flagRowvector
    Sy = Sy(:)';
    f  = f(:)';
    if strcmp(method,'arprewhite')
        model.Se = Se(:)';
    end
end

%If method = 'arprewhite' or 'ar' --> last output argument = model
%If method = 'fft' or 'welch'     --> last output argument = f
if any(strcmp({'arprewhite','ar'},method))
    out.model = model;
elseif any(strcmp({'fft','welch'},method))
    out.model = [];
end
out.f = f;
out.df = df;
out.detrendorder = detrendorder;
out.Sy = Sy;










function out = chkInputarg(optinputs)

narg = size(optinputs,2); %number of optional input aruguments
df = [];
detrendorder = [];
na = [];

%Check optional input arguments
if narg==0 %no optional inputs --> use default method
    method = 'arprewhite'; %default method

    
elseif narg>0 && ~rem(narg,2) %optional inputs are specified in pairs
    
    for i=1:2:narg-1 %Loop input arguments
        inputField = optinputs{i};
        inputElement = optinputs{i+1};
        switch inputField
            case 'method'
                if strcmpi(inputElement,'arprewhite') || strcmpi(inputElement,'ar') || strcmpi(inputElement,'welch') 
                    method = inputElement;
                else
                    error('Invalid PSD method.');
                end
            case 'order'
                if (floor(inputElement) == inputElement) && (strcmpi(method,'arprewhite') || strcmpi(method,'ar')) 
                    na = inputElement;
                else
                    error('Invalid AR order');
                end
            case 'df'
                df = inputElement;
            case 'detrendorder'
                detrendorder = inputElement;
            otherwise
                 error('Invalid input arguments.');           
        end
    
    end

else
    error('Invalid input arguments.');

end %end if narg==0

out.method = method;
out.na = na; %AR order
out.df = df; %Frequency resolution
out.detrendorder = detrendorder; %Detrending order



function out = detrendPoly(data,n)
%Sang 5-Jun-2014: modifid from function Javier Jo's 'detrend_high2.m' function.
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


    

    