function C = mtimes_3d3d(A,B)
% 3D matrix multiplying
% 
% Input:
%       A,      [n1,n2,n3]
%       B,      [n2,m2,n3]
% 
% Output:
%       C,      [n1,m2,n3]
% 
% Examples:
%       A = rand(4,4,1000);B=rand(4,5,1000);
%       C = mtimes_3d3d(A,B);
% 
% Description:
%       This code is equivalent to code below but saves looping time: 
%       for n=1: size(A,3)
%           C(:,:,n) = A(:,:,n)*B(:,:,n);
%       end
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/03/2019: original code

[n1,n2,n3] = size(A);
[m1,m2,m3] = size(B);

if n2~=m1 || n3~=m3
    error('dimension mismatch in matrix multiplying')
end

if n3==1 && m3==1
    C = A*B;
    return
end

A = permute(A,[2,1,4,3]);  
B = permute(B,[1,4,2,3]);  
C = bsxfun(@times,A,B);                   
C = sum(C,1);               
C = permute(C,[2,3,4,1]);   


