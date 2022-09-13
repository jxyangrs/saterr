function [varargout] = movingavg_cal(opt_window,opt_length,N,varargin)
% moving average along columnar direction
%
% Input:
%         opt_window, shape of moving window, 'rectangle'/'triangle'
%         opt_length, 0=cut off edges,1=keep the same length
%         n, window size, scalar
%         varargin, [n1,n2,...], variables to be applied with moving average along n1 direction
%
% Output:
%         varargout, after moving average
%                    opt_length=0,[n1-N+1,n2]
%                    opt_lenght=1,[n1,n2]
%
% Example:
%         [x2,y2] = math_movingavg('rectangle',0,9,x1,y1)
%
% Comment
%         when using triangle, a odd N keeps triangle shape, while even number is not triangle
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 12/19/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 12/26/2017: debug 'same'
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 12/26/2017: MATLAB window

% set up stride window
% switch opt_window
%     case 'rectangle'
%         w = ones(N,1); % weight (unnormalized)
%         ww = sum(w); % normalized factor
%         nw = size(w,1);
%     case 'triangle'
%         n = (N-1)/2;
%         k = (-n:n)';
%         w = 1/(n+1)*(1-abs(k)/(n+1));
%         ww = sum(w);
%         nw = size(w,1);
%     otherwise
%         error(['opt_window does not exist: ',opt_window])
% end

[w] = math_window(opt_window,N);

% do moving average
switch opt_length
    case 0 % default
        for i=1:length(varargin)
            A = varargin{i};
            B = conv2(A,w,'valid')/sum(w);
            varargout{i} = B;
        end
    case 1 % same
        for i=1:length(varargin)
            A = varargin{i};
            B = conv2(A,w,'same');
            w1 = conv2(ones(size(A)),w,'same'); % a 2nd convolve to avoid edge bias
            B = bsxfun(@rdivide,B,w1);
            varargout{i} = B;
        end
    otherwise
        error(['opt_length does not exist: ',opt_length])
end



