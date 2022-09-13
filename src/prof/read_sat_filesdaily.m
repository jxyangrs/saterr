function [qual_daily,tb_daily,eia_daily,lat_daily,lon_daily,time_daily,azm_daily,scanpos_daily,scanangle_daily,sc_h_daily,sc_lat_daily,sc_lon_daily,len_orbit] = ...
    read_sat_filesdaily(TarRadDataInfo,fileinfo)
% read dailly data
%
% Input:
%       TarRadDataInfo
%
% Output:
%       qual_daily,        quality flag,               [crosstrack,alongtrack]
%       tb_daily,          brightness temperature,     [crosstrack,alongtrack,channel]
%       eia_daily,         Earth incidence angle,      [crosstrack,alongtrack,channel]
%       lat_daily,         fov latitude,               [crosstrack,alongtrack]
%       lon_daily,         fov longitude,              [crosstrack,alongtrack]
%       time_daily,        time,                       [1,alongtrack]
%       azm_daily,         fov local azimuth,          [crosstrack,alongtrack,channel]
%       scanpos_daily,     scan position,              [crosstrack,alongtrack,channel]
%       scanangle_daily,   scan angle daily,           [crosstrack,alongtrack,channel]
%       sc_h_daily,        spacecraft altitude (km),   [1,alongtrack]/[crosstrack,alongtrack] -999 if empty
%       sc_lat_daily,      spacecraft latitude (km),   [1,alongtrack]/[crosstrack,alongtrack] -999 if empty
%       sc_lon_daily,      spacecraft longitude(km),   [1,alongtrack]/[crosstrack,alongtrack] -999 if empty
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2019: spacecraft altitude

qual_daily = [];
tb_daily = [];
eia_daily = [];
lat_daily = [];
lon_daily = [];
time_daily = [];
azm_daily = [];
scanpos_daily = [];
scanangle_daily = [];
sc_h_daily = [];
sc_lat_daily = [];
sc_lon_daily = [];
len_orbit = [];

for ifile=1: fileinfo.united_filenum
    
    disp(fileinfo.name(ifile).united)
    
    % read one-orbit
    inpath = fileinfo.path;
    
    indchanselect = 0; % use all channels
    [qual,tb,eia,lat,lon,time,azm,sc_h,sc_lat,sc_lon] = set_Read1File(TarRadDataInfo,inpath,fileinfo.name(ifile),indchanselect);
    [n1,n2,n3] = size(tb);
    nchannel = n3;
    if size(eia,3)==1
        eia = eia(:,:,ones(nchannel,1));
    end
    if size(azm,3)==1
        azm = azm(:,:,ones(nchannel,1));
    end
    scanpos = repmat((1:n1)',[1,n2]);
    scanangle = scanpos2angle(TarRadDataInfo.sensor);
    scanangle = repmat(scanangle(:),[1,n2]);
    
    time = repmat(time,[n1,1]);
    
    % collect
    qual_daily = cat(2,qual_daily,qual);
    tb_daily = cat(2,tb_daily,tb);
    eia_daily = cat(2,eia_daily,eia);
    lat_daily = cat(2,lat_daily,lat);
    lon_daily = cat(2,lon_daily,lon);
    time_daily = cat(2,time_daily,time);
    azm_daily = cat(2,azm_daily,azm);
    scanpos_daily = cat(2,scanpos_daily,scanpos);
    scanangle_daily = cat(2,scanangle_daily,scanangle);
    sc_h_daily = cat(2,sc_h_daily,sc_h);
    sc_lat_daily = cat(2,sc_lat_daily,sc_lat);
    sc_lon_daily = cat(2,sc_lon_daily,sc_lon);
    
    len_orbit = [len_orbit;n2];
    
end


