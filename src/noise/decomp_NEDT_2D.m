function [NEDT_total,NEDT_thermal,NEDT_1f,NEDT_per_1f] = decomp_NEDT_2D(M)
% decomposing noise into total, thermal and 1/f
%   total noise is from column & row
%   thermal is from column; if n1=1, thermal is for n2
%   1/f noise = sqrt(total^2-thermal^2)
% 
% Input:
%       M,              [n1,n2,n3,...]  [cross-track,along-track]/[cross-track,along-track,channel,...]
% 
% Output:
%       NEDT_total,     total NEDT,         [n3,...]
%       NEDT_thermal,   thermal NEDT,       [n3,...]
%       NEDT_1f,        1/f NEDT,           [n3,...]
%       NEDT_per_1f,    1/f percentage,     [n3,...]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/30/2019: original code

n = size(M);

NEDT_total = std(reshape(M,n(1)*n(2),[]),0,1);

if length(n)>=4
    NEDT_total = reshape(NEDT_total,n(3:end));
else
    NEDT_total = NEDT_total(:);
end

NEDT_thermal = allandev_2sample_2D(M);

M1 = NEDT_total.^2 - NEDT_thermal.^2;
M1(M1<0) = 0;
NEDT_1f = sqrt(M1);

NEDT_per_1f = NEDT_1f.^2./NEDT_total.^2;


