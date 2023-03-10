function out = TIVPSD_inputadj(y,x,Sx0,fs,varargin)
% TOEY 29-04-2019
% TIVPSD_inputadj returns stationary one-sided power spectral density 
% (i.e. from freq = 0 to fs/2), which already accounts for the negative 
% frequencies. Use ARX model to separate y into input-correlated (yc) and
% input-uncorrelated (yu) parts: y = yc + yu. For more details, see:
% - Khoo et al., Sleep. 1999 Jun 15;22(4):443-51.
% - Sangkatumvong et al., Physiol Meas. 2008 May;29(5):655-68.
%
% Syntax:
% out = TIVPSD_inputadj(y,x,Sx0,fs,'method','arx','df',df,'detrendorder',detrendorder);

% Inputs:
% y = output signal of ARX model
% x = input signal of ARX model (e.g. baseline respiration)
% Sx0 = one-sided PSD of x that you want to adjust the input-correlated PSD to
%       e.g. if want to adjust for respiration, let Sx0 = PSD of (uniform
%            and spontaneous) respiration.
%       Note: Sx0 must have the same vector size and frequency resolution 
%             as Syu and Syc (computed in this function).
% fs = sampling frequency of y [Hz]
% 'method' 
%       - 'arxprewhite'  = use ARX model with prewhitening
%       - 'arx'         = use ARX model
% 
% 'df' = frequency resolution (eg. 0.001, 0.0001)
% 'detrendorder' = 5 (default)
%
% Outputs:
% Sya  = adjusted one-sided PSD, accounted for -ve frequencies
% Syu  = input-UNcorrelated one-sided PSD
% Syc  = input-Correlated one-sided PSD
% model = struct containing information of the ARX model
%   model.a      = coefficients of y terms
%   model.b      = coefficients of x terms
%   model.ypred  = predicted output
%   model.errvar = variance of residuals
%   model.Se     = one-sided PSD of residuals (if method = 'arxprewhite')




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
    df = 0.001;         % Frequency resolution on the PSD
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
sample_lf = (f > 0.04) & (f < 0.15); %low-frequency range [Hz]
sample_hf = (f > 0.15) & (f < 0.4);  %high-frequency range [Hz]
lgth = length(y);

%Maximum ARX model orders
na_max = 20;
nb_max = 20;

clear optinputs;


%% Prepare signals

%Remove 5th-order polynomial from signals
%Note: 'detrendPoly' function is called within this 'TIVPSD' function
y = detrendPoly(y,detrendorder);
x = detrendPoly(x,detrendorder);

%Column vectors
y = y(:);
x = x(:);
Sx0 = Sx0(:);


%% Determine optimal ARX model order and coefficients

if isempty(na) || isempty(nb) %choose optimal ARX model orders

    %Estimate ARX models starting from order = 1 to max order
    %Note: 'arx_myfunc' function is called within this 'TIVPSD_inputadj' function
    yxv = zeros(na_max*nb_max,3); %col1 = na, col2 = nb, col3 = variance of residuals
    ii = 0; %row for J matrix

    for nna=1:na_max
    for nnb=1:nb_max
        ii = ii + 1;
        ypred = arx_myfunc(y,x,nna,nnb);
        yxv(ii,:) = [nna, nnb, var(y - ypred)];
        clear ypred;
    end %end for nnb
    end %end for nna

    %Select optimal model: MDL or AIC
    % MDL = log(NMSE) + (na + nb)*log(lgth)/lgth
    % --> MDL = log(yxv(:,3)./var(y)) + (yxv(:,1) + yxv(:,2))*log(lgth)/lgth;
    % AIC = 2*(no. of coefficients to be estimated) + (signal length)*log(residual variance)
    % --> AIC = 2*(yxv(:,1) + yxv(:,2)) + lgth*log(yxv(:,3));
    MDL = log(yxv(:,3)./var(y)) + (yxv(:,1) + yxv(:,2))*log(lgth)/lgth;
    [jk,ind] = min(MDL); %find ARX model orders that minimizes MDL or AIC
    na = yxv(ind,1);
    nb = yxv(ind,2);

end %end if isempty(na or nb)

%Determine ARX coefficients and predicted output
[ypred,a,b] = arx_myfunc(y,x,na,nb);
errvar = var(y - ypred); %variance of residuals

%Collect estimated ARX model
model.a = a;
model.b = b;
model.ypred = ypred;
model.errvar = errvar;



%% Compute one-sided stationary PSD

%PSD of residuals, one-sided (already acct for -ve freq)
switch method
    case 'arxprewhite'
        
        %Use FFT method
        e = y - model.ypred;
        nfft = length(f)*2;
        dft = fft(e,nfft);
        dft = dft(1:nfft/2);
        Se = (1/(fs*lgth)).*abs(dft).^2;
        Se(2:end-1) = 2*Se(2:end-1); %times 2 to acct for -ve freq. (exclude DC power, freq=0)
        model.Se = Se(:); %one-sided PSD of residuals
        clear e nfft dft;
            
	case 'arx'

        %Assumes that residuals is white i.e. has flat PSD such that
        %Se can be approximated by errvar*2*T (for one-sided PSD).
        Se = errvar*T;
        Se(2:end) = 2*Se(2:end); %times 2 to acct for -ve freq. (exclude DC power, freq=0)
        
end %end switch method

%PSD of input-UNcorrelated part (Syu)        
    %'Transfer function' between y and residuals (e)
    He = freqz(1,a,f,fs);
    Hemag = abs(He); %get magnitude

    %PSD of yu (Syu)
    Syu = (Hemag.^2).*Se; %since Se already accounted for -ve freq, Syu is thus also one-sided.
    Syu = Syu(:); %column vector
    
%PSD of input-Correlated part (Syc)
    %Transfer function between y and x
    Hx = freqz(b,a,f,fs);
    Hxmag = abs(Hx); %get magnitude

    %PSD of yc (Syc) adjusted to Sx0; Sx0 is one-sided PSD (one of the input arguments)
    Syc = (Hxmag.^2).*Sx0; %since Sx0 already accounted for -ve freq, Syc is thus also one-sided.
    Syc = Syc(:); %column vector
        
%Input-ADJUSTED PSD
Sya = Syu + Syc;

%Scale total power of Sya to signal variance
K = var(y)/trapz(f,Sya); %scaling factor: equate total power to signal variance
Syu = K*Syu;
Syc = K*Syc;
Sya = K*Sya;


%% Prepare outputs

%Change output to its original vector form
if flagRowvector
    Sya = Sya(:)';
    Syu = Syu(:)';
    Syc = Syc(:)';
    if strcmp(method,'arxprewhite')
        model.Se = Se(:)';
    end
end


out.Sya = Sya;
out.Syc = Syc;
out.Syu = Syu;

out.model = model;
out.f = f;










function out = chkInputarg(optinputs)

narg = size(optinputs,2); %number of optional input aruguments
df = [];
detrendorder = [];
na = [];
nb = [];

%Check optional input arguments
if narg==0 %no optional inputs --> use default method
    method = 'arxprewhite'; %default method
    na = []; %choose optimal ARX model orders
    nb = [];
    
elseif narg>0 && ~rem(narg,2) 
    
    for i=1:2:narg-1
        inputField = optinputs{i};
        inputElement = optinputs{i+1};
        switch inputField
            case 'method'
                if strcmpi(inputElement,'arprewhite') || strcmpi(inputElement,'arx') 
                    method = inputElement;
                else
                    error('Invalid PSD method.');
                end
            case 'order'
                if (floor(inputElement) == inputElement) && (strcmpi(method,'arprewhite') || strcmpi(method,'ar'))
                    na = inputElement(1);
                    nb = inputElement(2);
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
    error('Too many input arguments.');

end %end if narg==0

out.method = method;
out.na = na; %ARX order
out.nb = nb; %ARX order
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
    


function [ypred,a,b] = arx_myfunc(y,u,na,nb)

lgth = length(y);

flagRowvector = 0;
if size(y,1)<size(y,2)
    flagRowvector = 1;
    y = y(:); %transpose y to a column vector
end

%A matrix: output part
A = zeros(lgth, na+nb+1);
for n=1:na
    A(n+1:lgth,n) = -y(1:lgth-n);
end

%A matrix: input part
A(:,na+1) = u(1:lgth);
ncol = na + 1;
for n=1:nb
    A(n+1:lgth,ncol+n) = u(1:lgth-n);
end

par = ((A'*A)\A')*y; %estimated model parameters
a = par(1:na);
b = par(na+1:end);

a = [1, a(:)']; %append 1 to a for a0 term
b = b(:)';      %b already starts from b0

ypred = A*par; %predicted output

%Change output to its original vector form
if flagRowvector
    ypred = ypred(:)'; %transpose ypred to a row vector
end