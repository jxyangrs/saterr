function varargout = interp_lin_3D_asc(Hi,H,varargin)
% linarly interpolation in the 3nd dimension
%
% Input:
%       Hi,         [lat/lon,lon/lat,altitude],     interpolation altitude (Hi can have different intervals)
%       H,          [lat/lon,lon/lat,altitude],     original altitude; H must be monotonically ascending along the column
%       varargin,   [lat/lon,lon/lat,altitude],     environment parameters
%
% Output:
%       varargout,  [lat,lon,altitude],     interpolated environment parameters
%
% Examples:
%       Hi=(1:88)';H=[1:37]';
%       Hi(1,1,:)=1:88; H(1,1,:)=1:37;
%       Hi = repmat(Hi,[181,360,1]); H = repmat(Hi,[181,360,1]);
%       T=rand(180,360,37);q=rand(180,360,37);
%       [Ti,qi] = interp_lin_3D_asc(Hi,H,T,q);
%
% Note:
%       double precision is needed for large matrix
%
% written by John Xun Yang, University of Maryalnd, jxyang@umd.edu, or johnxun@umich.edu, 02/25/2020: original code


% interpolate setting w/ linear pressure
[m1,m2,m3] = size(Hi);
Hi = permute(Hi,[3,1,2]);
Hi = reshape(Hi,[m3,m1*m2]);

[n1,n2,n3] = size(H);
x = H;
x = permute(x,[3,1,2]);
x = reshape(x,[n3,n1*n2]);
H = x;

% interpolate
for i=1: nargin-2
    x = varargin{i};
    [n1,n2,n3] = size(x);
    x = permute(x,[3,1,2]);
    x = reshape(x,[n3,n1*n2]);
    [xi] = interp_lin_2D_asc(Hi,H,x);
    xi = reshape(xi,[m3,m1,m2]);
    xi = permute(xi,[2,3,1]);
    varargout{i} = xi;
end



