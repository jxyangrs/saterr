% output TOA tb
%
% Output
%       tb_mainlobe,    cold-space temperature,     [crosstrack,alongtrack,channel]
%       tb_scene,       warm-load temperature,      [crosstrack,alongtrack,channel]
%       cc,             cold-space count,           [crosstrack,alongtrack,channel]
%       cw,             warm-load count,            [crosstrack,alongtrack,channel]
%       cs,             scene count,                [crosstrack,alongtrack,channel]
%       Rad.*,          radiometer setting
%       Noise.*,        noise
%       WarmLoad.*,     warm-load
%       Reflector.*,    reflector angle & emission
%       ScanBias.*,     scan bias
%       TimeVarying.oscillation.*,        oscillation
%       TBsrc.*,        tb source
%       AP.*,           antenna pattern
%       Orbit.*,        orbit and geo
%       PolOffset.*,    pol misalignment
%       Faraday.*,      Faraday
%       Path.*,         Path setting
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code

% -----------------------------
% preprocessing
% -----------------------------
tb_mainlobe = single(AP.tb.mainlobe);
if AP.onoff == 1
    tb_scene = single(AP.tb.tbscene);
else
    tb_scene = [];
end

lat = single(Orbit.fov.lat);
lon = single(Orbit.fov.lon);

% -----------------------------
% output simulation
% -----------------------------
outpath = [Path.sim.granuel,'/',Path.date.ndatestr(ind_dayn1(nfile),1:4),'/',Path.date.ndatestr(ind_dayn1(nfile),:)];
if ~exist(outpath,'dir')
    mkdir(outpath)
end
outfile = strrep(files_prof(nfile).name,'prof_','sim_tb_');
outfile = strrep(outfile,'.bin','.mat');
save([outpath,'/',outfile],...
    'lat','lon','tb_mainlobe','tb_scene')
