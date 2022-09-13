function ta = saterr_cal_conic_fovintrusion(ta)
% correcting for main reflector emission of conical-scanning radiometer
%
% Input:
%       ta,          antenna temperature,        [crosstrack,alongtrack,channel]
%       CalPara.
%
% Output:
%       ta,         antenna temperature,         [crosstrack,alongtrack,channel]
%                       (FOV intrusion removed)
%
% Description:
%       Intrusion is from near-field and thus removed from TA.
%       The additive term can arise from sidelobe and backlobe, and the multiplicative term can from cold-sky mirror, spacecraft
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara

if CalPara.scanbias.fovintrusion.onoff == 1
    ta_intru = CalPara.scanbias.fovintrusion.tb;     % [1,channel]
    f = CalPara.scanbias.fovintrusion.frac;          % [crosstrack,channel]
    
    f = permute(f,[1,3,2]);
    ta_intru = ta_intru(:);
    ta_intru = permute(ta_intru,[3,2,1]);
    
    ta = bsxfun(@plus, bsxfun(@times,ta,(1-f)), bsxfun(@times,ta_intru,f));
end




