function saterr_parse_radspc_chan
% parsing radiometer channel specification
%
% Input:
%       mode,       
%       Radiometer channel setting
% 
% Output:
%       --index for Stokes
%       Rad.chanpol_ind,                  index for polarization,           1=V/QV,2=H/QH
%       --subband
%       Rad.subband.freq,                 subband frequency
%       Rad.subband.ind2chan,             index for subband
%       Rad.subband.num,                  No. of subband
%       --unique frequency
%       Rad.subband.uniq_freq,            unique frequency
%       Rad.subband.uniq_ind_freq2band,   index
%       Rad.subband.uniq_freq_num,        No. of unique frequency
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/19/2019: more index of crosstrack
global Rad

% index for Stokes
chanpol_ind = NaN(Rad.num_chan,1);
for nchan=1: Rad.num_chan
    t = Rad.chanpol{nchan};
    if strcmp(t,'V')
        chanpol_ind(nchan) = 1;
    elseif strcmp(t,'QV')
        chanpol_ind(nchan) = 1;
    elseif strcmp(t,'H')
        chanpol_ind(nchan) = 2;
    elseif strcmp(t,'QH')
        chanpol_ind(nchan) = 2;
    elseif strcmp(t,'3')
         chanpol_ind(nchan) = 3;
    elseif strcmp(t,'4')
         chanpol_ind(nchan) = 4;
    else
        error(['Rad.chanpol is wrong: ',t])
    end
end

Rad.chanpol_ind = chanpol_ind;


% subband
mode = 'channel';
saterr_imp_uniqfreq(mode)
