% cross-channel correlation
% 
% Input:
%       ta noise
%
% Output:
%       cor_tbw,            correlation matrix,       [channel,channel]
%       cor_tbc,            correlation matrix,       [channel,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

% cross-channel correlation
[n1,n2,n3] = size(tbw_noise);
M = reshape(tbw_noise,[n1*n2,n3]);
M = corr(M);
cor_tbw = M;

[n1,n2,n3] = size(tbc_noise);
M = reshape(tbc_noise,[n1*n2,n3]);
M = corr(M);
cor_tbc = M;

% figure(1)
% imagesc(cor_tbw)
% colorbar
% 
% figure(2)
% imagesc(cor_tbc)
% colorbar
