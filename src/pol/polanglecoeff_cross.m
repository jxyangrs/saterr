function [A,B] = polanglecoeff_cross(phi,theta,psi)
% angular offset for quasi-pol
% 
% Input:
%       phi,    [1,cross-track]
%       theta,  scalar
%       psi,    scalar
% 
% Output:
%       A,      [1,cross-track]
%       B,      [1,cross-track]
%
%       TBqv = TBv*B^2 + TBh*A^2
%       TBqh = TBh*B^2 + TBv*A^2
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/23/2019: correct D for proper negative

if theta==45 && psi==90
    A = sind(phi);
    B = cosd(phi);
    
elseif theta==45
    A = -cosd(phi+psi);
    B = sind(phi).*(cosd(phi+psi).*cosd(phi)-cosd(psi)) - cosd(phi).*(cosd(phi+psi).*sind(phi)+sind(psi));
    
else
    [A,B] = polanglecoeff_cross_deinf(phi,theta,psi);
    
end
A = A(:)';
B = B(:)';

function [A,B] = polanglecoeff_cross_deinf(phi,theta,psi)
% avoid sigularity
D = sqrt(1-sind(2*theta)^2*cosd(phi).^2);
if phi<0
    D = -D;
end
[n1,n2] = size(phi);
A = NaN(n1,n2);
B = NaN(n1,n2);

idx = abs(D)<1e-5;

if sum(idx(:))
    phi1 = phi(idx);
    A1 = -2*sind(theta)^2*cosd(phi1+psi);
    B1 = sind(phi1).*(cosd(phi1+psi).*cosd(phi1)-cosd(psi)) - cosd(phi1).*(cosd(phi1+psi).*sind(phi1)+sind(psi));
    A(idx) = A1;
    B(idx) = B1;
end

if sum(~idx(:))
    phi1 = phi(~idx);
    A1 = 1./D.*(cosd(2*theta)*sind(psi)-2*sind(theta)^2*cosd(phi1+psi).*sind(phi1));
    B1 = 1./D.*((cosd(2*theta)^2+sind(2*theta)^2*sind(phi1).^2)...
        .*(2*sind(theta)^2*cosd(phi1+psi).*cosd(phi1)-cosd(psi))...
        -1/2*sind(2*theta)^2*sind(2*phi1).*(2*sind(theta)^2*cosd(phi1+psi).*sind(phi1)+sind(psi))...
        -1/2*sind(4*theta)*cosd(phi1).*sind(2*theta).*cosd(phi1+psi));
    A(~idx) = A1;
    B(~idx) = B1;
end
