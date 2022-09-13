function [Tr_cc_ovar,Tr_cw_ovar,Tr_cs_ovar,Tr_null_ovar] = saterr_imp_oscil_tr
% implement orbital variation for Tr
%
% Output:
%       Tr_cc_ovar,    [crosstrack (n1),alongtrack]    
%       Tr_cw_ovar,    [crosstrack (n2),alongtrack]
%       Tr_cs_ovar,    [crosstrack (n3),alongtrack]
%       Tr_null_ovar,  [crosstrack (n4),alongtrack]
% 
% Note:
%       amplitude < min(Tr), otherwise zero comes out for Tr
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: reformat sytax and cutomization

global Setting Rad Noise TimeVarying Target VarDynamic

nchan = VarDynamic.nchan;

% variables
Tr_cc_ovar = 0;
Tr_cw_ovar = 0;
Tr_cs_ovar = 0;
Tr_null_ovar = 0;

% execute
if TimeVarying.oscillation.onoff~=1
    return
end

switch TimeVarying.oscillation.Tr.source
    % 0=turn off variation
    % 1=variation in forms of waveform
    % 2=customize w/ empirical or external source
    % 3=empirical sine waveform based on observation
    
    case 0 % 0=turn off variation
        Tr_cc_ovar = TimeVarying.oscillation.preset.Tr_var;
        Tr_cw_ovar = TimeVarying.oscillation.preset.Tr_var;
        Tr_cs_ovar = TimeVarying.oscillation.preset.Tr_var;
        Tr_null_ovar = TimeVarying.oscillation.preset.Tr_var;
        
    case {1,3} % 1,3=variation in forms of waveform
        switch TimeVarying.oscillation.Tr.wave.scan
            case 1 % cross-track and along-track variation
                n1 = sum(Rad.num_crosstrack);
                n2 = Rad.num_alongtrack;
                
                switch TimeVarying.oscillation.Tr.wave.type
                    case 'sine'
                        x = linspace(0,1,n1*n2);
                        y = TimeVarying.oscillation.Tr.wave.amp(nchan)*sin(2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)*x+TimeVarying.oscillation.Tr.wave.phase(nchan));
                    case 'square'
                        x = linspace(TimeVarying.oscillation.Tr.wave.phase(nchan),2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)+TimeVarying.oscillation.Tr.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.Tr.wave.amp*square(x);
                    case 'triangle'
                        x = linspace(TimeVarying.oscillation.Tr.wave.phase(nchan),2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)+TimeVarying.oscillation.Tr.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.Tr.wave.amp*sawtooth(x,0.5);
                    case 'sawtooth'
                        x = linspace(TimeVarying.oscillation.Tr.wave.phase(nchan),2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)+TimeVarying.oscillation.Tr.wave.phase(nchan),n1*n2);
                        y = TimeVarying.oscillation.Tr.wave.amp(nchan)*sawtooth(x,TimeVarying.oscillation.Tr.wave.sawwidth(nchan));
                    otherwise
                        error('orbitvar wave type is wrong')
                end
                
                y = reshape(y,[n1,n2]);
                
                ind = Rad.ind_CT{1};
                Tr_cc_ovar = y(ind,:);
                ind = Rad.ind_CT{2};
                Tr_cw_ovar = y(ind,:);
                ind = Rad.ind_CT{3};
                Tr_cs_ovar = y(ind,:);
                ind = Rad.ind_CT{4};
                Tr_null_ovar = y(ind,:);
                
            case 2 % along-track variation only
                n1 = Rad.num_alongtrack;
                
                switch TimeVarying.oscillation.Tr.wave.type
                    case 'sine'
                        x = linspace(0,1,n1);
                        y = TimeVarying.oscillation.Tr.wave.amp(nchan)*sin(2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)*x+TimeVarying.oscillation.Tr.wave.phase(nchan));
                    case 'square'
                        x = linspace(TimeVarying.oscillation.Tr.wave.phase(nchan),2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)+TimeVarying.oscillation.Tr.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.Tr.amp*square(x);
                    case 'triangle'
                        x = linspace(TimeVarying.oscillation.Tr.wave.phase(nchan),2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)+TimeVarying.oscillation.Tr.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.Tr.amp*sawtooth(x,0.5);
                    case 'sawtooth'
                        x = linspace(TimeVarying.oscillation.Tr.wave.phase(nchan),2*pi*TimeVarying.oscillation.Tr.wave.num_period(nchan)+TimeVarying.oscillation.Tr.wave.phase(nchan),n1);
                        y = TimeVarying.oscillation.Tr.wave.amp(nchan)*sawtooth(x,TimeVarying.oscillation.Tr.wave.sawwidth(nchan));
                    otherwise
                        error('orbitvar wave type is wrong')
                end
                
                n = length(Rad.ind_CT{1});
                Tr_cc_ovar = y(ones(n,1),:);
                n = length(Rad.ind_CT{2});
                Tr_cw_ovar = y(ones(n,1),:);
                n = length(Rad.ind_CT{3});
                Tr_cs_ovar = y(ones(n,1),:);
                n = length(Rad.ind_CT{4});
                Tr_null_ovar = y(ones(n,1),:);
                
            otherwise
                error('TimeVarying.oscillation.Tr.wave.scan is wrong')
        end
        
    case 2 % 2=customize w/ empirical or external source
        Tr_cc_ovar = TimeVarying.oscillation.preset.Tr_var(Rad.ind_CT{1},:,nchan);
        Tr_cw_ovar = TimeVarying.oscillation.preset.Tr_var(Rad.ind_CT{2},:,nchan);
        Tr_cs_ovar = TimeVarying.oscillation.preset.Tr_var(Rad.ind_CT{3},:,nchan);
        Tr_null_ovar = TimeVarying.oscillation.preset.Tr_var(Rad.ind_CT{4},:,nchan);
        
    otherwise
        error('Error in TimeVarying.oscillation.Tr.source')
end

