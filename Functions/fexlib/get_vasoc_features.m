function varargout = get_vasoc_features(PPGa, fs_PPGa, varargin)
% Calculate vasoconstriction features based on the input signal
% 
% Usage (Syntax):
% Mvasoc = get_vasoc_features(PPGa, fs_PPGa)
% Mvasoc = get_vasoc_features(__, Name, Value)
% [Mvasoc, Avasoc, Tvasoc, Nvasoc] = get_vasoc_features(PPGa, fs_PPGa)
% [Mvasoc, Avasoc, Tvasoc, Nvasoc] = get_vasoc_features(__, Name, Value)
% [Mvasoc, Avasoc, Tvasoc, Nvasoc, Arric, Arriu, Arrinet, Rrri, IDXexpose, IDXdosage] = get_vasoc_features(PPGa, fs_PPGa, RRI, fs_RRI)
% [Mvasoc, Avasoc, Tvasoc, Nvasoc, Arric, Arriu, Arrinet, Rrri, IDXexpose, IDXdosage] = get_vasoc_features(__, Name, Value)
% 
% Refer to the codes for default values of the hyper-parameters in the
% 'Hyper-parameters and input arguments' section.

% Toey's Note - the function is for fs = 2Hz
% Better normalize PPGa before using this function
% 12/02/20 - Fixed overlapping baseline with previous vasoconstriction bug  
% 12/02/20 - Enter debug mode to plot CVpeaks and corresponding events
DEBUGMODE = false; %Not recommended for a long segment e.g. hrs

%% Verify number of outputs/inputs
if nargout ~= 1 && nargout ~= 4 && nargout ~= 10
    error('Number of outputs is invalid.')
end

if nargout == 10 && nargin < 4
    error('RRI is needed to output 10 features.')
end

%% Hyper-parameters and input arguments

%FIR lowpass equiripple, order = 50, fs = 2 Hz
%Fpass = 0.3 Hz, Apass = 1 dB, Fstop = 0.4 Hz, Astop = 80 dB
filtnum1 = [7.06924427214942e-06,0.000979250467960226,0.00389055525764409,0.00882408645583282,0.0134900298725085,0.0138225165488970,0.00719473432777581,-0.00388046997821118,-0.0117138077937783,-0.00904913408778444,0.00338368992394387,0.0149717909077938,0.0132337222657467,-0.00352884116137712,-0.0212221955733371,-0.0205163108085362,0.00364334015176190,0.0319263541729526,0.0336598152447220,-0.00369303114652135,-0.0541397063396323,-0.0647617385746685,0.00371852099096234,0.138528936276417,0.273215826563305,0.329604322972122,0.273215826563305,0.138528936276417,0.00371852099096234,-0.0647617385746685,-0.0541397063396323,-0.00369303114652135,0.0336598152447220,0.0319263541729526,0.00364334015176190,-0.0205163108085362,-0.0212221955733371,-0.00352884116137712,0.0132337222657467,0.0149717909077938,0.00338368992394387,-0.00904913408778444,-0.0117138077937783,-0.00388046997821118,0.00719473432777581,0.0138225165488970,0.0134900298725085,0.00882408645583282,0.00389055525764409,0.000979250467960226,7.06924427214942e-06];

%FIR lowpass equiripple, order = 50, fs = 2 Hz
%Fpass = 0.15 Hz, Apass = 1 dB, Fstop = 0.25 Hz, Astop = 80 dB
filtnum2 = [-0.000338751480972588,-0.000919628374691763,-0.00185212249853268,-0.00295784958030182,-0.00384096710447554,-0.00391062017435168,-0.00253646068922243,0.000692130863957986,0.00567673168704022,0.0116040021059854,0.0169484004334208,0.0197607496282871,0.0182316822554858,0.0114036816806572,-0.000189353225232522,-0.0142066881658793,-0.0267062897720478,-0.0329255506224587,-0.0285017039399530,-0.0108208313581782,0.0199092608628117,0.0602357876071713,0.103900258184038,0.143102704858411,0.170294476276412,0.180020849907840,0.170294476276412,0.143102704858411,0.103900258184038,0.0602357876071713,0.0199092608628117,-0.0108208313581782,-0.0285017039399530,-0.0329255506224587,-0.0267062897720478,-0.0142066881658793,-0.000189353225232522,0.0114036816806572,0.0182316822554858,0.0197607496282871,0.0169484004334208,0.0116040021059854,0.00567673168704022,0.000692130863957986,-0.00253646068922243,-0.00391062017435168,-0.00384096710447554,-0.00295784958030182,-0.00185212249853268,-0.000919628374691763,-0.000338751480972588];

% hyper-parameters
fslo = 2; % Hz, sampling frequency for signal (after resampling)
fsi = 10; % Hz, sampling frequency for interpolation
cvsd = 5; % sec, window for SD calculation of CV
cvmean = 15; % sec, window for mean calculation of CV
cvstep = 2; % sec, step size for CV
cvminpeakprct = 75; % percentile to find CV peak (candidates for events)
cvminpeakdist = 10; % sec, min distance of two candidates
winsearch = 6; % sec, search window for minimum signal value
winbase = [-20, -5]; % sec, relative time (to event onset) for baseline [start, end]
winrspn = 100; % sec, response window
return_lvl = 0.005; % tolerance level for zero-crossing identification
flag_normalize = 0; % whether to normalize PPGa (in this function)
minvasocdur = 3; % sec, min vasoc duration (respiratory fluctuations)
maxvasocdur = 150; % sec, max vasoc duration (probably vasoc that don't return to baseline)
minvasocarea = 0; % min vasoc area (exclude dilation)
maxvasocarea = 100; % max vasoc area (probably vasoc that don't return to baseline)
combinemode = 'median';

% parse input arguments
p = inputParser;
addRequired(p, 'PPGa', @isnumeric);
addRequired(p, 'fs_PPGa', @isnumeric);
addOptional(p, 'RRI', [], @isnumeric);
addOptional(p, 'fs_RRI', [], @isnumeric);
addParameter(p, 'PPGa_filter', filtnum2, @isnumeric);
addParameter(p, 'RRI_filter', filtnum2, @isnumeric);
addParameter(p, 'fs', fslo, @isnumeric);
addParameter(p, 'fs_interp', fsi, @isnumeric);
addParameter(p, 'window_cvsd', cvsd, @isnumeric);
addParameter(p, 'window_cvmean', cvmean, @isnumeric);
addParameter(p, 'stepsize', cvstep, @isnumeric);
addParameter(p, 'cvminpeakprct', cvminpeakprct, @isnumeric);
addParameter(p, 'cvminpeakdist', cvminpeakdist, @isnumeric);
addParameter(p, 'window_search', winsearch, @isnumeric);
addParameter(p, 'window_baseline', winbase, @isnumeric);
addParameter(p, 'window_response', winrspn, @isnumeric);
addParameter(p, 'return_level', return_lvl, @isnumeric);
addParameter(p, 'flag_normalize', flag_normalize, @isnumeric);
addParameter(p, 'min_vasoc_dur', minvasocdur, @isnumeric);
addParameter(p, 'max_vasoc_dur', maxvasocdur, @isnumeric);
addParameter(p, 'min_vasoc_area', minvasocarea, @isnumeric);
addParameter(p, 'max_vasoc_area', maxvasocarea, @isnumeric);
addParameter(p, 'combine_mode', combinemode, ...
                @(x) any(validatestring(x, {'mean', 'median'})));
parse(p, PPGa, fs_PPGa, varargin{:});

% update hyper-parameters
RRI = p.Results.RRI;
fs_RRI = p.Results.fs_RRI;
filtnumPPGa = p.Results.PPGa_filter;
filtnumRRI = p.Results.RRI_filter;
fslo = p.Results.fs;
fsi = p.Results.fs_interp;
cvsd = p.Results.window_cvsd;
cvmean = p.Results.window_cvmean;
cvstep = p.Results.stepsize;
cvminpeakprct = p.Results.cvminpeakprct;
cvminpeakdist = p.Results.cvminpeakdist;
winsearch = p.Results.window_search;
winbase = p.Results.window_baseline;
winrspn = p.Results.window_response;
return_lvl = p.Results.return_level;
flag_normalize = p.Results.flag_normalize;
minvasocdur = p.Results.min_vasoc_dur;
maxvasocdur = p.Results.max_vasoc_dur;
minvasocarea = p.Results.min_vasoc_area;
maxvasocarea = p.Results.max_vasoc_area;
combinemode = p.Results.combine_mode;

%% Detect vasoc event candidates
if flag_normalize
    PPGa = PPGa / prctile(PPGa(~isnan(PPGa)), 95);
end

% downsample signal to 2Hz (original sampling frequency needs to be
% multiply of fslo.
if fs_PPGa < fslo || mod(fs_PPGa, fslo) ~= 0
    error('fs_PPGa needs to be multiply of %d (or you will need to implement customized resampling algorithm).', fslo)
end
PPGa = dsAverage(PPGa, fs_PPGa/fslo);

if ~isempty(RRI)
    if fs_RRI < fslo || mod(fs_RRI, fslo) ~= 0
        error('fs_RRI needs to be multiply of %d (or you will need to implement customized resampling algorithm).', fslo)
    end
    RRI = dsAverage(RRI, fs_RRI/fslo);
    assert(length(PPGa) == length(RRI), 'PPGa and RRI need to last for the same amount of time.')
end

% remove trailing NaNs
first_idx = 1;
last_idx = length(PPGa);
if isnan(PPGa(1))
    first_idx = find(~isnan(PPGa), 1);
end
if isnan(PPGa(end))
    last_idx = find(~isnan(PPGa), 1, 'last');
end

if ~isempty(RRI)
    if isnan(RRI(1))
        first_idx = max(first_idx, find(~isnan(PPGa), 1));
    end
    if isnan(RRI(end))
        last_idx = min(last_idx, find(~isnan(RRI), 1, 'last'));
    end
    RRI = RRI(first_idx : last_idx);
end
PPGa = PPGa(first_idx : last_idx);

time = (0 : length(PPGa)-1) / fslo;
PPGa_filt = interp1(time(~isnan(PPGa)), PPGa(~isnan(PPGa)), time);
PPGa_filt = filtfilt(filtnumPPGa, 1, PPGa_filt);
PPGa = PPGa_filt - mean(PPGa_filt) + mean(PPGa);

if ~isempty(RRI)
    RRI_filt = interp1(time(~isnan(RRI)), RRI(~isnan(RRI)), time);
    RRI_filt = filtfilt(filtnumRRI, 1, RRI_filt);
    RRI = RRI_filt - mean(RRI_filt) + mean(RRI);
end

% PPGa coefficient of variation calculation
nseg = floor((time(end) - max([cvsd, cvmean])) / cvstep) + 1;
timeCV = nan(nseg, 1);
PPGaCV = nan(nseg, 1);
for s = 1:nseg
    tmean = [0, cvmean] + cvstep*(s-1);
    tsd = cvmean + [-1, 1]*cvsd/2 + cvstep*(s-1);
    mean_idx = time >= tmean(1) & time < tmean(2);
    sd_idx = time >= tsd(1) & time < tsd(2);
    timeCV(s) = cvmean + cvstep*(s-1);
    PPGaCV(s) = std(PPGa(sd_idx)) / mean(PPGa(mean_idx));
end

% detect possible vasoc events
[pks, loc] = findpeaks(PPGaCV, ...
                       'MinPeakHeight', prctile(PPGaCV, cvminpeakprct), ...
                       'MinPeakDistance', cvminpeakdist * fslo);
first_idx = find(loc * cvstep > max(abs(winbase)), 1);
last_idx = find(loc * cvstep <= time(end) - cvminpeakdist*2, 1, 'last');
pks = pks(first_idx : last_idx);
loc = loc(first_idx : last_idx);

%% identify vasoc events and derive vasoc features
nseg = length(pks);
Mvasoc = nan(nseg, 1); % average vasoconstriction magnitude
Avasoc = nan(nseg, 1); % vasoconstriction area
Tvasoc = nan(nseg, 1); % vasoc event duration
Nvasoc = 0; % number of vasoc events
Arric = nan(nseg, 1); % RRI compensated area
Arriu = nan(nseg, 1); % RRI uncompensated area
Arrinet = nan(nseg, 1); % net changes in RRI area: Arriu - Arric
Rrri = nan(nseg, 1); % Arriu / Tvasoc

tvasocend = 0; % initialize time at the end of current vasoc

% DEBUG MODE = true
RejectedStatus = cell(nseg,2);
if DEBUGMODE
    figure,
    ax=subplot(1,1,1);
    plot(timeCV,PPGaCV,'LineWidth',1);
    hold on; plot(time,PPGa,'LineWidth',1);
    hold on; plot(timeCV(loc),PPGaCV(loc),'rx','MarkerSize',12,'LineWidth',2);
    hold on; plot(timeCV,repmat(prctile(PPGaCV, cvminpeakprct),length(timeCV),1));
    xlabel('Time(sec)');
    ax.FontSize = 16;
    
end
    
for s = 1:nseg
    if timeCV(loc(s)) > tvasocend
        t = timeCV(loc(s)) + (winsearch/2)*[-1, 1];  
        
        %5) Identify the onset of vasoconstriction & Calculate the temporary baseline
        [~, ii] = min(PPGa(time >= t(1) & time <= t(2)));  %Search for the minimum value around the CV peak
        idx_min = find(time >= t(1), 1) + ii - 1; %Get the index of the minPPGa relative to PPGa
        if time(idx_min) + winbase(1) <= tvasocend %If there is not enough time to recruit baseline, next loop
            RejectedStatus(s,:) = {timeCV(loc(s)),'Not enough temporary baseline'};
            continue
        end
        ppgabase = PPGa(idx_min + fslo*(winbase(1) : 1/fslo : winbase(2))); % temporary baseline
        ppgabase = median(ppgabase(~isnan(ppgabase))); %Calculate a median and use as a baseline value
        
        ppgabase_temp = ppgabase; %TOEY : Save temporary baseline for inspection only
        
        ppgatmp = PPGa(idx_min + fslo*winbase(1) : idx_min) - ppgabase; %20 sec before the minimum vasoc, identify the onset of vasoc -> by checking for zero-crossing
        idx_onset = find(ppgatmp >= 0, 1, 'last'); % vasoc onset index on ppgatmp
        idx_onset = idx_min + fslo*winbase(1) + idx_onset - 1; % vasoc onset index on PPGa
        
        %If new baseline overlaps with previous vasoconstriction, exclude
        %the current vasoc
        if time(idx_onset)+winbase(1) <=tvasocend
            RejectedStatus(s,:) = {timeCV(loc(s)),'Not enough baseline'};
            continue           
        end
        indice_base = idx_onset + fslo*(winbase(1): 1/fslo : winbase(2)); % baseline indices
        indice_base(indice_base<1) = []; %Temporary fix
        indice_rspn = idx_onset + fslo*(winbase(1): 1/fslo : winrspn); % response indices [-20,+300] sec
        indice_rspn(indice_rspn > length(PPGa)) = []; % if the response duration exceeds the length of the data, uses only the rest
        indice_rspn(indice_rspn < 1) = [];
        ppgabase = median(PPGa(indice_base));
        ppgarspn = PPGa(indice_rspn) - ppgabase; %The response is the difference from the baseline
        


        
        %6) Identify the end of vasoconstriction
        % interpolate PPGa
        tt = (0 : length(ppgarspn)-1) / fslo; %tt is response time [-20,300] by default in 2Hz
        ti = 0 : 1/fsi : tt(end);             %convert tt to 10Hz (upsampling)
        ti0 = ti + winbase(1);                %adjust for winbase(1) offset, so that ti0 begin at -20 like tt at 10Hz
        ppga = interp1(tt(~isnan(ppgarspn)), ppgarspn(~isnan(ppgarspn)), ti, 'pchip');
        ionset = find(ti0 == 0);              %identify the vasoc onset on 10Hz response
        isearch = min([length(ppga), ionset + fsi*10]);
        [mm, ii] = min(ppga(ionset:isearch)); % search for minimum within 10 sec from onset
        if mm >= 0 % skip vasodilation because the minimum response is higher than the baseline
             RejectedStatus(s,:) = {timeCV(loc(s)),'Vasodilation'};
            continue
        end
        ii = ii + ionset - 1; % idx for minimum point of ppga, ppga is 10Hz
        iend = find(ppga(ii:end) >= -return_lvl, 1) + ii - 1; % vasoc end, use thresholding to determine
        
        if isempty(iend) % vasoc event does not return
            tvasocend = time(idx_onset) + winrspn;
            RejectedStatus(s,:) = {timeCV(loc(s)),'Cannot identify the end of vasoconstriction'};                         
            continue
        end
        

        
        
        % discard outliers
        ppga_areadrop = trapz(ppga(ionset:iend)) / fsi;
        ppga_durdrop = (iend - ionset) / fsi;
        if ppga_durdrop <= minvasocdur || ...
           ppga_durdrop > maxvasocdur || ...
           -ppga_areadrop <= minvasocarea || ...
           -ppga_areadrop > maxvasocarea
            tvasocend = time(idx_onset) + ppga_durdrop;
            RejectedStatus(s,:) = {timeCV(loc(s)),'The duration is too short or too long, or the area is too small or too big'};
            continue
        end
        
        % feature calculation
        Mvasoc(s) = -ppga_areadrop / ppgabase / ppga_durdrop; %Change from the baseline normalized by
        Avasoc(s) = -ppga_areadrop / ppgabase;
        Tvasoc(s) = ppga_durdrop;
        Nvasoc = Nvasoc + 1;
                
           
        if DEBUGMODE %Plot the end of vasoc
            hold on; l = line([time(idx_min) time(idx_min)],ax.YLim,'LineStyle','--','Color','b');
            time_tempbase = time(idx_min + fslo*(winbase(1) : 1/fslo : winbase(2)));
            hold on; plot(time_tempbase,ppgabase_temp*ones(length(time_tempbase),1),'k--'); %Plot temporary baseline
            hold on; plot(time(indice_base),ppgabase*ones(length(indice_base),1),'--r');  %New baseline
            hold on; l = line([time(idx_onset) time(idx_onset)],ax.YLim,'LineStyle','--','Color','k','LineWidth',1);
            tend = (indice_rspn(1)-1)/fslo+(iend-1)/fsi;
            hold on; l = line([tend tend],ax.YLim,'LineStyle','--','Color','k','LineWidth',1);
        end
        
        % RRI related features
        if ~isempty(RRI)
            % interpolate RRI
            rribase = median(RRI(indice_base));
            rrirspn = RRI(indice_rspn) - rribase;
            rri = interp1(tt(~isnan(rrirspn)), rrirspn(~isnan(rrirspn)), ti, 'pchip');
            rrivasoc = rri(ionset:iend); % RRI drop during vasoc
            rri_durdrop = sum(rrivasoc <= 0) / fsi;
            rri_areadrop = trapz(rrivasoc(rrivasoc <= 0)) / fsi;
            rri_durrise = ppga_durdrop - rri_durdrop;
            rri_arearise = trapz(rrivasoc(rrivasoc > 0)) / fsi;
            
            % feature calculation
            Arric(s) = -rri_areadrop / rribase;
            Arriu(s) = rri_arearise / rribase;
            Arrinet(s) = Arriu(s) - Arric(s);
            Rrri(s) = rri_durrise / ppga_durdrop;         
        end
        
        % update vasoc end time
        tvasocend = time(idx_onset) + ppga_durdrop; 

    else
         RejectedStatus(s,:) = {timeCV(loc(s)),'The CV peak overlaps with the previous vasoconstriction'};
    end
end


if DEBUGMODE
    T = table(RejectedStatus(:,1),RejectedStatus(:,2),'VariableNames',{'Time(s)','RejectedStatus'});
    disp(nseg);
    disp(T);
end

%% Finalize vasoc features
if ~isempty(RRI)
    IDXexpose = sum(Arrinet, 'omitnan') + sum(Avasoc, 'omitnan'); % cumulatve exposure, larger value -> more exposed to UNcompensation
    IDXdosage = IDXexpose / sum(Tvasoc, 'omitnan'); % average intensity, larger value -> stronger UNcompensation
end

switch combinemode
    case 'mean'
        Tvasoc = mean(Tvasoc, 'omitnan');
        Mvasoc = mean(Mvasoc, 'omitnan');
        Avasoc = mean(Avasoc, 'omitnan');
        if ~isempty(RRI)
           Arric = mean(Arric, 'omitnan');
           Arriu = mean(Arriu, 'omitnan');
           Arrinet = mean(Arrinet, 'omitnan');
           Rrri = mean(Rrri, 'omitnan');
        end
    case 'median'
        Tvasoc = median(Tvasoc, 'omitnan');
        Mvasoc = median(Mvasoc, 'omitnan');
        Avasoc = median(Avasoc, 'omitnan');
        if ~isempty(RRI)
           Arric = median(Arric, 'omitnan');
           Arriu = median(Arriu, 'omitnan');
           Arrinet = median(Arrinet, 'omitnan');
           Rrri = median(Rrri, 'omitnan');
        end
end
varargout{1} = Mvasoc;
varargout{2} = Avasoc;
varargout{3} = Tvasoc;
varargout{4} = Nvasoc;
if ~isempty(RRI)
    varargout{5} = Arric;
    varargout{6} = Arriu;
    varargout{7} = Arrinet;
    varargout{8} = Rrri;
    varargout{9} = IDXexpose;
    varargout{10} = IDXdosage;
end

end