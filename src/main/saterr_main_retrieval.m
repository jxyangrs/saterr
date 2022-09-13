function saterr_main_retrieval
% retrieving geophysical parameters with satellite radiance
%
% Input:
%       satellite radiance
%
% Output:
%       retrieved geophysical parameters
%
% Description:
%       There have been a range of retrieval algorithms from simple empirical inversions to sofisticated ones like 1D var.
%       Users are suggested to refer to those algorithms for studying the error propogation. 
%       Here we only list a couple of retrieval algorithms that are simply empirical
% 
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code

global Setting

% cloud liquid water content w/ amsu-a
[clwp,ierrret,scat] = retr_clwc_amsua(tb_obs,tsavg5,zasat);

% atmospheric temperature retrieval w/ atms
[pres,tmp] = retr_tmp_atms(tb,theta);

% surface oceanic wind speed w/ ssm/i
ws = retr_wind_ssmi(tb);
