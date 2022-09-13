function [G_cc_ovar,G_cw_ovar,G_cs_ovar,G_null_ovar] = saterr_imp_oscil_gain
% implement orbital variation for gain
%
% Output:
%       G_cc_ovar,    [crosstrack (n1),alongtrack]/scalar
%       G_cw_ovar,    [crosstrack (n2),alongtrack]/scalar
%       G_cs_ovar,    [crosstrack (n3),alongtrack]/scalar
%       G_null_ovar,  [crosstrack (n4),alongtrack]/scalar
% 
% Note:
%       amplitude < min(G), otherwise zero comes out for gain
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/11/2020: change for sytax and cutomization

global Setting Rad Noise TimeVarying Target VarDynamic

nchan = VarDynamic.nchan;

% variables
G_cc_ovar = 0;
G_cw_ovar = 0;
G_cs_ovar = 0;
G_null_ovar = 0;

% execute
if TimeVarying.oscillation.onoff~=1
    return
end

switch TimeVarying.oscillation.gain.source
    % 0=turn off variation
    % 1=variation in forms of waveform
    % 2=customize w/ empirical or external source
    % 3=empirical sine waveform based on observation
    
    case 0 % 0=turn off variation
        G_cc_ovar = TimeVarying.oscillation.preset.gain_var;
        G_cw_ovar = TimeVarying.oscillation.preset.gain_var;
        G_cs_ovar = TimeVarying.oscillation.preset.gain_var;
        G_null_ovar = TimeVarying.oscillation.preset.gain_var;
        
    case {1,3} % 1,3=variation in forms of waveform
        switch TimeVarying.oscillation.gain.wave.scan
            case 1 % cross-track and along-track variation
                n1 = sum(Rad.num_crosstrack);
                n2 = Rad.num_alongtrack;
                
                switch TimeVarying.oscillation.gain.wave.type
                    case 'sine'
                        x = linspace(0,1,n1*n2);
                        y = TimeVarying.oscillation.gain.wave.amp(nchan)*sin(2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)*x+TimeVarying.oscillation.gain.wave.phase(nchan));
                    case 'square'
                        x = linspace(TimeVarying.oscillation.gain.wave.phase(nchan),2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)+TimeVarying.oscillation.gain.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.gain.wave.amp*square(x);
                    case 'triangle'
                        x = linspace(TimeVarying.oscillation.gain.wave.phase(nchan),2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)+TimeVarying.oscillation.gain.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.gain.wave.amp*sawtooth(x,0.5);
                    case 'sawtooth'
                        x = linspace(TimeVarying.oscillation.gain.wave.phase(nchan),2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)+TimeVarying.oscillation.gain.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.gain.wave.amp(nchan)*sawtooth(x,TimeVarying.oscillation.gain.wave.sawwidth(nchan));
                    otherwise
                        error('orbitvar wave type is wrong')
                end
                
                y = reshape(y,[n1,n2]);
                
                ind = Rad.ind_CT{1};
                G_cc_ovar = y(ind,:);
                ind = Rad.ind_CT{2};
                G_cw_ovar = y(ind,:);
                ind = Rad.ind_CT{3};
                G_cs_ovar = y(ind,:);
                ind = Rad.ind_CT{4};
                G_null_ovar = y(ind,:);
                
            case 2 % along-track variation only
                n1 = Rad.num_alongtrack;
                
                switch TimeVarying.oscillation.gain.wave.type
                    case 'sine'
                        x = linspace(0,1,n1);
                        y = TimeVarying.oscillation.gain.wave.amp(nchan)*sin(2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)*x+TimeVarying.oscillation.gain.wave.phase(nchan));
                    case 'square'
                        x = linspace(TimeVarying.oscillation.gain.wave.phase(nchan),2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)+TimeVarying.oscillation.gain.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.gain.amp*square(x);
                    case 'triangle'
                        x = linspace(TimeVarying.oscillation.gain.wave.phase(nchan),2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)+TimeVarying.oscillation.gain.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.gain.amp*sawtooth(x,0.5);
                    case 'sawtooth'
                        x = linspace(TimeVarying.oscillation.gain.wave.phase(nchan),2*pi*TimeVarying.oscillation.gain.wave.num_period(nchan)+TimeVarying.oscillation.gain.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.gain.wave.amp(nchan)*sawtooth(x,TimeVarying.oscillation.gain.wave.sawwidth(nchan));
                    otherwise
                        error('orbitvar wave type is wrong')
                end
                
                n = length(Rad.ind_CT{1});
                G_cc_ovar = y(ones(n,1),:);
                n = length(Rad.ind_CT{2});
                G_cw_ovar = y(ones(n,1),:);
                n = length(Rad.ind_CT{3});
                G_cs_ovar = y(ones(n,1),:);
                n = length(Rad.ind_CT{4});
                G_null_ovar = y(ones(n,1),:);
                
            otherwise
                error('TimeVarying.oscillation.gain.wave.scan is wrong')
        end
        
    case 2 % 2=customize w/ empirical or external source
        G_cc_ovar = TimeVarying.oscillation.preset.gain_var(Rad.ind_CT{1},:,nchan);
        G_cw_ovar = TimeVarying.oscillation.preset.gain_var(Rad.ind_CT{2},:,nchan);
        G_cs_ovar = TimeVarying.oscillation.preset.gain_var(Rad.ind_CT{3},:,nchan);
        G_null_ovar = TimeVarying.oscillation.preset.gain_var(Rad.ind_CT{4},:,nchan);
        
    otherwise
        error('Error in TimeVarying.oscillation.gain.source')
end

