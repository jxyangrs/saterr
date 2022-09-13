function [ind1,ind2] = ind_startend_bin(Ntotal,Nbin)
% all index from start and end
%
% Input:
%       Ntotal,     total number,           scalar>0
%       Nbin,       interval length,        scalar>0
%
% Output:
%       ind1,       index of subsection start
%       ind2,       index of subsection end
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/11/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/15/2017: debug

if Ntotal<Nbin
    ind1 = 1;
    ind2 = Ntotal;
    
else
    
    ind1 = 1: Nbin: Ntotal;
    ind2 = Nbin: Nbin: Ntotal;
    
    if ind2(end)<Ntotal
        ind2(end+1) = Ntotal;
    end
    
end
