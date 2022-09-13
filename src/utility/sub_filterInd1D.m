function [varargout] = sub_filterInd1D(ndim,idx,varargin)
% filter using Nth 1D input index applied to ND matrix
%
% Input: (input dimension can be different)
%         ndim, Nth dimension
%         idx, 1D [index,1]/[1,index]; logical index of filter; 1=good,0=bad; or non-logical index, real index number=good
%         varargin, 1D [index,1] or 2D [index,colum]
%
% Output:
%         varargout, variables with filtering applied
%
% Examples:
%         x1 = rand(100,3); 
%         x2 = rand(100,3); 
%         idx = rand(100,1)>0.5; %1=good,0=bad
%         [y1,y2] = sub_filterInd1D(1,idx,x1,x2);
%         or
%         [y1,y2] = sub_filterInd1D(2,idx,x1',x2');
%         or
%         x.x1=x1;x.x2=x2;
%         [y] = sub_filterInd1D(1,idx,x);
%         or
%         x1 = rand(3,100,5); x2 = rand(2,100);
%         [y1,y2] = sub_filterInd1D(2,idx,x1,x2);
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/26/2016: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/28/2016: allow for struct
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 3/14/2017: allow for Nth dimension with varibles of different dimension

n = nargin-2;
varargout = cell(1,n);

for i = 1: n
    x = varargin{i};
    
    if isstruct(x)
        m = fieldnames(x);
        for j=1: length(m)
            eval(['y=x.',m{j},';'])
            NDmax = numel(size(y));
            [~,sy] = strcommand(NDmax,ndim);
            eval(sy);
            eval(['x.',m{j},'=y;'])
        end
    else
        NDmax = numel(size(x));
        [sx,~] = strcommand(NDmax,ndim);
        eval(sx)
    end
    varargout{i} = x;
end


function [sx,sy] = strcommand(Nd,ndim)
% command to execute
% 
% Nd, max dimension
% ndim, Nth dimension, ndim<=Nd

s = ':,';
s = repmat(s,[1,Nd]);
s = [s(1:(ndim-1)*2),'idx,',s(ndim*2+1:end)];
s(end) = ')';
s = ['(',s];

sx = ['x=x',s,';'];
sy = ['y=y',s,';'];
