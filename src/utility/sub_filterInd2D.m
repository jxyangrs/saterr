function [varargout] = sub_filterInd2D(idx,varargin)
% filter using 2D input index applied to 2D/3D array
% 
% Input:
%         idx, 1D/2D; logical index of filter, 1=good,0=bad; or non-logical index, real index number=good
%         varargin, 2D/3D 
% 
% Output (dimension reduced by 1):
%         varargout, variables with filtering applied; the first two dimensions are merged with the others the same
% 
% Example:
%         x1 = rand(100,3); 
%         x2 = rand(100,3); 
%         x3 = rand(100,3,3,4);
%         idx = rand(100,3)>0.5; %1=good,0=bad
%         [x1,x2,x3] = sub_filterInd2D(idx,x1,x2,x3);
% 
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2016: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/25/2016: allow for ind or idx

n = nargin-1;
varargout = cell(1,n);
for i = 1: n
    x = varargin{i};
    m = size(x);
    if length(m)>2
        x = reshape(x,m(1)*m(2),[]);
        x = x(idx(:),:);
        k = numel(x)/prod(m(3:end));
        x = reshape(x,[k,m(3:end)]);
    else
        x = x(idx);
    end
    varargout{i} = x;
end
