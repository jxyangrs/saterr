function saterr_set_noiseadditive_cust
% setting additive noise source for demo and customizing
%
% Input:
%       setting additive noise
% 
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
%       Noise.addnoise.mode,                 Fraction/Absolute
%                                            Fraction (setting total noise and sub-noise fraction)
%                                            Absolute (setting absolute value of individual sub-noise)
% 
% Table of noise type:
%       Noise type,     Description,                                    Slope of PSD  (S=f^alpha; S is PSD; slope=alpha)      
%       RWFM,           random walk frequency modulation (RWFM),        -4                    
%       FFM,            flicker frequency modulation (FFM),             -3                    
%       WFM,            white frequency modulation (WFM),               -2                    
%       1/f,            flicker noise,                                  -1                    
%       FPM,            flicker phase modulation (FPM),                 -1                    
%       thermal,        thermal (Additive White Gaussian Noise,AWGN),   0
%       WPM,            white phase modulcation (WFM),                  0
%       FPM,            frequency phase modulation (FPM),               1                    
%       quantization,   quantization                                    2,              
%       others,         other power-law noise or w/ diff. names,        alpha
% 
%       signal-dependent noise, e.g. shot noise, is set in saterr_set_noisesigdep.m
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: noise setting
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: unify noise name

global Noise Rad

% -----------------------------
% setting
% -----------------------------
switch Noise.addnoise.source
    case {'demo'} % a simple example
        % -----------------------------
        % example
        % Noise.addnoise.type = {'thermal','1/f'};
        % Noise.addnoise.type = {'thermal','1/f','quantization'};
        % -----------------------------
        % setup same NEDT for cold,warm,scene,null
        Noise.addnoise.mode = 'Fraction'; % Fraction/Absolute; Fraction=Input total Noise and percentage of sub-noise, Absolute=Input sub-noise
        Noise.addnoise.chan_std = ones(1,Rad.num_chan); % NEDT of each channel (Kelvin), [1,channel]
        Noise.addnoise.type = {'thermal','1/f'}; % 1/f,thermal,quantization,; more in help
        Noise.addnoise.type_varfrac = {[0.7],[0.3]}; % variance fraction, {type-1 [1,channel],type-2 [1,channel],...,type-n [1,channel]}; range [0,1]
        Noise.addnoise.num_type = numel(Noise.addnoise.type);
        
    case 'customize' % customized setting
        Noise.addnoise.mode = 'Fraction'; % Fraction/Absolute; Fraction=Input total Noise and percentage of sub-noise, Absolute=Input sub-noise
        
        switch Noise.addnoise.mode
            case 'Fraction'
                % -----------------------------
                % Fraction: input are NEDT of total-noise, percentage of sub-noise
                % -----------------------------
                % setup
                Noise.addnoise.chan_std_cold = [1,1,1]; % noise of cold observation, tbc; [1,channel]
                Noise.addnoise.chan_std_warm = [3,3,3]; % noise of warm observation, tbw; [1,channel]
                Noise.addnoise.chan_std_scene = [2,2,2];% noise of scence observation, tbs; [1,channel]
                Noise.addnoise.chan_std_null = [3,3,3]; % noise of null observation, tbnull; [1,channel]
                
                Noise.addnoise.type = {'thermal','1/f'}; % 1/f,thermal,quantization; [1,type]
                Noise.addnoise.num_type = numel(Noise.addnoise.type);
                Noise.addnoise.type_varfrac = {[0.3,0.5,0.7],1-[0.3,0.5,0.7]}; % variance fraction, {type-1 [1,channel],type-2 [1,channel],...,type-n [1,channel]}; range [0,1]
                
            case 'Absolute'
                % -----------------------------
                % Absolute: input are NEDT of sub-noise
                % -----------------------------
                % setup
                Noise.addnoise.type = {'thermal','1/f'}; % 1/f,thermal; more see help
                Noise.addnoise.num_type = numel(Noise.addnoise.type);
                Noise.addnoise.type_std_cold_sub = {[0.3,0.5,0.7],[0.7,0.5,0.3]};
                Noise.addnoise.type_std_warm_sub = {[0.9,1.5,2.1],[2.1,1.5,0.9]};
                Noise.addnoise.type_std_scene_sub = {[0.6,1,1.4],[1.4,1,0.6]};
                Noise.addnoise.type_std_null_sub = {[0.9,1.5,2.1],[2.1,1.5,0.9]};
                
        end
    otherwise
        error('Noise.addnoise.source is wrong')
        
end
