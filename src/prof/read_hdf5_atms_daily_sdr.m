function [tb,qual] = read_hdf5_atms_daily_sdr(inpath,infile,varargin)
% Read daily atms SDR file
%
% Input:
%       inpath, path of file
%       infile, name of file
%
% Output:
%       tb, brightness temperature; 3D, [cross-track,along-track,channel]
%       qual, quality flag, 0=good,1=bad; 2D, [cross-track,along-track]
% 
% Examples:
%       Satms.npp.STAR.SDR.20111127.HDF5
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/6/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/10/2016: debug qual
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 9/8/2016: flag bad lat
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/13/2017: eia can be single channel
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/20/2017: attributes revised
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 2/4/2018: indchanselect=0 uses all channels

tb=[];qual=[];

% bad file
s = dir([inpath,infile]);
if isempty(s)
    return
end
if s.bytes==0
    return
end

try
% read
% variables coverted to double
InVar = {...
    '/Data/tb',...
    };
Var = {'tb'};

for i=1: length(Var)
    eval([Var{i}, '= double(h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
end

% variables keeping the same format
InVar = {...
    '/Attributes/tb_scale'...
    };
Var = {'tb_scale'};
for i=1: length(Var)
    eval([Var{i}, '= (h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
end

% select channel if applicalbe
if ~isempty(varargin)
    indchanselect = varargin{1};
else
    indchanselect = 1:size(tb,3);
end
if indchanselect==0
    indchanselect = 1:size(tb,3);
end

% corrupted file
if isempty(tb)
    return
end

% quality flag
qual = logical(sum(tb==0,3));

% convert
tb = tb*tb_scale(1)+tb_scale(2);

% channels select
tb = tb(:,:,indchanselect);


end

