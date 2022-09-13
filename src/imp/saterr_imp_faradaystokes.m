function saterr_imp_faradaystokes
% Stokes parameters change due to Faraday rotation
%
%
% Input:
%       Faraday.omega,          Farady rotation angle (degree),     [cross-track,alongtrack,uniq-frequency]
%       VarDynamic.Tas,         Stokes before ionosphere,           [4,crosstrack,alongtrack,uniq-frequency]
%
% Output:
%       VarDynamic.Tas,         Stokes after ionosphere,            [4,crosstrack,alongtrack,uniq-frequency]
%       Faraday.U,              Stokes U after ionosphere,          [crosstrack,alongtrack,uniq-frequency]
%       VarDynamic.Tas,         Stokes after ionosphere,            [4,crosstrack,alongtrack,uniq-frequency]
%       Faraday.chan.omega,     channel omega (degree),             [cross-track,alongtrack,channel]
%       Faraday.chan.d,         channel d (K),                      [cross-track,alongtrack,channel]
%       Faraday.chan.U,         channel U (K),                      [cross-track,alongtrack,channel]
% 
% Description:
%       Theory and equation:
%       Given that input Stokes [Tv1,Th1,U1,V1], output Stokes [Tv2,Th2,U2,V2], 
%       omega = 1.355e-5.*VTEC.*f.^(-2).*Bp.*secd(psi); % Bp (nano Tesla), TEC (TECU), f (GHz), psi (tilt ange, degree)
%       Q1 = Tv1-Th1;
%       d = Q1.*sind(omega).^2 - U1/2.*sind(2*omega);
%       Tv2 = Tv1 - d;
%       Th2 = Th1 + d;
%       U2 = U1.*cosd(2*omega) - Q1.*sind(2*omega);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code

global Orbit Faraday VarDynamic Rad

% -----------------------------
% Faraday rotation
% -----------------------------

if Orbit.onoff==1 && Faraday.onoff==1
    % -----------------------------
    % Faraday rotation of uniq-frequency
    % -----------------------------
    Tas = VarDynamic.Tas;
    Tas2 = Tas;
    omega = Faraday.omega;
    
    n2=size(Tas,2);n3=size(Tas,3);n4=size(Tas,4);
    
    d_uniqfreq = zeros(n2,n3,n4);
    U2_uniqfreq = zeros(n2,n3,n4);
    for i=1: n4
        Tv = reshape(Tas(1,:,:,i),[n2,n3]);
        Th = reshape(Tas(2,:,:,i),[n2,n3]);
        U = reshape(Tas(3,:,:,i),[n2,n3]);
        omega1 = omega(:,:,i);
        
        Q = Tv-Th;
        d = Q.*sind(omega1).^2 - U/2.*sind(2*omega1);
        Tv2 = Tv - d;
        Th2 = Th + d;
        U2 = U.*cosd(2*omega1) - Q.*sind(2*omega1);
        
        Tas2(1,:,:,i) = Tv2;
        Tas2(2,:,:,i) = Th2;
        Tas2(3,:,:,i) = U2;
        
        d_uniqfreq(:,:,i) = d;
        U2_uniqfreq(:,:,i) = U2;
    end
    
    % -----------------------------
    % channel's Faraday
    % -----------------------------
    for nchan=1: Rad.num_chan
        idx = Rad.subband.ind2chan==nchan;
        ind = Rad.subband.uniq_ind_freq2band(idx);
        
        d = d_uniqfreq(:,:,ind);
        U2 = U2_uniqfreq(:,:,ind);
        omega1 = omega(:,:,ind);
        
        % average w/ boxcar window (SRF not counted)
        if length(ind)>1
            d = mean(d,3);
            U2 = mean(U2,3);
            omega1 = mean(omega1,3);
        end
        
        % output
        Faraday.chan.omega(:,:,nchan) = omega1;
        Faraday.chan.d(:,:,nchan) = d;
        Faraday.chan.U(:,:,nchan) = U2;
    end
    
    
    VarDynamic.Tas = Tas2;
end







