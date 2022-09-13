function radspc = rad_spc_set(rad)
% table of radiometer specifications
%
% Input:
%       rad,        radiometer name
%
% Output:
%       radspc,     radiometer specifications
% 
% Examples:
%       radspc = rad_spc_set('mhs');
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/05/2019: original code

switch rad

    case 'amsr2'
        radspc.rad = 'amsr2';
        radspc.scantype = 'conical';
        radspc.chanfreq = {6.925,6.925,7.3,7.3,10.65,10.65,18.7,18.7,23.8,23.8,36.5,36.5,89,89,89,89}; % channel frequency (can have sub-channels)
        radspc.chan_freq_nominal = {'6.9','6.9','7.3','7.3','10.7','10.7','18.7','18.7','23.8','23.8','36.5','36.5','89','89','89','89'}; % channel string frequency
        radspc.chanpol = {'V','H','V','H','V','H','V','H','V','H','V','H','V','H','V','H'}; % channels polarization: V=vertical,H=horizontal,P=+45,M=-45,L=left circular,R=right circular,QV=quasi vertical,QH=quasi horizontal
        radspc.chanstr = strcat(radspc.chan_freq_nominal,radspc.chanpol); % channel string name
        radspc.numchan = 16; % No. of channels
        radspc.chanind = 1:radspc.numchan;
        radspc.num_crosstrack = 243; % No. of cross-track scans
       
    case 'amsu-a'
        % NOAA KLM User's Guide, Section 3.9
        radspc.rad = 'amsu-a';
        radspc.scantype = 'crosstrack';
        radspc.chanfreq = {23.8,31.4,50.3,52.8,[53.596-0.115,53.596+0.115],54.4,54.94,55.5,57.290344,[57.290344-0.217,57.290344+0.217],[57.290344-0.3222-0.048,57.290344-0.3222+0.048,57.290344+0.3222-0.048,57.290344+0.3222+0.048],[57.290344-0.3222-0.022,57.290344-0.3222+0.022,57.290344+0.3222-0.022,57.290344+0.3222+0.022],[57.290344-0.3222-0.01,57.290344-0.3222+0.01,57.290344+0.3222-0.01,57.290344+0.3222+0.01],[57.290344-0.3222-0.0045,57.290344-0.3222+0.0045,57.290344+0.3222-0.0045,57.290344+0.3222+0.0045],89}; % channel frequency (can have sub-channels)
        radspc.chan_freq_nominal = {'23.8','31.4','50.3','52.8','53.59','54.4','54.94','55.5','57.29','57.29±0.32±0.22','57.29±0.32±0.0048','57.29±0.32±0.02','57.29±0.32±0.01','57.29±0.32±0.0045','89'}; % channel string frequency
        radspc.chanpol = {'QV','QV','QV','QV','QH','QH','QV','QH','QH','QH','QH','QH','QH','QH','QV'}; % channels polarization: V=vertical,H=horizontal,P=+45,M=-45,L=left circular,R=right circular,QV=quasi vertical,QH=quasi horizontal
        radspc.chanstr = strcat(radspc.chan_freq_nominal,radspc.chanpol); % channel string name
        radspc.numchan = 15; % No. of channels
        radspc.chanind = 1:radspc.numchan;
        radspc.num_crosstrack = 30; % No. of cross-track scans
        
    case 'mhs'
        % NOAA KLM User's Guide, Section 3.9
        radspc.rad = 'mhs';
        radspc.scantype = 'cross-track';
        radspc.chanfreq = {89.0,157.0,[183.311-1,183.311+1],[183.311-3,183.311+3],190.311}; % channel frequency (can have sub-channels)
        radspc.chan_freq_nominal = {'89','157','183.31±1','183.31±3','190.31'}; % channel names
        radspc.chanpol = {'QV','QV','QH','QH','QV'}; % channels polarization: V=vertical,H=horizontal,P=+45,M=-45,L=left circular,R=right circular,QV=quasi vertical,QH=quasi horizontal
        radspc.chanstr = strcat(radspc.chan_freq_nominal,radspc.chanpol); % channel string name
        radspc.numchan = 5; % No. of channels
        radspc.chanind = 1:radspc.numchan;
        radspc.num_crosstrack = 90; % No. of cross-track scans

    otherwise
        error(['No such radiometer: ', Rad])
end

% % special symbol
% radspc.chanstr=strrep(radspc.chanstr,'±',char(177));
% radspc.chanstruni=strrep(radspc.chanstruni,'±',char(177));
% radspc.chanstrdecimal=strrep(radspc.chanstrdecimal,'±',char(177));
% radspc.chanstr=strrep(radspc.chanstr,'±',char(177));
% radspc.chanstruni=strrep(radspc.chanstruni,'±',char(177));
% radspc.chanstrdecimal=strrep(radspc.chanstrdecimal,'±',char(177));
