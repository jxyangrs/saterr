function [chan_freq,ind_band,time,lat,lon,eia,ta,scan,nedt_nd,nedt_ds,qual,sc_ecef] = read_tropics_1a(inpath,infile)
% reading a single orbit of TROPICS 1A data
%   e.g. TROPICS01.ANTT.L1A.Orbit01539.V03-00.ST20211010-002928.ET20211010-020443.CT20220131-164141.nc
% 
% Input:
%       inpath,     input path
%       infile,     input file name
% 
% Output:
%       (name)      (detail)                        (data type)         (dimension)
%       chan_freq,  channel frequency (GHz),        cell,               [1,12]
%       ind_band,   band index,                     double,             [1,12]
%       lat,       	latitude (degree),              double,             [crosstrack(81),alongtrack,band(5)]
%       lon,       	longitude (degree),             double,             [crosstrack,alongtrack,band(5)]
%       eia,        Earth incidence angle (degree), double,             [crosstrack,alongtrack,channel(12)]
%       ta,         antenna temperature (K),        double,             [crosstrack,alongtrack,channel(12)]
%       scan,       scan angle (degree),            double,             [crosstrack,alongtrack,band(5)]
%       nedt_nd,    NEDT of noise diode (K),        double,             [alongtrack,channel(12)]
%       nedt_ds,    NEDT of deep space (K),         double,             [alongtrack,channel(12)]
%       qual,       quality flag,                   unit8,              [crosstrack,alongtrack,channel(12)]
%                   Bit 1: land/undefined; Bit 2: Lunar/solar intrusion; Bit 3: Active Maneuver; Bit 4: Cold Cal. Consistency 
%                   Bit 5: Hot Cal. Consistency; Bit 6: Ascending/Descending; Bit 7: Day/Night; Bit 8: Payload forward/aft'
%       sc_ecef,    sc position of ECEF (km),       double,             [x,y,z]
% 
% Reference: 
%       TROPICS.UserGuide.pdf,              data structure 
%       TRPCS-ATBD-034_L1_Rad_V2.1.pdf,     ATBD
% 
% Description:
%       To see the data structure, use the command line:
%       ncdisp([inpath,'/',infile])
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/14/2021: original code

filename = [inpath,'/',infile];

nedt_nd = ncread(filename,'NEDT_ND_K');
nedt_ds = ncread(filename,'NEDT_DS_K');

% quality flag:
% Bit 1: land/undefined Bit 2: Lunar/solar intrusion Bit 3: Active Maneuver Bit 4: Cold Cal. Consistency 
% Bit 5: Hot Cal. Consistency Bit 6: Ascending/Descending Bit 7: Day/Night Bit 8: Payload forward/aft'
qual = ncread(filename,'calQualityFlag');

lat = ncread(filename,'losLat_deg');
lon = ncread(filename,'losLon_deg');
scan = ncread(filename,'losScan_deg');
eia = ncread(filename,'losZen_deg');
ta = ncread(filename,'tempAntE_K');
sc_ecef = ncread(filename,'scPosECEF_km');
time = ncread(filename,'timeE');

time = time/(24*3600) + datenum([2000 1 1 0 0 0]);

ind_band = [1, 2*ones(1,length(2:4)), 3*ones(1,length(5:8)), 4*ones(1,length(9:11)), 5*ones(1,length(12))];
chan_freq = {'91.656±1.4','114.5','115.95','116.65','117.25','117.8','118.24','118.58','184.41','186.51','190.31','204.8'};

eia = eia(:,:,ind_band);
