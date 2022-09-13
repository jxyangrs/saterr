function [EV,EH] = ocean_emissivity(T,Freq,W,ANGLE)
% emissivity of ocean
%
% Input:
%       T,          sea surface temperature in (K)  scalar/N-D
%       Freq,       frequency in (GHz)              scalar/N-D
%       W,          wind speed in (m/s)             scalar/N-D
%       ANGLE,      incidence angle in (degrees)    scalar/N-D
%
% Output:
%       EV,         emissivity vertical polarization
%       EH,         emissivity horizontal polarization
%
% Literature:
%       Elsaesser, G., 2006: A parametric optimal estimation retrieval of the non-precipitating parameters over the global oceans. M.S. thesis, Dept. of Atmospheric Science, Colorado State University

% setting
S = 34; % sea surface salinity (ppt)

EPS_WNTZ = ocean_emissivity_dia(T,S,Freq);
EPS=conj(EPS_WNTZ);

CUNITY = complex(1.0,0.0);

% Use Fresnel Equations below (G. Elsaesser MS Thesis (2006) )
ANGLE_RAD = ANGLE*pi/180 ;
CTERM1V = EPS .* cos(ANGLE_RAD);
CTERM1H = CUNITY .* cos(ANGLE_RAD);
CTERM2 = sqrt(EPS - sin(ANGLE_RAD).*sin(ANGLE_RAD));
CTERMV = (CTERM1V - CTERM2)./(CTERM1V + CTERM2);
CTERMH = (CTERM1H - CTERM2)./(CTERM1H + CTERM2);
EMISV = 1.0 - abs(CTERMV).*abs(CTERMV);
EMISH = 1.0 - abs(CTERMH).*abs(CTERMH);

% FROM HERE THE EFFECT OF SURFACE ROUGHNESS AND FOAM ARE INCLUDED
% BASED ON HOLLINGER MODEL AND FOAM MODEL OF STOGRYN
RSH = 1-EMISH;
RSV = 1-EMISV;

FOAM = 7.751E-06 * (W.^3.231);

GH = 1-1.748E-3*ANGLE-7.336E-5*ANGLE.^2+1.044E-7*ANGLE.^3;
GV = 1-9.946E-4*ANGLE+3.218E-5*ANGLE.^2-1.187E-6*ANGLE.^3+7.0E-20*ANGLE.^10;

A1 = (208.0+1.29*Freq)./T;

RFV = 1. - A1 .* GV;
RFH = 1. - A1 .* GH;

Y = 7.32E-02*ANGLE;

% T SURFACE TEMP IS IN DEGREE KELVIN
SQRTF = sqrt(Freq);

CORRV = (W.*(1.17E-01-2.09E-03*exp(Y)).*SQRTF./T);
CORRH = (W.*(1.15E-01+3.80E-05*ANGLE.^2).*SQRTF./T);

RRV = RSV-CORRV;
RRH = RSH-CORRH;

RV = RRV.*(1-FOAM)+RFV.*FOAM;
RH = RRH.*(1-FOAM)+RFH.*FOAM;

EH = 1-RH;
EV = 1-RV;

function [EPS_Conj] = ocean_emissivity_dia(T,S,Freq)
% Complex Dielectric constant of Water
%
% Inputs:
%       T,      Sea Surface Temperature in [K];
%               For Saline: 271.16K (-2 C) to 307.16K (34C); For Fresh: 248.16K (-25C) to 313.16K (40C); size, N-D
%       S,      Salinity in [ppt]; can range from 0 to 40; size, scalar
%       Freq,   Frequency in [GHz], can range from 1 to 400 GHz; size, N-D
%
% Output:
%       EPS_Conj: complex dielectric constant
%

J = complex(0,1); %Sets J = i (complex number)
F0 = 17.97510;

X = [5.7230e00
    2.2379e-02
    -7.1237e-04
    5.0478e00
    -7.0315e-02
    6.0059e-04
    3.6143e00
    2.8841e-02
    1.3652e-01
    1.4825e-03
    2.4166e-04];

Z = [-3.56417e-03
    4.74868e-06
    1.15574e-05
    2.39357e-03
    -3.13530e-05
    2.52477e-07
    -6.28908e-03
    1.76032e-04
    -9.22144e-05
    -1.99723e-02
    1.81176e-04
    -2.04265e-03
    1.57883e-04];

SST = T-273.15; %Temperature Conversion

% Pure Water
E0 = (3.70886E4 - 8.2168E1*SST)./(4.21854E2 + SST);  % Stogryn et al.
E1 = X(1) + X(2)*SST + X(3)*(SST.^2);
N1 = (45.00 + SST)./(X(4) + X(5)*SST + X(6)*(SST.^2));
E2 = X(7) + X(8)*SST;
N2 = (45.00 + SST)./(X(9) + X(10)*SST + X(11)*(SST.^2));

% Saline Water
% Conductivity [S/m] taken from Stogryn et al.
SIG35 = 2.903602 + 8.60700E-2*SST + 4.738817E-4*(SST.^2) - 2.9910E-6*(SST.^3) + 4.3047E-9*(SST.^4);
R15 = S*(37.5109+5.45216*S+1.4409E-2*(S^2))/(1004.75+182.283*S+(S^2));
ALPHA0 = (6.9431+3.2841*S-9.9486E-2*(S^2))/(84.850+69.024*S+(S^2));
ALPHA1 = 49.843 - 0.2276*S + 0.198E-2*(S^2);
RTR15 = 1.0 + (SST-15.0).*ALPHA0./(ALPHA1+SST);
SIG = SIG35.*R15.*RTR15;

% Permittivity
A0  = exp(Z(1)*S + Z(2)*(S^2) + Z(3)*S*SST);
E0S = A0.*E0;
B1  = 1.0 + S*(Z(4) + Z(5)*SST + Z(6)*(SST.^2));
N1S = N1.*B1;
A1  = exp(Z(7)*S + Z(8)*(S^2) + Z(9)*S*SST);
E1S = E1.*A1;
B2 = 1.0 + S*(Z(10) + Z(11)*SST);
N2S = N2.*B2;
A2 = 1.0  + S*(Z(12) + Z(13)*SST);
E2S = E2.*A2;

% Debye Law (2 relaxation wavelengths)
EPS =(E0S - E1S)./(1.0 - J*(Freq./N1S))+(E1S - E2S)./(1.0-J*(Freq./N2S))+E2S +J*SIG.*F0./Freq;
EPS_Conj = conj(EPS);
