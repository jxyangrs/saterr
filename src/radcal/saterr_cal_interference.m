function ta = saterr_cal_interference(ta)
% correcting for main reflector emission of conical-scanning radiometer
%
% Input:
%       ta,          antenna temperature,        [crosstrack,alongtrack,channel]
%       CalPara.
%
% Output:
%       ta,          antenna temperature,        [crosstrack,alongtrack,channel]
%                    (interference removed)
%
% Description:
%       Intrusion is from near-field and thus removed from TA.
%       The additive term can arise from sidelobe and backlobe, and the multiplicative term can from cold-sky mirror, spacecraft
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara

if CalPara.scanbias.interference.onoff == 1
    ta_bias = CalPara.scanbias.interference.tb;       % [crosstrack,channel]
    ta_bias = permute(ta_bias,[1,3,2]);
    
    ta = bsxfun(@minus, ta, ta_bias);
end




