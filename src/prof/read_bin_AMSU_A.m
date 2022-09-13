function [t_datenum,tb,lat,lon,eia,azm,altitude,wn] = read_bin_AMSU_A(inpath,infile)
% read AMSU_A data with NOAA KLM format
% e.g. NSS.AMAX.M1.D19152.S0920.E1017.B3477475.SV
% 
% Input:
%   filepathname
% 
% Output:
%   t_datenum    time in datenum                     1D [1,nscanline]
%   tb	         tb/ta (K)                           3D [ncrossScene,nscanline,antenna1&2],             
%   lat          latitude (degree)                   2D [ncrossScene(30),nscanline]
%   lon          longitude(degree)                   2D [ncrossScene(30),nscanline]
%   eia          earth indicence angle(degree)       2D [ncrossScene(30),nscanline]
%   azm          local azimuth angle(degree)         2D [ncrossScene(30),nscanline]
%   altitude,    spacecraft altitude (km),        	 1D [1,alongtrack]
%   wn           wavenumber (cm^-1)                  1D [1,nchan], 23.8,31.4,...,89
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
% file content (table number in code):
%     ARS
%     Header Record
%     Data Record
% 
% 
% Reference:
%       NOAA KLM User's Guide with NOAA-N, N Prime, and MetOp SUPPLEMENTS, April 2014
%       amsu-a and AMSU-B:  section 3.3 page 3-35,  instrument
%                           section 7.3. page 7-16
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
%   ---warm-load temperature to channel
%         A1-1,	chan 6-7 & 9-15,		1:5 (5) PRT
%         A1-2,	chan 3-5 & 8,			6:10 (5) PRT
%         A2,		chan 1-2,				11:17 (7) PRT
%         tw = [:,[1,2,3]]; % [scanline,[A1-1,A1-2,A2]]
%         ind_tw2chan = [3 3 2 2 2 1 1 2 1 1 1 1 1 1 1];
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/19/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/12/2018: AMSU_A
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/13/2020: tb
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/02/2020: eia


% =====================================================
% setting
% =====================================================
Byte.ARS = 512;
Byte.PrimaryHeader = 2560;
Byte.SciencePacket = 2560;

nchan = 15;

% =====================================================
% open file
% =====================================================
fid = fopen([inpath,'/',infile],'r','ieee-be');

% =====================================================
% ARS header (Table 8.3.1.2-1)
% =====================================================
% skip ARS header


% =====================================================
% primary header (Table 8.3.1.6.2.2-1)
% =====================================================
nstart = Byte.ARS;

% data information (checking reading)
fseek(fid,nstart,-1); % skip Archive Retrieval System (ARS) Header
DataID = fread(fid,[1,3],'uchar'); % data ID (should be NSS)
DataID = char(DataID);
fseek(fid,nstart+72,-1);
IDspacecraft = fread(fid,[1,1],'uint16'); % spacecraft ID
IDsensor = fread(fid,[1,2],'uint16'); 
fseek(fid,nstart+144,-1);
nscanline = fread(fid, 1,'uint16'); % number of science packet; nscanline = (fileinfo.bytes-Byte.ARS-Byte.PrimaryHeader)/Byte.SciencePacket;

% PRT of RF shelf: count to temperature
% T = d0 + d1*C + d2^2*C^2 + d3^3*C^3
fseek(fid,nstart+1488,-1); % A1-1&2
M = fread(fid,[4,2],'int32');
coeff_PRT_RFshelf = M;

fseek(fid,nstart+2080,-1); % A2
M = fread(fid,[4,1],'int32');
coeff_PRT_RFshelf(:,3)= M;

coeff_PRT_RFshelf = coeff_PRT_RFshelf.*repmat([1e-4,1e-9,1e-16,1e-20]',[1,3]);

% radiance to brightness temperature to conversion
% T = d0 + d1*C + d2^2*C^2 + d3^3*C^3
fseek(fid,nstart+688,-1); 
M = fread(fid,[1,3*nchan],'int32')*1e-6;
M = reshape(M,[3,nchan]);
wn = M(1,:); % wavenumber (cm^-1) of channel-1
c_bw = M(2:3,:); % coefficients for bandwidth correction, constant 1&2

% PRT count-to-temperature conversion coefficient
% T = d0 + d1*C + d2^2*C^2 + d3^3*C^3
fseek(fid,nstart+1536,-1); % A1-1 and A1-2: warm-load 1-4 & warm-load center
M = fread(fid,[4,10],'int32'); 
M = M./repmat([1e4,1e9,1e16,1e20]',[1,10]);
coeff_PRT_warmload(:,1:10) = M;

fseek(fid,nstart+2112,-1); % A2: warm-load center & warm-load 1-6
M = fread(fid,[4,7],'int32'); 
M = M./repmat([1e4,1e9,1e16,1e20]',[1,7]);
coeff_PRT_warmload(:,11:17) = M;

% =====================================================
% science packet (Table 8.3.1.6.3.2-1.)
% =====================================================
ncrossCal = 2;
ncrossScene = 30;

scanline = zeros(nscanline,1);
t_year = zeros(nscanline,1);
t_doy = zeros(nscanline,1);
t_UTC = zeros(nscanline,1);

angle_solarzenith = zeros(ncrossScene,nscanline);
angle_satzenith = zeros(ncrossScene,nscanline);
angle_azimuth = zeros(ncrossScene,nscanline);

lat = zeros(ncrossScene,nscanline);
lon = zeros(ncrossScene,nscanline);

cc = zeros(ncrossCal,nchan,nscanline);
cw = zeros(ncrossCal,nchan,nscanline);
cs = zeros(ncrossScene,nchan,nscanline);

% PRT telemetry for converting to temperature
% count_PRT_A1 = zeros(10,nscanline); % A1-1 load 1-4, load center; A1-2 load 1-4, load center
% count_PRT_A2 = zeros(7,nscanline);
count_PRT_warmload = zeros(17,nscanline);

% calibration coefficients
c_c2r = zeros(3,nchan,nscanline); % [a0/a1/a2,nchan,nscanline]

% go through scanlines
for iscanline=1:nscanline
    nstart = Byte.ARS+Byte.PrimaryHeader+Byte.SciencePacket*(iscanline-1);
    
    % scan information
    fseek(fid,nstart,-1);
    scanline(iscanline) = fread(fid,[1,1],'uint16');
    t_year(iscanline) = fread(fid,[1,1],'uint16');
    t_doy(iscanline) = fread(fid,[1,1],'uint16');
    fread(fid,[1,1],'int16');
    t_UTC(iscanline) = fread(fid,[1,1],'uint32');
   
    % ----------------------------
    % Navigation
    % ----------------------------
    fseek(fid,nstart+470,-1);
    M = fread(fid,[1],'uint16')/1e1;
    altitude(iscanline) = M;
    fseek(fid,nstart+472,-1);
    M = fread(fid,[3,30],'int16');
    angle_solarzenith(:,iscanline) = M(1,:)/1e2;
    angle_satzenith(:,iscanline) = M(2,:)/1e2;
    angle_azimuth(:,iscanline) = M(3,:)/1e2;
    
    fseek(fid,nstart+652,-1);
    M = fread(fid,[1,60],'int32');
    lat(:,iscanline) = M(1:2:end)/1e4;
    lon(:,iscanline) = M(2:2:end)/1e4;
    
    % ----------------------------
    % calibration coefficients
    % ----------------------------
    fseek(fid,nstart+80,-1);
    M = fread(fid,[1,nchan*3],'int32');
    M = reshape(M,[3,nchan]);
    M(1,:) = M(1,:)*1e-19;
    M(2,:) = M(2,:)*1e-13;
    M(3,:) = M(3,:)*1e-9;
    c_c2r(:,:,iscanline) = M(end:-1:1,:); % [a0/a1/a2,nchan,nscanline]
    
    % ----------------------------
    % Chan 3-15 (amsu-a1 1&2 Digital A)
    % ----------------------------
    ind_chan = 3:15;
    
    % Earth view count
    fseek(fid,nstart+904,-1);
    M = fread(fid,[1,510],'uint16');
    M = reshape(M,[17,510/17]);
    M = M(5:end,:)';
    cs(:,ind_chan,iscanline) = M; % [position,nchan,nscanline]
    
    % cold count 
    fseek(fid,nstart+1924,-1); 
    M = fread(fid,[1,30],'uint16');
    M = M(5:30);
    M = reshape(M,[13,2])'; 
    cc(:,ind_chan,iscanline) = M; % [position,nchan,nscanline]
    
    % warm count
    fseek(fid,nstart+2076,-1); 
    M = fread(fid,[1,30],'uint16');
    M = M(5:30);
    M = reshape(M,[13,2])'; 
    cw(:,ind_chan,iscanline) = M; % [position,nchan,nscanline]
    
    % temperature sensor (PRT) telemetry to be converted to temperature
    fseek(fid,nstart+1984,-1); 
    M = fread(fid,[1,46],'uint16');
    
    count_PRT_warmload(1:10,iscanline) = M(36:45); % % A1-1 and A1-2: warm-load 1-4 & warm-load center
    count_PRT_RFmux(1:2,iscanline) = M(5:6); % RF mux, A1-1&2
    count_PRT_RFshelf(1:2,iscanline) = M(33:34); % RF shelf, A1-1&2
    
    % ----------------------------
    % Chan 1-2 (amsu-a2 Digital A)
    % ----------------------------
    ind_chan = 1:2;
    
    % Earth view count
    fseek(fid,nstart+2192,-1);
    M = fread(fid,[1,120],'uint16');
    M = reshape(M,[4,120/4]);
    M = M(3:4,:)';
    cs(:,ind_chan,iscanline) = M; % [position,nchan,nscanline]
    
    % cold count 
    fseek(fid,nstart+2432,-1); 
    M = fread(fid,[1,6],'uint16');
    M = M(3:6);
    M = reshape(M,[2,2])'; 
    cc(:,ind_chan,iscanline) = M; % [position,nchan,nscanline]
    
    % PRT telemetry to be converted to temperature      2444
    fseek(fid,nstart+2444,-1); 
    M = fread(fid,[1,20],'uint16');
    count_PRT_RFshelf(3,iscanline) = M(11);
    count_PRT_warmload(11:17,iscanline) = M(13:19); % load center, warm load 1-6

    % warm count
    fseek(fid,nstart+2484,-1); 
    M = fread(fid,[1,6],'uint16');
    M = M(3:6);
    M = reshape(M,[2,2])'; 
    cw(:,ind_chan,iscanline) = M; % [position,nchan,nscanline]
    
end

% change order to [ncross,nscanline,nchan]
cc = permute(cc,[1,3,2]);
cw = permute(cw,[1,3,2]);
cs = permute(cs,[1,3,2]);

% =====================================================
% close file
% =====================================================
fclose(fid);

% nstart = Byte.ARS+Byte.PrimaryHeader;
% fseek(fid,nstart+2568,-1); 
% x = fread(fid,'24*uint16',Byte.SciencePacket);

% =====================================================
% conversion
% =====================================================

% ---------------------------
% time
% ---------------------------
n = size(t_year,1);
t_datenum = datenum([t_year,zeros(n,5)]);
t_datenum = t_datenum + t_doy + t_UTC/(1e3*24*3600);
t_datenum = t_datenum'; 

% ---------------------------
% PRT temperature conversion
% ---------------------------
% Tw = Tw_base + dTw,      (Equation 7.3.1-2)
% where dTw is based on both TVAC and inflight measurements
% 
% A2 for chan 1-2, A1-1 for chan 3-5&8, A1-1 for chan 6-7&9-15

% Tw_base
% ---------------
% tw = d0 + d1*C + d2^2*C^2 + d3^3*C^3;
d0 = coeff_PRT_warmload(1,:)'; % [17,scanline]
d1 = coeff_PRT_warmload(2,:)';
d2 = coeff_PRT_warmload(3,:)';
d3 = coeff_PRT_warmload(4,:)';

[n1,n2] = size(count_PRT_warmload);
d0 = repmat(d0,[1,n2]);
d1 = repmat(d1,[1,n2]);
d2 = repmat(d2,[1,n2]);
d3 = repmat(d3,[1,n2]);
Tw_base = d0 + d1.*count_PRT_warmload + d2.*count_PRT_warmload.^2 + d3.*count_PRT_warmload.^3; % [17,scanline]

idx = diff(Tw_base,1,2)>0.2; % time series > 0.2K
idx = idx(:,[1,1:end]);
Tw_base(idx) = NaN;
Tw_A1_1 = nanmean(Tw_base(1:5,:),1);
Tw_A1_2 = nanmean(Tw_base(6:10,:),1);
Tw_A2 = nanmean(Tw_base(11:17,:),1);
ind_tw2chan = [3 3 2 2 2 1 1 2 1 1 1 1 1 1 1];
Tw_base = [Tw_A1_1;Tw_A1_2;Tw_A2];
Tw_base = Tw_base(ind_tw2chan,:); % [chan 1-15,nscaline]
Tw_base = permute(Tw_base,[3,2,1]); % [ncross,nscaline,chan 1-15]

% T_RFshelf
% ---------------
% dTw = d0 + d1*C + d2^2*C^2 + d3^3*C^3;
d0 = coeff_PRT_RFshelf(1,:)'; % [3,scanline]
d1 = coeff_PRT_RFshelf(2,:)';
d2 = coeff_PRT_RFshelf(3,:)';
d3 = coeff_PRT_RFshelf(4,:)';

[n1,n2] = size(count_PRT_RFshelf);
d0 = repmat(d0,[1,n2]);
d1 = repmat(d1,[1,n2]);
d2 = repmat(d2,[1,n2]);
d3 = repmat(d3,[1,n2]);
T_RFshelf = d0 + d1.*count_PRT_RFshelf + d2.*count_PRT_RFshelf.^2 + d3.*count_PRT_RFshelf.^3; % [17,scanline]

ind_tw2chan = [3 3 2 2 2 1 1 2 1 1 1 1 1 1 1];
T_RFshelf = T_RFshelf(ind_tw2chan,:); % [chan 1-15,nscaline]
T_RFshelf = permute(T_RFshelf,[3,2,1]); % [ncross,nscaline,chan 1-15]

% tw
% ---------------
tw = Tw_base;

% ---------------------------
% scene count to radiance 
% ---------------------------
c_c2r = permute(c_c2r,[1,3,2]); % [a0/a1/a2,nscanline,nchan]

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

% bandwidth correction (amsu-a correction is none)
% T2 = (T1-b1)/b2; 
tb_bw = tb;
for i=1: nchan
    tb1 = tb(:,:,i);
    tb_bw(:,:,i) = (tb1-c_bw(1,i))/c_bw(2,i);
end
tb = tb_bw;

% ---------------------------
% navigation
% ---------------------------
eia = angle_satzenith;
azm = angle_azimuth;



