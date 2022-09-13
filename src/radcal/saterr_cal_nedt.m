% calculating NEDT and breaking NEDT into thermal noise and non-thermal parts (e.g. 1/f noise)
% 
% Input:
%       ta noise
%
% Output:
%       NEDT_table_tas_noise,            noise table,       [channel,type]
%       NEDT_table_taw_noise,            noise table,       [channel,type]
%       NEDT_table_tac_noise,            noise table,       [channel,type]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code


% ---noise of taw_noise
M = taw_noise;
[NEDT_taw_total,NEDT_taw_thermal,NEDT_taw_1f,NEDT_taw_per_1f] = decomp_NEDT_2D(M);
NEDT_table_taw_noise = [NEDT_taw_total(:),NEDT_taw_per_1f(:)];

% ---noise of tac_noise
M = tac_noise;
[NEDT_tac_total,NEDT_tac_thermal,NEDT_tac_1f,NEDT_tac_per_1f] = decomp_NEDT_2D(M);
NEDT_table_tac_noise = [NEDT_tac_total(:),NEDT_tac_per_1f(:)];

% ---noise of ta_noise
M = tas_noise;
[NEDT_tas_total,NEDT_tas_thermal,NEDT_tas_1f,NEDT_tas_per_1f] = decomp_NEDT_2D(M);
NEDT_table_tas_noise = [NEDT_tas_total(:),NEDT_tas_per_1f(:)];



