function Mu = mueller_reflc_ct(theta)
% Mueller matrix for quasi-pol through reflector
% 
% Input:
%       theta,  polarization twist angle (degree),       [1,1,crosstrack]
%
% Output:
%       Mu,     Muelleter matrix for reflection,         [4,4,crosstrack]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: Stokes

N = size(theta);

theta = theta/180*pi;
Mu = [cos(theta).^2     sin(theta).^2   1/2*sin(2*theta)    zeros(N);...
      sin(theta).^2     cos(theta).^2   -1/2*sin(2*theta)   zeros(N);...
      -sin(2*theta)     sin(2*theta)    cos(2*theta)        zeros(N);...
      zeros(N)          zeros(N)        zeros(N)            ones(N)];
