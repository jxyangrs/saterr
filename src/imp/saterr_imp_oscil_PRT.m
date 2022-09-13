function [tw_cw_var,tw_PRT_var] = saterr_imp_oscil_PRT
% implementing oscillation of warm-load w/ orbit
%
% Input:
%       orbit oscillation setting
% 
% Output:
%       tw_cw_var,        Stokes of cold-space,       [crosstrack,alongtrack]/scalar
%       tw_PRT_var,       Stokes of warm-load,        [1,alongtrack]/scalar
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: reformat syntax

global Setting Rad Noise TimeVarying Target VarDynamic

nchan = VarDynamic.nchan;

% variables
tw_cw_var = 0;
tw_PRT_var = 0;

% setup
ind_cw = Rad.ind_CT{2};

% execute
if TimeVarying.oscillation.onoff~=1
    return
end

switch TimeVarying.oscillation.warmload.source
    % 0=turn off variation,
    % 1=variation in forms of waveform
    % 2=customize w/ empirical or external source
    % 3=empirical sine waveform based on observation
    
    case 0
        tw_cw_var = TimeVarying.oscillation.preset.tw_cw_var;
        tw_PRT_var = TimeVarying.oscillation.preset.tw_PRT_var;
        
    case {1,3}
        switch TimeVarying.oscillation.warmload.wave.scan
            case 1 % cross-track and along-track variation
                n1 = sum(Rad.num_crosstrack);
                n2 = Rad.num_alongtrack;
                
                switch TimeVarying.oscillation.warmload.wave.type
                    case 'sine'
                        x = linspace(0,1,n1*n2);
                        y = TimeVarying.oscillation.warmload.wave.amp(nchan)*sin(2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)*x+TimeVarying.oscillation.warmload.wave.phase(nchan));
                    case 'square'
                        x = linspace(TimeVarying.oscillation.warmload.wave.phase(nchan),2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)+TimeVarying.oscillation.warmload.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.warmload.wave.amp*square(x);
                    case 'triangle'
                        x = linspace(TimeVarying.oscillation.warmload.wave.phase(nchan),2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)+TimeVarying.oscillation.warmload.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.warmload.wave.amp*sawtooth(x,0.5);
                    case 'sawtooth'
                        x = linspace(TimeVarying.oscillation.warmload.wave.phase(nchan),2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)+TimeVarying.oscillation.warmload.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.warmload.wave.amp(nchan)*sawtooth(x,TimeVarying.oscillation.warmload.wave.sawwidth(nchan));
                    otherwise
                        error('orbitvar wave type is wrong')
                end
                
                y = reshape(y,[n1,n2]);
                ind = ind_cw;
                tw_cw_var = y(ind,:);
                tw_PRT_var = mean(y(ind,:),1);
                
            case 2 % along-track variation only
                n1 = Rad.num_alongtrack;
                
                switch TimeVarying.oscillation.warmload.wave.type
                    case 'sine'
                        x = linspace(0,1,n1);
                        y = TimeVarying.oscillation.warmload.wave.amp(nchan)*sin(2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)*x+TimeVarying.oscillation.warmload.wave.phase(nchan));
                    case 'square'
                        x = linspace(TimeVarying.oscillation.warmload.wave.phase(nchan),2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)+TimeVarying.oscillation.warmload.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.warmload.amp*square(x);
                    case 'triangle'
                        x = linspace(TimeVarying.oscillation.warmload.wave.phase(nchan),2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)+TimeVarying.oscillation.warmload.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.warmload.amp*sawtooth(x,0.5);
                    case 'sawtooth'
                        x = linspace(TimeVarying.oscillation.warmload.wave.phase(nchan),2*pi*TimeVarying.oscillation.warmload.wave.num_period(nchan)+TimeVarying.oscillation.warmload.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.warmload.wave.amp(nchan)*sawtooth(x,TimeVarying.oscillation.warmload.wave.sawwidth(nchan));
                    otherwise
                        error('orbitvar wave type is wrong')
                end
                
                n = length(ind_cw);
                tw_cw_var = y(ones(n,1),:);
                tw_PRT_var = y;
                
            otherwise
                error('TimeVarying.oscillation.warmload.wave.scan is wrong')
        end
        
    case 2
        tw_cw_var = TimeVarying.oscillation.preset.tw_cw_var(:,:,nchan);
        tw_PRT_var = TimeVarying.oscillation.preset.tw_PRT_var(:,:,nchan);
        
    otherwise
        error('Error in TimeVarying.oscillation.warmload.source')
end

