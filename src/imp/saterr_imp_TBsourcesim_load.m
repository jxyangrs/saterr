function [tb,E] = saterr_imp_TBsourcesim_load(tb_source)
% calculating TB per the tb source
%
% Input:
%       tb_source
%       nchan,         channel index for presetting,            scalar,     range [1,Rad.num_chan]
%       freq,          frequency (GHz) for oceanic model,       scalar,     range Rad.subband.freq
%   implicit
%       TBsrc.Tas
%       Rad.
%           scanning info.    
%
% Output:
%       tb,           [Stokes,1,1,channel]/[Stokes,crosstrack,alongtrack,channel]
%       E,            [Stokes,1,1,channel]/[Stokes,crosstrack,alongtrack,channel]
%
% Examples:
%       [tb,E] = saterr_imp_TBsource(TBsrc.source)
%       [tb,E] = saterr_imp_TBsource(TBsrc.source,[23.8])
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/21/2020: add TBsrc setting

global Rad TBsrc Orbit VarDynamic Const

tb = [];
E = [];

% build up scene TBsrc
switch tb_source
    case 'customize'
        % -------------------------
        % customize w/ empirical and observation
        % external input is allowed such as scene from RTM simulation
        % -------------------------
        
        % TBsrc.Ta.Tas is set in saterr_set_TBsource.m
        tb = TBsrc.Tas;
        E = TBsrc.E;
        
    case 'zero'
        % -------------------------
        % constant zero
        % -------------------------
        
        % TBsrc.Tas is set in saterr_set_TBsource.m
        tb(1,1,1,:) = TBsrc.Tas;
        tb(2,1,1,:) = TBsrc.Tas;
        tb(3,1,1,:) = 0;
        tb(4,1,1,:) = 0;
        
        E = [1;1;0;0];
        E = repmat(E,[1,1,1,Rad.num_chan]);
        
    case 'constant'
        % -------------------------
        % constant
        % -------------------------
        % TBsrc.Tas is set in saterr_set_TBsource.m
        tb(1,1,1,:) = TBsrc.Tas;
        tb(2,1,1,:) = TBsrc.Tas;
        tb(3,1,1,:) = 0;
        tb(4,1,1,:) = 0;
        
        E = [1;1;0;0];
        E = repmat(E,[1,1,1,Rad.num_chan]);
        
    case 'waveform'
        % -------------------------
        % waveform
        % scene in forms of waveform w/ TBsrc.mode=1/2
        % E.g. a waveform is: amp*sin(w*t+phase) + dc, where w=2*pi*num_period
        % -------------------------
        tb = [];
        E = [];
        for nfreq = 1: Rad.num_chan
            [tb(:,:,:,nfreq),E(:,:,:,nfreq)] = saterr_imp_TBsource_waveform(nfreq);
        end
        
        
    case 'linear'
        % -------------------------
        % case : linear
        % -------------------------
        
        % TBsrc.Tas is set in saterr_set_TBsource.m
        n1 = Rad.ind_CT_num(1);
        n2 = Rad.num_alongtrack;
        
        tbrange = TBsrc.linear.tbrange;
        tb1 = linspace(tbrange(1),tbrange(2),n1*n2);
        tb1 = reshape(tb1,[n1,n2]);
        
        tb = zeros(4,n1,n2);
        tb(1,:,:) = tb1;
        tb(2,:,:) = tb1;
        tb(3,:,:) = 0;
        tb(4,:,:) = 0;
        
        E = ones(4,n1,n2);
        E(3,:,:) = 0;
        E(4,:,:) = 0;
        
    otherwise
        error('Error of tb_source')
        
end



