function [aux_latgeo,aux_longeo,aux_atm_pres_interface,...
    aux_atm_pres,aux_atm_t,aux_atm_q,aux_sfc_ws,aux_sfc_skt,aux_sfc_pres,aux_sfc_sst]=prof_atmsfc(ana_datainfo,idateaux)
% read reanalysis data and interpolate if necessary
%   ERA5-ml-137 can be used as 137-level or 91-level
%   ERA5-pl-37 is interpolated to 91-level
%   
% Input:
%         ana_datainfo,                 data information of reanalysis data
%               .name,                      name of reanalysis data
%               .path,                      rootpath of reanalysis data
%               .fileID,                    rootpath of reanalysis data
%         idateaux,                     string yyyymmddHH
% 
% Output (137/91):
%         aux_latgeo (degree)           [n1(ascend),1]  ranging [-90,90]
%         aux_longeo (degree)           [n2(ascend),1]  ranging [0,360)
%         aux_atm_pres_interface (Pa)   [n1(ascend),n2(ascend),n3+1(bottom-up)]
%         aux_atm_pres (Pa)             [n1(ascend),n2(ascend),n3(bottom-up)]
%         aux_atm_t (K)                 [n1(ascend),n2(ascend),n3(bottom-up)]
%         aux_atm_q (Kg/Kg)             [n1(ascend),n2(ascend),n3(bottom-up)]
%         aux_sfc_ws (m/s)              [n1(ascend),n2(ascend)]
%         aux_sfc_skt (K)               [n1(ascend),n2(ascend)]                     sst for over-ocean, skin-temp for over-land
%         aux_sfc_sst (K)               [n1(ascend),n2(ascend)]                     land=NaN
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/19/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/23/2020: refine; output sst


switch ana_datainfo.name
    case 'era5-137' % ERA5 at model-level of 137 levels
        % read
        inpath = [ana_datainfo.path,'/',idateaux(1:4),'/',idateaux(1:8)];
        infileID = [ana_datainfo.fileID,idateaux(1: 10),'.nc']; % e.g. era5_ana_ml_137_umd_2019060100.nc
        fileinfo = dir([inpath,'/',infileID]);
        if isempty(fileinfo)
            error(['reanalysis data not found: ',inpath,'/',infileID])
        end
        infile = fileinfo.name;
        disp(infile)
        
        [aux_latgeo,aux_longeo,aux_atm_t,aux_atm_q,aux_sfc_pres,sfc_10u,sfc_10v,aux_sfc_skt,aux_sfc_sst] = ...
            ec_read_era5_ana_ml_137_sfc_umd(inpath,infile);
        aux_sfc_ws = sqrt(sfc_10u.^2 + sfc_10v.^2);
        
        if 1 % replace ocean w/ sst
            idx = ~isnan(aux_sfc_sst);
            aux_sfc_skt(idx) = aux_sfc_sst(idx);
        end
        
        [aux_atm_pres_interface,aux_atm_pres] = ECMWF_pres_sfc2atm_L137(aux_sfc_pres);
        
        % make the order as [lat,lon,layer] == [ascending,ascending,ascending]
        aux_atm_pres_interface = permute(aux_atm_pres_interface,[2,1,3]); % dimension of [lat,lon,altitude]
        aux_atm_pres = permute(aux_atm_pres,[2,1,3]); 
        aux_atm_t = permute(aux_atm_t,[2,1,3]); 
        aux_atm_q = permute(aux_atm_q,[2,1,3]); 
        
        aux_atm_pres_interface = aux_atm_pres_interface(end:-1:1,:,end:-1:1); % in the order of ascending
        aux_atm_pres = aux_atm_pres(end:-1:1,:,end:-1:1);
        aux_atm_t = aux_atm_t(end:-1:1,:,end:-1:1);
        aux_atm_q = aux_atm_q(end:-1:1,:,end:-1:1);
        
        aux_sfc_pres = aux_sfc_pres(:,end:-1:1)';
        aux_sfc_ws = aux_sfc_ws(:,end:-1:1)';
        aux_sfc_skt = aux_sfc_skt(:,end:-1:1)';
        aux_sfc_sst = aux_sfc_sst(:,end:-1:1)';
        
        aux_latgeo = aux_latgeo(end:-1:1);
        aux_latgeo = aux_latgeo(:); 
        aux_longeo = aux_longeo(:); 
        
    case 'era5-37' % ERA5 at pressure-level of 37 levels
        % load data
        inpath = [ana_datainfo.path,'/',idateaux(1:4),'/',idateaux(1:8)];
        infileID = [ana_datainfo.fileID,idateaux(1: 10),'.nc']; % e.g. era5_ana_pl_37_sfc_umd_2019060100.nc
        fileinfo = dir([inpath,'/',infileID]);
        if isempty(fileinfo)
            error(['reanalysis data not found: ',inpath,'/',infileID])
        end
        infile = fileinfo.name;
        disp(infile)
        
        [aux_latgeo,aux_longeo,aux_atm_pres1D,aux_atm_t_layer,aux_atm_q_layer,aux_sfc_pres,sfc_u10,sfc_v10,aux_sfc_skt,aux_sfc_sst] = ucar_read_era5_ana_pl_37_sfc_umd(inpath,infile);
        aux_sfc_ws = sqrt(sfc_u10.^2+sfc_v10.^2);

        if 1 % replace ocean w/ sst
            idx = ~isnan(aux_sfc_sst);
            aux_sfc_skt(idx) = aux_sfc_sst(idx);
        end
        
        % interpolation
        [aux_atm_pres_interface,aux_atm_pres,aux_atm_t,aux_atm_q] = prof_interp_atm(aux_sfc_pres,aux_atm_pres1D,aux_atm_t_layer,aux_atm_q_layer);

        % make the order as [lat,lon,layer] == [ascending,ascending,ascending]
        aux_atm_pres_interface = permute(aux_atm_pres_interface,[2,1,3]);
        aux_atm_pres = permute(aux_atm_pres,[2,1,3]);
        aux_atm_t = permute(aux_atm_t,[2,1,3]);
        aux_atm_q = permute(aux_atm_q,[2,1,3]);
        
        aux_atm_pres_interface = aux_atm_pres_interface(end:-1:1,:,end:-1:1);
        aux_atm_pres = aux_atm_pres(end:-1:1,:,end:-1:1);
        aux_atm_t = aux_atm_t(end:-1:1,:,end:-1:1);
        aux_atm_q = aux_atm_q(end:-1:1,:,end:-1:1);
        
        aux_latgeo = aux_latgeo(end:-1:1);
        aux_sfc_pres = aux_sfc_pres(:,end:-1:1)';
        aux_sfc_ws = aux_sfc_ws(:,end:-1:1)';
        aux_sfc_skt = aux_sfc_skt(:,end:-1:1)';
        aux_sfc_sst = aux_sfc_sst(:,end:-1:1)';
        
    otherwise 
        error([ana_name,' not found'])
end
