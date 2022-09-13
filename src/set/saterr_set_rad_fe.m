function saterr_set_rad_fe
% setting front-end receiver including temperature (warm/cold/scene) and gain
%
% Input:
%       front-end setting
% 
% Output:
%       Rad.Tc,     cold space temperature,     [1,channel]
%       Rad.Tw,     warm-load temperature,      [1,channel]
%       Rad.Ts,     scene temperature,          [1,channel]
%       Rad.Tr,     receiver temperature,       [1,channel]
%       Rad.G,      gain,                       [1,channel]     
%
% Description:
%       Equation of TA to count:    (Ta+Tr)G=Count
%       These parameters are mean. Effect of orbital osciallation can be set in saterr_set_oscil.m
%       Further setting for scene temperature is in radsim_set_scenetarget.m, which can overwrite the setting here
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: noise setting

global Rad

% -----------------------------
% setting
% -----------------------------
switch Rad.sensor
    case {'demo'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = 2.725*ones(1,5); % cold space temperature
        Rad.Tw = 284.8*ones(1,5); % warm-load temperature
        Rad.Ts = 284.8*ones(1,5); % scene temperature
        Rad.Tr = [328.9,392.9,329.8,326.0,347.6]; % receiver temperature
        Rad.G  = [161.6,115.3,165.4,162.7,131.6]; % gain: (Ta+Tr)G=Count
        
    case {'customize'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = 2.725*ones(1,5); % cold space temperature
        Rad.Tw = 284.8*ones(1,5); % warm-load temperature
        Rad.Ts = 284.8*ones(1,5); % scene temperature
        Rad.Tr = [328.9,392.9,329.8,326.0,347.6]; % receiver temperature
        Rad.G  = [161.6,115.3,165.4,162.7,131.6]; % gain
        
    case {'amsr2'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.94]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [260.1]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [199.8]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [337.9]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [41.2]*ones(1,Rad.num_chan); % gain

    case {'amsr-e'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [260.1]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [199.8]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [337.9]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [41.2]*ones(1,Rad.num_chan); % gain
        
    case {'amsu-a'}
        % noaa-19
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = 2.725*ones(1,15);
        Rad.Tw = [288.75,288.75,279.80,279.80,279.80,279.80,279.80,279.80,279.80,279.80,279.80,279.80,279.80,279.80,279.80];
        Rad.Ts = [205.45,197.93,237.29,251.29,244.75,231.62,222.75,219.26,213.30,216.90,223.62,233.01,243.93,253.60,232.80];
        Rad.Tr = [1476.56,1050.22,1220.86,1104.87,1137.16,1047.35,1392.03,2055.41,1179.71,1170.67,1088.06,1062.37,1080.94,1045.82,1545.73];
        Rad.G  = [8.89,14.33,12.38,13.22,13.01,15.52,13.82, 4.71,13.55,13.78,17.53,18.79,17.86,20.36,11.13];
        
    case {'amsu-b'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [281]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [900]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [10]*ones(1,Rad.num_chan); % gain
        
    case {'atms'}
        switch Rad.spacecraft
            case {'npp'}
                % parameters of orbital mean, size [1,Rad.num_chan]
                Rad.Tc = 2.725*ones(1,22);
                Rad.Tw = [281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281];
                Rad.Ts = [205.45,197.93,237.29,251.29,244.75,231.62,222.75,219.26,213.30,216.90,223.62,233.01,243.93,253.60,232.80];
                Rad.Tr = [101,232,329,302,315,333,335,322,484,350,362,341,352,341,344,611,1101,1266,1238,1267,1307,1267];
                Rad.G  = [37.86,48.32,38.26,36.21,33.56,34.47,27.42,31.16,31.66,33.74,34.05,37.79,38.56,40.47,39.65,35.08,16.64,14.36,14.6,15.59,15.29,14.52];

            case {'n20'}
                % parameters of orbital mean, size [1,Rad.num_chan]
                Rad.Tc = 2.725*ones(1,22);
                Rad.Tw = [281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281,281];
                Rad.Ts = [205.45,197.93,237.29,251.29,244.75,231.62,222.75,219.26,213.30,216.90,223.62,233.01,243.93,253.60,232.80];
                Rad.Tr = [101,232,329,302,315,333,335,322,484,350,362,341,352,341,344,611,1101,1266,1238,1267,1307,1267];
                Rad.G  = [37.86,48.32,38.26,36.21,33.56,34.47,27.42,31.16,31.66,33.74,34.05,37.79,38.56,40.47,39.65,35.08,16.64,14.36,14.6,15.59,15.29,14.52];
            
            otherwise
                error('Rad.spacecraft is wrong')
        end
        
    case {'gmi'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.94]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [260.1]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [199.8]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [337.9]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [41.2]*ones(1,Rad.num_chan); % gain
        
    case {'mhs'}
        switch Rad.spacecraft
            case 'noaa-19'
                % parameters of orbital mean
                Rad.Tc = 2.725*ones(1,5); % cold space temperature
                Rad.Tw = [282.05,282.05,282.05,282.05,282.05]; % warm-load temperature
                Rad.Ts = [232.20,252.86,245.61,256.12,260.76]; % scene temperature
                Rad.Tr = [351.02, 334.19,2285.07, 391.62, 370.71]; % receiver temperature
                Rad.G  = [134.46,128.56, 12.38,101.96,126.32]; % gain
            case 'metop-a'
                % parameters of orbital mean
                Rad.Tc = 2.725*ones(1,5); % cold space temperature
                Rad.Tw = 284.8*ones(1,5); % warm-load temperature
                Rad.Ts = [231,248,245,254,256]; % scene temperature
                Rad.Tr = [328.9,392.9,329.8,326.0,347.6]; % receiver temperature
                Rad.G  = [161.6,115.3,165.4,162.7,131.6]; % gain
                
            otherwise
                % using metop-a parameters
                Rad.Tc = 2.725*ones(1,5); % cold space temperature
                Rad.Tw = 284.8*ones(1,5); % warm-load temperature
                Rad.Ts = [231,248,245,254,256]; % scene temperature
                Rad.Tr = [328.9,392.9,329.8,326.0,347.6]; % receiver temperature
                Rad.G  = [161.6,115.3,165.4,162.7,131.6]; % gain
        end
        
    case {'mwri'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [280]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [350]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [40]*ones(1,Rad.num_chan); % gain
        
    case {'mwhs-2'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [280]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [350]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [40]*ones(1,Rad.num_chan); % gain
        
    case {'mwts-2'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [280]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [350]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [40]*ones(1,Rad.num_chan); % gain
        
    case {'smap'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [260.1]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [199.8]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [337.9]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [41.2]*ones(1,Rad.num_chan); % gain
        
    case {'ssmi'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [289]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [250]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [9]*ones(1,Rad.num_chan); % gain

    case {'ssmis'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [306]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [350]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [28.7]*ones(1,Rad.num_chan); % gain

    case {'tempest-d'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [281]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [340]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [600]*ones(1,Rad.num_chan); % gain

    case {'tms'}
        % parameters of orbital mean, size [1,Rad.num_chan]
        Rad.Tc = [2.7]*ones(1,Rad.num_chan); % cold space temperature
        Rad.Tw = [278]*ones(1,Rad.num_chan); % warm-load temperature
        Rad.Ts = [200]*ones(1,Rad.num_chan); % scene temperature
        Rad.Tr = [350]*ones(1,Rad.num_chan); % receiver temperature
        Rad.G  = [702]*ones(1,Rad.num_chan); % gain

    otherwise
        error('Noise.source is wrong')
end



