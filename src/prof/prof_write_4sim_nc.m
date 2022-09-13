function prof_write_4sim_nc(outpath,outfile,...
    nvar,npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
    lat,lon,eia,azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres,atm_tmp,atm_q,landseafrac)
% write files of atmospheric profiles and surfaces collocated w/ satellite FOV
% 
% Input:
%         outpath,              output path,                        string
%         outfile,              output filename,                    string
% 
%         nvar,                 No. of geo variables                scalar              npixel=cross-track * along-track
%         npixel,               No. of pixel                        scalar              npixel=cross-track * along-track
%         nlevel,               No. of level                        scalar              nlevel is top-down  
%         nchannel,             No. of channel                      scalar              
%         ncrosstrack,          No. of channel                      scalar              
%         nalongtrack,          No. of channel                      scalar              
%         lat,                  latitude(degree),                   [npixel,1]
%         lon,                  longitude(degree)[-180,180),        [npixel,1]              
%         eia,                  EIA (degree),                       [npixel,nchannel]  
%         azm,                  azimuth angle(degree),              [npixel,nchannel]  
%         scanangle,            scan angle (degree),                [npixel,1]
%         sc_h,                 spacecraft altitude (km),           [1,nalongtrack]/[ncrosstrack,nalongtrack]  
%         sc_lat,               spacecraft latitude (degree),       [1,nalongtrack]/[ncrosstrack,nalongtrack]  
%         sc_lon,               spacecraft longitude (degree),      [1,nalongtrack]/[ncrosstrack,nalongtrack]  
%         sfc_tmp               surface tempertaure (K),            [npixel,1]
%         sfc_ws                surface wind speed (w/s)            [npixel,1]
%         atm_pres_interface,   atm. pressure interface (mb),       [nlevel+1,npixel]    nlevel is top-down
%         atm_pres(mb),         atm. pressure level                 [nlevel,npixel],           
%         atm_tmp,              atm. temperature (K),               [nlevel,npixel],           
%         atm_q,                atm. specific humidity (kg/kg),     [nlevel,npixel],     
%         landseafrac,          land-sea fraction (0=sea,1=land)    [npixel,1]           
%                               e.g.0.3=30% land,70% sea
% 
% Output:
%         profiles
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/16/2018: refine
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/01/2020: remove altitude and humrel


fid = fopen([outpath,'/',outfile],'w','ieee-le');

% number of profiles and vertical layers
fwrite(fid,npixel,'int32');
fwrite(fid,nlevel,'int32');
fwrite(fid,nchannel,'int32');
fwrite(fid,ncrosstrack,'int32');
fwrite(fid,nalongtrack,'int32');

fwrite(fid,sc_h,'float32');
fwrite(fid,sc_lat,'float32');
fwrite(fid,sc_lon,'float32');

fwrite(fid,lat,'float32');
fwrite(fid,lon,'float32');
fwrite(fid,sfc_tmp,'float32');
fwrite(fid,sfc_ws,'float32');
fwrite(fid,scanangle,'float32');

fwrite(fid,eia,'float32');
fwrite(fid,azm,'float32');

fwrite(fid,atm_pres_interface,'float32');
fwrite(fid,atm_pres,'float32');
fwrite(fid,atm_tmp,'float32');
fwrite(fid,atm_q,'float32');

fwrite(fid,landseafrac,'float32');

fclose(fid);
