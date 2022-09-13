function prof_write_4sim_mat(outpath,outfile,npixel,nlevel,nchannel,ncrosstrack,nalongtrack,lat,lon,eia,azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_q_level,landseafrac)
% write files of atmospheric profiles and surfaces collocated w/ satellite FOV
% 
% Input:
%         outpath,              output path,                        string
%         outfile,              output filename,                    string
%         lat,                  FOV latitude(degree),               [crosstrack,alongtrack]
%         lon,                  FOV longitude(degree)[-180,180),    [crosstrack,alongtrack]              
%         eia,                  FOV EIA (degree),                   [crosstrack,alongtrack,nchannel]  
%         azm,                  FOV azimuth angle(degree),          [crosstrack,alongtrack,nchannel]  
%         scanangle,            scan angle (degree),                [crosstrack,alongtrack]
%         sc_h,                 spacecraft altitude (km),           [1,nalongtrack] 
%         sc_lat,               spacecraft latitude (degree),       [1,nalongtrack] 
%         sc_lon,               spacecraft longitude (degree),      [1,nalongtrack]
%         sfc_tmp               surface tempertaure (K),            [crosstrack,alongtrack]
%         sfc_ws                surface wind speed (w/s)            [crosstrack,alongtrack]
%         atm_pres_interface,   atm. pressure interface (mb),       [nlevel+1,crosstrack,alongtrack]    nlevel is top-down
%         atm_pres_level(mb),   atm. pressure level                 [nlevel,crosstrack,alongtrack],           
%         atm_tmp_level,        atm. temperature (K),               [nlevel,crosstrack,alongtrack],           
%         atm_q_level,          atm. specific humidity (kg/kg),     [nlevel,crosstrack,alongtrack],     
%         landseafrac,          land-sea fraction (0=sea,1=land)    [crosstrack,alongtrack]           
%                               e.g.0.3=30% land,70% sea
%         npixel,               No. of pixel                        scalar              npixel=cross-track * along-track
%         nlevel,               No. of level                        scalar              nlevel is top-down  
%         nchannel,             No. of channel                      scalar              
%         ncrosstrack,          No. of crosstrack                   scalar              
%         nalongtrack,          No. of alongtrack                   scalar              
% Output:
%         profiles
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/01/2019: remove altitude and humrel


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


save([outpath,'/',outfile],'npixel','nchannel','nlevel','ncrosstrack','nalongtrack',...
    'lat','lon','eia','azm','scanangle','sc_h','sc_lat','sc_lon','sfc_tmp','sfc_ws','atm_pres_interface','atm_pres_level','atm_tmp_level','atm_q_level','landseafrac');

