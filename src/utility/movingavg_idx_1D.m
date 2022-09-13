function ind = movingavg_idx_1D(M,n)
% index of full overlap (valid) wrt moving average along columnar direction
%
% Input:
%       M, number of data length
%       n, window size, scalar
%       M>n
%
% Output:
%       ind, index of start and end, 1D [start index;end index] 
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 12/19/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 12/19/2017: output real index rather than logical


if mod(n,2) % odd
    ind = [(n+1)/2; M-(n+1)/2+1];
else % even
    ind = [n/2; M-n/2];
end

if M<=n
    ind = [1;M];
end
