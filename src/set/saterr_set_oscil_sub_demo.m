function saterr_set_oscil_sub_demo
% Orbit variation for demo, 'Demo_TimeVarying.oscillation.ation'
% 
% Input:
%         warm-load variation
%         gain variation
%         receiver temperature variation
% 
%         0=turn off variation,
%         1=variation in forms of waveform
%         2=customize w/ empirical or external source
% 
% Output:
%         TimeVarying.oscillation.
% 
% Note:
%         E.g. a waveform can be: amp*sin(w*t+phase) + dc, where w=2*pi*num_period
%         amplitude < min(tw), otherwise zero comes out for gain
% 
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: rename and add customization
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: split demo, cust, sensor

global TimeVarying Rad
% -----------------------------
% setting
% -----------------------------

% -----------------------------
% warm-load variation
% -----------------------------
% 0=turn off variation
% 1=variation in forms of waveform
% 2=customize w/ empirical or external source
TimeVarying.oscillation.warmload.source = 0;

switch TimeVarying.oscillation.warmload.source
    case 0
        % 0=turn off variation
        TimeVarying.oscillation.preset.tw_cw_var = 0;
        TimeVarying.oscillation.preset.tw_PRT_var = 0;
        
    case 1
        % 1=variation in forms of waveform
        
        % setting
        TimeVarying.oscillation.warmload.wave.type = 'sine';  % sine/square/triangle/sawtooth
        TimeVarying.oscillation.warmload.wave.amp = 1*ones(Rad.num_chan,1); % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
        TimeVarying.oscillation.warmload.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
        TimeVarying.oscillation.warmload.wave.phase = 0*ones(Rad.num_chan,1); % phase, [channel,1], [-pi,pi], e.g. pi*ones(Rad.num_chan,1)
        TimeVarying.oscillation.warmload.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
        
        % set width for sawtooth wave
        if strcmp(TimeVarying.oscillation.warmload.wave.type,'sawtooth')
            TimeVarying.oscillation.warmload.wave.sawwidth = 0.2; % for wave.type='sawtooth', scalar ranging from [0,1]
        end
        
    case 2
        % 2=customize w/ empirical or external source
        
        % setting
        n1 = length(Rad.ind_CT{2});
        n2 = Rad.num_alongtrack;
        n3 = Rad.num_chan;
        
        % customize here. e.g.:
        x = linspace(0,1,n1*n2);
        y = 1*sin(2*pi*1*x+0);
        y = reshape(y,[n1,n2]);
        y = y(:,:,ones(n3,1));
        TimeVarying.oscillation.preset.tw_cw_var = y; % [cross-track,along-track,channel]
        TimeVarying.oscillation.preset.tw_PRT_var = mean(y,1); % [1,along-track,channel]
        
        % check
        n = [size(TimeVarying.oscillation.preset.tw_cw_var,1),size(TimeVarying.oscillation.preset.tw_cw_var,2),size(TimeVarying.oscillation.preset.tw_cw_var,3)];
        if ~isequal(n,[n1,n2,n3])
            error('Error of size of TimeVarying.oscillation.preset.tw_cw_var')
        end
        
        n = [size(TimeVarying.oscillation.preset.tw_PRT_var,1),size(TimeVarying.oscillation.preset.tw_PRT_var,2),size(TimeVarying.oscillation.preset.tw_PRT_var,3)];
        if ~isequal(n,[1,n2,n3])
            error('Error of size of TimeVarying.oscillation.preset.tw_PRT_var')
        end
        
    otherwise
        error('Error of TimeVarying.oscillation.warmload.source')
end

% -----------------------------
% gain variation
% -----------------------------
% 0=turn off variation,
% 1=variation in forms of waveform
% 2=customize w/ empirical or external source
TimeVarying.oscillation.gain.source = 0;

switch TimeVarying.oscillation.gain.source
    case 0
        TimeVarying.oscillation.preset.gain_var = 0;
        
    case 1
        TimeVarying.oscillation.gain.wave.type = 'sine';  % sine/square/triangle/sawtooth
        TimeVarying.oscillation.gain.wave.amp = 3*ones(Rad.num_chan,1); % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
        TimeVarying.oscillation.gain.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
        TimeVarying.oscillation.gain.wave.phase = 0*ones(Rad.num_chan,1); % phase, [channel,1], [-pi,pi], e.g. pi*ones(Rad.num_chan,1)
        TimeVarying.oscillation.gain.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
        
        % set width for sawtooth wave
        if strcmp(TimeVarying.oscillation.gain.wave.type,'sawtooth')
            TimeVarying.oscillation.gain.wave.sawwidth = 0.2; % for wave.type='sawtooth', scalar ranging from [0,1]
        end
        
    case 2
        n1 = sum(Rad.num_crosstrack);
        n2 = Rad.num_alongtrack;
        n3 = Rad.num_chan;
        
        % customize here. e.g.:
        x = linspace(0,1,n1*n2);
        y = 3*sin(2*pi*1*x+0);
        y = reshape(y,[n1,n2]);
        TimeVarying.oscillation.preset.gain_var = y(:,:,ones(n3,1)); % [cross-track,along-track,channel]
        
        % check
        n = [size(TimeVarying.oscillation.preset.gain_var,1),size(TimeVarying.oscillation.preset.gain_var,2),size(TimeVarying.oscillation.preset.gain_var,3)];
        if ~isequal(n,[n1,n2,n3])
            error('Error of size of TimeVarying.oscillation.preset.gain_var')
        end
        
    otherwise
        error('Error of TimeVarying.oscillation.gain.source')
end

% -----------------------------
% receiver temperature variation
% -----------------------------
% 0=turn off variation,
% 1=variation in forms of waveform
% 2=customize w/ empirical or external source
TimeVarying.oscillation.Tr.source = 0;

switch TimeVarying.oscillation.Tr.source
    case 0
        TimeVarying.oscillation.preset.Tr_var = 0;
        
    case 1
        TimeVarying.oscillation.Tr.wave.type = 'sine';  % sine/square/triangle/sawtooth
        TimeVarying.oscillation.Tr.wave.amp = 5*ones(Rad.num_chan,1); % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
        TimeVarying.oscillation.Tr.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
        TimeVarying.oscillation.Tr.wave.phase = 0*ones(Rad.num_chan,1); % phase, [channel,1], [-pi,pi], e.g. pi*ones(Rad.num_chan,1)
        TimeVarying.oscillation.Tr.wave.scan  = 1; % 1=cross-track and along-track variation only, 2=along-track variation only
        
        % set width for sawtooth wave
        if strcmp(TimeVarying.oscillation.Tr.wave.type,'sawtooth')
            TimeVarying.oscillation.Tr.wave.sawwidth = 0.2*ones(Rad.num_chan,1); % for wave.type='sawtooth', scalar ranging from [0,1],[channel,1]
        end
        
    case 2
        n1 = sum(Rad.num_crosstrack);
        n2 = Rad.num_alongtrack;
        n3 = Rad.num_chan;
        
        % customize here. e.g.:
        x = linspace(0,1,n1*n2);
        y = 5*sin(2*pi*1*x+0);
        y = reshape(y,[n1,n2]);
        TimeVarying.oscillation.preset.Tr_var = y(:,:,ones(n3,1)); % [cross-track,along-track,channel]
        
        % check
        n = [size(TimeVarying.oscillation.preset.Tr_var,1),size(TimeVarying.oscillation.preset.Tr_var,2),size(TimeVarying.oscillation.preset.Tr_var,3)];
        if ~isequal(n,[n1,n2,n3])
            error('Error of size of TimeVarying.oscillation.preset.Tr_var')
        end
        
    otherwise
        error('Error of TimeVarying.oscillation.Tr.source')
end
