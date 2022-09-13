% parse far-field TB sources for mainlobe, sidelobe, spillover
% near-field emission such as reflector emission is not set here, but in saterr_set_reflcemiss.m etc
%
% Output:
%       targets of far-field
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/06/2019: add customize option
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/06/2019: external sample

% default setting
if strcmp(Setting.Rad.sensor, 'demo')
    AP.tbsrc.mainlobe = 'waveform';
end

if strcmp(Path.scheme, 'B') % Scheme B for extensive simulation w/ reanalysis
    AP.tbsrc.mainlobe = 'reanalysis';
end

if strcmp(AP.tbsrc.sidelobe,'customize_sidefuncmain')
     if ~isfield(TBsrc.tb_sidelobe, 'func')
        error( 'TBsrc.tb_sidelobe.func not defined')
     end
     
end

% % -------------------------
% % brightness temperature of mainlobe, sidelobe, spillover
% % nominal mode: mainlobe=Earth,spillover=cosmic
% % manuever:     mainlobe=cosmic,spillover=Earth
% % TVAC:         step function
% % saterr_set_TBsource.m
% % -------------------------
% AP.mode = 'Nominal';
% AP.tbsrc.mainlobe = 'ocean'; % tb source of mainlobe;
% AP.tbsrc.sidelobe = 0; % sidelobe
% AP.tbsrc.spillover = 'cosmic'; % backlobe/spillover



