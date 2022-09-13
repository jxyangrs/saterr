function [tb,E] = saterr_imp_TBsource_waveform(nfreq)
% implement setup of tb source
%
% Input:
%       TBsrc
%       Rad
% 
%         % waveform basics
%         % ------------
%         TBsrc.wave.type = 'sine';  % waveform: constant/sine/square/triangle/sawtooth;
%         TBsrc.wave.amp = 10*ones(Rad.num_chan,1); % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
%         TBsrc.wave.dc = 240*ones(Rad.num_chan,1); % DC component (Kelvin), [channel,1]
%         TBsrc.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
%         TBsrc.wave.phase = 0*ones(Rad.num_chan,1); % phase, [channel,1], [-pi,pi], e.g. pi*ones(Rad.num_chan,1)
%         TBsrc.wave.scan = 1; % 1=waveform scene going through both cross-track and along-track
%         
% 
% Output:
%       tb,           [Stokes,crosstrack,alongtrack]/[Stokes,1,1,channel] of each channel
%       E,            [Stokes,alongtrack]/scalar
%
% Examples:
%       [tb,E] = saterr_imp_TBsource(TBsrc.source)
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/21/2020: add TBsrc setting

global Rad TBsrc 

tb = [];
E = [];

% -------------------------
% case 1: waveform
% scene in forms of waveform w/ TBsrc.mode=1/2
% E.g. a waveform is: amp*sin(w*t+phase) + dc, where w=2*pi*num_period
% -------------------------
switch TBsrc.wave.scan
    case 1 % cross-track and along-track variation
        n1 = Rad.ind_CT_num(1);
        n2 = Rad.num_alongtrack;
        switch TBsrc.wave.type
            case 'constant'
                y = TBsrc.wave.dc(nfreq)*ones(n1,n2);
            case 'sine'
                x = linspace(0,1,n1*n2);
                y = TBsrc.wave.amp(nfreq)*sin(2*pi*TBsrc.wave.num_period(nfreq)*x+TBsrc.wave.phase(nfreq))+TBsrc.wave.dc(nfreq);
            case 'square'
                x = linspace(TBsrc.wave.phase(nfreq),2*pi*TBsrc.wave.num_period(nfreq)+TBsrc.wave.phase(nfreq),n1*n2);
                y = TBsrc.wave.amp(nfreq)*square(x)+TBsrc.wave.dc(nfreq);
            case 'triangle'
                x = linspace(TBsrc.wave.phase(nfreq),2*pi*TBsrc.wave.num_period(nfreq)+TBsrc.wave.phase(nfreq),n1*n2);
                y = TBsrc.wave.amp(nfreq)*sawtooth(x,0.5)+TBsrc.wave.dc(nfreq);
            case 'sawtooth'
                x = linspace(TBsrc.wave.phase(nfreq),2*pi*TBsrc.wave.num_period(nfreq)+TBsrc.wave.phase(nfreq),n1*n2);
                y = TBsrc.wave.amp(nfreq)*sawtooth(x,TBsrc.wave.sawwidth)+TBsrc.wave.dc(nfreq);
            otherwise
                error('orbitvar wave type is wrong')
        end
        
        y = reshape(y,[n1,n2]);
        tb(1,:,:) = y;
        tb(2,:,:) = y;
        tb(3,:,:) = 0;
        tb(4,:,:) = 0;
        
        % E=[1;1;0;0];
        E = ones(4,n1,n2);
        E(3,:,:) = 0;
        E(4,:,:) = 0;
    case 2 % along-track variation only
        n1 = Rad.num_alongtrack;
        switch TBsrc.wave.type
            case 'constant'
                y = TBsrc.wave.dc(nfreq)*ones(n1,n2);
            case 'sine'
                x = linspace(0,1,n1);
                y = TBsrc.wave.amp(nfreq)*sin(2*pi*TBsrc.wave.num_period(nfreq)*x+TBsrc.wave.phase(nfreq))+TBsrc.wave.dc(nfreq);
            case 'square'
                x = linspace(TBsrc.wave.phase(nfreq),2*pi*TBsrc.wave.num_period(nfreq)+TBsrc.wave.phase(nfreq),n1);
                y = TBsrc.wave.amp(nfreq)*square(x)+TBsrc.wave.dc(nfreq);
            case 'triangle'
                x = linspace(TBsrc.wave.phase(nfreq),2*pi*TBsrc.wave.num_period(nfreq)+TBsrc.wave.phase(nfreq),n1);
                y = TBsrc.wave.amp(nfreq)*sawtooth(x,0.5)+TBsrc.wave.dc(nfreq);
            case 'sawtooth'
                x = linspace(TBsrc.wave.phase(nfreq),2*pi*TBsrc.wave.num_period(nfreq)+TBsrc.wave.phase(nfreq),n1);
                y = TBsrc.wave.amp(nfreq)*sawtooth(x,TBsrc.wave.sawwidth)+TBsrc.wave.dc(nfreq);
            otherwise
                error('orbitvar wave type is wrong')
        end
        
        n = Rad.ind_CT_num(1);
        y = y(ones(n,1),:);
        tb(1,:,:) = y;
        tb(2,:,:) = y;
        tb(3,:,:) = 0;
        tb(4,:,:) = 0;
        
        % E=[1;1;0;0];
        E = ones(4,n1,n2);
        E(3,:,:) = 0;
        E(4,:,:) = 0;
    otherwise
        error('Error of TBsrc.wave.scan')
end
