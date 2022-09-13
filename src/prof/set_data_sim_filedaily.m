function [fileinfo] = set_data_sim_filedaily(RadDataInfo,PathIn,ndatestr)
% set up locations of daily raw files
%
% Input:
%       RadDataInfo (struct), radiometer data information
%       PathIn, root path of data
%       ndatestr, string of date
%
% Output:
%       fileinfo (struct)
%           groups, number of groups
%           united_filenum, number of united files
%           path (string), file path
%           name (struct, [n,1]),
%           united, geo, sdr, ...
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/29/2017: rename, add atms, and structure output
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/29/2017: JPSS1

% set output variables:
fileinfo.groupnum = 1; % number of file groupnum
fileinfo.united_filenum = 0; % number of united file
fileinfo.path = []; % file path (string)
fileinfo.name = []; % file name (struct), can have multiple sub-file groups

% choose radiometer
fileinfo.groupnum = 1;
fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
files = dir([fileinfo.path,RadDataInfo.fileID]); % e.g., NSS.AMAX.M2.D19152.S0213.E0356.B6545758.SV
temp = {files.name}';
[fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
fileinfo.united_filenum = size(files,1);
