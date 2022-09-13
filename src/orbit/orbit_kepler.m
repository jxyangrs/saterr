function [lat,lon,h,az,Torbit] = orbit_kepler(a,e,i,wa,w,M,N_orbit,N_at)
% calculate spacecraft position of Keplerian orbit
% 
% Input:
%       --six Keplerian orbit elements
%       a,       orbital semi-major axis (km),                scalar
%       e,       orbital eccentricity,                        scalar
%       i,       inclination (degrees),                       scalar (range [0,180])
%       wa,      longitude of ascending node (degree),        scalar (range [0,360])
%       w,       argument of perigee (degrees),               scalar (range [0,360])
%       M,       mean anomaly at epoch t0 (degrees),          scalar (range [0,360])
%       --orbit number
%       N_orbit, number of orbit,                             scalar
%       N_at,    number of alongtrack in one orbit,           scalar
% 
% Ouput:
%       lat,     spacecraft geodetic latitude (degree),       [n,1] n=N_orbit*N_at
%       lon,     spacecraft longtitude (degree),              [n,1]
%       h,       spacecraft altitude (km),                    [n,1]
%       az,      spacecraft azimuth (degree),                 [n,1]
%       Torbit,  spacecraft orbital period (minute),          scalar
%                (total time=N_orbit*Torbit)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: based on a Keplerian model code

% variables
GM = 3.986004e5; % Earth gravatational parameter (km^3/s^2)
TE = (23 + 56/60 + 4.0910/3600)*3600; % Earth sidereal day (sec)
wE = 2*pi/TE; % Earth rotation angular speed (radian/sec)

rotangle = 0; % Earth rotation angle (degree)
rotangle = rotangle*pi/180;
T = 2*pi*sqrt(a^3/GM)/TE;
t_step = T/N_at;
t = (0:t_step:N_orbit*T-t_step)';
era = rotangle + wE*t*TE;
Torbit = 2*pi/(sqrt(GM./a^3))/60; % orbit period (minute)

% ECI
[xsc,ysc,zsc,ux,uy,uz] = sc_vector(a,e,i,wa,w,M,t);

% ECI to ECEF
rotz = [];
rotz(1,1,:) = era/pi*180;
rotz = -rotz;

n = size(rotz);
rotx = zeros(n);
roty = zeros(n);
R1 = eulerrotate(rotx,roty,rotz);

% ---geo
X = [xsc,ysc,zsc]';
X = permute(X,[1,3,2]);
X = mtimes_3d3d(R1,X);
X = permute(X,[1,3,2]);

% ---velocity
V0 = [ux,uy,uz]';
V = permute(V0,[1,3,2]);
V = mtimes_3d3d(R1,V);
V = permute(V,[1,3,2]);
R2 = [0,  -wE, 0;
      wE, 0,   0;
      0,  0,   0];
V = V - R2*X;

% spacecraft ground track, azimuth
[a1,b1,e1] = earth_wgs84;
x = X(1,:)';
y = X(2,:)';
z = X(3,:)';
[lat,lon,h] = gc2gd(x,y,z,a1,e1);

dx = V(1,:)';
dy = V(2,:)';
dz = V(3,:)';

[x2, y2, z2] = gco2enu(dx,dy,dz,lat,lon);
[az,elev,rs] = enu2ang(x2,y2,z2);


function [x,y,z,ux,uy,uz] = sc_vector(a,e,i,wa,w,M,t)
% calculate spacecraft position and velocity with keplerian elements
%
% Input:  
%       a,          orbital semi-major axis (km),                scalar
%       e,          orbital eccentricity,                        scalar
%       i,          inclination (degrees),                       range [-360,360]
%       wa,         longitude of ascending node (degree),        scalar
%       w,          argument of perigee (degrees),               scalar
%       M,          mean anomaly in degrees at epoch t0,         range [0,360]
%       t           epoch in Julian Date                         [n1,1]

% Output: 
%       x,          x (km),                 [n1,1]
%       y,          ECI y (km),             [n1,1]
%       z,          ECI z (km),             [n1,1]
%       ux,         ECI velocity x (km/s),  [n1,1]
%       uy,         ECI v y (km/s),         [n1,1]
%       uz,         ECI v z (km/s),         [n1,1]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: based on a Keplerian model code

% variables
GM = 3.986004e5; % Earth gravatational parameter (km^3/s^2)
w = w.*pi/180;
wa = wa.*pi/180;
i = i.*pi/180;
M = M.*pi/180;

% time difference in seconds
dt = 86400*(t-t(1));

% mean anomaly
M1 = M + dt.*sqrt(GM/(a^3));

% Normalize mean anomaly
M1 = mod(M1,2*pi);

% calculate eccentric anomaly
E0 = M1;
% ---first
E = E0 -(E0-e.*sin(E0)-M1)./(1-e.*cos(E0));
dE = abs(E-E0);
E0 = E;
d1 = max(dE(:));
d2 = d1;
d3 = 1; % execute more at least once

% ---more
n = 1;
rd = 1e-5; % relative difference
while d3 > rd
    E = E0 -(E0-e.*sin(E0)-M1)./(1-e.*cos(E0));
    dE = abs(E-E0);
    E0 = E;
    n = n+1;
    
    d1 = d2;
    d2 = max(dE(:));
    d3 = abs((d1-d2)/d1);
    
    if n == 1000
        warning('iteration exceeds 1000 and stops')
        break
    end
end

% true anomaly
v = 2*atan2(sqrt(1 + e).*sin(E/2),sqrt(1 - e).*cos(E/2));

% eccentric anomaly
r = a.*(1 - e.*cos(E));

% spacecraft position and velocity in Orbital Reference Frame (ORF)
x_orf = r.*cos(v);
y_orf = r.*sin(v);
z_orf = zeros(size(x_orf));

vx_orf = (sqrt(GM*a)./r).*(-sin(E));
vy_orf = (sqrt(GM*a)./r).*(sqrt(1 - e^2).*cos(E));
vz_orf = zeros(size(vx_orf));

% Rotation from ORF to ECI
R(1,1) = cos(w)*cos(wa) - sin(w)*cos(i)*sin(wa);
R(1,2) =-sin(w)*cos(wa) - cos(w)*cos(i)*sin(wa);
R(1,3) = sin(i)*sin(wa);
R(2,1) = cos(w)*sin(wa) + sin(w)*cos(i)*cos(wa);
R(2,2) =-sin(w)*sin(wa) + cos(w)*cos(i)*cos(wa);
R(2,3) =-sin(i)*cos(wa);
R(3,1) = sin(w)*sin(i);
R(3,2) = cos(w)*sin(i);
R(3,3) = cos(i);

P_orf = [x_orf,y_orf,z_orf]';
V_orf = [vx_orf,vy_orf,vz_orf]';

P = R*P_orf;
V = R*V_orf;

x = P(1,:)';
y = P(2,:)';
z = P(3,:)';

ux = V(1,:)';
uy = V(2,:)';
uz = V(3,:)';

