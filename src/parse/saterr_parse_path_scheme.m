% parse path setting 
% 
% Input:
%       Setting in saterr_main.m
% 
% Output:
%       Path of sensor, reanalysis, processing
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/04/2019: original code

global Rad Path Orbit Prof Setting

% -----------------------------
% scheme
% -----------------------------
Path.scheme = set_scheme;

% -----------------------------
% sensor data
% -----------------------------
Path.sensor.path = path_satellite_data;
Path.sensor.fileID = sensor_file_ID;
Path.sensor.name = Setting.Rad.sensor;
Path.sensor.spacecraft = Setting.Rad.spacecraft;

t_parse = parse_sensorname(sensor_data_info);
Path.sensor.level = t_parse.level;

% -----------------------------
% reanalysis data
% -----------------------------
Path.ana.name = name_reanalysis_data;
Path.ana.path = path_reanalysis_data;
Path.ana.fileID = ana_file_ID;

Prof.ana.name = Path.ana.name;
Prof.ana.path = Path.ana.path;
Prof.ana.fileID = Path.ana.fileID;

% -----------------------------
% processing path
% -----------------------------
Path.pathroot = Setting.pathroot_output;
if ~isempty(path_processing)
    Path.pathroot = path_processing;
end

if iscell(date_range)
    Path.date.range = date_range;
else
    error('date_range should be cell')
end

% Path.date.range is overwritten by Setting.date_range, if any
Path.process.nsubset = [];
if isfield(Setting,'date_range')
    if ~iscell(Setting.date_range)
        error('date_range should be cell')
    end
    Path.date.range = Setting.date_range;
end
if isfield(Setting,'nsubset')
    if length(Setting.nsubset)~=2
        error('Setting.nsubset should have a length of 2')
    end
    Path.process.nsubset = Setting.nsubset;
end

% -----------------------------
% processing path
% -----------------------------
switch Path.scheme
    case 'A'
        
        Path.sim.count = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/simple/','1sim'];
        Path.cal.output = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/simple/','2cal'];
            
    case 'B'
        Path.sim.prof = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','1sim/1prof'];
        Path.sim.granuel = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','1sim/2sim_granule'];
        Path.sim.orbit = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','1sim/3sim_orbit'];
        Path.sim.count = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','1sim/4sim_count'];
        Path.cal.output = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','2cal'];
        Path.cal.plot = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','2cal','/','plot'];
        Path.intercal.output = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','3intercal'];
        Path.intercal.plot = [Path.pathroot,'/',Path.sensor.spacecraft,'/',Path.sensor.name,'/','3intercal_plot'];
        
        Prof.type = 'reanaylsis';        
    otherwise
        error('Path.scheme is wrong')
end



