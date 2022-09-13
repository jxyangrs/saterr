function saterr_set_TBsource(tb_source)
% setting TB source
% this is for the mainlobe
%
% Input:
%       tb_source
%           see specific source for input requirement
% Output:
%       TBsrc
%
% Examples:
%    set sst and wind speed for oceanic emission
%         TBsrc.ocean.sst = 290; % sea surface temperature (K)
%         TBsrc.ocean.wind = 5; % surface wind speed (m/s)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/06/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/06/2019: add customize option
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/06/2019: external sample

global Rad TBsrc Const

if nargin<1
    return
end
% -----------------------------
% setting
% -----------------------------
switch tb_source
    case 0
        % -------------------------
        % zeros such as for sidelobe
        % size = [1,channel]
        % -------------------------
        TBsrc.Tas = 0*ones(1,Rad.num_chan); % Ta of modified Stokes [1,channel]
        TBsrc.E = 1*ones(1,Rad.num_chan); % E of [1,channel]
        
    case 'constant'
        % -------------------------
        % constant as in saterr_set_rad_fe.m
        % size = [1,channel]
        % -------------------------
        TBsrc.Tas = 150*ones(1,Rad.num_chan); % Ta of [1,channel]
        TBsrc.E = 1*ones(1,Rad.num_chan); % E of [1,channel]
        
    case 'ocean'
        % -------------------------
        % ocean emission
        % size = scalar/[crosstrack,alongtrack]
        % -------------------------
        TBsrc.ocean.sst = 290; % sea surface temperature (K)
        TBsrc.ocean.wind = 5; % surface wind speed (m/s)
        
    case 'land'
        % -------------------------
        % land emission
        % size = scalar/[crosstrack,alongtrack]
        % -------------------------
        TBsrc.land.tmp = 300; % land surface temperature (K)
        TBsrc.land.E = 0.9; % land emissivity 
        
    case 'cosmic'
        % -------------------------
        % cosmic background
        % size = scalar
        % -------------------------
        TBsrc.Tcosmic = Const.Tcosmic; % (K)
        
    case 'waveform'
        % -------------------------
        % scene in forms of waveform
        % scene in forms of waveform w/ TBsrc.mode=1/2
        % E.g. a waveform is: amp*sin(w*t+phase) + dc, where w=2*pi*num_period
        % size of amp/dc/num_period,phase,scan = [channel,1]
        % TBsrc.wave.type = constant/sine/square/triangle/sawtooth
        % For sawtooth, TBsrc.wave.sawwidth should be defined
        % -------------------------
        
        % waveform basics
        % ------------
        TBsrc.wave.type = 'sine';  % waveform: constant/sine/square/triangle/sawtooth;
        TBsrc.wave.amp = 10*ones(Rad.num_chan,1); % amplitude (Kelvin), [channel,1], amp=1 means peak-to-peak value is 2
        TBsrc.wave.dc = 240*ones(Rad.num_chan,1); % DC component (Kelvin), [channel,1]
        TBsrc.wave.num_period = Rad.num_orbit*ones(Rad.num_chan,1); % number of periods, [channel,1]
        TBsrc.wave.phase = 0*ones(Rad.num_chan,1); % phase, [channel,1], [-pi,pi], e.g. pi*ones(Rad.num_chan,1)
        TBsrc.wave.scan = 1; % 1=waveform scene going through both cross-track and along-track
        
        % set width for sawtooth wave
        % ------------
        if strcmp(TBsrc.wave.type,'sawtooth')
            TBsrc.wave.sawwidth = 0.2; % for TBsrc.wave.type='sawtooth', scalar ranging from [0,1]
        end
        
    case 'linear'
        % -------------------------
        % linear scene
        % size = [min,max]
        % -------------------------
        TBsrc.linear.tbrange = [5,300]; % range of tb, [min,max]

    case 'customize'
        % -------------------------
        % linear scene
        % size = [crosstrack,alongtrack,channel]
        % -------------------------
        n1 = 4;
        n2 = Rad.ind_CT_num(1);
        n3 = Rad.num_alongtrack(1);
        n4 = Rad.num_chan;
        TBsrc.Tas = 0*ones(n1,n2,n3,n4); % Ta [Stokes,crosstrack,alongtrack,channel]
        TBsrc.E = 1*ones(n1,n2,n3,n4);   % E of [Stokes,crosstrack,alongtrack,channel]
        
    otherwise
        error('TBsrc.source error')
end

saterr_parse_TBsource(tb_source)


