% parse cold-space mirror
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

% parse
if MirrorCold.error.onoff==1
    
    n = size(MirrorCold.error.slope);
    if ~isequal(n,[1,Rad.num_chan])
        error('MirrorCold.errors.slope size is wrong')
    end
    n = size(MirrorCold.error.intercept);
    if ~isequal(n,[1,Rad.num_chan])
        error('MirrorCold.errors.intercept size is wrong')
    end
    
end


