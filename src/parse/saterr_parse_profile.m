% parsing and preprocessing default profile
% 
% Output:
%   default
%       Prof.atm_pres,      pressure (mb),                          [altitude(top-down),1]
%       Prof.atm_tmp,       temperature (K),                        [altitude(top-down),1]
%       Prof.atm_q,         specific humidity (kg/kg),              [altitude(top-down),1]
%   customize
%       Prof.atm_pres,      pressure (mb),                          [altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_tmp,       temperature (K),                        [altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_q,         specific humidity (kg/kg),              [altitude(top-down),crosstrack,alongtrack]
%       
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code


% -------------------------
% checking and preprocessing
% -------------------------
Prof.default = {'Tropical','Midlatitude_Summer','Midlatitude_Winter','Subarctic_Summer','Subarctic_Winter','US_Standard_Atmosphere'};

switch Prof.type
    case Prof.default
        [Prof.atm_pres,Prof.atm_tmp,atm_H20_mr] = atm_6prof(Prof.type,'H2O');
        
        atm_H20_mr = atm_H20_mr*1e-3; % kg/kg
        atm_q = humconvert('MR2SH',atm_H20_mr);
        Prof.atm_q = atm_q; % specific humidity (kg/kg)
        
    case {'customize'}
        n1 = Rad.ind_CT_num(1);
        n2 = Rad.num_alongtrack;
        
        m1 = size(Prof.atm_pres);
        m2 = size(Prof.atm_tmp);
        m3 = size(Prof.atm_q);
        
        m = [m1;m2;m3];
        m = m(:,2:end);
        d = bsxfun(@minus,[n1,n2],m);
        if sum(d(:))>0
            error('Size of Prof.atm_pres, atm_tmp, atm_q should be [altitude,crosstrack,alongtrack]')
        end
        
    case {'reanalysis'}
        if ~isfield(Prof.ana,'name')
            error('Reanalysis profile name not specified: setting at saterr_set_path.m')
        end
         if ~isfield(Prof.ana,'path')
            error('Reanalysis profile path not specified: setting at saterr_set_path.m')
        end
       
        
    otherwise
        error('Prof.type is wrong')
end
