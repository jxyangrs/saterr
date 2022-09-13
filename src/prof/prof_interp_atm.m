function [atm_pres_interface,atm_pres_level,varargout] = prof_interp_atm(sfc_pres,atm_pres1D_level,varargin)
% interpolating atmospheric profiles
% n-level to m-level and (m+1) interface (e.g. n=37, m=91)
%
% Input:
%       sfc_pres,               surface pressure (Pa),          [lon,lat]
%       atm_pres1D_level,       atm pressure (Pa),              [level(up-down;n),1]
%       varargin,               atm variables,                  [lon,lat,level(up-down;n)]
%       (original profiles)     (e.g. temperature (K), specific humidity (kg kg^-1))
% 
% Output:
%       atm_pres_interface,     atm pressure (Pa),              [lon,lat,level(up-down;m+1)]
%       atm_pres_level,         atm pressure (Pa),              [lon,lat,level(up-down;m)]
%       varargout,              interpolated variables          [lon,lat,level(up-down;m)]
%       (interpolated profiles)
% 
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/11/2020: separate reading and interpolating

% profiles for interpolation
switch 1
    case 1
        % pressure level=92, level=91
        [atm_pres_interface,atm_pres_level] = ECMWF_pres_sfc2atm_L91(sfc_pres);
    case 2
        % pressure level=138, level=137
        [atm_pres_interface,atm_pres_level] = ECMWF_pres_sfc2atm_L137(sfc_pres);
end

% a) interpolate w/ linear interpolation and extrapolation
% Hi = atm_pres_level;
% [n1,n2,n3] = size(atm_tmp_level);
% H(1,1,:) = atm_pres1D_level(:);
% H = repmat(H,[n1,n2,1]);
% [atm_tmp_level,atm_q_level] = interp_lin_3D_asc(Hi,H,atm_tmp_level,atm_q_level);

% b) interpolate within the bounds, no extrapolation
Hi = atm_pres_level;
[n1,n2] = size(sfc_pres);

toa_level = atm_pres_level(:,:,1);
toa_level = min(toa_level(:));

if toa_level<atm_pres1D_level(1)
    % add a top level and a bottom level
    H(1,1,:) = [toa_level;atm_pres1D_level(:);atm_pres1D_level(end)+10];
    H = repmat(H,[n1,n2,1]);
    for i=1: length(varargin)
        x = varargin{i};
        x = x(:,:,[1,1:end,end]);
        varargin{i} = x;
    end
else
    % adding a bottom level
    H(1,1,:) = [atm_pres1D_level(:);atm_pres1D_level(end)+10];
    H = repmat(H,[n1,n2,1]);
    for i=1: length(varargin)
        x = varargin{i};
        x = x(:,:,[1:end,end]);
        varargin{i} = x;
    end
end

for i=1: length(varargin)
    x = varargin{i};
    x = interp_lin_3D_asc(Hi,H,x);
    varargout{i} = x;
end


