function tb = saterr_cal_crosstalk(tb)
% correcting for cross-pol contamination
% 
% Input:
%       tb,         brightness temperature,      [crosstrack,alongtrack,channel]
%                      (w/ crosstalk)
%       CalPara.
% 
% Output:
%       tb,        brightness tempereture,      [crosstrack,alongtrack,channel]
%                      (w/o crosstalk)
%
% Description:
%       A couple of schemes can be used
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara

if CalPara.crosstalk.onoff
    M = CalPara.crosstalk.X;
    iM = inv(M);
    tb = permute(tb,[3,1,2]);
    tb = mtimes_2d3d(iM,tb);
    tb = permute(tb,[2,3,1]);
end


