function saterr_set_profile
% setting for customizing atmospheric profile
% 
% Input:
%       setting atmospheric profiles, where 6 typical atmospheric profiles can be chosen or you can import and customize your own ones.
%
% Output:
%       Prof.atm_pres,      pressure (mb),              [altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_tmp,       temperature (K),            [altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_q,         specific humidity (kg/kg),  [altitude(top-down),crosstrack,alongtrack]
%
% Description:
%       6 typical atmospheric profile: 
%       Tropical,Midlatitude_Summer,Midlatitude_Winter,Subarctic_Summer,Subarctic_Winter,US_Standard_Atmosphere
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/06/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/06/2019: add customize option
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/07/2019: add reanalysis option

global Rad Prof Path

Prof.onoff = 1; % 0=off,1=on

if Prof.onoff == 1
    % -----------------------------
    % setting
    % -----------------------------
    % 7 options: 6 typical atmospheric profiles, and customize
    % US_Standard_Atmosphere,Tropical,Midlatitude_Summer,Midlatitude_Winter,Subarctic_Summer,Subarctic_Winter,
    % customize,Reanalysis
    Prof.type = 'US_Standard_Atmosphere'; % US_Standard_Atmosphere/Tropical/Midlatitude_Summer/Midlatitude_Winter/Subarctic_Summer/Subarctic_Winter/customize/Reanalysis
    
    if Path.scheme=='B' % scheme B use reanalysis data
        Prof.type = 'reanalysis';
    end
    switch Prof.type
        case {'US_Standard_Atmosphere','Tropical','Midlatitude_Summer','Midlatitude_Winter','Subarctic_Summer','Subarctic_Winter'}
            
        case {'customize'}
            % customize profiles here:
            n1 = Rad.ind_CT_num(1);
            n2 = Rad.num_alongtrack;
            Prof.atm_pres = zeros(n1,n2); % pressure (mb),              [altitude,crosstrack,alongtrack]
            Prof.atm_tmp = zeros(n1,n2);  % temperature (K),            [altitude,crosstrack,alongtrack]
            Prof.atm_q = zeros(n1,n2);    % specific humidity (kg/kg),  [altitude,crosstrack,alongtrack]
            
            [atm_pres,atm_tmp,atm_H20_mr] = atm_6prof('US_Standard_Atmosphere','H2O');
            atm_H20_mr = atm_H20_mr*1e-3; % kg/kg
            atm_q = humconvert('MR2SH',atm_H20_mr);
            
            Prof.atm_pres = repmat(atm_pres,[1,n1,n2]); % size=[num_crosstrack,num_alongtrack], unit (mb)
            Prof.atm_tmp = repmat(atm_tmp,[1,n1,n2]);  % size=[num_crosstrack,num_alongtrack], unit (K)
            Prof.atm_q = repmat(atm_q,[1,n1,n2]);    % size=[num_crosstrack,num_alongtrack], unit (kg/kg)
        case {'reanalysis'}
            % saterr_set_path_scheme.m
            % Prof.ana.name = Path.ana.path;
            % Prof.ana.path = Path.ana.name;
            
        otherwise
            error('Prof.type is wrong')

    end
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_profile
    
end
