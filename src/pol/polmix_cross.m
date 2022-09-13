function [tb_chan] = polmix_cross(Tas,phi)
% angular offset for quasi-pol
%
% Input:
%       Tas,        [Stokes(4),crosstrack,alongtrack,channel]
%       phi,        [crosstrack,1]/[crosstrack,alongtrack] (degrees)
%
% Output:
%       tb_chan,    [crosstrack,alongtrack,channel]
%
% Description:
%       TBqv = TBv*B^2 + TBh*A^2
%       TBqh = TBh*B^2 + TBv*A^2
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/01/2019: original code

global Rad

A = sind(phi);
B = cosd(phi);

[n1,n2,n3,n4] = size(Tas);
TBv = Tas(1,:,:,:);
TBv = reshape(TBv,[n2,n3,n4]);
TBh = Tas(2,:,:,:);
TBh = reshape(TBh,[n2,n3,n4]);

TBqv = bsxfun(@times,TBv,B.^2) + bsxfun(@times,TBh,A.^2);
TBqh = bsxfun(@times,TBh,B.^2) + bsxfun(@times,TBv,A.^2);

tb_chan = [];
for nchan=1: size(Tas,4)
    indpol = Rad.chanpol_ind(nchan);
    switch indpol
        case 1
            tb1 = TBqv(:,:,nchan);
        case 2
            tb1 = TBqh(:,:,nchan);
    end
    tb_chan(:,:,nchan) = tb1;
end


