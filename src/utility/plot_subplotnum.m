function [n1row,n2col] = plot_subplotnum(n)
% determine the number of subplots, given the total number n
% 
% Input:
%       n,          No. of subplot
% Output:
%       n1row,      No. of row
%       n2col,      No. of column
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/03/2019: original code

switch n
    case 1
        n1row = 1;
        n2col = 1;
    case 2
        n1row = 2;
        n2col = 1;
    case 3
        n1row = 3;
        n2col = 1;
    case 15
        n1row = 5;
        n2col = 3;
    otherwise
        n1row = ceil(sqrt(n));
        n2col = ceil(n/n1row);
end
