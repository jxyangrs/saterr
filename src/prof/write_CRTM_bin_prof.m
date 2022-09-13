function write_CRTM_bin_prof(outpath,outfile,...
    num_pixel,num_layer,num_channel,...
    lat,lon,eia,azm,scanangle,sfc_tmp,sfc_ws,atm_H,atm_pres_level,atm_pres_layer,atm_tmp,atm_humspc,atm_humrel,landseafrac)
% write binary file for running RTM with atmospheric profile and surface
% (% eia, azm, tb_obs are channel dependent and should have the same size)
% 
% Input:
%         outpath,outfile
%         num_pixel               scalar
%         num_layers,             scalar              
%         num_channel,            scalar
% 
%         lat         (degree),   npixel
%         lon,        (degree),   npixel              [0,360)
%         eia,        (degree),   [npixel,nchannel]  
%         azm,        (degree),   [npixel,nchannel]  
%         scanangle,  (degree),   npixel
%         sfc_tmp     (K),        npixel
%         sfc_ws      (w/s)       npixel
%         atms_H      (km),       [nlayer,npixel],     bottom-up
%         atm_pres_level(mb),     [nlayer+1,npixel]    bottom-up       
%         atm_pres_layer(mb),     [nlayer,npixel],     bottom-up       
%         atm_tmp     (K),        [nlayer,npixel],     bottom-up       
%         atm_humspc  (kg/kg),    [nlayer,npixel],     bottom-up      >=0
%         atm_humrel  (%),        [nlayer,npixel],     bottom-up      -999=bad value
%         landseafrac             [npixel,1]           (0=sea,1=land,0.3=30% land,70% sea)
% 
% Output:
%         profile for running CRTM
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/16/2018: refine


fid = fopen([outpath,outfile],'w');

% number of profiles and vertical layers
fwrite(fid,num_pixel,'int32');
fwrite(fid,num_layer,'int32');
fwrite(fid,num_channel,'int32');

fwrite(fid,lat,'float32');
fwrite(fid,lon,'float32');
fwrite(fid,eia,'float32');
fwrite(fid,azm,'float32');
fwrite(fid,scanangle,'float32');

fwrite(fid,sfc_tmp,'float32');
fwrite(fid,sfc_ws,'float32');

fwrite(fid,atm_H,'float32');
fwrite(fid,atm_pres_level,'float32');
fwrite(fid,atm_pres_layer,'float32');
fwrite(fid,atm_tmp,'float32');
fwrite(fid,atm_humspc,'float32');
fwrite(fid,atm_humrel,'float32');

fwrite(fid,landseafrac,'float32');

fclose(fid);





