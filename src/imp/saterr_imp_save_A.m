function saterr_imp_save_A(fname,Rad,Noise,WarmLoad,Reflector,MirrorCold,ScanBias,TimeVarying,TBsrc,AP,Orbit,PolOffset,Faraday,Path,tw,tc,cc,cw,cs)
% saving simulation results of scheme A
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code


% -----------------------------
% tb allocation
% -----------------------------
% converting Stokes tb_mainlobe to channel tb_mainlobe
tb = AP.tb.mainlobe;
AP.tb = rmfield(AP.tb,'mainlobe');
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
        AP.tb.mainlobe = single(tb_mainlobe_chan);
        
    case 'crosstrack'
        phi = Rad.scan.cs_angscan;
        tb_mainlobe_chan = polmix_cross(tb,phi);
        AP.tb.mainlobe = single(tb_mainlobe_chan);
end

% output
AP.tb.tbscene = single(AP.tb.tbscene);

if AP.onoff==0
    AP = rmfield(AP,'frac');
    AP.tb = rmfield(AP.tb,'sidelobe');
    AP.tb = rmfield(AP.tb,'spillover');
end

% -----------------------------
% scanning and orbit
% -----------------------------
if Orbit.onoff==1
    Orbit.fov = rmfield(Orbit.fov,'az');
    Orbit.fov = rmfield(Orbit.fov,'rs');
    
    Orbit.fov.lat = single(Orbit.fov.lat);
    Orbit.fov.lon = single(Orbit.fov.lon);
    Orbit.fov.eia = single(Orbit.fov.eia);
    
    Orbit.sc.h = single(Orbit.sc.h(round(end/2),:));
    Orbit.sc.lat = single(Orbit.sc.lat(round(end/2),:));
    Orbit.sc.lon = single(Orbit.sc.lon(round(end/2),:));
    Orbit.sc.az = single(Orbit.sc.az(round(end/2),:));
end

if Faraday.onoff==1
    Faraday = rmfield(Faraday,'omega');
    Faraday.chan.omega = single(Faraday.chan.omega);
    Faraday.chan.d = single(Faraday.chan.d);
    Faraday.chan.U = single(Faraday.chan.U);
end

% -----------------------------
% noise
% -----------------------------
if isfield(Noise,'addnoise')
    if isfield(Noise.addnoise,'noise_subset')
        Noise.addnoise = rmfield(Noise.addnoise,'noise_subset');
    end
end

% -----------------------------
% count
% -----------------------------
tc = single(tc);
tw = single(tw);
cc = single(cc);
cw = single(cw);
cs = single(cs);

% -----------------------------
% save
% -----------------------------

if isfield(Orbit,'multiorbit')
    Orbit = rmfield(Orbit,'multiorbit');
end

save(fname,'Rad','Noise','WarmLoad','Reflector','MirrorCold','ScanBias','TimeVarying','TBsrc','AP','Orbit','PolOffset','Faraday','Path',...
    'tw','tc','cc','cw','cs')



