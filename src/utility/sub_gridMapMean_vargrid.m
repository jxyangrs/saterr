function [gridz,gridnum] = sub_gridMapMean_vargrid(gridlat,gridlon,lat,lon,z)
% average to grid coordinate on Earth
%
% Input:
%   gridlat, [n1,1]
%   gridlon, [n2,1]
%   lat,lon, [n3,1]
%   z: 1D/2D [n3,n4]
%
% Output:
%   gridz, [n1,n2,n4]; 0=no sample in grid
%   gridnum, [n1,n2]
% 
% Comment:
%   gridlat and gridlon are with equal step
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/11/2016
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/28/2018: add input gridlat,gridlon
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/09/2018: debug grid

divlat = mean(diff(gridlat));
divlon = mean(diff(gridlon));
RangeLat = max(gridlat(:)) - min(gridlat(:));

LatNum = round(RangeLat/divlat+1);

n1 = length(gridlat);
n2 = length(gridlon);
n3 = size(z,2);

IDgridlat = round(gridlat/divlat);
IDgridlon = round(gridlon/divlon);
IDgrid = bsxfun(@plus,IDgridlat(:),IDgridlon(:)'*LatNum);

IDlat = round(lat/divlat);
IDlon = round(lon/divlon);
IDgeo = IDlat+IDlon*LatNum;

[cID,idxIDgrid] = intersect(IDgrid(:),IDgeo);

idx = ismember(IDgeo,cID);
IDgeo = IDgeo(idx);
z = z(idx,:);

[mnum,~,~,mz] = sub_uniqmean(IDgeo,z);
gridz = zeros(n1,n2,n3);
igridz = zeros(n1,n2);
for i=1: n3
    igridz(idxIDgrid) = mz(:,i);
    gridz(:,:,i) = igridz;
end
gridnum = zeros(n1,n2);
gridnum(idxIDgrid) = mnum;
