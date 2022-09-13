function varargout = movingavg_edge_lr(w,varargin)
% moving average w/ left-right edge merged
%   e.g. applying moving-average through longitude edge; edge is accounted
%
% Input:
%       w,              1D/2D window
%       varargin{i},    [n1,n2,...] can be N-D
%
% Output:
%       varargout{i},   moving average applied
%
% Example:
%       sfc_tmp = rand(360,91); % [longitude,latitude]
%       w = ones(3,3);
%       sfc_tmp_avg = math_movingavg_edge_lr(w,sfc_tmp);
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 02/14/2020: original code

if numel(w) == 1 
    % no moving average
    for i=1: nargin-1
        varargout{i} = varargin{i};
    end
    
else
    % moving average
    for i=1: nargin-1
        A = varargin{i};
        n = size(A);
        n1 = n(1);
        n2 = n(2);
        
        m = size(w);
        m1 = m(1);
        m2 = m(2);
        
        if n2-1<m2
            error('size(A,2)-1 should be larger than size(w,2)')
        end
        
        B = movingavg_2Dwin_1conv('same',w,A);
        
        ind = movingavg_idx_1D(n2,m2);
        ind_edge_left = 1:ind(1)-1;
        ind_edge_right = ind(2)+1:n2;
        
        M = cat(2,A(:,end-m2+2:end,:),A(:,1:m2-1,:));
        M = movingavg_2Dwin_1conv('same',w,M);
        
        ind = movingavg_idx_1D(size(M,2),m2);
        ind_left = ind(2)-length(ind_edge_left)+1: ind(2);
        ind_right = ind(1): ind(1)+length(ind_edge_right)-1;
        
        B(:,ind_edge_left,:) = M(:,ind_left,:);
        B(:,ind_edge_right,:) = M(:,ind_right,:);
        
        varargout{i} = B;
    end
    
end


