function [ind1,ind2] = ind_startend_binnum(N,num_subset)
% determine index of start and end w/ given number of bin (subsets may be slightly different)
%       N>=num_subset
%
% Input:
%       Ntotal,         total number,           scalar>0
%       num_subset,     number of subsets,      scalar>0
%
% Output:
%       ind1,           index of subsection start
%       ind2,           index of subsection end
%
% Examples:
%       [ind1,ind2] = ind_startend_binnum(10,3)
%       determine files for each CPU job
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/11/2019: original code

if N<=0 || num_subset<=0
    error('N should >0; num_subset shoudl >0')
end

if N<num_subset
    ind1 = 1: N;
    ind2 = ind1;
else
    a = rem(N,num_subset);
    n = (N-a)/num_subset;
    nmember = ones(num_subset,1)*n;
    nmember(1:a) = nmember(1:a) + 1;
    
    [ind1,ind2] = ind_startend_cum(nmember);
end
