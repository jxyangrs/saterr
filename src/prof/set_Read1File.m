function [qual,tb,eia,lat,lon,time,azm,sc_h,sc_lat,sc_lon] = set_Read1File(RadDataInfo,inpath,filename,indchanselect)
% read one single file
%
% Input:
%       RadDataInfo (struct)
%       inpath (string), path of a single file
%       filename (struct), file names
%       indchanselect (struct), index for selecting channels
%
% Output:
%       qual        quality flag,               [crosstrack,alongtrack]
%       tb          brightness temperature,     [crosstrack,alongtrack,channel]
%       eia         Earth incidence angle,      [crosstrack,alongtrack,channel]
%       lat         fov latitude,               [crosstrack,alongtrack]
%       lon         fov longitude,              [crosstrack,alongtrack]
%       time        time,                       [1,alongtrack]
%       azm         fov local azimuth,          [crosstrack,alongtrack,channel]
%       sc_h        spacecraft altitude (km),   [1,alongtrack]/[crosstrack,alongtrack]
%       sc_lat      spacecraft latitude,        [1,alongtrack]/[crosstrack,alongtrack]
%       sc_lon      spacecraft longitude,       [1,alongtrack]/[crosstrack,alongtrack]
%
% Description:
%       The code can be extended to add sensor data of new format
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/11/2016: add indchanselect
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/20/2016: add mhs amsu-a
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/13/2017: new reading for daily Star atms
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/15/2017: for atms only
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/17/2018: azm channel

qual = [];
tb = [];
eia = [];
lat = [];
lon = [];
time = [];
azm = [];
sc_h = [];
sc_lat = [];
sc_lon = [];

% read data
switch RadDataInfo.sensor
    case 'amsr2'
        switch RadDataInfo.level
            case '1C' % read TB from PPS 1C file
                [tb_low,qual_low,eia_low,lat_low,lon_low,time_low,sc_h_low,sc_lat_low,sc_lon_low,...
                    tb_high,qual_high,eia_high,lat_high,lon_high] = read_pps_amsr2_1c(inpath,infile);
                % slice, or merge
                tb=tb_low;
                qual=qual_low;
                eia=eia_low;
                lat=lat_low;
                lon=lon_low;
                time=time_low;
                sc_h=sc_h_low;
                sc_lat=sc_lat_low;
                sc_lon=sc_lon_low;
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'amsr-e'
        switch RadDataInfo.level
            case '1C' % read TB from PPS 1C file
                [tb_low,qual_low,eia_low,lat_low,lon_low,time_low,sc_h_low,sc_lat_low,sc_lon_low,...
                    tb_high,qual_high,eia_high,lat_high,lon_high] = read_pps_amsre_1c(inpath,infile);
                tb=tb_low;
                qual=qual_low;
                eia=eia_low;
                lat=lat_low;
                lon=lon_low;
                time=time_low;
                sc_h=sc_h_low;
                sc_lat=sc_lat_low;
                sc_lon=sc_lon_low;
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'amsu-a'
        [time,tb,lat,lon,eia,azm,sc_h,wn] = read_bin_AMSU_A(inpath,filename.united);
        qual = abs(lat)>90;
        
    case 'amsu-b'
        switch RadDataInfo.level
            case '1C' % read TB from PPS 1C file
                [tb,qual,eia,lat,lon,time,sc_h,sc_lat,sc_lon] = read_pps_amsub_1c(inpath,infile);
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'atms'
        switch RadDataInfo.level
            case 'TDRdaily' % daily file
                [lat,lon,time,eia,qual1,azm] = read_hdf5_atms_daily_geo(inpath,filename.united);
                [tb,qual2] = read_hdf5_atms_daily_tdr(inpath,filename.tdr,indchanselect);
                qual = qual1|qual2;
                n = size(tb,3);
                eia = eia(:,:,ones(n,1));
                azm = azm(:,:,ones(n,1));
                lat = lat(:,:,1);
                lon = lon(:,:,1);
            case 'SDRdaily' % daily file
                [lat,lon,time,eia,qual1,azm] = read_hdf5_atms_daily_geo(inpath,filename.united);
                [tb,qual2] = read_hdf5_atms_daily_sdr(inpath,filename.sdr,indchanselect);
                qual = qual1|qual2;
                n = size(tb,3);
                eia = eia(:,:,ones(n,1));
                azm = azm(:,:,ones(n,1));
                lat = lat(:,:,1);
                lon = lon(:,:,1);
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
    case 'gmi'
        switch RadDataInfo.level
            case '1C' % read TB from PPS 1C file
                [tb,qual,eia,lat,lon,time] = read_pps_gmi_1c(inpath,infile,indchanselect);
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'mhs'
        % NOAA KLM binary format in big-endian w/ header
        [time,lat,lon,eia,cc,cw,cs,tw,tb,wn,ind_tw,sc_h,azm] = read_bin_KLM_MHS_L1B(inpath,filename.united);
        qual = abs(lat)>90;
        
    case 'smap'
        switch RadDataInfo.level
            case '1B' % read TB from 1B file
                [tb,qual,eia,lat,lon,time] = read_smap_1b(inpath,filename.united,indchanselect);
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'ssmi'
        switch RadDataInfo.level
            case '1C' % read TB from 1B file
                [tb_low,qual_low,eia_low,lat_low,lon_low,time_low,sc_h_low,sc_lat_low,sc_lon_low,tb_high,qual_high,eia_high,lat_high,lon_high] = read_pps_ssmi_1c(inpath,infile);
                tb=tb_low;
                qual=qual_low;
                eia=eia_low;
                lat=lat_low;
                lon=lon_low;
                time=time_low;
                sc_h=sc_h_low;
                sc_lat=sc_lat_low;
                sc_lon=sc_lon_low;
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'ssmis'
        switch RadDataInfo.level
            case '1C' % read TB from 1B file
                [tb,qual,eia,lat,lon,time] = read_smap_1b(inpath,filename.united,indchanselect);
            otherwise
                error(['No such level: ',RadDataInfo.level])
        end
        
    case 'tempest-d'
        [time,lat,lon,eia,tb,scanangle] = read_tempestd_1b(inpath,infile);
        
    case 'tropics'
        [chan_freq,ind_band,time,lat,lon,eia,ta,scan,nedt_nd,nedt_ds,qual,sc_ecef] = read_tropics_1a(inpath,infile);
        
        
    otherwise
        error(['No ',RadDataInfo.sensor])
end


if exist('sc_lat','var')
    sc_lat = lat(round(end/2),:);
end
if exist('sc_lon','var')
    sc_lon = lon(round(end/2),:);
end
if exist('sc_h','var')
    sc_h = 800*ones(size(sc_lat));
end

