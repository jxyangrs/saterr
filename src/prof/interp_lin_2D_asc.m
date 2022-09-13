function varargout = interp_lin_2D_asc(Hi,H,varargin)
% linarly interpolation with columnar ascending
%
% Input:
%       Hi,         [altitude,pixel]/[altitude,1],      interpolation altitude (Hi can have different intervals)
%       H,          [altitude(ascending),pixel],        original altitude; H must be monotonically ascending along the column
%       varargin,   [altitude(wrt H),pixel],            environment parameters
%
% Output:
%       varargout,  [altitude,pixel],                   interpolated environment parameters
%
% Examples:
%       Hi=(1:88)';H=[23 50 70;13 40 80]';T=rand(3,2);clw=rand(3,2);q=rand(3,2);
%       [Ti,clwci,qi] = interp_lin_2D_asc(Hi,H,T,clw,q); 
%       Hi=[(1:88)',(2:89)'];H=[23 50 70;13 40 80]';T=rand(3,2);clw=rand(3,2);q=rand(3,2);
%       [Ti,clwci,qi] = interp_lin_2D_asc(Hi,H,T,clw,q); 
% 
% Note:
%       double precision is needed for large matrix
%
% written by John Xun Yang, University of Maryalnd, jxyang@umd.edu, or johnxun@umich.edu, 12/24/2016: original code
% revised by John Xun Yang, University of Maryalnd, jxyang@umd.edu, or johnxun@umich.edu, 01/02/2017: debug the bound from Hi and H
% revised by John Xun Yang, University of Maryalnd, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Hi interval can be different; Hi can be 1D array

M = diff(H,1,1);
if sum(M(:)<=0)>0
    error('Not monotonic ascending')
end

% determine the depth of extension
[n1,n2] = size(H); 
dHext = abs(mean(M(:),1)); % extension depth
Hmin = min(min(H(1,:)),min(Hi(1,:))); % ascending
Hmax = max(max(H(end,:)),max(Hi(end,:)));
Hstart = Hmin-dHext;
Hend = Hmax+dHext;
m1 = size(Hi,1);

% add a ground layer and a top layer to avoid interpolation out-of-bound
for i=1: nargin-2
    x = varargin{i};
    x1 = (x(2,:)-x(1,:))./(H(2,:)-H(1,:))*Hstart+(x(1,:).*H(2,:)-x(2,:).*H(1,:))./(H(2,:)-H(1,:));
    x2 = (x(end,:)-x(end-1,:))./(H(end,:)-H(end-1,:))*Hend+(x(end-1,:).*H(end,:)-x(end,:).*H(end-1,:))./(H(end,:)-H(end-1,:));
    x = [x1;x;x2];
    varargin{i} = x;
end
H = [Hstart*ones(1,n2);H;Hend*ones(1,n2)];
if n2==1
    dHmono = dHext;
else
    dHmono = max(H(end,1:end-1)-H(1,2:end)) + dHext; % ascending
end

% linear interploation 
Hi_trans = bsxfun(@plus,Hi,(0:n2-1)*(dHmono));
Hi_trans = Hi_trans(:);

H_trans = bsxfun(@plus,H,(0:n2-1)*(dHmono));
H_trans = H_trans(:);

for i=1: nargin-2
    x = varargin{i};
    xi = interp1(H_trans,x(:),Hi_trans,'linear');
    xi = reshape(xi, [m1 n2]);
    varargout{i} = xi;
end

