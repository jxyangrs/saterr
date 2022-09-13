function [tb,lat,lon] = read_mhs_chan1_89GHz(file)
% read a sample orbit of mhs channel 1 of 89 GHz
%
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/29/2019: original code

fid = fopen(file,'r','ieee-be');
n1 = fread(fid,1,'int32');
n2 = fread(fid,1,'int32');
tb = fread(fid,[n1,n2],'float32');
lat = fread(fid,[n1,n2],'float32');
lon = fread(fid,[n1,n2],'float32');
fclose(fid);
