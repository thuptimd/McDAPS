function [newvarname,flagChange] = checkRepeatedVarname(varname,allvarnames)

%Check for repeated variable name
if any(strcmp(allvarnames,varname)) %found variable in handles.DB.varname with the same name
    flagChange = 1;
    for n=2:500 %allow automatic renaming upto 500-1 times
        newvarname = [varname,'_',num2str(n)];
        if ~any(strcmp(allvarnames,newvarname))
            break
        end
    end
else
    flagChange = 0;
    newvarname = varname; %do NOT change current variable name
end