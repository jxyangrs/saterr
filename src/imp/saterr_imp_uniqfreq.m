function saterr_imp_uniqfreq(mode)
% accouting unique frequency for speeding up simulation
% It can also set to do all frequencies
%
% Input:
%       mode,                             unique/channel
%       Rad,        
% Output:
%       --subband
%       Rad.subband.mode,                 unique/channel
%       Rad.subband.freq,                 subband frequency
%       Rad.subband.ind2chan,             index for subband
%       Rad.subband.num,                  No. of subband
% 
%       --under unique mode
%       Rad.subband.uniq_freq,            unique frequency
%       Rad.subband.uniq_ind_freq2band,   index
%       Rad.subband.uniq_freq_num,        No. of unique frequency
%       --under channel mode
%       Rad.subband.uniq_freq,            subband frequency
%       Rad.subband.uniq_ind_freq2band,   index
%       Rad.subband.uniq_freq_num,        No. of channel subband
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/31/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: accounting for the thermal part of 1/f

global Rad

switch mode
    case 'unique'
        % count channel subband with unique frequencies considered
        
        % index for subband
        subband_freq = [];
        subband_ind = [];
        for nchan = 1: Rad.num_chan
            M = Rad.chanfreq{nchan};
            n = length(M);
            subband_freq = [subband_freq,M];
            subband_ind = [subband_ind,nchan*ones(1,n)];
        end
        Rad.subband.mode = mode;
        Rad.subband.freq = subband_freq;
        Rad.subband.ind2chan = subband_ind;
        Rad.subband.num = length(subband_ind);
        
        % index for unique frequency
        [c,~,ind] = unique(subband_freq);
        Rad.subband.uniq_freq = c;
        Rad.subband.uniq_ind_freq2band = ind;
        Rad.subband.uniq_freq_num = length(c);
        Rad.subband.uniq_freq = c;
        
    case 'channel'
        % count channel subband w/o unique frequencies considered
        
        % index for subband
        subband_freq = [];
        subband_ind = [];
        for nchan = 1: Rad.num_chan
            M = Rad.chanfreq{nchan};
            n = length(M);
            subband_freq = [subband_freq,M];
            subband_ind = [subband_ind,nchan*ones(1,n)];
        end
        Rad.subband.mode = mode;
        Rad.subband.freq = subband_freq;
        Rad.subband.ind2chan = subband_ind;
        Rad.subband.num = length(subband_ind);
        
        % index for unique frequency
        c = subband_freq;
        ind = subband_ind;
        
        Rad.subband.uniq_freq = c;
        Rad.subband.uniq_ind_freq2band = ind;
        Rad.subband.uniq_freq_num = length(c);
        Rad.subband.uniq_freq = c;
        
    otherwise
        error(['mode is wrong: ',mode])
end

