function absH2O = rtm_abs_wvp(T,P,rho,F)
% Water Vapor Absorption Model
% Inputs: 
%       T,      Temperature in (K)
%       P,      Pressure in (mb)
%       rho,    Water Vapor Density in (g/m^3)
%       F,      Frequency in (GHz)
%
% Output: 
%       absH2O, Water Vapor Absorption Coefficient in (Np/km)
% 
% Description:
%       This code is based on the Fortran code of Rosenkranz model of version 2020
%       http://cetemps.aquila.infn.it/mwrnet/lblmrt_ns.html
%       [DOI: 10.21982/M81013 ] Line-by-line microwave radiative transfer (non-scattering)


%Line Frequencies
FL= [22.2351 183.3101 321.2256 325.1529 380.1974 439.1508...
    443.0183 448.0011 470.8890 474.6891 488.4911 556.9360...
    620.7008 752.0332 916.1712];
%Line Itensities at 300K
S1= [0.1314e-13 .2279e-11 .8058e-13 .2701e-11 .2444e-10...
    .2185e-11 .4637e-12 .2568e-10 .8392e-12 .3272e-11 .6676e-12...
    .1535e-08 .1711e-10 .1014e-08 .4238e-10];
%T Coeff. of Intensities
B2= [2.144 .668 6.179 1.541 1.048 3.595 5.048 1.405...
    3.597 2.379 2.852 .159 2.391 .396 1.441];
%Air-Broadened Width Parameters at 300K
W3= [.00281 .00287 .0023 .00278 .00287 .0021 .00186...
    .00263 .00215 .00236 .0026 .00321 .00244 .00306 .00267];
%T-Exponent of Air-Broadening
X=[.69 .64 .67 .68 .54 .63 .60 .66 .66...
    .65 .69 .69 .71 .68 .70];
%Self-Broadened Width Parameters at 300K
WS=[.01349 .01491 .0108 .0135 .01541 .0090 .00788...
    .01275 .00983 .01095 .01313 .01320 .01140 .01253 .01275];
%T-Exponent of Self-Broadening
XS=[.61 .85 .54 .74 .89 .52 .50 .67 .65 .64 .72...
    1.0 .68 .84 .78];
%Ratio of Shift to Width
SR=[0 -.017 0 0 0 0 0 0 0 0 0 0 0 0 0];

% dimension parameters
m = length(SR); % m=15

% atmosphere parameters
PVAP=rho.*T./217;
PDA=P-PVAP;
DEN=3.335e16*rho;
TI = 300./T;
TI2 = TI.^(2.5);

% continuum Terms
CON = (5.43e-10*PDA.*TI.^3 + 1.8e-8*PVAP.*TI.^7.5).*PVAP.*F.^2;

%Add resonances
% (intentionally use loop rather than vectorization, because (1) loop saves 
% memory; and (2) there is only 15-loop, which is even faster than 
% vecterzation when vectorization manipulates huge matrix)
SUM = 0;
for i = 1: m
    WIDTH = W3(i)*PDA.*TI.^X(i) + WS(i)*PVAP.*TI.^XS(i);
    SHIFT = SR(i)*WIDTH;   % unknown temperature dependence
    WSQ = WIDTH.^2;
    DF1 = F - FL(i) - SHIFT;
    DF2 = F + FL(i) + SHIFT;
    RES = WIDTH./(DF1.^2+WSQ) + WIDTH./(DF2.^2+WSQ)-2*WIDTH./(562500 + WSQ); % C  USE CLOUGH'S DEFINITION OF LOCAL LINE CONTRIBUTION
    thre = abs(DF1)>=750 + abs(DF2)>=750; % zero when beyond threshold; this code structure saves a lot of time
    if sum(thre(:))~=0
        RES(thre>0) = 0;
    end
    SUM = SUM + S1(i)*TI2.*exp(B2(i)*(1-TI)).*RES.*(F./FL(i)).^2;
end
absH2O = 0.3183e-4*DEN.*SUM + CON;

