function [Z,E,S,explained] = pca_svds(A,varargin)
% PCA with SVD for kth largest eigen values
% 
% Input:
%       A,       data,                      [n,p] ([trial,dimension])
% Output:
%       Z,       projected/score matrix,    [n,k]
%                pricipal components
%       E,       eigen vector/EOF,          [p,k]
%       S,       variances,                 [n1,n1]
% 
% Examples:
%       A = magic(3000);
%       [Z,U,S] = pca_svds(A); % full decomposition
%       [Z,U,S] = pca_svds(A,10); % the largest 10 principal component
% 
% Note:
%       A = U*S*V'
%       explained variance = diag(S)/sum(diag(S))
%       scaled eigen vecotr, U_scaled = bsxfun(@times,U,sqrt(S'));
%       A*E(:,1:n)*E(:,1:n)', reconstructed w/ first few EOF
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/22/2019: original code

[n1,n2] = size(A);

if nargin==2
    k = varargin{1};
else 
    k = min(n1,n2);
end

A = A - mean(A,1);

[U,S,V] = svds(A,k); % the factor 1/sqrt(n-1) does not affect U/V except S, and S is counted in the following code

S = diag(S).^2/(n1-1);
explained = S/sum(S);

Z = A*V;
E = V;

