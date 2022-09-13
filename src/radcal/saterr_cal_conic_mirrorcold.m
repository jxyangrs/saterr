function tc = saterr_cal_conic_mirrorcold(tc)
% correcting cold-space mirror error
%
% Input:
%       tc_chan,          Stokes  spillover,           [Stokes,crosstrack,alongtrack]
%       CalPara.
%           frac.spillover
%           tb.spillover
%
% Output:
%       tc_chan,         spillover corrected tb,      [Stokes,crosstrack,alongtrack]
%
% Description:
%       tb_out = (tb_in - frac_spillover*tb_spillover)./(1-frac_spillover);
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara

if CalPara.mirrorcold.error.onoff
    a = CalPara.mirrorcold.error.slope;     % slope, [1,channel]
    b = CalPara.mirrorcold.error.intercept; % intercept, [1,channel]
    
    a = permute(a,[1,3,2]);
    b = permute(b,[1,3,2]);
    
    tc = bsxfun(@times, bsxfun(@minus,tc,b), 1./a);

end