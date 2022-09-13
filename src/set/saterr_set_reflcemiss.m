function saterr_set_reflcemiss
% setting for reflector emissivity and temperature
%
% Input:
%       setting for reflector emissivity
% 
% Output:
%       Reflector.emission.E,      emissivity Stokes,           [Emissivity(V,H,3,4),channel]
%       Reflector.emission.tmp,    reflector temperature,       [1,alongtrack]/scalar
%
% Description:
%       The emissivity is defined in the reflector's reflection plane such that Ev>Eh
%       The reflection plane that is parallel to the incidence plane for conical scanning radiometers, but perpendicular to
%       the incidence plane for cross-track scanning radiometers.
%       Given the 45-degree reflector in crosstrack scanning atms, an approximate can be made as Ev=2*Eh
%
% Note:
%       Literature reported reflector emissivity
%       f16 ssmis:  0.05,   0.08,   0.09,   0.10,   0.10
%                   91h,    150h,   183±7h, 183±3h, 183±1h
%       npp atms:   0.0025, 0.0026, 0.0045, 0.0039
%                   K-band, V-band, W-band, G-band
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes

global Reflector Rad

% -----------------------------
% setting
% -----------------------------
Reflector.emission.onoff = 0; % 0=off,1=on

% set up the emissivity for onoff==1
if Reflector.emission.onoff==1
    n1 = Rad.num_chan;
    n2 = Rad.num_alongtrack;
    Reflector.emission.E = repmat([0.005;0.0025;0;0],[1,n1]); % emissivity of V-pol, H-pol, [Ev&Eh,channel], Ev>Eh, defined in reflection plane that is perpendicular to cross-track plane
    Reflector.emission.tmp = 300; % reflector physical temperature (Kelvin), [1,alongtrack]/scalar
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_reflcemiss

% -----------------------------
% setting for Path.scheme='B'
% -----------------------------
saterr_set_reflcemiss_sat_ana
