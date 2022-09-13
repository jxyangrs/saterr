function saterr_imp_targetTB_prof
% target/surface tb for using observational satellite and reanalysis data
%
% Input:
%       AP.tbsrc.mainlobe,  target/surface mainlobe TB (K),         string(ocean,land,etc.)
%
% Output:
%     atmosphere is off:
%       tb_mainlobe,        reference far-field TB (K),             [Stokes(4),crosstrack,alongtrack,uniq-frequency]
%       E_mainlobe,         target/surface emissivity (K),          [Stokes(4),crosstrack,alongtrack,uniq-frequency]
%       Tas,                TB Stokes (K),                          [Stokes(4),crosstrack,alongtrack,uniq-frequency]/empty
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2019: original code

global Rad AP Prof VarDynamic Orbit

tb_mainlobe = [];
E_mainlobe = [];
Tas = [];

E_land = 0.9;

for nfreq = 1: Rad.subband.uniq_freq_num
    VarDynamic.nfreq = nfreq;

    [n1,n2] = size(Prof.sfc_tmp);
    
    % ocean
    sst1 = Prof.sfc_tmp;
    freq1 = Rad.subband.uniq_freq(nfreq);
    wind1 = Prof.sfc_ws;
    eia1 = Orbit.fov.eia;
    [EV1,EH1] = ocean_emissivity(sst1,freq1,wind1,eia1);
    
    tb1(1,:,:) = sst1.*EV1;
    tb1(2,:,:) = sst1.*EH1;
    tb1(3,:,:) = 0;
    tb1(4,:,:) = 0;
    
    E1(1,:,:) = EV1;
    E1(2,:,:) = EH1;
    E1(3,:,:) = zeros(size(EV1));
    E1(4,:,:) = zeros(size(EV1));
    
    % land
    sfc_tmp = Prof.sfc_tmp;
    sfc_emis = E_land;
    
    tb2(1,:,:) = sfc_tmp.*sfc_emis;
    tb2(2,:,:) = sfc_tmp.*sfc_emis;
    tb2(3,:,:) = 0;
    tb2(4,:,:) = 0;
    
    E2(1,:,:) = sfc_emis;
    E2(2,:,:) = sfc_emis;
    E2(3,:,:) = 0;
    E2(4,:,:) = 0;
    
    % location of land+sea
    x = Prof.landseafrac;
    landseafrac(1,:,:) = x;
    
    tb_mainlobe(:,:,:,nfreq) = bsxfun(@times,tb1,1-landseafrac)+bsxfun(@times,tb2,landseafrac);
    E_mainlobe(:,:,:,nfreq) = bsxfun(@times,E1,1-landseafrac)+bsxfun(@times,E2,landseafrac);

end

Tas = tb_mainlobe;
VarDynamic.tb_mainlobe = tb_mainlobe;
VarDynamic.E_mainlobe = E_mainlobe;
VarDynamic.Tas = Tas;

VarDynamic = rmfield(VarDynamic,'nfreq');

