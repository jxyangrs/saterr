function Sout = stokes_reflc_conical(E,Sin,Trflc)
% modified Stokes of reflector for conical scanning
% 
% Input:
%       E,       reflector emissivity V-pol,    [Stokes(V,H,3,4),crosstrack,alongtrack],      reflector plane parallel to Earth incidence plane
%       Sin,     incidence Stokes,              [4,crosstrack,alongtrack]
%       Trflc,   reflector temperature,         [1,1,alongtrack]
%
% Output:
%       Sout,    Stokes off reflector,          [4,crosstrack,alongtrack]
%                (Reflection+Emission)
% 
% Description:
%       For conical scanning, the reflector plane is parallel to Earth incidence plane
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: Stokes

Ev = E(1);
Eh = E(2);
E3 = E(3);
E4 = E(4);

Sout = [(1-Ev)*Sin(1,:,:)+Ev*Trflc;(1-Eh)*Sin(2,:,:)+Eh*Trflc;(1-E3)*Sin(3,:,:)+E3*Trflc;(1-E4)*Sin(4,:,:)+E4*Trflc];


