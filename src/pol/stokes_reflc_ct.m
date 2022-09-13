function Sout = stokes_reflc_ct(E,Sin,Trflc)
% modified Stokes off reflector for cross-track scanning
%
% Input:
%       E,       reflector emissivity V-pol,    [Stokes(V,H,3,4),crosstrack,alongtrack],      reflector plane (Eh<Ev) is perperdicular to Earth incidence plane: swap Earth V/H
%       Sin,     incidence Stokes,              [4,crosstrack,alongtrack]
%       Trflc,   reflector temperature,         [1,1,alongtrack]/scalar
%
% Output:
%       Sout,    Stokes off reflector,          [4,crosstrack,alongtrack]
%                (Reflection+Emission)
% 
% Description:
%       For cross-track scanning, the reflector plane is perperdicular to Earth incidence plane, resulting in swap of Ev,Eh and flipping of E3,E4
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: Stokes

Ev = E(1);
Eh = E(2);
E3 = -E(3);
E4 = -E(4);

Sout = [(1-Eh)*Sin(1,:,:)+Eh*Trflc;(1-Ev)*Sin(2,:,:)+Ev*Trflc;(1-E3)*Sin(3,:,:)+E3*Trflc;(1-E4)*Sin(4,:,:)+E4*Trflc];
