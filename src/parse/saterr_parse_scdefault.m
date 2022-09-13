% assigning default spacecrafts to specific sensors
% 
% Input:
%       Rad.sensor,       radiometer,               string
% 
% Output:
%       Rad.spacecraft,   spacecraft name,          string
% 
% Description:
%       saterr_set_listscsensor.m
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/07/2019: parse input setting

if isempty(Rad.spacecraft)
    switch Rad.sensor
        case 'customize'
            Rad.spacecraft = 'customize';
        case {'demo'}
            Rad.spacecraft = 'demo';
        case {'amsr-e'}
            Rad.spacecraft = 'aqua';
        case {'amsr2'}
            Rad.spacecraft = 'gcom-w';
        case 'amsu-a'
            Rad.spacecraft = 'metop-a';
        case 'amsu-b'
            Rad.spacecraft = 'n17';
        case {'atms'}
            Rad.spacecraft = 'npp';
        case {'gmi'}
            Rad.spacecraft = 'gpm-core';
        case 'mhs'
            Rad.spacecraft = 'metop-a';
        case 'mwri'
            Rad.spacecraft = 'fy-3c';
        case 'mwhs-2'
            Rad.spacecraft = 'fy-3c';
        case 'mwts-2'
            Rad.spacecraft = 'fy-3c';
        case {'smap'}
            Rad.spacecraft = 'smap';
        case {'ssmi'}
            Rad.spacecraft = 'f15';
        case {'ssmis'}
            Rad.spacecraft = 'f18';
        case 'tempest-d'
            Rad.spacecraft = 'tempest-d';
        case 'tms'
            Rad.spacecraft = 'tropics-pathfinder';
        otherwise
            error('Rad.sensor is wrong')
    end
end
