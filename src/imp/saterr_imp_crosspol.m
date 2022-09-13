function [Tas] = saterr_imp_crosspol(Tas)
% implementing cross polarization contamination
%
% Input:
%       Tas,        Stokes before cross-pol contamination,      [Stokes,crosstrack,alongtrack]
% 
% Output:
%       Tas,        Stokes with cross-pol contamination,        [Stokes,crosstrack,alongtrack]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes

global AP VarDynamic

if AP.crosspol.onoff==1
    M = AP.crosspol.X(:,:,VarDynamic.nchan);
    [n1,n2,n3] = size(Tas);
    Tas = permute(Tas,[4,1,2,3]);
    Tas = reshape(sum(bsxfun(@times,M,Tas),2),[n1,n2,n3]);
end
