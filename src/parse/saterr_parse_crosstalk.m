% parse crosstalk
%
%
% Output:
%       Rad.crosstalk.X,    [channel,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

% parse
if Rad.crosstalk.onoff==1
    % parse
    m = X;
    if ~isequal(size(m),[Rad.num_chan,Rad.num_chan])
        error('Error of size of Rad.crosstalk')
    end
    
    switch scheme
        case 1
            % check normalization
            Rad.crosstalk.scheme = scheme;
            Rad.crosstalk.X = X;
            Rad.crosstalk.refl = 0;
            
        case 2
            % check normalization
            Rad.crosstalk.scheme = scheme;
            Rad.crosstalk.X = X;
            Rad.crosstalk.refl = refl;
            
        case 3
            M = X.^2;
            M1 = M - diag(diag(M));
            M1 = M1*2;
            M = M1 + diag(diag(M));
            M = M./sum(M,1);

            % check normalization
            Rad.crosstalk.scheme = scheme;
            Rad.crosstalk.X = M;
            Rad.crosstalk.refl = 0;
            
        otherwise
            error('scheme is wrong')
    end
    
end


