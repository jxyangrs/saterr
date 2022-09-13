% initializing Tc, Tw
% 
% Input:
%       cold-space and warm-load setting
% 
% Output:
%       Tac,        Stokes of cold-space,       [Stokes,crosstrack,alongtrack]
%       Taw,        Stokes of warm-load,        [Stokes,crosstrack,alongtrack]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code


% one orbit
ind_startend = Rad.alongtrack_orbit_ind_startend(Rad.norbit,:);
n2 = ind_startend(2) - ind_startend(1) + 1;

% parameters
Tc0 = Rad.Tc(nchan);
Tw0 = Rad.Tw(nchan);

% tc, tw
n1 = Rad.ind_CT_num(2);
tc = Tc0*ones(n1,n2);
n1 = Rad.ind_CT_num(3);
tw = Tw0*ones(n1,n2);

% Tac, Taw
n1 = Rad.ind_CT_num(3);
Taw = zeros(4,n1,n2);
Taw(1,:,:) = tw;
Taw(2,:,:) = tw;

n1 = Rad.ind_CT_num(2);
Tac = zeros(4,n1,n2);
Tac(1,:,:) = tc;
Tac(2,:,:) = tc;
