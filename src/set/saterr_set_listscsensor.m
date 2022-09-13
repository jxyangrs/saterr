% list of sensors and spacecrafts
%
% Description:
%       A sensor onboard different spacecrafts can have distinct performance. Users can define different settings such as
%       noise, counts, and gains for sensors onboard different spacecrafts.
%       Users can also expand the sensor database by adding new sensors and spacecrafts. Adjustement needs to be made in
%       relevant modules.
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/07/2022: new sensors

switch Rad.sensor
    case 'customize'
        Rad.spacecraft = 'customize';
    case 'demo'
        Rad.spacecraft = 'demo';
    case 'amsr-e'
        Rad.spacecraft = 'aqua';
    case 'amsr2'
        Rad.spacecraft = 'gcom-w';
    case 'amsu-a'
        Rad.spacecraft = {'aqua','metop-a','metop-b','metop-c','n15','n16','n17','n18','n19'};
    case 'amsu-b'
        Rad.spacecraft = {'n15','n16','n17'};
    case 'atms'
        Rad.spacecraft = {'npp','n20'};
    case 'gmi'
        Rad.spacecraft = 'gpm-core';
    case 'mhs'
        Rad.spacecraft = {'metop-a','metop-b','metop-c','n18','n19'};
    case 'mwri'
        Rad.spacecraft = {'fy-3c','fy-3d'};
    case 'mwhs-2'
        Rad.spacecraft = {'fy-3c','fy-3d'};
    case 'mwts-2'
        Rad.spacecraft = {'fy-3c','fy-3d'};
    case 'smap'
        Rad.spacecraft = 'smap';
    case 'ssmi'
        Rad.spacecraft = {'f08','f10','f11','f12','f13','f14','f15'};
    case 'ssmis'
        Rad.spacecraft = {'f16','f17','f18','f19'};
    case 'tempest-d'
        Rad.spacecraft = 'tempest-d';
    case 'tms'
        Rad.spacecraft = 'tropics-pathfinder';
    otherwise
        error('Rad.sensor is wrong')
end

