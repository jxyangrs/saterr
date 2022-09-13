function saterr_set_noiseadditive_sensor
% setting radiometer additive noise
%
% Input:
%       setting additive noise
% Output:
%       Noise.addnoise.type,                 subnoise type,                {type-1,type-2,...,type-n};size of [1,n]
%       Noise.addnoise.num_type,             No. of noise type,            scalar(=length(Noise.addnoise.type))
%       Noise.addnoise.chan_std_cold,        total noise of cold-end,      {channel-1,channel-2,...,channel-m};size of [1,m]
%       Noise.addnoise.type_cold_varfrac,    subnoise fraction,            {type-1,type-2,...,type-n};size of [1,n]
%       Noise.addnoise.chan_std_warm,        total noise of warm-end,      {channel-1,channel-2,...,channel-m};size of [1,m]
%       Noise.addnoise.type_warm_varfrac,    subnoise fraction,            {type-1,type-2,...,type-n};size of [1,n]
%       Noise.addnoise.chan_std_scene,       total noise of scene,         {channel-1,channel-2,...,channel-m};size of [1,m]
%       Noise.addnoise.type_scene_varfrac,   subnoise fraction,            {type-1,type-2,...,type-n};size of [1,n]
%       Noise.addnoise.chan_std_null,        total noise of null,          {channel-1,channel-2,...,channel-m};size of [1,m]
%       Noise.addnoise.type_null_varfrac,    subnoise fraction,            {type-1,type-2,...,type-n};size of [1,n]
%
% Syntax
%       Noise.addnoise.type,                 {type-1,type-2,...,type-n},
%       Noise.addnoise.chan_std_cold,        [1,channel]
%       Noise.addnoise.type_cold_varfrac,    {type-1 [1,channel],type-2 [1,channel],...,type-n [1,channel]};
%                                   range [0,1];  sum(type-1 to n) = 1
%
% Examples:
%       Noise.addnoise.type = {'thermal','1/f'};                             % 2 types noise of thermal and 1/f
%       Noise.addnoise.num_type = length(Noise.addnoise.type);                        % 2
%       Noise.addnoise.type_cold_varfrac = [1,1,1];                          % 3 channels w/ noise NEDT=1
%       Noise.addnoise.type_cold_varfrac = {[0.7,0.8,0.9],[0.3,0.2,0.1]};    % fraction of thermal and 1/f noise for each channel
%
% Table of noise type:
%       Noise type,     Description,                                    Slope of PSD  (S=f^alpha; S is PSD; slope=alpha)
%       RRFM,           random run frequency modulation (RRFM),         -4
%       FWFM,           flicker walk frequency modulation (FWFM),       -3
%       RWFM,           random walk frequency modulation (RWFM),        -2
%       1/f,            flicker noise,                                  -1
%       FFM,            flicker frequency modulation (FFM),             -1
%       thermal,        thermal (Additive White Gaussian Noise,AWGN),   0
%       WFM,            white frequency modulcation (WFM),              0
%       FPM,            frequency phase modulation (FPM),               1
%       quantization,   quantization                                    2,
%       WPM,            white phase modulation (WPM),                   2,
%       others,         other power-law noise or w/ diff. names,        alpha
%
%       signal-dependent noise, e.g. shot noise, is set in saterr_set_noisesigdep.m
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: noise setting
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: type-chan sytax change
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/14/2019: unify noise name

global Rad Noise
% -----------------------------
% setting
% -----------------------------
switch Rad.sensor
    
    case {'amsr-e'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.5*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 1*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'amsr2'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.5*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 1*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'amsu-a'}
        switch Rad.spacecraft
            case {'n19','metop-a'}
                %                 Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n; thermal/1/f/F_FM/quantization
                Noise.addnoise.type = {'thermal'}; % type-1,type-2,...,type-n; thermal/1/f/F_FM/quantization
                Noise.addnoise.num_type = length(Noise.addnoise.type);
                
                % --- Noise.addnoise.chan_std_cold, [1,channel]
                Noise.addnoise.chan_std_cold = [0.128,0.086,0.156,0.088,0.107,0.088,0.261,0.635,0.106,0.137,0.147,0.218,0.308,0.497,0.092];
                % --- Noise.addnoise.type_cold_varfrac, {type-1 [1,channel],type-2 [1,channel],...,type-n [1,channel]}; range [0,1]
                Noise.addnoise.type_cold_varfrac = {ones(1,15)};
                %                 Noise.addnoise.type_cold_varfrac = {...
                %                     1-[0.110,0.125,0.077,0.128,0.074,0.074,0.016,0.000,0.104,0.144,0.147,0.115,0.133,0.111,0.082],...
                %                     [0.110,0.125,0.077,0.128,0.074,0.074,0.016,0.000,0.104,0.144,0.147,0.115,0.133,0.111,0.082]};
                
                % --- Noise.addnoise.chan_std_warm, [1,channel]
                Noise.addnoise.chan_std_warm = [0.192,0.170,0.229,0.140,0.155,0.136,0.276,0.975,0.158,0.217,0.227,0.347,0.481,0.777,0.113];
                % --- Noise.addnoise.type_warm_varfrac, {type-1 [1,channel],type-2 [1,channel],...,type-n [1,channel]}; range [0,1]
                Noise.addnoise.type_warm_varfrac = {ones(1,15)};
                %                 Noise.addnoise.type_warm_varfrac = {...
                %                     1-[0.069,0.149,0.155,0.120,0.082,0.116,0.016,0.000,0.059,0.185,0.128,0.179,0.141,0.159,0.083],...
                %                     [0.069,0.149,0.155,0.120,0.082,0.116,0.016,0.000,0.059,0.185,0.128,0.179,0.141,0.159,0.083]};
                
                % --- Noise.addnoise.chan_std_scene, [1,channel]
                Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
                % --- Noise.addnoise.type_scene_varfrac, {type-1 [1,channel],type-2 [1,channel],...,type-n [1,channel]}
                Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
                
                Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
            otherwise
                error('Rad.spacecraft is wrong')
        end
        
    case {'amsu-b'}
        % nedt from specification
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = [0.37,0.84,0.6,0.7,1.1];
        Noise.addnoise.type_cold_varfrac = {...
            1-[0.1,0.1,0.1,0.1,0.1],...
            [0.1,0.1,0.1,0.1,0.1]};
        
        Noise.addnoise.chan_std_warm = [0.37,0.84,0.6,0.7,1.1];
        Noise.addnoise.type_warm_varfrac = {...
            1-[0.1,0.1,0.1,0.1,0.1],...
            [0.1,0.1,0.1,0.1,0.1]};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'mhs'}
        switch Rad.spacecraft
            case 'n19'
                Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
                Noise.addnoise.num_type = length(Noise.addnoise.type);
                
                Noise.addnoise.chan_std_cold = [0.130,0.330,3.786,0.632,0.266];
                Noise.addnoise.type_cold_varfrac = {...
                    1-[0.171,0.340,0.168,0.179,0.283],...
                    [0.171,0.340,0.168,0.179,0.283]};
                
                Noise.addnoise.chan_std_warm = [0.201,0.396,3.887,0.709,0.339];
                Noise.addnoise.type_warm_varfrac = {...
                    1-[0.168,0.310,0.175,0.173,0.229],...
                    [0.168,0.310,0.175,0.173,0.229]};
                
                Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
                
                Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
            case 'metop-a'
                Noise.addnoise.type = {'thermal','1/f'};
                Noise.addnoise.num_type = length(Noise.addnoise.type);
                
                % 2015
                Noise.addnoise.chan_std_cold = [0.146,0.324,0.538,0.431,0.312];
                Noise.addnoise.type_cold_varfrac = {...
                    1-[0.156,0.247,0.185,0.185,0.322],...
                    [0.156,0.247,0.185,0.185,0.322]};
                
                Noise.addnoise.chan_std_warm = [0.212,0.401,0.653,0.516,0.376];
                Noise.addnoise.type_warm_varfrac = {...
                    1-[0.155,0.249,0.204,0.211,0.275],...
                    [0.155,0.249,0.204,0.211,0.275]};
                
                % paper adaptive
                Noise.addnoise.chan_std_cold = [1,1,1,1,1];
                Noise.addnoise.type_cold_varfrac = {...
                    1-[0.156,0.247,0.9,0.9,0.322],...
                    [0.156,0.247,0.9,0.9,0.322]};
                
                Noise.addnoise.chan_std_warm = [1,1,1,1,1];
                Noise.addnoise.type_warm_varfrac = {...
                    1-[0.155,0.249,0.9,0.9,0.275],...
                    [0.155,0.249,0.9,0.9,0.275]};
                
                % parse
                Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
                
                Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
            otherwise
                error('Rad.spacecraft is wrong')
        end
        
    case {'atms'}
        switch Rad.spacecraft
            case {'npp'}
                Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
                Noise.addnoise.num_type = length(Noise.addnoise.type);
                
                Noise.addnoise.chan_std_cold = [0.108,0.131,0.191,0.149,0.141,0.151,0.139,0.146,0.162,0.226,0.296,0.304,0.470,0.651,1.051,0.203,0.354,0.306,0.369,0.440,0.467,0.641];
                Noise.addnoise.type_cold_varfrac = {...
                    1-[0.083,0.200,0.187,0.239,0.284,0.187,0.235,0.243,0.183,0.200,0.145,0.201,0.152,0.152,0.146,0.510,0.392,0.329,0.457,0.372,0.459,0.479],...
                    [0.083,0.200,0.187,0.239,0.284,0.187,0.235,0.243,0.183,0.200,0.145,0.201,0.152,0.152,0.146,0.510,0.392,0.329,0.457,0.372,0.459,0.479]};
                
                Noise.addnoise.chan_std_warm = [0.251,0.312,0.377,0.297,0.282,0.302,0.271,0.263,0.304,0.431,0.553,0.589,0.892,1.249,1.967,0.288,0.421,0.374,0.431,0.509,0.549,0.681];
                Noise.addnoise.type_warm_varfrac = {...
                    1-[0.102,0.320,0.230,0.390,0.358,0.306,0.287,0.199,0.217,0.178,0.182,0.140,0.077,0.172,0.034,0.476,0.391,0.323,0.422,0.424,0.422,0.393],...
                    [0.102,0.320,0.230,0.390,0.358,0.306,0.287,0.199,0.217,0.178,0.182,0.140,0.077,0.172,0.034,0.476,0.391,0.323,0.422,0.424,0.422,0.393]};
                
                Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
                
                Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
            case {'n20'}
                Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
                Noise.addnoise.num_type = length(Noise.addnoise.type);
                
                Noise.addnoise.chan_std_cold = [0.108,0.117,0.158,0.098,0.101,0.111,0.103,0.106,0.110,0.164,0.228,0.241,0.349,0.500,0.776,0.118,0.248,0.296,0.320,0.354,0.359,0.508];
                Noise.addnoise.type_cold_varfrac = {...
                    1-[0.250,0.172,0.132,0.116,0.228,0.228,0.180,0.189,0.184,0.212,0.164,0.113,0.055,0.141,0.211,0.421,0.196,0.398,0.271,0.157,0.303,0.132],...
                    [0.250,0.172,0.132,0.116,0.228,0.228,0.180,0.189,0.184,0.212,0.164,0.113,0.055,0.141,0.211,0.421,0.196,0.398,0.271,0.157,0.303,0.132]};
                
                Noise.addnoise.chan_std_warm = [0.244,0.279,0.315,0.226,0.230,0.242,0.221,0.227,0.239,0.342,0.481,0.480,0.742,1.026,1.595,0.188,0.321,0.371,0.384,0.425,0.436,0.630];
                Noise.addnoise.type_warm_varfrac = {...
                    1-[0.128,0.132,0.000,0.162,0.226,0.205,0.173,0.130,0.163,0.138,0.090,0.112,0.125,0.105,0.082,0.445,0.202,0.323,0.368,0.219,0.244,0.082],...
                    [0.128,0.132,0.000,0.162,0.226,0.205,0.173,0.130,0.163,0.138,0.090,0.112,0.125,0.105,0.082,0.445,0.202,0.323,0.368,0.219,0.244,0.082]};
                
                Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
                
                Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
                Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
            otherwise
                error('Rad.spacecraft is wrong')
        end
        
    case {'mwri'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.5*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 1*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;

    case {'mwhs-2'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.5*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 1*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;

    case {'mwts-2'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.5*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 1*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;

    case {'gmi'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'ssmi'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'ssmis'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'tempest-d'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = [0.18,0.25,0.2,0.25,0.7];
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 0.96*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'tms'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = [0.6,0.55,0.6,0.7,0.7,0.75,0.85,1,0.5,0.5,0.5,0.5];
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = [0.6,0.55,0.6,0.7,0.7,0.75,0.85,1,0.5,0.5,0.5,0.5];
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    case {'smap'}
        Noise.addnoise.type = {'thermal','1/f'}; % type-1,type-2,...,type-n
        Noise.addnoise.num_type = length(Noise.addnoise.type);
        
        Noise.addnoise.chan_std_cold = 0.34*ones(1,Rad.num_chan);
        Noise.addnoise.type_cold_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_warm = 0.34*ones(1,Rad.num_chan);
        Noise.addnoise.type_warm_varfrac = {...
            1-0.2*ones(1,Rad.num_chan),...
            0.2*ones(1,Rad.num_chan)};
        
        Noise.addnoise.chan_std_scene = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_scene_varfrac = Noise.addnoise.type_warm_varfrac;
        
        Noise.addnoise.chan_std_null = Noise.addnoise.chan_std_warm;
        Noise.addnoise.type_null_varfrac = Noise.addnoise.type_warm_varfrac;
        
    otherwise
        error('Rad.sensor is wrong')
end


