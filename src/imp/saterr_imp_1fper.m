function f_1f_adjust = saterr_imp_1fper(f_1f,x)
% adjust 1/f percentage if necessary
% it depends on the definition of 1/f and comparisoin with observation
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: original code

if f_1f<1
    x = x(:);
    a = 1-1/2*mean(diff(x).^2);
    if a<0
        a = 1;
    end
    
    f_1f_adjust = f_1f/a;
    
    if f_1f_adjust>1
        f_1f_adjust = f_1f; % no adjust
        warning('1/f low frequency cannot exceed 1')
    end
else
    f_1f_adjust = f_1f;
end
