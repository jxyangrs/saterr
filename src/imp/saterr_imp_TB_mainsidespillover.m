function saterr_imp_TB_mainsidespillover
% tb of mainlobe, sidelobe, spillover
%   This is after RTM is done
%
% Input:
%       VarDynamic.Tas,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       Rad.*               channel specification
% 
% Output:
%       AP.tb.mainlobe,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       AP.tb.sidelobe,     mainlobe tb,                [Stokes,crosstrack,alongtrack,channel]
%       AP.tb.spillover,    spillover tb,               [Stokes,crosstrack,alongtrack,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/01/2019: separate mainlobe from sidelobe/spillover

global AP Rad VarDynamic 

% -----------------------------
% source of mainlobe, sidelobe, spillover
% -----------------------------
% mainlobe
tb_mainlobe = VarDynamic.Tas;

% sidelobe
VarDynamic.tb_mainlobe = VarDynamic.Tas;
tb_sidelobe = saterr_imp_TBsource_sidelobe(AP.tbsrc.sidelobe);

% spillover
VarDynamic.tb_mainlobe = VarDynamic.Tas;
tb_spillover = saterr_imp_TBsource_sidelobe(AP.tbsrc.spillover);

% -----------------------------
% output
% -----------------------------
AP.tb.mainlobe = tb_mainlobe;
AP.tb.sidelobe = tb_sidelobe;
AP.tb.spillover = tb_spillover;

% -----------------------------
% variables
% -----------------------------
if isfield(VarDynamic,'tb_mainlobe')
    VarDynamic = rmfield(VarDynamic,'tb_mainlobe');
end
