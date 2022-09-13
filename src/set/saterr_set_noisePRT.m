function saterr_set_noisePRT
% setting Platinum Resistance Thermometer (PRT) noise
% PRT noise refers to high-frequency noise in the measured warm-load PRT temperature. It is different from the orbit oscillation.
%
% Input:
%       setting noise of PRT
% 
% Output:
%       noise type and magnitude of PRT
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/02/2019: adding option of quantization

global Noise Rad
% -----------------------------
% setting
% -----------------------------
Noise.PRT.onoff = 0; % 0=off,1=on

if Noise.PRT.onoff==1
    switch Rad.sensor
        case {'demo'}
            
            Noise.PRT.type = 'Gaussian'; % Gaussian/Quantization
            Noise.PRT.std = 0.03*ones(Rad.num_chan,1); % std (Kelvin), [channel,1]
            
        case {'customize'}
            Noise.PRT.type = 'Gaussian'; % Gaussian/Quantization
            Noise.PRT.std = 0.05*ones(Rad.num_chan,1); % std (Kelvin), [channel,1]
            
        case {'amsu-a'}
            Noise.PRT.type = 'Gaussian'; % Gaussian/Quantization
            Noise.PRT.std = 0.024*ones(Rad.num_chan,1); % std (Kelvin), [channel,1]
            
        case {'mhs'}
            Noise.PRT.type = 'Gaussian'; % Gaussian/Quantization
            Noise.PRT.std = 0.03*ones(Rad.num_chan,1); % std (Kelvin), [channel,1]
            
        case {'amsr2'}
            Noise.PRT.type = 'Gaussian'; % Gaussian/Quantization
            Noise.PRT.std = 0.03*ones(Rad.num_chan,1); % std (Kelvin), [channel,1]
            
        otherwise
            error('Noise.source is wrong')
    end
end



