function saterr_set_crosspol
% setting cross polarization
%
% Input:
%       cross-pol coefficients
%       Xpp,	[1,channel]
%       Xpq,	[1,channel]
%       Xp3,	[1,channel]
%       Xp4,	[1,channel]
%       Xqp,	[1,channel]
%       Xqq,	[1,channel]
%       Xq3,	[1,channel]
%       Xq4,	[1,channel]
%       X3p,	[1,channel]
%       X3q,	[1,channel]
%       X33,	[1,channel]
%       X34,	[1,channel]
%       X4p,	[1,channel]
%       X4q,	[1,channel]
%       X43,	[1,channel]
%       X44,	[1,channel]
% 
% Output:
%       AP.crosspol.X,    [4,4,channel]
% 
% Description:
%       crosspol coefficients are defined in matrix such that
%           [Tap = [Xpp Xpq Xp3 Xp4 * [Tap_in     
%            Taq    Xqp Xqq Xq3 Xq4    Taq_in       i.e.    Stokes_out = M * Stokes_in  
%            Ta3    X3p X3q X33 X34    Ta3_in
%            Ta4]   X4p X4q X43 X44]   Ta4_in]
%       where p,q can represent V,H,QV,QH. pp is col-pol, pq is cross-pol. Normalization is required, sum(M,2)==1.
% 
%       E.g. for conical scanning sensor w/ V, H channels, there is:
%           [Tav = [Xvv Xvh Xv3 Xv4 * [Tav_in
%            Tah    Xhv Xhh Xh3 Xh4    Tah_in
%            Ta3    X3v X3h X33 X34    Ta3_in
%            Ta4]   X4v X4h X43 X44]   Ta4_in]
%
%       when there is no crosspol contamination
%           [Tav = [1 0 0 0 * [Tav_in
%            Tah    0 1 0 0    Tah_in
%            Ta3    0 0 1 0    Ta3_in
%            Ta4]   0 0 0 1]   Ta4_in]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global AP Rad
% -----------------------------
% setting
% -----------------------------
AP.crosspol.onoff = 0; % 0=no cross-pol,1=set cross-pol coefficients

if AP.crosspol.onoff==1
    % -----------------------------
    % format:
    % M = [Xpp Xpq Xp3 Xp4
    %      Xqp Xqq Xq3 Xq4
    %      X3p X3q X33 X34
    %      X4p X4q X43 X44]
    % sum(M,2)==1
    % -----------------------------

    Xpp = 0.95*ones(1,Rad.num_chan); % [1,channel]
    Xpq = 0.05*ones(1,Rad.num_chan);
    Xp3 = 0.000*ones(1,Rad.num_chan);
    Xp4 = 0.000*ones(1,Rad.num_chan);
    Xqp = 0.05*ones(1,Rad.num_chan);
    Xqq = 0.95*ones(1,Rad.num_chan);
    Xq3 = 0.000*ones(1,Rad.num_chan);
    Xq4 = 0.000*ones(1,Rad.num_chan);
    X3p = 0.000*ones(1,Rad.num_chan);
    X3q = 0.000*ones(1,Rad.num_chan);
    X33 = 1.000*ones(1,Rad.num_chan);
    X34 = 0.000*ones(1,Rad.num_chan);
    X4p = 0.000*ones(1,Rad.num_chan);
    X4q = 0.000*ones(1,Rad.num_chan);
    X43 = 0.000*ones(1,Rad.num_chan);
    X44 = 1.000*ones(1,Rad.num_chan);
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_crosspol






