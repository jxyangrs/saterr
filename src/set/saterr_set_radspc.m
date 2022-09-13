function saterr_set_radspc
% radiometer basic specifications
% 
% Input:
%       radioemter basic setting
%
% Output:
%       Rad.scantype,               crosstrack/conical,                     
%       Rad.name_crosstrack,        viewing target per rotation,            cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
%       Rad.num_crosstrack,         No. of view wrt .name_crosstrack,       [1,m]
%       Rad.num_alongtrack_1orbit,  No. of rotation per orbit,              scalar
%       Rad.num_orbit,              No. of orbit,                           scalar; total rotations=num_orbit*num_alongtrack_1orbit
%       Rad.num_chan,               No. of channel,                         scalar
%
% Examples:
%       The following case is for mhs. mhs is a crosstrack scanning radiometer with 5 channels. It has 144 (sum([90,4,4,19,4,23])) scanning 
%       positions in one rotation, including 90 scanning positions for Earth scene, 4 for cold-space and 4 for warm-load, 
%       with Null gaps in between. There is 2000 rotations in one orbit. We set 3 orbits for simulation.
%           Rad.scantype = 'crosstrack'; % crosstrack/conical
%           Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
%           Rad.num_crosstrack = [90,4,4,19,4,23]; % number of scanning positions in one rotation w.r.t. name_crosstrack
%           Rad.num_alongtrack_1orbit = 2000; % number of alongtrack scanlines/rotations of one orbit
%           Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit
%           Rad.num_chan = 5; % channel number
% 
% Description:
%       A number of sensors are provided, and users can also customize a sensor by providing the sensor specifications
%       refer to saterr_set_listscsensor.m, saterr_set_radspc.m
%       
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/06/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/05/2019: separate adv
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: starting w/ cs
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/14/2022: adding tropics tempest-d

global Rad

% -----------------------------
% setting
% -----------------------------
switch Rad.sensor
    
    case 'customize'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,4,4,19,4,23]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2342; % number of alongtrack scanlines/rotations of one orbit
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit
        
    case {'demo'}
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,4,4,19,4,23]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2342; % number of alongtrack scanlines/rotations of one orbit
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit
        
    case {'amsr-e'}
        Rad.scantype = 'conical'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [196,101,16,101,16,101]; % number of scanning positions in one rotation w.r.t. name_crosstrack; amsr-e, 6-36: 196; 89: 392
        Rad.num_alongtrack_1orbit = 3956; % number of alongtrack scanlines/rotations of one orbit; amsr-e, ~3956
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit
        
    case {'amsr2'}
        Rad.scantype = 'conical'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [243,101,16,101,16,101]; % number of scanning positions in one rotation w.r.t. name_crosstrack; [243,108,16,108,16,108] 6-36 GHz; 486, 89 GHz
        Rad.num_alongtrack_1orbit = 3956;% number of alongtrack scanlines/rotations of one orbit; amsr2, ~3956
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit
        
    case 'amsu-a'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [30,1,2,2,2,3]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 766; % number of alongtrack scanlines/rotations of one orbit; amsu-a, ~766
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit
        
    case 'amsu-b'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,4,4,19,4,23]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2277; % number of alongtrack scanlines/rotations of one orbit; amsu-b, ~2277
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case {'atms'}
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [96,5,4,17,4,22]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2200;% number of alongtrack scanlines/rotations of one orbit; atms, ~2200
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case {'gmi'}
        Rad.scantype = 'conical'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack =  [221,98,13,84,13,71]; % number of scanning positions in one rotation w.r.t. name_crosstrack;  [221,72,85,22,65,35]
        Rad.num_alongtrack_1orbit = 2962;% % number of alongtrack scanlines/rotations of one orbit
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case 'mhs'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,4,4,19,4,23]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2342;% number of alongtrack scanlines/rotations of one orbit; mhs, ~2342
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case 'mwri'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,4,4,19,4,23]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 3200;% number of alongtrack scanlines/rotations of one orbit; mhs, ~2342
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case 'mwhs-2'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [98,17,4,94,4,113]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2000;% number of alongtrack scanlines/rotations of one orbit; mhs, ~2342
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case 'mwts-2'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,20,4,92,4,114]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2000;% number of alongtrack scanlines/rotations of one orbit; mhs, ~2342
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case {'smap'}
        Rad.scantype = 'conical'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [241,2,2,2,2,2]; % number of scanning positions in one rotation w.r.t. name_crosstrack; smap, 241
        Rad.num_alongtrack_1orbit = 779;% number of alongtrack scanlines/rotations of one orbit; smap, ~779
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case {'ssmi'}
        Rad.scantype = 'conical'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [64,78,4,112,4,190]; % number of scanning positions in one rotation w.r.t. name_crosstrack; 
        Rad.num_alongtrack_1orbit = 3214;% % number of alongtrack scanlines/rotations of one orbit; ssmi, [64,1607] for 19-37, [128,3214] for 85.5V,85.5H
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case {'ssmis'}
        Rad.scantype = 'conical'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [90,105,4,105,4,104]; % number of scanning positions in one rotation w.r.t. name_crosstrack; 
        Rad.num_alongtrack_1orbit = 3222;% % number of alongtrack scanlines/rotations of one orbit; ssmis, [90,3222] for 19-37 GHz, [180,3222] for 91-183 GHz
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case 'tempest-d'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [133,128,10,90,10,29]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2578;% number of alongtrack scanlines/rotations of one orbit; tempest-d, [133,2578]
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    case 'tms'
        Rad.scantype = 'crosstrack'; % crosstrack/conical
        Rad.name_crosstrack = {'cs','null','cc','null','cw','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
        Rad.num_crosstrack = [81,61,10,30,10,258]; % number of scanning positions in one rotation w.r.t. name_crosstrack
        Rad.num_alongtrack_1orbit = 2859;% number of alongtrack scanlines/rotations of one orbit; tropics, [81,2859]
        Rad.num_orbit = 1; % number of orbit; total scanlines/rotations =  num_orbit*num_alongtrack_1orbit

    otherwise
        error('Rad.sensor is wrong')
end

% -----------------------------
% parsing basic
% -----------------------------
if length(Rad.num_crosstrack)~=length(Rad.name_crosstrack)
    error('lengths of Rad.num_crosstrack and Rad.name_crosstrack not equal')
end

if sum(strcmp(Rad.scantype,{'crosstrack','conical'}))==0
    error('Rad.scantype is wrong')
end

Rad.num_alongtrack = Rad.num_alongtrack_1orbit*Rad.num_orbit;
[ind1,ind2] = ind_startend_bin(Rad.num_orbit*Rad.num_alongtrack_1orbit,Rad.num_alongtrack_1orbit);
Rad.alongtrack_orbit_ind_startend = [ind1(:),ind2(:)];             
Rad.norbit = 1;
% -----------------------------
% parsing crosstrack index
% -----------------------------
saterr_parse_indCT

