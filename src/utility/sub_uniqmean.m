function [n,IDuniq,idxID,varargout] = sub_uniqmean(ID,varargin)
% compute mean values for different groups
%
% Input: cannot have NaN element
% ID, identity for different groups
% varargin, input variables
%
% Output:
% n, numbers in each groups
% varargout, mean values for different groups
%
% Example:
% tb1 = rand(100,3)+200; % v-pol
% tb2 = rand(100,3)+160; % h-pol
% eia = rand(100,3)+53; % EIA
% idx = randi(5,100,1); %1=good,0=bad
% [n,IDuniq,idxID,mtb1,mtb2,meia] = sub_uniqmean(ID,tb1,tb2,eia)
%
% Note:
% accumarray is used for each column, while not used for each variable;
% however time consuming is the same, unless No. of input variables are
% big, e.g., >=50
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/12/2016

N = zeros(1,nargin-1);
for i=1: nargin-1
    N(i) = size(varargin{i},2);
end

[IDuniq,~,idxID] = unique(ID);
n = accumarray(idxID,1);
varargout = cell(1,nargin-1);
for i=1: nargin-1
    vals = varargin{i};
    n2 = size(vals,2);
    valsmean = NaN(length(IDuniq),n2);
    for j = 1: n2
        valsmean(:,j) = accumarray(idxID, vals(:,j))./n;
    end
    varargout{i} = valsmean;
end
