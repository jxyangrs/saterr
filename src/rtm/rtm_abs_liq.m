function absLIQ = rtm_abs_liq(WATER,FREQ,TEMP)
% Cloud Liquid Water (Suspended) Absorption Model
% Inputs: WATER: Cloud Liquid Water in (g/m^3); 2D [heights,grids]
%         FREQ: Frequency in (GHz); vector: 1D [freqs]
%         TEMP: Temperature in (K); matrix: 2D [heights,grids]
%
% Output: Liquid Water Absorption Coefficient in (Np/km)

%-----------------Original Fortran Documentation-----------------------
% C     COMPUTES ABSORPTION IN NEPERS/KM BY SUSPENDED WATER DROPLETS
% c     ARGUMENTS (INPUT):
% C     WATER IN G/M**3 (rho)
% C     FREQ IN GHZ     (VALID FROM 0 TO 1000 GHZ)
% C     TEMP IN KELVIN
% C
% C     REFERENCES:
% C     LIEBE, HUFFORD AND MANABE, INT. J. IR & MM WAVES V.12, pp.659-675
% C      (1991);  Liebe et al, AGARD Conf. Proc. 542, May 1993.
% c
% C     REVISION HISTORY:
% C        PWR 8/3/92   original version
% c        PWR 12/14/98 temp. dependence of EPS2 eliminated to agree
% c                     with MPM93
% c        pwr 2/27/02  use exponential dep. on T, eq. 2b instead of eq. 4a
%----------------------------------------------------------------------

% if(WATER<0)
%   ABSLIQ = 0;
%   return
% end

% apply parameterization to compute absorption of liquid water
THETA1 = 1.-300./TEMP;
EPS0 = 77.66 - 103.3*THETA1;
EPS1 = .0671*EPS0;
EPS2 = 3.52;                % from MPM93
FP = 20.1*exp(7.88*THETA1);  % from eq. 2b
FS = 39.8*FP;

EPS = (EPS0-EPS1)./(1+1i*FREQ./FP) + ...
    (EPS1-EPS2)./(1+1i*FREQ./FS) +EPS2;

RE = (EPS-1.)./(EPS+2.);

absLIQ = -.06286*imag(RE).*FREQ.*WATER;

