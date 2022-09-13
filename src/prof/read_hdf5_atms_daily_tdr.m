function [ta,qual] = read_hdf5_atms_daily_tdr(inpath,infile,varargin)
% Read daily atms SDR file
%
% Input:
%       inpath, path of file
%       infile, name of file
%
% Output:
%       ta,     antenna temperature,            [cross-track,along-track,channel]; 
%               0/negative=bad, extreme high value (e.g. 330.02) can exist (might be RFI)
%       qual,   quality flag, 0=good,1=bad;     [cross-track,along-track]
% 
% Examples:
%       Tatms.npp.STAR.SDR.20111127.HDF5
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/6/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/10/2016: debug qual
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 9/8/2016: flag bad lat
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/13/2017: eia can be single channel
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/20/2017: attributes revised
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 2/4/2018: indchanselect=0 uses all channels

ta=[];qual=[];

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
    '/Data/ta',...
    };
Var = {'ta'};

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
    indchanselect = 1:size(ta,3);
end

if indchanselect==0
    indchanselect = 1:size(ta,3);
end

% corrupted file
if isempty(ta)
    return
end

% quality flag
qual = logical(sum(ta==0,3));

% convert
ta = ta*tb_scale(1)+tb_scale(2);

% channels select
ta = ta(:,:,indchanselect);


end

