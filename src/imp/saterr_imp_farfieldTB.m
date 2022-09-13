function saterr_imp_farfieldTB
% target/far-field tb
% (spillover not counted here)
%
% Input:
%       AP.tb.mainlobe,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       AP.tb.sidelobe,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       AP.tb.spillover,    spillover tb,               [Stokes,crosstrack,alongtrack,channel]
% 
% Output:
%       VarDynamic.Tas,     farfield tb w/o spillover,  [Stokes,crosstrack,alongtrack,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global VarDynamic AP

% -----------------------------
% antenna pattern weighting
% -----------------------------
tb_farfield = bsxfun(@plus, bsxfun(@times,AP.tb.mainlobe,AP.frac.mainlobe), bsxfun(@times,AP.tb.sidelobe,AP.frac.sidelobe));

% -----------------------------
% output
% -----------------------------
VarDynamic.Tas = tb_farfield;

