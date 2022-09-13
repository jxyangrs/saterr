function [t_datenum,lat,lon,eia,tb,altitude,wn] = read_bin_mhs(inpath,infile)
% read mhs data with NOAA KLM format
% e.g. NSS.mhsX.NP.D17281.S1831.E2015.B4466970.WI
% 
% Input:
%   filepathname
% 
% Output:
%   t_datenum,      time in datenum                           1D [nscanline,1]
%   lat,            latitude (degree)                         2D [90,nscanline]
%   lon,            longitude(degree)                         2D [90,nscanline]
%   eia             earth indicence angle(degree)             2D [ncrossScene(30),nscanline]
%   tb,             scene brightness temperature (K),         2D [ncrossScene,nscanline,channel]
%   wn,             wavenumber (cm^-1),                       1D [1,nchan] frequency=[89,157,183.311+-1,183.311+-3,190.311]
%   altitude,       spacecraft altitude (km),                 1D [1,alongtrack]
% 
% Date format:
% filename,   NSS.mhsX.M1.D19151.S2306.E0003.B3476869.GC
%     NSS,        NOAA/NESDIS
%     mhsX,       mhs data set derived from AIP
%     M1,         Metop-B
%     D19151,     year day, day 151 of year 2019
%     S2306,      start time, 23 hours 06 minutes UTC
%     E0003,      end time, 00 hours 03 minutes UTC
%     B3476869,   processing block ID
%     GC,         source, GC=Fairbanks Alaska
% 
% table number is denoted in following sections
% 
% Algorithm:
%   NOAA KLM User's Guide with NOAA-N, N Prime, and MetOp SUPPLEMENTS, April 2014
%     mhs refers to Equation 7.6.8-1 to 7.6.8-7 
%     More algorithm details of similar principles can be found in amsu-a/B section from Equations 7.3.3-1 to 7.3.3-10 
%   a) count to radiance
%     R=a0+a1*C+a2*C^2    R, mW/(m**2*sr*cm**-1)
%     e.g. R=a(1,:,:)+a(2,:,:).*Cw_mean+a(3,:,:).*Cw_mean.^2;
%   b) radiance to temperature conversion
%    b1) black-body equation
%     T = B^-1(R)
%     specifically, T = c2.*wn1./log(c1*wn1.^3./R+1)
%     where c1 = 1.191042952e-5; c2 = 1.43877736;wn is wavenumber (cm^-1)
%    b2) bandwidth correction
%     T2 = (T1-b1)/b2; 
%   where T1 is before correction, T2 is after correction
%   and b1 and b2 can be obtained for channel-1 such that b1 = b_bw(1,1); b2 = b_bw(2,1); 
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/19/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/12/2018: add cs
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/08/2020: rename to L1B and refine
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/02/2020: eia



% =====================================================
% setting
% =====================================================
% infile = 'NSS.mhsX.NP.D17292.S2127.E2322.B4482527.GC';

Byte.ARS = 512;
Byte.PrimaryHeader = 3072;
Byte.SciencePacket = 3072;

nchan = 5;
nPRT = 5;

% =====================================================
% open file
% =====================================================
fid = fopen([inpath,infile],'r','ieee-be');

% =====================================================
% ARS header (Table 8.3.1.2-1)
% =====================================================
% skip ARS header


% =====================================================
% primary header (Table 8.3.1.9.2-1)
% =====================================================
nstart = Byte.ARS;

% data information (checking reading)
fseek(fid,nstart,-1); % skip Archive Retrieval System (ARS) Header
DataID = fread(fid,[1,3],'uchar'); % data ID (should be NSS)
DataID = char(DataID);

fseek(fid,nstart+132,-1); % number of data record
nscanline = fread(fid,[1,1],'uint16');

% band width correction when doing temperature radiance conversion
% b_bw [constant1&constant2,channel]
fseek(fid,nstart+416,-1); 
M = fread(fid,[1,15],'int32')/1e6; 
M = reshape(M,[3,5]);
wn = M(1,:); % wavenumber (cm^-1) of channel-1
c_bw = M(2:3,:); % coefficients for bandwidth correction, constant 1&2


% =====================================================
% science packet (Table 8.3.1.9.3.1-1)
% =====================================================
ncrossCal = 4;
ncrossScene = 90;

scanline = zeros(nscanline,1);
t_year = zeros(nscanline,1);
t_doy = zeros(nscanline,1);
t_UTC = zeros(nscanline,1);

eia = zeros(ncrossScene,nscanline);
lat = zeros(ncrossScene,nscanline);
lon = zeros(ncrossScene,nscanline);

cc = zeros(ncrossCal,nchan,nscanline);
cw = zeros(ncrossCal,nchan,nscanline);
cs = zeros(ncrossScene,nchan,nscanline);


tw = zeros(nPRT,nscanline);
c_c2r = zeros(nscanline,3,nchan); % primary constants converting count to radiance, [nscanline,a0&a1&a2,channel]
% a_2nd = zeros(nscanline,3,nchan); % secondary constants (same as primary in many datasets)

for iscanline=1:nscanline
    nstart = Byte.ARS+Byte.PrimaryHeader+Byte.SciencePacket*(iscanline-1);
    
    % scan information
    fseek(fid,nstart,-1);
    scanline(iscanline) = fread(fid,[1,1],'uint16');
    t_year(iscanline) = fread(fid,[1,1],'uint16');
    t_doy(iscanline) = fread(fid,[1,1],'uint16');
    fread(fid,[1,1],'int16');
    t_UTC(iscanline) = fread(fid,[1,1],'uint32');
    
    % calibration coefficients
    fseek(fid,nstart+60,-1);
    M = fread(fid,[30,1],'int32');
    M = M./repmat([1e16,1e10,1e6]',[10,1]); % scale
    M = reshape(M,[3*nchan,2]); % [3*nchan,1st&2nd]
    
    x = reshape(M(:,1),[3,nchan]);
    c_c2r(iscanline,:,:) = x(end:-1:1,:); % x from [a2/a1/a0,channel] to [a0/a1/a2,channel]
    
    % Navigation
    fseek(fid,nstart+190,-1);
    M = fread(fid,[1,3],'int16')/1e3;
    angle_attitude(:,iscanline) = M;
    fseek(fid,nstart+204,-1);
    M = fread(fid,[1,3],'int16')/1e3;
    angle_euler(:,iscanline) = M;
    
    fseek(fid,nstart+210,-1);
    M = fread(fid,[1],'uint16');
    altitude(iscanline) = M/1e1;
    fseek(fid,nstart+212,-1);
    M = fread(fid,[3,90],'int16')/1e2;
    eia(:,iscanline) = M(2,:);
    ang_solarzenith(:,iscanline) = M(1,:);
    ang_az(:,iscanline) = M(3,:); % local azimuth
    
    M = fread(fid,[1,180],'int32')/1e4;
    lat(:,iscanline) = M(1:2:end);
    lon(:,iscanline) = M(2:2:end);
    
    % Earth view count
    fseek(fid,nstart+1480,-1);
    count_earth1 = fread(fid,[1,540],'uint16');
    count_earth1 = reshape(count_earth1,[6,90]);
    count_earth1 = count_earth1(2:end,:)';
    cs(:,:,iscanline) = count_earth1; % [position,nchan,nscanline]
    
    % count
    fseek(fid,nstart+2568,-1); 
    space_view = fread(fid,[1,24],'uint16');
    count_space1 = reshape(space_view,[6,4]);
    count_space1 = count_space1(2:end,:)'; 
    cc(:,:,iscanline) = count_space1; % [position,nchan,nscanline]
    
    obct_view = fread(fid,[1,24],'uint16'); % OBCT=on board calibration target
    count_obct1 = reshape(obct_view,[6,4]);
    count_obct1 = count_obct1(2:end,:)'; 
    cw(:,:,iscanline) = count_obct1; % [position,nchan,nscanline]
    
    % PRT temperature
    fseek(fid,nstart+2768,-1); 
    tmp_obct1 = fread(fid,[1,5],'uint32');
    tw(:,iscanline) = tmp_obct1/1e3; % [nPRT,nscanline]
end
c_c2r = permute(c_c2r,[2,1,3]); % [a0&a1&a2,nscanline,channel]

% change order to [position,nscanline,nchan]
cc = permute(cc,[1,3,2]);
cw = permute(cw,[1,3,2]);
cs = permute(cs,[1,3,2]);

% =====================================================
% close
% =====================================================
fclose(fid);

% nstart = Byte.ARS+Byte.PrimaryHeader;
% fseek(fid,nstart+2568,-1); 
% x = fread(fid,'24*uint16',Byte.SciencePacket);

% =====================================================
% conversion
% =====================================================

% ---------------------------
% OBCT temperature
% ---------------------------
tw = mean(tw,1);
tw = tw(:,:,ones(nchan,1));
ind_tw = 1;

% ---------------------------
% time
% ---------------------------
n = size(t_year,1);
t_datenum = datenum([t_year,zeros(n,5)]);
t_datenum = t_datenum + t_doy + t_UTC/(1e3*24*3600);
t_datenum = t_datenum';

% ---------------------------
% scene count to radiance 
% ---------------------------
Rs = NaN(ncrossScene,nscanline,nchan); % [ncrossScene,nscanline,nchan]
for i=1: nchan
    c0 = c_c2r(1,:,i);
    c0 = repmat(c0,[ncrossScene,1]);
    c1 = c_c2r(2,:,i);
    c2 = c_c2r(3,:,i);
    
    Rs(:,:,i) = c0 + bsxfun(@times,cs(:,:,i),c1) + bsxfun(@times,cs(:,:,i).^2,c2);
end

Rs = Rs*1e-3/1e4; % from mW/(m**2*sr*cm**-1) to W/(cm**2*sr*cm**-1)

% ---------------------------
% radiance to brightness temperature
% ---------------------------
% TB = c2.*wn1./log(c1*wn1.^3./R+1)
c1 = 1.191042952e-12;
c2 = 1.43877736;

tb = NaN(ncrossScene,nscanline,nchan); % [ncross,nalong,nchan]
for i=1: nchan
    wn1 = wn(i);
    tb(:,:,i) = c2.*wn1./log(c1*wn1.^3./Rs(:,:,i)+1);
end

% bandwidth correction
% T2 = (T1-b1)/b2; 
tb_bw = tb;
for i=1: nchan
    tb1 = tb(:,:,i);
    tb_bw(:,:,i) = (tb1-c_bw(1,i))/c_bw(2,i);
end
tb = tb_bw;


