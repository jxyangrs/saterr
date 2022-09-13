function saterr_set_crosstalk
% setting crosstalk correlation
%
% Input:
%       crosstalk correlation coefficients
%       Rad.crosstalk.X,    [channel,channel]
%
% Output:
%       Rad.crosstalk.X,    [channel,channel]
%
% Description:
%       Some crosstalk correlation reported in previous studies can be found in coeff_crosstalk_corr.m
%       Schemes are provided for implementing crosspol channel correlation, saterr_imp_crosstalk.m
%       empirical covariance: coeff_crosstalk_corr('npp','atms');
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global Rad
% -----------------------------
% setting
% -----------------------------
Rad.crosstalk.onoff = 1; % 0=no cross-channel,1=set cross-channel

if Rad.crosstalk.onoff==1
    
    scheme = 2; % 1/2/3
    switch scheme
        case 1
            % -----------------------------
            % scheme 1
            % TA = X*TA
            % X = [X11 ... X1n
            %      X21 ... X2n
            %          ...
            %      Xn1 ... Xnn]
            % e.g. uncorrelated channels have an identity matrix
            % -----------------------------
            X = eye(Rad.num_chan);
            %     X = coeff_crosstalk_corr('npp','atms');
            
        case 2
            % -----------------------------
            % scheme 2
            % TA = M*TA*refl + TA*(1-refl)
            % -----------------------------
            X = eye(Rad.num_chan);
            refl = 0.1; % reflection can take place in the antenna sub-system due to impedance mismatch or polarization grid reflection
            
        case 3
            % -----------------------------
            % scheme 3, covariance
            % M is derived from covariance
            % TA = M*TA
            % -----------------------------
            X = eye(Rad.num_chan);
            refl = 0.1; % reflection can take place in the antenna sub-system due to impedance mismatch or polarization grid reflection
    end
    
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_crosstalk






