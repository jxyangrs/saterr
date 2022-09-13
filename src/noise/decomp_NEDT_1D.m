function [NEDT_total,NEDT_thermal,NEDT_1f,NEDT_per_1f] = decomp_NEDT_1D(M)
% noise of total, thermal and 1/f
% 
% M,    [sample,channel]

NEDT_total = std(M,0,1);
NEDT_total = NEDT_total(:);

NEDT_thermal = allandev_2sample(M);
NEDT_thermal = NEDT_thermal(:);

M1 = NEDT_total.^2 - NEDT_thermal.^2;
M1(M1<0) = 0;
NEDT_1f = sqrt(M1);

NEDT_per_1f = NEDT_1f.^2./NEDT_total.^2;
