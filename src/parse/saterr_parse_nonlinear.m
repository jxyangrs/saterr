% parsing Faraday rotation
%
% Input:
%       Receiver.nonlinear.onoff,       turn on/off nonlinearity,           0/1
%       T_nl,                           peak nonlinearity (K),              [1,channel]
% 
% Output:
%       Receiver.nonlinear.onoff,       turn on/off nonlinearity,           0/1
%       Receiver.nonlinear.T_nl,        peak nonlinearity (K),              [1,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/31/2019: original code



% check size
n1 = size(T_nl);
n2 = [1,Rad.num_chan];

if ~isequal(n1,n2)
    error('size inconsistent: T_nl and Rad.num_chan')
end

% output
Rad.nonlinear.T_nl = T_nl;

