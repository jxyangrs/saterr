function [lat,lon,h] = gc2gd(x,y,z,a,e)
% geodetic to geocentric
%
% Input:
%         x, y, z, geocentric coordinate (km)
%         a,       major axis (km)
%         e,       eccentricity
% Output:
%         lat,     latitude (degree)
%         lon,     longitude (degree)   [-180,180]
%         h,       altitude (km)
% 
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/04/2019: relative difference in iteration

e2 = e^2;

p = sqrt(x.*x+y.*y);
lat = atan2(z,p./(1-e2));
h = 0;

% first
lat0 = lat;
h0 = h;
v = a./sqrt(1-e2.*sin(lat).*sin(lat));
h = p.*cos(lat)+z.*sin(lat)-(a*a)./v;
lat = atan2(z, p.*(1-e2.*v./(v+h)));
dlat = abs(lat-lat0);
dh = abs(h-h0);
c1 = max(dlat(:));
c2 = c1;
c3 = 1;

d1 = max(dh(:));
d2 = d1;
d3 = 1;

% more
rd = 1e-5; % relative difference
n = 1;
while c3>rd || d3>rd
  lat0 = lat;
  h0 = h;
  v = a./sqrt(1-e2.*sin(lat).*sin(lat));
  h = p.*cos(lat)+z.*sin(lat)-(a*a)./v;
  lat = atan2(z, p.*(1-e2.*v./(v+h)));
  dlat = abs(lat-lat0);
  dh = abs(h-h0);
  
  c1 = c2;
  c2 = max(dlat(:));
  c3 = abs((c1-c2)/c1);
  
  d1 = d2;
  d2 = max(dh(:));
  d3 = abs((d1-d2)/d1);
  
  if n == 1000
      warning('iteration exceeds 1000 and stops')
      break
  end
end

% lon
lon = atan2(y,x);

lon = lon/pi*180;
lat = lat/pi*180;
