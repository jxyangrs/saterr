% adjust 1/f percentage if necessary
% it depends on the definition of 1/f and comparisoin with observation
%
% Input:
%       std_tbs,        std of scene noise,         [1,noise type]
%       std_tbc,        std of scene noise,         [1,noise type]
%       std_tbw,        std of scene noise,         [1,noise type]
%       std_tbnull,     std of scene noise,         [1,noise type]
% Output:
%       std_tbs,        adjusted scene noise,       [1,noise type]
%       std_tbc,        adjusted scene noise,       [1,noise type]
%       std_tbw,        adjusted scene noise,       [1,noise type]
%       std_tbnull,     adjusted scene noise,       [1,noise type]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/31/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: accounting for the thermal part of 1/f

idx = ~cellfun(@isempty,strfind(Noise.addnoise.type,'1/f'));

if sum(idx)
    var_sum = sum(std_tbs.^2);
    var_f = std_tbs.^2/var_sum;
    f_1f = var_f(idx);
    x = noise_sub(Rad.ind_CT{1},:,idx);
    per_1f_adjust = saterr_imp_1fper(f_1f,x);
    if per_1f_adjust~=f_1f
        var_f(idx) = per_1f_adjust;
        f = var_f(~idx)/sum(var_f(~idx));
        var_f(~idx) = (1-per_1f_adjust)*f;
    end
    std_tbs = sqrt(var_sum*var_f);
    
    var_sum = sum(std_tbc.^2);
    var_f = std_tbc.^2/var_sum;
    f_1f = var_f(idx);
    x = noise_sub(Rad.ind_CT{2},:,idx);
    per_1f_adjust = saterr_imp_1fper(f_1f,x);
    if per_1f_adjust~=f_1f
        var_f(idx) = per_1f_adjust;
        f = var_f(~idx)/sum(var_f(~idx));
        var_f(~idx) = (1-per_1f_adjust)*f;
    end
    std_tbc = sqrt(var_sum*var_f);
    
    var_sum = sum(std_tbw.^2);
    var_f = std_tbw.^2/var_sum;
    f_1f = var_f(idx);
    x = noise_sub(Rad.ind_CT{3},:,idx);
    per_1f_adjust = saterr_imp_1fper(f_1f,x);
    if per_1f_adjust~=f_1f
        var_f(idx) = per_1f_adjust;
        f = var_f(~idx)/sum(var_f(~idx));
        var_f(~idx) = (1-per_1f_adjust)*f;
    end
    std_tbw = sqrt(var_sum*var_f);
    
    var_sum = sum(std_tbnull.^2);
    var_f = std_tbnull.^2/var_sum;
    f_1f = var_f(idx);
    x = noise_sub(Rad.ind_CT{4},:,idx);
    per_1f_adjust = saterr_imp_1fper(f_1f,x);
    if per_1f_adjust~=f_1f
        var_f(idx) = per_1f_adjust;
        f = var_f(~idx)/sum(var_f(~idx));
        var_f(~idx) = (1-per_1f_adjust)*f;
    end
    std_tbnull = sqrt(var_sum*var_f);
end
