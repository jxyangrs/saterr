function [varargout] = movingavg_2Dwin_1conv(opt,w,varargin)
% moving average w/ window of 1D or 2D
% only one convolution saving time for big array
%
% Input:
%       opt,        'same'/'valid'
%       w,          1D/2D window
%       varargin,   [n1,n2,...] can be N-D
%
% Output:
%       varargout,  after moving average
%
% Example:
%       A = rand(3,4,5);
%       w = ones(2,2);
%       [x2,y2] = math_movingavg_2Dwin_1conv('same',w,x1,y1)
%
%       [w] = math_window(opt_window,N);
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 11/06/2019: original code

% do moving average
switch opt
    case 'valid' % default
        for i=1:length(varargin)
            A = varargin{i};
            B = convn(A,w,'valid')/sum(w(:));
            varargout{i} = B;
        end
    case 'same' % same
        for i=1:length(varargin)
            A = varargin{i};
            N = size(A);
            n1 = N(1);
            n2 = N(2);
            M = size(w);
            m1 = M(1);
            m2 = M(2);
            
            % first conv
            B = convn(A,w,'same');
            
            % weight matrix
            if n1<=m1 || n2<=m2
                W = conv2(ones(n1,n2),w,'same');
            else
                % edge matrix W_edge
                W_edge = conv2(ones(m1,m2),w,'same');
                
                if mod(m1,2)
                    ind_mid1 = (m1+1)/2;
                else
                    ind_mid1 = m1/2;
                end
                
                if mod(m2,2)
                    ind_mid2 = (m2+1)/2;
                else
                    ind_mid2 = m2/2;
                end
                
                % weight matrix
                W = ones(n1,n2)*W_edge(ind_mid1,ind_mid2);
                
                % upper
                W(1:ind_mid1-1,:) = repmat(W_edge(1:ind_mid1-1,ind_mid2),[1,n2]);
                % bottom
                W(end-ind_mid1+1:end,:) = repmat(W_edge(end-ind_mid1+1:end,ind_mid2),[1,n2]);
                % left
                W(:,1:ind_mid2-1) = repmat(W_edge(ind_mid1,1:ind_mid2-1),[n1,1]);
                % right
                W(:,end-ind_mid2+1:end) = repmat(W_edge(ind_mid1,end-ind_mid2+1:end),[n1,1]);
                
                % corner upper-left
                W(1:ind_mid1,1:ind_mid2) = W_edge(1:ind_mid1,1:ind_mid2);
                % corner upper-right
                W(1:ind_mid1,end-ind_mid2+1:end) = W_edge(1:ind_mid1,end-ind_mid2+1:end);
                % corner lower-left
                W(end-ind_mid1+1:end,1:ind_mid2) = W_edge(end-ind_mid1+1:end,1:ind_mid2);
                % corner lower-right
                W(end-ind_mid1+1:end,end-ind_mid2+1:end) = W_edge(end-ind_mid1+1:end,end-ind_mid2+1:end);
            end
            % output
            B = bsxfun(@rdivide,B,W);
            
            varargout{i} = B;
        end
    otherwise
        error([opt,' does not exist'])
end



