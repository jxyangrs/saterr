function saterr_imp_prof_load(inpath,infile)
% determining scanning geometry from the observations (SC and FOV geolocation)
%
% Input:
%       satellite geometry and profiles from reanalysis
%
% Output:
%       Orbit,      satellite geometry          
%       Prof,       reanalysis profiles      
%
% Description:
%       'Real_SCFOV' is used in saterr_imp_scanning.m
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit Prof


% -----------------------------
% load profiles and satellite geo
% -----------------------------
opt_infile = 1; % 1=MAT, 2=binary
switch opt_infile
    case 1
        [npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
            fov_lat,fov_lon,fov_eia,fov_azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_q_level,landseafrac] = prof_read_4sim_mat(inpath,infile);
    case 2
        [npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
            fov_lat,fov_lon,fov_eia,fov_azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_q_level,landseafrac] = prof_read_4sim_bin(inpath,infile);
end

[n1,n2,n3] = size(fov_eia);

% -----------------------------
% SC and FOV geo
% -----------------------------

% basic geo info
Orbit.fov.lat = fov_lat;     
Orbit.fov.lon = fov_lon;      
Orbit.fov.eia = fov_eia(:,:,1);      
Orbit.fov.az = fov_azm(:,:,1);      

% advanced geo info
% variables can be assigned if observations are available
Orbit.sc.ind_center = round(n1/2); % crosstrack center index (e.g. [15] out of 30)
Orbit.sc.time = ''; 
Orbit.sc.lat = sc_lat;
Orbit.sc.lon = sc_lon;
Orbit.sc.h = sc_h;

% -----------------------------
% profile
% -----------------------------
Prof.atm_pres = atm_pres_level;
Prof.atm_tmp = atm_tmp_level;
Prof.atm_q = atm_q_level;
Prof.sfc_tmp = sfc_tmp;
Prof.sfc_ws = sfc_ws;
Prof.landseafrac = landseafrac;
