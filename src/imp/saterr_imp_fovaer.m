function saterr_imp_fovaer
% footprint angle of azimuth,elevation,range
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code

global Rad

% -----------------------------
% implement
% -----------------------------
switch Rad.scantype
    case 'Spheroid'
        eia = sphere_nadir2eia(Rad.altitude,Rad.scanrotate.bs_angle_dcz);
        Rad.scanrotate.eia = eia;
        
    otherwise
        error('Rad.scantype')
end