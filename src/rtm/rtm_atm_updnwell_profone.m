function [tbup, tbdn, tau] = rtm_atm_updnwell_profone
% compute atmosphere up-downwell w/ default single profile
%
% Input:
%       Prof.atm_pres,      pressure (mb),                          [altitude(top-down),1]
%       Prof.atm_tmp,       temperature (K),                        [altitude(top-down),1]
%       Prof.atm_q,         specific humidity (kg/kg)               [altitude(top-down),1]
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
% prepare atmospheric profiles
% -----------------------------
[uniq_pres,uniq_tmp,uniq_qabs] = rtm_prof;

% -----------------------------
% setting
% -----------------------------
MemoryMax = 2e8; % maximum size of single variable (Byte)

% -----------------------------
% pre-process
% -----------------------------
% variables
[n1,n2] = size(uniq_pres);
freq = Rad.subband.uniq_freq;
n3 = length(freq);

eia = Orbit.fov.eia;
[ncross,nalong] = size(eia);
eia = eia(:);

nlayer = n1;
npixel = ncross*nalong;
nfreq = n3;

% set a proper bin of pixel to avoid out of memory
Nbin = round(MemoryMax/(nlayer*nfreq*8));

% break down pixel
[ind1,ind2] = ind_startend_bin(npixel,Nbin);

% -----------------------------
% absorption
% -----------------------------
% layer absorption (Neper/km)
pres1 = uniq_pres(:,:,ones(nfreq,1));
tmp1 = uniq_tmp(:,:,ones(nfreq,1));
qabs1 = uniq_qabs(:,:,ones(nfreq,1));
freq1=[];freq1(1,1,:) = freq(:);
freq1 = repmat(freq1,[nlayer,1,1]);

absatm = rtm_atm_abs(pres1,tmp1,qabs1,freq1);

% altitude
p = uniq_pres(end:-1:1); % top-down (asecnding value)
h = press2h_interp(p);
h = h(end:-1:1,:);
dh = diff(h,1); 
dh = dh([1:end,end],:,:); % bottom-up

% absorption (Neper)
alpha = bsxfun(@times,absatm,dh*1e-3);

% -----------------------------
% compute atmosphere up-downwell
% -----------------------------

% variables
tbup = zeros(npixel,nfreq);
tbdn = zeros(npixel,nfreq);
tau = zeros(npixel,nfreq);

% atmospheric up-downwell
for i=1: length(ind1)
    ind = ind1(i): ind2(i);
    n = ind2(i) - ind1(i) + 1;
    tmp1 = repmat(uniq_tmp,[1,n,nfreq]);
    eia1 = repmat(eia(ind)',[nlayer,1,nfreq]);
    alpha1 = alpha(:,ones(n,1),:);
    
    tau1 = sum(alpha1,1);
    [tbup1,tbdn1] = rtm_tbupdn(tmp1,alpha1,eia1);
    
    tbup(ind,:) = squeeze(tbup1);
    tbdn(ind,:) = squeeze(tbdn1);
    tau(ind,:) = squeeze(tau1);
end

tbup = reshape(tbup,[ncross,nalong,nfreq]);
tbdn = reshape(tbdn,[ncross,nalong,nfreq]);
tau = reshape(tau,[ncross,nalong,nfreq]);

