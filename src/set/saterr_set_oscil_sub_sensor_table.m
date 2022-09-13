function saterr_set_orbitvar_sub_sensor_table(Spacecraft,Sensor)
% table of empirical parameters for orbit variation
%
% Input:
%         spacecraft
%         sensor
% Output:
%         TimeVarying.oscillation.
%
% Note:
%         The table assumes sinusoid oscillation with parameters derived from observations
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: original code

global TimeVarying.oscillation.Rad

% -----------------------------
% setting
% -----------------------------
% table of empirical parameters
switch Spacecraft
    case 'noaa-19'
        switch Sensor
            case 'amsu-a'
                sensor.warmload.wave.type = 'sine';  % sine/square/triangle/sawtooth
                sensor.warmload.wave.amp = [0.235,0.235,0.077,0.077,0.077,0.077,0.077,0.077,0.077,0.077,0.077,0.077,0.077,0.077,0.077]; % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
                sensor.warmload.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
                sensor.warmload.wave.phase = [-120,-120, -14, -14, -14, -14, -14, -14, -14, -14, -14, -14, -14, -14, -14]/180*pi; % phase, [channel,1], e.g. pi*ones(Rad.num_chan,1)
                sensor.warmload.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
                
                sensor.gain.wave.type = 'sine';  % sine/square/triangle/sawtooth
                sensor.gain.wave.amp = [0.008,0.007,0.016,0.014,0.017,0.044,0.047,0.056,0.040,0.043,0.083,0.091,0.092,0.113,0.066]; % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
                sensor.gain.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
                sensor.gain.wave.phase = [213,131, 94, 77, 69,103, 96,-60, 92, 94,101,102, 99,106, 85]/180*pi; % phase, [channel,1], e.g. pi*ones(Rad.num_chan,1)
                sensor.gain.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
                
                sensor.Tr.wave.type = 'sine';  % sine/square/triangle/sawtooth
                sensor.Tr.wave.amp = [1.418, 0.572, 0.908, 0.570, 0.756, 1.325, 7.203,16.930, 1.696, 1.862, 2.424, 2.505, 2.709, 3.040, 4.166]; % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
                sensor.Tr.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
                sensor.Tr.wave.phase = [102, 176, -58, -91,-104, -52, -77,  89, -47, -56, -49, -45, -56, -53, -68]/180*pi; % phase, [channel,1], e.g. pi*ones(Rad.num_chan,1)
                sensor.Tr.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
                
            case 'mhs'
                sensor.warmload.wave.type = 'sine';  % sine/square/triangle/sawtooth
                sensor.warmload.wave.amp = 0.17*ones(Rad.num_chan,1); % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
                sensor.warmload.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
                sensor.warmload.wave.phase = [144,144,144,144,144]/180*pi; % phase, [channel,1], e.g. pi*ones(Rad.num_chan,1)
                sensor.warmload.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
                
                sensor.gain.wave.type = 'sine';  % sine/square/triangle/sawtooth
                sensor.gain.wave.amp = [0.34,0.38,2.86,2.66,0.23]; % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
                sensor.gain.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
                sensor.gain.wave.phase = [-27,-39,-27,-58,-33]/180*pi; % phase, [channel,1], e.g. pi*ones(Rad.num_chan,1)
                sensor.gain.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
                
                sensor.Tr.wave.type = 'sine';  % sine/square/triangle/sawtooth
                sensor.Tr.wave.amp = [1.62,0.92,3.68,4.02,1.35]; % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
                sensor.Tr.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
                sensor.Tr.wave.phase = [150,157,182,-60,151]; % phase, [channel,1], e.g. pi*ones(Rad.num_chan,1)
                sensor.Tr.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
                
            otherwise
                error('Rad.sensor')
        end
        
    otherwise
        error('Rad.spacecraft')
end

% -----------------------------
% implement
% -----------------------------
TimeVarying.oscillation.warmload.wave.type = sensor.warmload.wave.type;
TimeVarying.oscillation.warmload.wave.amp = sensor.warmload.wave.amp;
TimeVarying.oscillation.warmload.wave.num_period = sensor.warmload.wave.num_period;
TimeVarying.oscillation.warmload.wave.phase = sensor.warmload.wave.phase;
TimeVarying.oscillation.warmload.wave.scan = sensor.warmload.wave.scan;

TimeVarying.oscillation.gain.wave.type = sensor.gain.wave.type;
TimeVarying.oscillation.gain.wave.amp = sensor.gain.wave.amp;
TimeVarying.oscillation.gain.wave.num_period = sensor.gain.wave.num_period;
TimeVarying.oscillation.gain.wave.phase = sensor.gain.wave.phase;
TimeVarying.oscillation.gain.wave.scan = sensor.gain.wave.scan;

TimeVarying.oscillation.Tr.wave.type = sensor.Tr.wave.type;
TimeVarying.oscillation.Tr.wave.amp = sensor.Tr.wave.amp;
TimeVarying.oscillation.Tr.wave.num_period = sensor.Tr.wave.num_period;
TimeVarying.oscillation.Tr.wave.phase = sensor.Tr.wave.phase;
TimeVarying.oscillation.Tr.wave.scan = sensor.Tr.wave.scan;
