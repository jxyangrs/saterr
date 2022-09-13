function [npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
    lat,lon,eia,azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_q_level,landseafrac] = ...
    prof_read_4sim_bin(inpath,infile)
% read atmospheric profiles and surfaces collocated with satellite FOV
% 
% Input:
%         inpath,               intput path,                        string
%         infile,               intput filename,                    string
% 
% Output:
%         nvar,                 No. of geo variables                scalar              npixel=cross-track * along-track
%         npixel,               No. of pixel                        scalar              npixel=cross-track * along-track
%         nlevel,               No. of level                        scalar              nlevel is top-down  
%         nchannel,             No. of channel                      scalar              
%         ncrosstrack,          No. of channel                      scalar              
%         nalongtrack,          No. of channel                      scalar              
%         lat,                  latitude(degree),                   [ncrosstrack,nalongtrack]
%         lon,                  longitude(degree)[0,360),           [ncrosstrack,nalongtrack]              
%         eia,                  EIA (degree),                       [ncrosstrack,nalongtrack,nchannel]  
%         azm,                  azimuth angle(degree),              [ncrosstrack,nalongtrack,nchannel]  
%         scanangle,            scan angle (degree),                [ncrosstrack,nalongtrack]
%         sc_h,                 spacecraft altitude (km),           [1,nalongtrack]/[ncrosstrack,nalongtrack]  
%         sc_lat,               spacecraft latitude (degree),       [1,nalongtrack]/[ncrosstrack,nalongtrack]  
%         sc_lon,               spacecraft longitude (degree),      [1,nalongtrack]/[ncrosstrack,nalongtrack]  
%         sfc_tmp               surface tempertaure (K),            [ncrosstrack,nalongtrack]
%         sfc_ws                surface wind speed (w/s)            [ncrosstrack,nalongtrack]
%         atm_pres_interface,   atm. pressure interface (mb),       [nlevel+1,ncrosstrack,nalongtrack]    nlevel is top-down
%         atm_pres_level(mb),   atm. pressure level                 [nlevel,ncrosstrack,nalongtrack],           
%         atm_tmp_level,        atm. temperature (K),               [nlevel,ncrosstrack,nalongtrack],           
%         atm_q_level,          atm. specific humidity (kg/kg),     [nlevel,ncrosstrack,nalongtrack],     
%         landseafrac,          land-sea fraction (0=sea,1=land)    [ncrosstrack,nalongtrack]           
%                               e.g.0.3=30% land,70% sea
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/01/2019: remove altitude and humrel


fid = fopen([inpath,'/',infile],'r','ieee-le');

nvar = fread(fid,1,'int32');
npixel = fread(fid,1,'int32');
nlevel = fread(fid,1,'int32');
nchannel = fread(fid,1,'int32');
ncrosstrack = fread(fid,1,'int32');
nalongtrack = fread(fid,1,'int32');

lat = fread(fid,[npixel,1],'float32');
lon = fread(fid,[npixel,1],'float32');
eia = fread(fid,[npixel,nchannel],'float32');
azm = fread(fid,[npixel,nchannel],'float32');
scanangle = fread(fid,[npixel,1],'float32');
sc_h = fread(fid,[nalongtrack,1],'float32');
sc_lat = fread(fid,[nalongtrack,1],'float32');
sc_lon = fread(fid,[nalongtrack,1],'float32');

sfc_tmp = fread(fid,[npixel,1],'float32');
sfc_ws = fread(fid,[npixel,1],'float32');

atm_pres_interface = fread(fid,[nlevel+1,npixel],'float32');
atm_pres_level = fread(fid,[nlevel,npixel],'float32');
atm_tmp_level = fread(fid,[nlevel,npixel],'float32');
atm_q_level = fread(fid,[nlevel,npixel],'float32');

landseafrac = fread(fid,[npixel,1],'float32');

fclose(fid);

% reshape
lat = reshape(lat,[ncrosstrack,nalongtrack]);
lon = reshape(lon,[ncrosstrack,nalongtrack]);
eia = reshape(eia,[ncrosstrack,nalongtrack,nchannel]);
azm = reshape(azm,[ncrosstrack,nalongtrack,nchannel]);
scanangle = reshape(scanangle,[ncrosstrack,nalongtrack]);

sfc_tmp = reshape(sfc_tmp,[ncrosstrack,nalongtrack]);
sfc_ws = reshape(sfc_ws,[ncrosstrack,nalongtrack]);

atm_pres_interface = reshape(atm_pres_interface,[nlevel+1,ncrosstrack,nalongtrack]);
atm_pres_level = reshape(atm_pres_level,[nlevel,ncrosstrack,nalongtrack]);
atm_tmp_level = reshape(atm_tmp_level,[nlevel,ncrosstrack,nalongtrack]);
atm_q_level = reshape(atm_q_level,[nlevel,ncrosstrack,nalongtrack]);

landseafrac = reshape(landseafrac,[ncrosstrack,nalongtrack]);
