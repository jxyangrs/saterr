function ta = saterr_cal_spillover(ta)
% correcting spillover
% 
% Input:
%       ta,          Stokes  spillover,           [crosstrack,alongtrack,channel]
%       CalPara.
%           frac.spillover
%           tb.spillover
% 
% Output:
%       ta,          spillover corrected tb,      [crosstrack,alongtrack,channel]
%
% Description:
%       ta = (ta - frac_spillover*tb_spillover)./(1-frac_spillover);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara

if CalPara.spillover.onoff == 1
    
    f = CalPara.AP.frac.spillover; % [crosstrack,along-track,channel]
    tb = CalPara.AP.tb.spillover;  % [crosstrack,alongtrack,channel]
    
    if size(f)==2
        f = permute(f,[1,3,2]);
    end
    if size(tb)==2
        tb = permute(tb,[1,3,2]);
    end
    
    ta = bsxfun(@times, bsxfun(@minus, ta, bsxfun(@times,tb,f)), 1./(1-f));
end

