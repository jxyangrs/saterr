function tb_farfield = saterr_imp_farfieldTB_fun(tb_mainlobe,tb_sidelobe,frac_mainlobe,frac_sidelobe)
% target/far-field tb
% (spillover not counted here)
%
% Input:
%       tb_mainlobe,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       tb_sidelobe,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       frac_mainlobe,   fraction of mainlobe,       [Stokes,1,1,channel]/[Stokes,crosstrack,alongtrack,channel]
%       frac_sidelobe,   fraction of sidelobe,       [Stokes,1,1,channel]/[Stokes,crosstrack,alongtrack,channel]
% 
% Output:
%       tb_farfield,     farfield tb w/o spillover,  [Stokes,crosstrack,alongtrack,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

% -----------------------------
% antenna pattern weighting
% -----------------------------
tb_farfield = bsxfun(@plus, bsxfun(@times,tb_mainlobe,frac_mainlobe), bsxfun(@times,tb_sidelobe,frac_sidelobe));



