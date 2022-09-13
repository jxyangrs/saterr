function saterr_imp_targetTB
% target/surface tb
%
% Input:
%       AP.tbsrc.mainlobe,  target of mainlobe,         string(ocean,land,etc.)
%
% Output:
%     atmosphere is off:
%       tb_mainlobe,        reference far-field TB (K),          [Stokes(4),crosstrack,alongtrack,uniq-frequency/channel]/[Stokes(4),1,1,uniq-frequency/channel]
%       E_mainlobe,         target/surface emissivity (K),       [Stokes(4),crosstrack,alongtrack,uniq-frequency/channel]/[Stokes(4),1,1,uniq-frequency/channel]
%       Tas,                TB Stokes (K),                       [Stokes(4),crosstrack,alongtrack,uniq-frequency/channel]/[Stokes(4),1,1,uniq-frequency/channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2019: original code

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path NGranuel CalPara

tb_mainlobe = [];
E_mainlobe = [];
Tas = [];


% far field TB of modified stokes
saterr_set_TBsource(AP.tbsrc.mainlobe);

switch AP.tbsrc.mainlobe
    case {'customize','zero','constant','waveform','linear'}
        % using channel frequency regardless of replicate
        mode = 'channel';
        saterr_imp_uniqfreq(mode)
        
        % loading presetting
        [tb_mainlobe,E_mainlobe] = saterr_imp_TBsourcesim_load(AP.tbsrc.mainlobe);
        
    case {'ocean','land','cosmic'}
        % using Rad.subband.uniq_freq
        mode = 'unique';
        saterr_imp_uniqfreq(mode)
        freq = Rad.subband.uniq_freq;
        for nfreq = 1: length(freq)
            % modeling
            [tb_mainlobe(:,:,:,nfreq),E_mainlobe(:,:,:,nfreq)] = saterr_imp_TBsourcesim_model(AP.tbsrc.mainlobe,freq(nfreq));
        end
        
    otherwise
        error(['AP.tbsrc.mainlobe is wrong: ',AP.tbsrc.mainlobe])
        
end
Tas = tb_mainlobe;
VarDynamic.tb_mainlobe = tb_mainlobe;
VarDynamic.E_mainlobe = E_mainlobe;
VarDynamic.Tas = Tas;


