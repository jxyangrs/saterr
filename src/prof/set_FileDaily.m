function [fileinfo] = set_FileDaily(RadDataInfo,PathIn,ndatestr)
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
switch RadDataInfo.sensor
    case 'amsu-a'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        files = dir([fileinfo.path,RadDataInfo.fileID]); % e.g., NSS.AMAX.M2.D19152.S0213.E0356.B6545758.SV
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);
        
    case 'atms'
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        FileID_Geo = 'GATM'; % e.g. Gatms.npp.OPS.20140701.HDF5
        FileID_SDR = 'SATM'; % e.g. Satms.npp.OPS.20140701.HDF5
        FileID_TDR = 'TATM'; % e.g. Tatms.npp.OPS.20140701.HDF5
        files_geo = dir([fileinfo.path,FileID_Geo,'*']);
        files_sdr = dir([fileinfo.path,FileID_SDR,'*']);
        files_tdr = dir([fileinfo.path,FileID_TDR,'*']);
        
        fileinfo.united_filenum = size(files_geo,1);
        fileinfo.groupnum = size(files_geo,1) + size(files_sdr,1) + size(files_tdr,1);
        if ~isempty(files_geo)
            temp = {files_geo.name}';
            [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:}); % a pseudo united name
            [fileinfo.name(:).geo] = deal(temp{:});
        end
        if ~isempty(files_sdr)
            temp = {files_sdr.name}';
            [fileinfo.name(:).sdr] = deal(temp{:});
        end
        if ~isempty(files_tdr)
            temp = {files_tdr.name}';
            [fileinfo.name(:).tdr] = deal(temp{:});
        end
        
    case 'gmi'
        switch RadDataInfo.level
            case '1C'
                fileinfo.groupnum = 1;
                fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr,'/']; %year/month/day/files
                files = dir([fileinfo.path,'*',RadDataInfo.sensor,'*',ndatestr(1,1:8),'*']);
                temp = {files.name}';
                [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
                fileinfo.united_filenum = size(files,1);
            otherwise
        end
        
    case 'mhs'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        files = dir([fileinfo.path,RadDataInfo.fileID]);
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);

    case 'smap'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,5:6),'/',ndatestr(1,7:8),'/'];
        files = dir([fileinfo.path,'*',RadDataInfo.sensor,'*',ndatestr(1,1:8),'*']);
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);
        
    case 'ssmi'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        files = dir([fileinfo.path,RadDataInfo.fileID]);
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);

    case 'ssmis'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        files = dir([fileinfo.path,RadDataInfo.fileID]);
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);

    case 'tempest-d'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        files = dir([fileinfo.path,RadDataInfo.fileID]);
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);

    case 'tms'
        fileinfo.groupnum = 1;
        fileinfo.path = [PathIn,'/',ndatestr(1,1:4),'/',ndatestr(1,1:8),'/'];
        files = dir([fileinfo.path,RadDataInfo.fileID]);
        temp = {files.name}';
        [fileinfo.name(1:size(temp,1),1).united] = deal(temp{:});
        fileinfo.united_filenum = size(files,1);

    otherwise
        error('No such Radiometer')
end
