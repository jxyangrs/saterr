function [n,IDuniq,idxID,varargout] = sub_uniqmeanstd(ID,varargin)
% calcualte mean and std of data for different groups
%
% Input:
% ID, index for n3 numbers of unique-group; [n1,1]
% vals, n3 variables, each is 2D [n1,n2]
%
% Output:
% n, number in each unique-group;
% varargout, mean and std
% 
% Example:
% idx = randi(5,100,1);
% tb1 = rand(100,5);
% tb2 = rand(100,9);
% [IDuniq,n,idxID,mtb1,mtbstd1,mtb2,mtbstd2] = sub_uniqmeanstd(idx,tb1,tb2);
%
% written by John Xun Yang, University of Michigan, johnxun@umich.edu, 01/2014
% revised by John Xun Yang, 8/14/2014: change sinlge input to multiple (varargin)
% revised by John Xun Yang, 9/10/2014: add output, IDuniq
% revised by John Xun Yang, 1/21/2015: add output, idxID, and change order

N = zeros(1,nargin-1);
for i=1: nargin-1
    N(i) = size(varargin{i},2);
end

[IDuniq,~,idxID] = unique(ID);
n = accumarray(idxID,1);
varargout = cell(1,(nargin-1)*2);
for i=1: nargin-1
    vals = varargin{i};
    n2 = size(vals,2);
    valsmean = NaN(length(IDuniq),n2);
    valsstd = valsmean;
    for j = 1: n2
        X = accumarray(idxID, vals(:,j))./n;
        X2 = accumarray(idxID,vals(:,j).^2);
        valsmean(:,j) = X;
        valsstd(:,j) = sqrt(X2./n-X.^2);
    end
    varargout{2*i-1} = valsmean;
    varargout{2*i} = valsstd;
end
