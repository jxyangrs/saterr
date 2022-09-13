function SensorDataInfo = parse_sensorname(SensorData)
% parsing sensor data information
%
% Input:
%       SensorData,     synatax:  Rad_source_level_version_platform
%
% Output:
%       SensorDataInfo (struct):
%           sensor, source, level, version, platform, filename
%
% Example:
%       SensorData = 'SSMIS_GPM_1C_V02A_F16';
%       SensorDataInfo.rad='SSMIS';SensorDataInfo.source = 'GPM'; SensorDataInfo.level='1C';Rad.version='V02A';Rad.platform='F16';SensorDataInfo.filename='SSMIS_GPM_1C_V02A_F16';
%       SensorData = 'WindSat_GPM_SDR_NA_Uni';
%       SensorDataInfo.rad='WindSat';SensorDataInfo.source = 'GPM'; SensorDataInfo.level='SDR';SensorDataInfo.version='NA';SensorDataInfo.platform='Uni';SensorDataInfo.filename='WindSat_GPM_SDR_NA';
%       SensorData = 'atms_OPS_SDRdaily_V02_npp';
%       SensorDataInfo.rad='atms';SensorDataInfo.source = 'OPS'; SensorDataInfo.level='SDRdaily';SensorDataInfo.version='V02';SensorDataInfo.platform='npp';
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/01/2018: rename from sub_setRadName.m

idx = strfind(SensorData,'_');

if length(idx)~=4
    error('RadFull syntax not correct; syntax should be, Rad_source_level_version_platform')
end

SensorDataInfo.sensor = SensorData(1:idx(1)-1);
SensorDataInfo.source = SensorData(idx(1)+1: idx(2)-1);
SensorDataInfo.level = SensorData(idx(2)+1: idx(3)-1);
SensorDataInfo.version = SensorData(idx(3)+1: idx(4)-1);
SensorDataInfo.platform = SensorData(idx(4)+1: end);

if strcmp(SensorDataInfo.platform,'Uni')
    SensorDataInfo.filename = SensorData(1:idx(4)-1); % skip Uni
else
    SensorDataInfo.filename = SensorData;
end
