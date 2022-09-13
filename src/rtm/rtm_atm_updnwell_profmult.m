function [tbup, tbdn, tau] = rtm_atm_updnwell_profmult
% compute atmosphere up-downwell w/ customized multiple profiles
%
% Input:
%       Prof.atm_pres,      pressure (mb),                          [altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_tmp,       temperature (K),                        [altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_q,         specific humidity (kg/kg)               [altitude(top-down),crosstrack,alongtrack]
%       Orbit.fov.eia,      Earth incidence angle (degree),         [crosstrack,alongtrack]
%       Rad.subband.uniq_freq,      frequency including subbands (GHz),     [1,uniq-frequency]
%
% Output:
%       tbup,               upwell brightness temperature (K),      [crosstrack,alongtrack,uniq-frequency]
%       tbdn,               downwell brightness temperature (K),    [crosstrack,alongtrack,uniq-frequency]
%       tau,                optical depth of atmosphere (Np),       [crosstrack,alongtrack,uniq-frequency]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

global Rad Orbit
% -----------------------------
% setting
% -----------------------------
MemoryMax = 2e8; % maximum size of single variable (Byte)

% -----------------------------
% pre-process
% -----------------------------
% input
[uniq_pres,uniq_tmp,uniq_qabs] = rtm_prof;

% preprocessing
[nlayer,ncrosstrack,nalongtrack] = size(uniq_pres);
freq = Rad.subband.uniq_freq;
nfreq = length(freq);

eia = Orbit.fov.eia;
eia = eia(:);

npixel = ncrosstrack*nalongtrack;

uniq_pres = reshape(uniq_pres,[nlayer,npixel]);
uniq_tmp = reshape(uniq_tmp,[nlayer,npixel]);
uniq_qabs = reshape(uniq_qabs,[nlayer,npixel]);

% set a proper bin of pixel to avoid out of memory
Nbin = round(MemoryMax/(nlayer*nfreq*8));

% break down pixel
[ind1,ind2] = ind_startend_bin(npixel,Nbin);

% -----------------------------
% compute
% -----------------------------

% variables
tbup = zeros(npixel,nfreq); % [pixel,frequency]
tbdn = zeros(npixel,nfreq);
tau = zeros(npixel,nfreq);

% go through Nbin
for i=1: length(ind1)
    
    % pixel bin
    ind = ind1(i): ind2(i);
    nbin = ind2(i) - ind1(i) + 1;
    
    % altitude
    pres1 = uniq_pres(:,ind); % top-down (asecnding value)
    pres1 = pres1(end:-1:1,:);
    h = press2h_interp(pres1);
    h = h(end:-1:1,:);
    dh = diff(h,1);
    dh = dh([1:end,end],:,:); 
    dh = dh*1e-3; % km

    % absorption
    pres1 = uniq_pres(:,ind);
    tmp1 = uniq_tmp(:,ind);
    qabs1 = uniq_qabs(:,ind);
    
    pres1 = repmat(pres1,[1,1,nfreq]);
    tmp1 = repmat(tmp1,[1,1,nfreq]);
    qabs1 = repmat(qabs1,[1,1,nfreq]);
    
    freq1 = [];
    freq1(1,1,:) = freq(:);
    freq1 = repmat(freq1,[nlayer,nbin,1]);
    
    absatm1 = rtm_atm_abs(pres1,tmp1,qabs1,freq1);
    alpha1 = bsxfun(@times,absatm1,dh);
    
    % up-downwell
    eia1 = [];
    eia1(1,:) = eia(ind);
    eia1 = repmat(eia1,[nlayer,1,nfreq]);
    
    [tbup1, tbdn1] = rtm_tbupdn(tmp1,alpha1,eia1);
    tau1 = sum(alpha1,1);
    
    tbup1 = reshape(tbup1,[nbin,nfreq]);
    tbdn1 = reshape(tbdn1,[nbin,nfreq]);
    tau1 = reshape(tau1,[nbin,nfreq]);
    
    tbup(ind,:) = tbup1;
    tbdn(ind,:) = tbdn1;
    tau(ind,:) = tau1;
end

tbup = reshape(tbup,[ncrosstrack,nalongtrack,nfreq]);
tbdn = reshape(tbdn,[ncrosstrack,nalongtrack,nfreq]);
tau = reshape(tau,[ncrosstrack,nalongtrack,nfreq]);

