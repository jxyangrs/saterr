% parse setting for instrument intereference
%
% Output:
%       ScanBias.intrf.tb,      interference TB,        [crosstrack,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code

% -------------------------
% parse
% -------------------------
n1 = Rad.ind_CT_num(1);
n2 = Rad.num_chan;

N = size(tb);

if isequal(N,[n1,n2])
    ScanBias.interference.tb = tb;
else
    error('size of intereference tb should be [crosstrack,channel]')
end
