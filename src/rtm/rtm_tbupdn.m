function [tbup, tbdn] = rtm_tbupdn(T,alpha,eia)
% radiative transfer of atmosphere
%
% Input:
%       T,          tempearture (K),                            [altitude(bottom-up),pixel,channel]
%       alpha,      absorption (Neper),                         [altitude(bottom-up),pixel,channel]
%       eia,        Earth incidence angle (degree),             [altitude(bottom-up),pixel,channel]
%
% Output: 
%       tbup,       upwelling brightness temperature (K),       [1,pixel,channel]
%       tbdn,       downwelling brightness temperature (K),     [1,pixel,channel]
%       tau_atm,    optical depth of atmosphere (Np),           [1,pixel,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu or johnxun@umich.edu, 12/01/2016: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu or johnxun@umich.edu, 09/09/2018: debug asc/des mismatch

eia = eia*pi/180;
[~,n2,n3] = size(T);

% upwelling
tau_up = cumsum(alpha(end:-1:1,:,:),1); 
tau_up = tau_up(end:-1:1,:,:);
tau_up = [tau_up(2:end,:,:); zeros(1,n2,n3)];  
tbup = sum(T.*(1-exp(-sec(eia).*alpha)).*exp(-tau_up.*sec(eia)),1); 

% downwelling
tau_dn = cumsum(alpha,1); 
tau_dn = [zeros(1,n2,n3); tau_dn(1:end-1,:,:)]; 
tbdn = sum(T.*(1-exp(-sec(eia).*alpha)).*exp(-tau_dn.*sec(eia)),1); 