% implement calculation of reference NEDT
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

% TBC noise
ind = ind_CT{1};
M = noise_ts(ind,:);
NEDT_ref_tbc_thermal(nchan) = allandev_2sample_2D(M);

M = M(:);
NEDT_ref_tbc_total(nchan) = std(M);

% TBW noise
ind = ind_CT{2};
M = noise_ts(ind,:);
NEDT_ref_tbw_thermal(nchan) = allandev_2sample_2D(M);
NEDT_ref_tbw_thermal2(nchan) = allandev_2sample_2D(M(2:end,:));

M = noise_ts(ind,:);
M = M(:);
NEDT_ref_tbw_total(nchan) = std(M);

M = noise_ts(ind,:);
M = M(2:end,:); % reference for calibration
M = M(:);
NEDT_ref_tbw_total2(nchan) = std(M);

% TBS noise
ind = ind_CT{3};
M = noise_ts(ind,:);
NEDT_ref_tbs_thermal(nchan) = allandev_2sample_2D(M);

M = M(:);
NEDT_ref_tbs_total(nchan) = std(M);
