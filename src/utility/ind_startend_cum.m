function [ind1,ind2] = ind_startend_cum(Num)
% index of start and end from cumsum
%
% Input:
%
% Output:
%       NaN, invalide index due to Num of 0
% Example:
%       Num = [4,4,96,104];
%       [ind1,ind2] = ind_startend_cum(Num);
%       Num = [4,4,96,0];
%       [ind1,ind2] = ind_startend_cum(Num);
%       Num = [4,52,96,4,52];
%       [ind1,ind2] = ind_startend_cum(Num);
%       
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/11/2018: original code

ind = cumsum(Num);
ind1 = [1,ind(1:end-1)+1];
ind2 = ind;

idx = ind2-ind1<0;
ind1(idx) = NaN;
ind2(idx) = NaN;

