function saterr_set_noiserng
% setting random number generator and its reproductivity
% This is applied to both additive and signal-dependent noise
%
% Input:
%       noise generator and reproductivity
% Output:
%       noise generator and reproductivity
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: seed setting

global Noise
% -----------------------------
% setting
% -----------------------------
% 0=generating different random number that changes for channels and times
% 1=reproduce the same random number for all channels
% 2=reproduce but channel dependent
% default=0
Noise.rng.reproduce = 2;

% generator
Noise.rng.type = 'twister';

% seed
Noise.rng.seed = 1;

