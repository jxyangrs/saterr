function saterr_set_reflcemiss_sat_ana
% setting reflector emissivity and temperature for Path.scheme='B'
%
% Input:
%       setting for reflector emissivity and temperature
% 
% Output:
%       Reflector.emission.E,      emissivity Stokes,           [Emissivity(V,H,3,4),channel]
%       Reflector.emission.tmp,    reflector temperature,       scalar
%
% Description:
%       For since Path.scheme='B', reflector temperature can only be set as a scalar, as the scheme carries out simulation with varied granule length. 
%       That is, Rad.num_alongtrack is dependent on the granule file.
%       The reflector temperature is supposed to be from measurement if the effect of solar incidence angle needs to be counted.
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes

global Reflector Rad Path
% -----------------------------
% setting
% -----------------------------

% set up the emissivity for onoff==1
if Reflector.emission.onoff==1 && (Path.scheme=='B')
    n1 = Rad.num_chan(1);
    n2 = Rad.num_alongtrack;
    Reflector.emission.E = repmat([0.005;0.005;0;0],[1,n1]); % emissivity of V-pol, H-pol, [Ev&Eh,channel], Ev>Eh, defined in reflection plane that is perpendicular to cross-track plane
    Reflector.emission.tmp = 300; % reflector physical temperature (Kelvin), [scalar]
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_reflcemiss_sat_ana
