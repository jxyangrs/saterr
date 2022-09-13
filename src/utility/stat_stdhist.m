function [xstd,xm,xml] = stat_stdhist(x,y)
% standard deviation and weighted mean for a histogram (PDF)
% 
% Input:
% x, bin (column 1D)
% y, PDF (1D or 2D or nD)
% 
% Output (nD-1, [1,x,...]):
% xstd, standard deviation
% xm, weighted mean
% xml, x correponds to the maximum likelihood
% 
% Examples:
% x = (-10:0.01:10)';sigma = 1.4;u = 1; y = 1/sqrt(2*sigma^2*pi)*exp(-(x-u).^2/(2*sigma^2));
% xstd = stat_stdhist(x,y);
% 
% x = (-10:0.01:10)';sigma = 1.4;u = 1; y = 1/sqrt(2*sigma^2*pi)*exp(-(x-u).^2/(2*sigma^2));
% x = x(:,[1]);
% y = y(:,[1 1 1],[1 1]);
% xstd = stat_stdhist(x,y);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 08/23/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 09/14/2016: output maximum likelihood
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 02/15/2017: numel for prod; xml row
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 03/22/2018: description and nD

x = x(:);
w = bsxfun(@rdivide,y,sum(y,1));
xm = sum(bsxfun(@times,x,w),1);
xstd = sqrt(sum(bsxfun(@times,bsxfun(@minus,x,xm).^2,w),1));
[~,ind] = max(y,[],1);
xml = x(ind);







