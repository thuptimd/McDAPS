function fs = getSamplingFreq(filepath,filename,selvar)

%Determine variable name for sampling frequency: fs, fs_low, fs_high, or fs_ecg
%Input : filename = matfilename, filepath = matfilepath, selvar = variable name
%Modified
%2021-06-23: If fs cannot be identified, set the default to 2.
%allvars = who('-file',fullfile(filepath,filename));

%fs_high
matobj = matfile(fullfile(filepath,filename));
matobj_info = whos(matobj);
allvars = arrayfun(@(x) matobj_info(x).name, 1:numel(matobj_info), 'UniformOutput', false);
selvarlen =length(eval(['matobj.',selvar]));

%1. Identify #fs from the variables
fs_ind = startsWith(allvars,'fs');

if any(fs_ind)
    fs_names = allvars(fs_ind);
    fs_val = zeros(length(fs_names),1); % fs values
    %New
    for n=1:length(fs_names)
        val1 = eval(['matobj.',fs_names{n}]); %get value of frequency
        if isnumeric(val1) && size(val1,1) == 1 && size(val1,2) == 1
            fs_val(n) = val1;
        else
            fs_val(n) = nan;
        end
    end
    
    fs_names = fs_names(~isnan(fs_val));
    fs_val   = fs_val(~isnan(fs_val));

    [fs_val,ia] = unique(fs_val);
    fs_names = fs_names(ia);
    
    %2. Select the particular length for each fs, !! Assume all the
    %recordings have equal length
    if ~isempty(fs_val)   
        %Identify signal length
        siglen = nan(length(matobj_info),1);
        
        for n=1:numel(matobj_info)
            if isempty(matobj_info(n).size) 
               continue
            elseif matobj_info(n).size(1)>1 && matobj_info(n).size(2)==1 
                siglen(n) = matobj_info(n).size(1);
            end
        end         
        siglen(isnan(siglen)) = [];
        siglen = unique(siglen);
        
        %element must match fs_names elements
        try
            no_of_fs = length(fs_val);
            siglen = siglen(end-no_of_fs+1:end);
            fsvarname = fs_names{siglen==selvarlen};
            fs = eval(['matobj.',fsvarname]);
        catch
            prompt = {'Enter a sampling frequency'};
            def = {'2'};
            dlg_title = '';
            num_lines = 1;
            try
                enterfs = newid(prompt,dlg_title,num_lines,def);
                fs = str2double(enterfs{1});
            catch
                fs = 2;
            end
            
            if isnan(fs)
                fs = 2;
            end
            
        end
    else
        prompt = {'Enter a sampling frequency'};
        def = {'2'};
        dlg_title = '';
        num_lines = 1;
        try
            enterfs = newid(prompt,dlg_title,num_lines,def);
            fs = str2double(enterfs{1});
        catch
            fs = 2;
        end
        if isnan(fs)
            fs = 2;
        end
        
    end
    
    
else %Ask for fs
    prompt = {'Enter a sampling frequency'};
    def = {'2'};
    dlg_title = '';
    num_lines = 1;
    try
        enterfs = newid(prompt,dlg_title,num_lines,def);
        fs = str2double(enterfs{1});
    catch
        fs = 2;
    end
    if isnan(fs)
        fs = 2;
    end
    
end















    