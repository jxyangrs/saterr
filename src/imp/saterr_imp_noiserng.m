% implementing random number generator for its reproductivity
% This is applied to both additive and signal-dependent noise
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: seed setting


% -----------------------------
% implementation
% -----------------------------
switch Noise.rng.reproduce
    case 0 % 0=differenct random number
        % random number keeps changing
    case 1 % 1=reproduce the same random number for all channels
        rng(Noise.rng.seed,Noise.rng.type)
    case 2 % 2=reproduce but channel dependent
        rng(Noise.rng.seed+Noise.addnoise.nchan-1,Noise.rng.type)
    otherwise
        
end


