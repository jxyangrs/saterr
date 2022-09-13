function [tb_sidelobe] = saterr_imp_TBsource_sidelobe(tb_source)
% implement tb of sidelobe or spillover
%
% Input:
%       tb_source,              customize_Table/customize_Function_Mainlobe
%       VarDynamic,
%           .tb_mainlobe 
%           .nchan
% 
% Output:
%       tb_sidelobe,            [Stokes,1,1,channel]/[Stokes,crosstrack,alongtrack,channel]
%
% Examples:
%       tb_sidelobe = saterr_imp_TBsource_tbsidelobe('customize_Table');
%       tb_sidelobe = saterr_imp_TBsource_tbsidelobe('customize_Function_Mainlobe');
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/06/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/01/2019: separate mainlobe from sidelobe/spillover

global Rad TBsrc VarDynamic

tb_sidelobe = [];

% build up scene TBsrc
switch tb_source
    case 'customize_table'
        % -------------------------
        % customize w/ empirical and observation
        % It can also come from external data such as empirical scene from RTM or observations
        % -------------------------
        tb_sidelobe = TBsrc.tb_sidelobe.tb; % [Stokes,crosstrack,alongtrack,channel]
        
    case 'customize_sidefuncmain'
        % -------------------------
        % In many practice, sidelobe is estimated from tb of mainlobe
        % -------------------------
        tb_mainlobe = VarDynamic.tb_mainlobe;
        tb_sidelobe = TBsrc.tb_sidelobe.func(tb_mainlobe); % [Stokes,crosstrack,alongtrack,channel]

    case 'same_as_mainlobe'
        % -------------------------
        % sidelobe is the same as mainlobe
        % -------------------------
        tb_mainlobe = VarDynamic.tb_mainlobe;
        tb_sidelobe = tb_mainlobe; % [Stokes,crosstrack,alongtrack,channel]

    case {'ocean','land'}
        % -------------------------
        % such as for maneuver
        % -------------------------
        tb = [];
        E = [];
        freq = Rad.subband.freq;
        for nfreq = 1: Rad.num_chan
            % far field TB of modified stokes
            saterr_set_TBsource(tb_source);
            [tb(:,:,:,nfreq),E(:,:,:,nfreq)] = saterr_imp_TBsourcesim_model(tb_source,freq(nfreq));
        end
        tb_sidelobe = tb;
        
        if Rad.subband.num>Rad.num_chan
            tb_sidelobe = saterr_imp_band2chan_inout(tb_sidelobe);
        end
        
    case {'cosmic'}
        % -------------------------
        % cosmic
        % -------------------------
        tb_sidelobe = [];
        E = [];
        saterr_set_TBsource(tb_source);
        for nfreq = 1: Rad.num_chan
            % far field TB of modified stokes
            [tb_sidelobe(:,:,:,nfreq),E(:,:,:,nfreq)] = saterr_imp_TBsourcesim_model(tb_source);
        end
        
    case {'zero'}
        tb_sidelobe  = 0*ones(4,1,1,Rad.num_chan);
        
    case {'constant'}
        tb_sidelobe  = TBsrc.tb_sidelobe.tb;

    case 'waveform'
        % -------------------------
        % waveform
        % scene in forms of waveform w/ TBsrc.mode=1/2
        % E.g. a waveform is: amp*sin(w*t+phase) + dc, where w=2*pi*num_period
        % -------------------------
        tb_sidelobe = [];
        E = [];
        for nfreq = 1: Rad.num_chan
            [tb_sidelobe(:,:,:,nfreq),E(:,:,:,nfreq)] = saterr_imp_TBsource_waveform(nfreq);
        end
        
    otherwise
        error('tb_source is not found')
        
end




