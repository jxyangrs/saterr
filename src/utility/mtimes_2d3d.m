function C = mtimes_2d3d(A,B)
% 3D matrix multiplying
% 
% Input:
%       A,      [n1,n2]
%       B,      [n2,m2,n3]
% 
% Output:
%       C,      [n1,m2,n3]
% 
% Examples:
%       A = rand(4,4);B=rand(4,5,100);
%       C = mtimes_2d3d(A,B);
% 
% Description:
%       This code is equivalent to code below but saves looping time: 
%       for n=1: size(B,3)
%           C(:,:,n) = A*B(:,:,n);
%       end
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/03/2019: original code

[n1,n2,n3] = size(A);
[m1,m2,m3] = size(B);

if n2~=m1
    error('dimension mismatch in matrix multiplying')
end
if n3>1
    error('A should be 2D')
end

A = A(:,:,ones(m3,1));
C = mtimes_3d3d(A,B);



