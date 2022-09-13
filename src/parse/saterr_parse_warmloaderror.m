% parse warm-load error
%
% Input:
%       warm-load error setting
% 
% Output:
%       WarmLoad.error.slope,           slope error,        [1,channel]
%       WarmLoad.error.intercept,       intercept (K),      [1,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

% parse
if WarmLoad.error.onoff==1
    
    n = size(WarmLoad.error.slope);
    if ~isequal(n,[1,Rad.num_chan])
        error('WarmLoad.errors.slope size is wrong')
    end
    n = size(WarmLoad.error.intercept);
    if ~isequal(n,[1,Rad.num_chan])
        error('WarmLoad.errors.intercept size is wrong')
    end
    
end


