% parse cross polarization
%
%
% Output:
%       AP.crosspol.X,    [4,4,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

% parse
if AP.crosspol.onoff==1
    % parse
    m = [Xpp;Xpq;Xp3;Xp4;Xqp;Xqq;Xq3;Xq4;X3p;X3q;X33;X34;X4p;X4q;X43;X44;];
    if ~isequal(size(m),[16,Rad.num_chan])
        error('Error of size of AP.crosspol')
    end
    
    M = reshape(m,[4,4,Rad.num_chan]);
    
    % check normalization
    m = sum(M,2);
    if sum(abs(m(:)-1))~=0
        warning('cross polarization ~= 1; identity matrix used w/o cross-pol contamination')
        
        M = [1,0,0,0;
            0,1,0,0;
            0,0,1,0;
            0,0,0,1];
        AP.crosspol.X = M(:,:,ones(Rad.num_chan,1));
        
    else
        AP.crosspol.X = M; % [4,4,channel]
    end
    
else
    % identity matrix used w/o cross-pol contamination
    M = [1,0,0,0;
        0,1,0,0;
        0,0,1,0;
        0,0,0,1];
    AP.crosspol.X = M(:,:,ones(Rad.num_chan,1));
end


