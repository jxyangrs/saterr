function saterr_set_noiseadditive
% setting additive noise
%
% Input:
%       setting noise
% 
% Output:
%       Noise
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: noise setting
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: type-chan sytax change

global Noise Rad

% -----------------------------
% setting
% -----------------------------
Noise.addnoise.onoff = 1; % 0=off,1=on

% setting of noise
if Noise.addnoise.onoff==1
    Noise.addnoise.source = Rad.sensor;
    
    switch Noise.addnoise.source
        case {'demo','customize'} % Simple/customize
            % setting
            saterr_set_noiseadditive_cust
            
        case {'amsr-e','amsr2','amsu-a','amsu-b','atms','gmi','mhs','mwri','mwhs-2','mwts-2','smap','ssmi','ssmis','tempest-d','tms'} % sensor
            % setting
            saterr_set_noiseadditive_sensor
           
        otherwise
            error('Noise.source is wrong')
    end
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_noiseadditive
end