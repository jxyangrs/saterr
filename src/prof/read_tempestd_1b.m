function [time,lat,lon,eia,tb,scanangle] = read_tempestd_1b(inpath,infile)
% reading TEMPEST-D data
%   e.g. TEMPEST_L1_pub_20181201T024447_20181201T232452_v2.0.h5
% 
% Input:
%       inpath,     input path
%       infile,     input file name
% 
% Output:
%       (name)      (detail)                        (data type)         (dimension)
%       lat,       	latitude (degree),              double,             [crosstrack(133),alongtrack]
%       lon,       	longitude (degree),             double,             [crosstrack,alongtrack]
%       eia,        Earth incidence angle (degree), double,             [crosstrack,alongtrack,channel(5)]
%       tb,         antenna temperature (K),        double,             [crosstrack,alongtrack,channel]
%       scanangle,  scan angle (degree),            double,             [crosstrack,alongtrack]
% 
% Description:
%       channels: 89, 165, 176, 180, 182 GHz 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/18/2020: original code

filename = [inpath,'/',infile];

% quality flag:
InVar = {...
    '/scan/blat','/scan/blon','/scan/TB','/scan/UTCtime','/scan/binc','/scan/scanang'};
Var = {'lat','lon','tb','time','eia','scanangle'};

for i=1: length(Var)
    eval([Var{i}, '= double(h5read([''',filename,'''],','''',InVar{i},'''));']);
end

lat = lat';
lon = lon';
eia = eia';
eia = eia(:,:,ones(size(tb,3),1));
scanangle = scanangle';
tb = permute(tb,[2,1,3]);

time = time';
time = time/(24*3600) + datenum([2000 1 1 0 0 0]);

