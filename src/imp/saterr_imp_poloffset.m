function saterr_imp_poloffset
% calculate reflector twist angle
% twistangle offset can occur for cross-track sensors and result in polarization offset 
%
% Input:
%       PolOffset.angle.*,          polarization angle offset
%       Rad.scan.*,                 scanning angle
% 
% Output:
%       PolOffset.angpoloff_cs,     actual scene angle,         [1,crosstrack]
%
% Description:
%       The twist angle will be used in the reflector module
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/31/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: combine reflector emis

global PolOffset Rad

if PolOffset.onoff
    switch Rad.scantype
        case 'crosstrack'
            theta = PolOffset.angle.nominal_theta+PolOffset.angle.offset_theta; % reflector tilt angle in Earth plane (degree), scalar
            psi = PolOffset.angle.nominal_psi+PolOffset.angle.offset_psi; % reflector angle in horizontal plane (degree) scalar
            phi = Rad.scan.cs_angscan+PolOffset.angle.offset_phi; % scan angle [1,cross-track]
            
            [A,B] = polanglecoeff_cross(phi,theta,psi);
            angpoloff_cs = asind(A); % effective angle
            angpoloff_cs = abs(angpoloff_cs);
            
            PolOffset.angpoloff_cs = angpoloff_cs;
            
        case 'conical'
            % will be applied in saterr_imp_reflc_tas.m

    end
end
