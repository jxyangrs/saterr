% map plot of Faraday rotation
%
% Input:
%       --Faraday rotation angle and change of Stokes
%       Faraday.chan.omega,     channel omega (degree),             [cross-track,alongtrack,channel]
%       Faraday.chan.d,         channel d (K),                      [cross-track,alongtrack,channel]
%       Faraday.chan.U,         channel U (K),                      [cross-track,alongtrack,channel]
%
% Output:
%       plots of Faraday rotation
% 
% Description:
%       Theory and equation:
%       Given that input Stokes [Tv1,Th1,U1,V1], output Stokes [Tv2,Th2,U2,V2], where input is before Faraday rotation and
%       output is with Faraday rotation. There are:
%           omega = 1.355e-5.*VTEC.*f.^(-2).*Bp.*secd(psi); 
%       where omega is Faraday rotation angle (degree), Bp is parallel magnetic field (nano Tesla), TEC is total electron content (TECU), 
%       f is frequency (GHz), psi is local zenith ange (degree).
%           Q1 = Tv1-Th1;
%           d = Q1.*sind(omega).^2 - U1/2.*sind(2*omega);
%           Tv2 = Tv1 - d;
%           Th2 = Th1 + d;
%           U2 = U1.*cosd(2*omega) - Q1.*sind(2*omega);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2019: original code

% -------------------------
% input
% -------------------------
if ~(Orbit.onoff==1 && Faraday.onoff==1)
    return
end

lat = Orbit.fov.lat;
lon = Orbit.fov.lon;


[clat,clon] = plot_map_coastline(1);


% -------------------------
% plot
% -------------------------

% rotation angle Omega
M = CalPara.Faraday.chan.omega;

figure(1)
clf
set(gcf,'paperposition',[0 0 8 4]*1.2)

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    h_colorbar = plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'both');
    
    title(strrep([upper(Rad.sensor), ' Faraday \Omega Chan ',num2str(nchan)],'_',''))
    title(h_colorbar,'^o')
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_faraday_map_omega_chan',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end

% Stokes U
M = CalPara.Faraday.chan.U;

figure(1)
clf
set(gcf,'paperposition',[0 0 8 4]*1.2)

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    h_colorbar = plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'both');
    
    title(strrep([upper(Rad.sensor), ' Faraday U Chan ',num2str(nchan)],'_',''))
    title(h_colorbar,'K')
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_faraday_map_U_chan',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end

% d for Tv,Th
% Tv2 = Tv1-d;
% Th2 = Th1+d;
M = CalPara.Faraday.chan.d;

figure(1)
clf
set(gcf,'paperposition',[0 0 8 4]*1.2)

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    h_colorbar = plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'both');
    
    title(strrep([upper(Rad.sensor), ' Faraday \Deltad Chan ',num2str(nchan)],'_',''))
    title(h_colorbar,'K')
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_faraday_map_d_chan',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end

