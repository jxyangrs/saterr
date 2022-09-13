% output TOA tb
%
% Output
%       tb_mainlobe,             cold-space temperature,     [crosstrack,alongtrack,channel]
%       tb_scene,             warm-load temperature,      [crosstrack,alongtrack,channel]
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
lat = data.lat;
lon = data.lon;
time_sc = data.time_sc;

tc = VarDynamic.tc_chan_out;
tw = VarDynamic.tw_chan_out;
cc = VarDynamic.cc_chan_out;
cw = VarDynamic.cw_chan_out;
cs = VarDynamic.cs_chan_out;

tc = single(tc);
tw = single(tw);
cc = single(cc);
cw = single(cw);
cs = single(cs);


% tb_mainlobe: converting Stokes tb_mainlobe to channel tb_mainlobe
tb = AP.tb.mainlobe;

tb_mainlobe_chan = [];
switch Rad.scantype
    case 'conical'
        n = size(tb);
        n = n(2:3);
        for nchan=1: size(tb,4)
            indpol = Rad.chanpol_ind(nchan);
            tb1 = tb(indpol,:,:,nchan);
            tb1 = reshape(tb1,n);
            tb_mainlobe_chan(:,:,nchan) = tb1;
        end
        
    case 'crosstrack'
        phi = Rad.scan.cs_angscan;
        tb_mainlobe_chan = polmix_cross(tb,phi);
end
tb_mainlobe = single(tb_mainlobe_chan);

% tb_scene
if AP.onoff == 1
    tb_scene = single(AP.tb.tbscene);
else
    tb_scene = [];
end

% -----------------------------
% output simulation
% -----------------------------
outpath = [Path.sim.count,'/',Path.date.ndatestr(nday,1:4),'/',Path.date.ndatestr(nday,:)];
if ~exist(outpath,'dir')
    mkdir(outpath)
end

outfile = strrep(files_daily(norbit).name,'sim_tb_','sim_count_');
outfile = strrep(outfile,'.bin','.mat');
save([outpath,'/',outfile],...
    'Rad','Noise','WarmLoad','Reflector','MirrorCold','ScanBias','TimeVarying','PolOffset','Faraday','Path',...
    'lat','lon','time_sc','tb_mainlobe','tb_scene',...
    'tc','tw','cc','cw','cs')

