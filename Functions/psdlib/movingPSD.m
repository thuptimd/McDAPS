function [LFP,HFP,varargout] = movingPSD(y,fs,windowsize,obj,varargin)

% movingPSD returns power spectral density computed using the specified
% method (FFT (default), AR, respiratory-adjusted AR, and prewhitened AR)
% at each time point as the window slides through the signal.
%
% Inputs:
% y  = signal for PSD calculation
% fs = sampling frequency of y [Hz]
% windowsize = size of the moving window [sec]
%
% Optional inputs:
% method  = method of computing PSD
%   'fft' = fast Fourier transform
%
%   'ar' = Autoregressive model: get the best model order from fitting the 
%       whole y to an AR model then apply the determined model order on
%   	every segment of y as the window slides through the whole signal.
%
%   'arfixed' = Autoregressive model: apply the specified model order on 
%       every segment of y as the window slides through the whole signal.
%
%   'arx' = Autoregressive model with exogenous input. This method returns
%       the PSD adjusted to the specified PSD. The best model order is
%       obtained from fitting y and u (exogenous input) to an ARX model.
%       The determined model order is then applied on every segment of y as
%   	the window slides through the whole signal.
%
%   'whitenfft' = a mixture of FFT and AR methods without applying a
%       windowing technique on the residuals. The AR model order is
%       specified.
%
%   'whitenfftwindow' = a mixture of FFT and AR methods, apply a windowing
%       technique on the residuals. The AR model order is specified.
%
% na = AR model order (only applicable for 'arfixed','whitenfft' and 
%       'whitenfftwindow' methods)
%
% u = exogenous input, is synchronous in time with y (only applicable to
%       the 'arx' method)
%
% Su0 = PSD of the exogenous input where the computed PSD is to be adjusted
%       to (only applicable to the 'arx' method).
%       NOTE: Make sure that Sresp0 is computed from a respiratory signal 
%             that is sampled at the SAME sampling frequency as y AND the 
%             frequency resolution (df) of both Su0 & Sy must be EQUAL.
%
% Outputs:
% LFP = low-frequency (0.04-0.15 Hz) power at each time point**
% HFP = high-frequency (0.15-0.4 Hz) power at each time point**
% ** Note: LFP and HFP are centered in the middle of each moving window
%      segment e.g. if windowsize = 10, the first LFP and HFP are computed
%      from the first 10*fs samples in y and will be stored at 
%      the ceil(10*fs/2) element of the output vectors of LFP and HFP.
%      Therefore, the elements before that will be equal to zero.
%      Similarly, half the window size at the end of LFP and HFP output
%      vectors will be equal to zero.
%
% Optional output:
% Sy = power spectral density at each time point
%
% Examples:
% Note: exclude Sy from output arguments if do NOT need to output it.
%
% 1. Compute PSD using 'fft' method:
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize) OR
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize,'fft')
%
% 2. Compute PSD using 'ar' method:
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize,'ar')
%
% 3. Compute PSD using 'arfixed' method:
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize,'arfixed',na)
%
% 4. Compute PSD using 'arx' method:
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize,'arx',u,Su0)
%
% 5. Compute PSD using 'whitenfft' method:
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize,'whitenfft',na)
%
% 6. Compute PSD using 'whitenfftwindow' method:
%    [LFP,HFP,Sy] = movingPSD(y,fs,windowsize,'whitenfftwindow',na)

T = 1/fs;        %sampling interval [sec]
df = 0.001;      %frequency spacing [Hz]
detrendorder = 5;
f = (0:df:fs/2)'; %frequency vector for positive freqs [Hz]
nfft = 2*length(f);
sample_lf = (f > 0.04) & (f < 0.15); %low-frequency range [Hz]
sample_hf = (f > 0.15) & (f < 0.4);  %high-frequency range [Hz]

lgth = length(y);
seglgth = round(fs*windowsize); %segment length [no. of samples]
nseg = length(y) - seglgth + 1;

flagRowvector = 0;
if size(y,1)<size(y,2)    
    flagRowvector = 1;
    
    %Transpose data to column vectors
    y = y(:);
end

%% Check input and output arguments
%===== Input arguments ===================================================

nargin = size(varargin,2);

if nargin==0
    method = 'fft';
    
elseif nargin==1
    
    methodlist = {'fft','ar','whitenfft'};
    tf = strcmpi(varargin{1},methodlist);
    if any(tf)
        method = lower(methodlist{tf});
    else
        error('Invalid input arguments.');
    end
    
elseif nargin==2
    
    methodlist = {'arfixed','whitenfftwindow'};
    tf = strcmpi(varargin{1},methodlist);
    if any(tf)
        method = lower(methodlist{tf});
        if ~ischar(varargin{2}) && varargin{2}>0
            na = varargin{2};
        else
            error('Invalid input arguments.');
        end
    else
        error('Invalid input arguments.');
    end
    
elseif nargin==3
    
    if strcmpi(varargin{1},'resp-adjusted')
        method = lower(varargin{1});
        if ~ischar(varargin{2}) && length(varargin{2})>0
            u = varargin{2};
            if ~ischar(varargin{3}) && length(varargin{3})>0
                Su0 = varargin{3};
                
                if flagRowvector
                    %Transpose data to column vectors
                    u   = u(:);
                    Su0 = Su0(:);
                end
            else
                error('Invalid input arguments.');
            end
        else
            error('Invalid input arguments.');
        end
    else
        error('Invalid input arguments.');
    end
    
end

%===== Output arguments ==================================================

LFP = zeros(nseg,1);
HFP = zeros(nseg,1);
flagSy = false; %default flag for computing Sy
if nargout==3
    flagSy = true; %set flaySy to true if no. of output argument = 3
    Sy  = zeros(length(f),nseg);
elseif nargout>3
    error('Too many output arguments.');
end

%% Compute Moving Window PSD
drawnow
set(obj,'BackgroundColor',[1 1 1],'ForegroundColor',[1 0.4 0],'Enable','inactive');


%hwaitbar = waitbar(0,'1','Name',['Computing PSD using ''',method,''' ...']); %initialize waitbar

switch method
    
case 'fft'
    
    for n=1:nseg

    %Detrend current y segment
    yc = detrendPoly(y(n:n+seglgth-1),5);

    %PSD
    ydft = fft(yc,nfft);
    ydft = ydft(1:nfft/2);
    py = (1/(fs*seglgth)).*abs(ydft).^2;
    py(2:end-1) = 2*py(2:end-1);

    %Extract LFP and HFP
    LFP(n) = trapz(f(sample_lf),py(sample_lf));
    HFP(n) = trapz(f(sample_hf),py(sample_hf));    
    if flagSy
        Sy(:,n) = py';
    end

    clear yc ydft py;
    drawnow
    set(obj,'String',[upper(method),' :Processing......',num2str(round((100*n)/nseg)),'%']);


    end %end for n

case 'ar'
    
    %Get the model order by fitting the whole signal to a TIV AR model
    out = TIVPSD(y,fs,'method','ar','df',df,'detrendorder',detrendorder);   
    model = out.model;

    na = length(model.a) - 1;
    clear junk model;
    
    for n=1:nseg

        %Current y segment
        yc = y(n:n+seglgth-1);
        
        %PSD, LFP, HFP
        out = TIVPSD(yc,fs,'method','ar','order',na,'df',df,'detrendorder',detrendorder);  
        SS = out.Sy;

        LFP(n) = trapz(f(sample_lf),SS(sample_lf));
        HFP(n) = trapz(f(sample_hf),SS(sample_hf));  
        if flagSy
            Sy(:,n) = SS;
        end
        
        clear yc junk SS;
        %waitbar(n/nseg,hwaitbar,sprintf('%12.0f %%',n/nseg*100)); %update waitbar
        drawnow
        set(obj,'String',[upper(method),' :Processing......',num2str(round((100*n)/nseg)),'%']);


    end %end for n
    
case 'arfixed'
    
    for n=1:nseg

        %Current y segment
        yc = y(n:n+seglgth-1);
        
        %PSD, LFP, HFP
         out = TIVPSD(yc,fs,'method','ar','order',na,'df',df,'detrendorder',detrendorder);  
         SS = out.Sy;

        if flagSy
            Sy(:,n) = SS;
        end
        
        clear yc junk SS;
        %waitbar(n/nseg,hwaitbar,sprintf('%12.0f %%',n/nseg*100)); %update waitbar
        drawnow
        set(obj,'String',[upper(method),' :Processing......',num2str(round((100*n)/nseg)),'%']);


    end %end for n
    
case 'resp-adjusted'

    %Get the model order by fitting the whole signal to a TIV resp-adjusted ARX model
    out = TIVPSD_inputadj(y,u,Su0,fs,'method','arx','df',df,'detrendorder',detrendorder);
    model = out.model;
    na = length(model.a) - 1;
    nb = length(model.b);
    clear junk model;
    
    for n=1:nseg

        %Current y and u segments
        yc = y(n:n+seglgth-1);
        uc = u(n:n+seglgth-1);
               
        
        %Respiratory-adjusted PSD
        out = TIVPSD_inputadj(yc,uc,Su0,fs,'method','arx','df',df,'detrendorder',detrendorder);
        SS = out.Sya;
        LFP(n) = trapz(f(sample_lf),SS(sample_lf));
        HFP(n) = trapz(f(sample_hf),SS(sample_hf));  
        if flagSy
            Sy(:,n) = SS;
        end
        
        clear yc uc junk;
        %waitbar(n/nseg,hwaitbar,sprintf('%12.0f %%',n/nseg*100)); %update waitbar
        drawnow
        set(obj,'String',[upper(method),' :Processing......',num2str(round((100*n)/nseg)),'%'],'ForegroundColor',[1 0 0]);


    end %end for n

case 'whitenfft'
    %% Need to validate the method 14June2019
    
    out = TIVPSD(y,fs,'method','ar','df',df,'detrendorder',detrendorder);   
    model = out.model;

    na = length(model.a) - 1;
    
    for n=1:nseg
        
        %Detrend current y segment
        yc = detrendPoly(y(n:n+seglgth-1),detrendorder);
        
        %AR PSD
        out = TIVPSD(yc,fs,'method','ar','order',na,'df',df,'detrendorder',detrendorder);
        model = out.model;
        
        S = out.Sy;

        
        
        %Denominator of AR PSD
        S(2:end) = S(2:end)/2;
        den = (model.errvar*T)./S;
        
        %PSD of residuals using FFT (no window)
        e = yc - model.ypred;
        edft = fft(e,nfft);
        edft = edft(1:nfft/2);
        pe = (1/(fs*seglgth)).*abs(edft).^2;
        pe(2:end) = 2*pe(2:end);
        
        %Whiten AR PSD using residual PSD
        py        = (pe*T)./den;
        py(2:end) = 2*py(2:end);
        
        %Extract LFP and HFP
        LFP(n) = trapz(f(sample_lf),py(sample_lf));
        HFP(n) = trapz(f(sample_hf),py(sample_hf));
        if flagSy
            Sy(:,n) = py';
        end
        
        clear yc junk S model den e edft pe py;
        %waitbar(n/nseg,hwaitbar,sprintf('%12.0f %%',n/nseg*100)); %update waitbar
        drawnow
        set(obj,'String',[upper(method),' :Processing......',num2str(round((100*n)/nseg)),'%']);

        

    end %end for n
    
case 'whitenfftwindow'
    
    k = (-4:1:4)';
    M = 16;
    N = seglgth;
    WIN = 4*pi^2*4*(1 + cos(2*pi*M*k/N))./(M^2*(2*pi*k/N).^2 - pi^2);
    
    for n=1:nseg

    %Detrend current y segment
    yc = detrendPoly(y(n:n+seglgth-1),5);

    %AR PSD
    out = TIVPSD(yc,fs,'method','ar','order',na,'df',df,'detrendorder',detrendorder);  
    model = out.model;

    %Denominator of AR PSD
    S(2:end) = S(2:end)/2;
    den = (model.errvar*T)./S;

    %PSD of residuals using FFT with Blackman window
    e = yc - model.ypred;
    edft = fft(e,nfft);
    edft = edft(1:nfft/2);
    edftwin = filter(WIN,1,edft); %convolve window with FFT(e)
    pe = (1/(fs*seglgth)).*abs(edftwin).^2;
    pe(2:end) = 2*pe(2:end);
    totpower = trapz(f,pe);
    pe = (model.errvar/totpower)*pe; %scale PSD to variance

    %Whiten AR PSD using residual PSD
    py        = (pe*T)./den;
    py(2:end) = 2*py(2:end);

    %Extract LFP and HFP
    LFP(n) = trapz(f(sample_lf),py(sample_lf));
    HFP(n) = trapz(f(sample_hf),py(sample_hf));
    if flagSy
        Sy(:,n) = py';
    end

    clear yc junk S model den e edft edftwin pe totpower py;
    %waitbar(n/nseg,hwaitbar,sprintf('%12.0f %%',n/nseg*100)); %update waitbar
    drawnow
    set(obj,'String',[upper(method),' :Processing......',num2str(round((100*n)/nseg)),'%'],'ForegroundColor',[1 0 0]);


    end %end for n
        
end %end switch

%delete(hwaitbar);
set(obj,'BackgroundColor',[1 1 1],'ForegroundColor',[0 0 0]);

%% Prepare outputs

%Center each LFP, HFP (and Sy) in the middle of each time window
nshift = ceil(windowsize*fs/2);
temp = zeros(lgth,1);
temp(nshift:nshift+nseg-1) = LFP;
LFP = temp;
clear temp;
temp = zeros(lgth,1);
temp(nshift:nshift+nseg-1) = HFP;
HFP = temp;
clear temp;
if flagSy
    temp = zeros(length(f),lgth);
    temp(:,nshift:nshift+nseg-1) = Sy;
    Sy = temp;
    clear temp;
    varargout{1} = Sy;
end

%Change output to its original vector form
if flagRowvector
    %Transpose to row vectors
    LFP = LFP(:)';
    HFP = HFP(:)';
end