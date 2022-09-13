% I/O output
%
% Output
%       tc,             cold-space temperature,     [crosstrack,alongtrack,channel]
%       tw,             warm-load temperature,      [crosstrack,alongtrack,channel]
%       cc,             cold-space count,           [crosstrack,alongtrack,channel]
%       cw,             warm-load count,            [crosstrack,alongtrack,channel]
%       cs,             scene count,                [crosstrack,alongtrack,channel]
%       Rad.*,          radiometer setting
%       Noise.*,        noise
%       WarmLoad.*,     warm-load
%       Reflector.*,    reflector angle & emission
%       ScanBias.*,     scan bias
%       TimeVarying.oscillation.*,     oscillation
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
saterr_imp_simiooutpre

% -----------------------------
% output simulation
% -----------------------------

switch Path.scheme
    case 'A'
        ndatestr1 = Path.date.ndatestr(nday,:);
        outpath = [Path.sim.count,'/',ndatestr1(1:4),'/',ndatestr1];
        if ~exist(outpath,'dir')
            mkdir(outpath)
        end
        sensor1 = [Path.sensor.spacecraft,'.',Path.sensor.name];
        orbittime1 = datestr(Orbit.sc.time(1),'yyyymmddHHMM');
        orbittime2 = datestr(Orbit.sc.time(end),'yyyymmddHHMM');
        outfile = ['sim_count_',sensor1,'_d',orbittime1(1:8),'_s',orbittime1(9:12),'_','e',orbittime2(9:12),'.mat'];
        fname = [outpath,'/',outfile];
        saterr_imp_save_A(fname,Rad,Noise,WarmLoad,Reflector,MirrorCold,ScanBias,TimeVarying,TBsrc,AP,Orbit,PolOffset,Faraday,Path,tw,tc,cc,cw,cs);
        
    case 'B'
        outpath = [Path.sim.granuel,'/',Path.date.ndatestr(nday,1:4),'/',Path.date.ndatestr(nday,:)];
        if ~exist(outpath,'dir')
            mkdir(outpath)
        end
        outfile = strrep(files_daily(ifile).name,'prof_','sim_');
        outfile = strrep(outfile,'.bin','.mat');
        save([outpath,'/',outfile],'Rad','Noise','WarmLoad','Reflector','MirrorCold','ScanBias','TimeVarying','PolOffset','Faraday','Path',...
            'lat','lon','tb_mainlobe','tb_scene',...
            'tw','tc','cc','cw','cs')
        saterr_imp_save_B(fname,Rad,Noise,WarmLoad,Reflector,MirrorCold,ScanBias,TimeVarying,TBsrc,AP,Orbit,PolOffset,Faraday,Path,tw,tc,cc,cw,cs);
        
end



