function h_interp = press2h_interp(p_interp)
% Barometric formula
% 
% Input:
%       p_interp,     pressure (mb),        [altitude(top-down,ascending),pixel]
% 
% Output:
%       h_interp      altitude (meter),     [altitude(top-down,ascending),pixel]
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu or johnxun@umich.edu, 09/09/2018: original code

% reference altitude and pressure of 137-level
[h_1D,pres_1D] = atm_ph_139;

% top-bottom range fixed
idx = p_interp<pres_1D(1);
p_interp(idx) = pres_1D(1);

idx = p_interp>pres_1D(end);
p_interp(idx) = pres_1D(end);

% interp
[n1,n2] = size(p_interp);
p = pres_1D;
p = repmat(p,[1,n2]);

h = h_1D;
h = repmat(h,[1,n2]);

h_interp = interp_lin_2D_asc(p_interp,p,h);


