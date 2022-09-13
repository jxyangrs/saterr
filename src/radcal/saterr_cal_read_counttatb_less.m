% loading count, ta, tb in the date range
%
% Input:
%       path
% Output:
%      from count data
%         tc,           [crosstrack,alongtrack,channel]
%         tw,           [crosstrack,alongtrack,channel]
%         cs,           [crosstrack,alongtrack,channel]
%         cc,           [crosstrack,alongtrack,channel]
%         cw,           [crosstrack,alongtrack,channel]
%         fov_lat,      [crosstrack,alongtrack,channel]
%         fov_lon,      [crosstrack,alongtrack,channel]
%         sc_lat,       [crosstrack,alongtrack,channel]
%         sc_lon,       [crosstrack,alongtrack,channel]
%         sc_time,      [crosstrack,alongtrack,channel]
%         faraday_omega,[crosstrack,alongtrack,channel]
%         faraday_d,    [crosstrack,alongtrack,channel]
%         faraday_U,    [crosstrack,alongtrack,channel]
%      from calibration data
%         tas,          [crosstrack,alongtrack,channel]
%         tas_bias,     [crosstrack,alongtrack,channel]
%         tas_noise,    [crosstrack,alongtrack,channel]
%         tac,          [crosstrack,alongtrack,channel]
%         taw,          [crosstrack,alongtrack,channel]
%         tac_noise,    [crosstrack,alongtrack,channel]
%         taw_noise,    [crosstrack,alongtrack,channel]
%         tbs,          [crosstrack,alongtrack,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code


% -----------------------------
% setting paths, variables
% -----------------------------
saterr_cal_read_counttatb_less_setting

% -----------------------------
% loading data 
% -----------------------------
ndatestr = datestr(datenum(Path.date.range(1),'yyyymmdd'): datenum(Path.date.range(2),'yyyymmdd')-1,'yyyymmdd');
outpath = [Path.cal.output,'/plot/',ndatestr1(1,:),'_',ndatestr1(end,:)];
% outpath
if ~exist(outpath,'dir')
    mkdir(outpath)
end

for nday = 1: size(ndatestr,1)
    % -----------------------------
    % setting date
    % -----------------------------
    ndatestr1 = ndatestr(nday,:);
    
    % -----------------------------
    % read count data
    % -----------------------------
    inpath = [pathin_count,'/',ndatestr1(1:4),'/',ndatestr1];
    fileID = ['sim_count_',Path.sensor.spacecraft,'.',Path.sensor.name,'*'];
    files = dir([inpath,'/',fileID]);
    for nfile=1: size(files,1)
        infile = files(nfile).name;
        disp(infile)
        data = load([inpath,'/',infile]);
        
        tc = [tc,double(data.tc)];
        tw = [tc,double(data.tw)];
        cs = [cs,double(data.cs)];
        cc = [cc,double(data.cc)];
        cw = [cw,double(data.cw)];
        
        fov_lat = [fov_lat,double(data.Orbit.fov.lat)];
        fov_lon = [fov_lon,double(data.Orbit.fov.lon)];
        sc_lat = [sc_lat,double(data.Orbit.sc.lat)];
        sc_lon = [sc_lon,double(data.Orbit.sc.lon)];
        sc_time = [sc_time,double(data.Orbit.sc.time)];
        
        if data.Faraday.onoff
            faraday_omega = [faraday_omega,Faraday.omega];
            faraday_d = [faraday_d,Faraday.faraday_d];
            faraday_U = [faraday_U,Faraday.faraday_U];
        end
    end
    
    % -----------------------------
    % read ta,tb data
    % -----------------------------
    inpath = [pathin_tatb,'/',ndatestr1(1:4),'/',ndatestr1];
    fileID = ['cal_tatb_',Path.sensor.spacecraft,'.',Path.sensor.name,'*'];
    files = dir([inpath,'/',fileID]);
    for nfile=1: size(files,1)
        infile = files(nfile).name;
        disp(infile)
        
        data = load([inpath,'/',infile]);
        
        tas = [tas,double(data.tas)];
        tas_bias = [tas_bias,double(data.tas_bias)];
        tas_noise = [tas_noise,double(data.tas_noise)];
        tac_noise = [tac_noise,double(data.tac_noise)];
        taw_noise = [taw_noise,double(data.taw_noise)];
        tbs = [tbs,double(data.tbs)];
    end
    
end
