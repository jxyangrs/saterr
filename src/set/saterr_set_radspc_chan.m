function saterr_set_radspc_chan
% radiometer channel specification
%   channel frequency, polarization, name
% 
% Input:
%       radiometer setting of channel specification
% 
% Output:
%       Rad.chanfreq,       channel frequency (GHz) (allowing for subband), {1,channel}
%       Rad.chanpol,        channel polarization (V/H/QV/QH),          {1,channel}
%       Rad.chanstr,        channel name,                                   {1,channel}
%
% Syntax:
%       Rad.chanfreq = {[subband-1,subband-2,...],[channel 2],[channel 3],...};
%       e.g. 1, computing subbands around 183 GHz:
%         Rad.chanfreq = {89,157,[183.311-1,183.311+1],[183.311-3,183.311+3],190.311}; 
%         Rad.chanpol =  {'QV','QV','QH','QH','QV'};
%         Rad.chanstr =  {'89QV','157QV','183.311±1QH','183.311±3QH','190.311QV'}; 
%       e.g. 2, computing sub-frequency w/ 0.1 GHz bin around center frequency of 55.5 GHz:
%         Rad.chanfreq = {54,[55.5-1: 0.1: 55.5+1]}; 
%         Rad.chanpol =  {'QV','QV'}; 
%         Rad.chanstr =  {'54QV','55.5QV'}; 
% 
% Description:
%       Channels frequency and numbers can be changed and customized.
%       When making adjustment, other settings such as noise may need to change accordingly if they are turned on
% 
%       polarization
%                   V=vertical,H=horizontal,QV=quasi-v,QH=quasi-h
% 
% parse scanning
%       saterr_parse_indCT.m
% 
% parse radiometer specification
%       saterr_parse_radspc_adv.m
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: original code

global Rad

% -----------------------------
% setting
% -----------------------------
switch Rad.sensor
    
    case 'customize'
        Rad.chanfreq = {23.8,31.4,[183.311-1,183.311+1]}; % frequency (GHz)
        Rad.chanpol = {'QV','QV','QH'};
        Rad.chan_freq_nominal = {'23.8','31.4','183.311±1'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number

    case {'demo'}
        Rad.chanfreq = {23.8}; % channel frequency (GHz); support subband
        Rad.chanpol = {'QV'}; % channel polarization
        Rad.chan_freq_nominal = {'23.8'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number

    case {'amsr-e'}
%         Rad.chanfreq = {6.925,6.925,10.65,10.65,18.7,18.7,23.8,23.8,36.5,36.5,89,89}; % channel frequency (GHz); support subband
%         Rad.chanpol = {'V','H','V','H','V','H','V','H','V','H','V','H'};
%         Rad.chan_freq_nominal = {'6.925','6.925','10.65','10.65','18.7','18.7','23.8','23.8','36.5','36.5','89','89'}; % channel nominal frequency (GHz), unique name
        Rad.chanfreq = {6.925,89}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V','V'};
        Rad.chan_freq_nominal = {'6.925','89'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number

    case {'amsr2'}
        Rad.chanfreq = {6.925,[6.925],[89]}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V','H','V'};
        Rad.chan_freq_nominal = {'6.925','6.925','89'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case 'amsu-a'
        Rad.chanfreq = {23.8,31.4,50.3,52.8,53.596,54.4,54.94,55.5,57.290344,57.290344-0.217,[57.290344-0.3222-0.048],[57.290344-0.3222-0.022],[57.290344-0.3222-0.01],[57.290344-0.3222-0.0045],89}; % frequency (GHz); representative, only one sub-band number for channels w/ multiple subbands
        Rad.chanpol = {'QV','QV','QV','QV','QH','QH','QV','QH','QH','QH','QH','QH','QH','QH','QV'};
        Rad.chan_freq_nominal = {'23.8','31.4','50.3','52.8','53.596±0.115','54.4','54.94','55.50','57.29034','57.29034±0.217','57.290344±0.322±0.048','57.2904±0.322±0.022','57.29034±0.322±0.010','57.2903±0.322±0.0045','89'}; % channel nominal freuency (Gz), uniue name
        Rad.num_chan = length(Rad.chanfreq); % channel number

    case 'amsu-b'
        Rad.chanfreq = {89,150,[183.31-7,183.31+7],[183.31-3,183.31+3],[183.31-1,183.31+1]}; % frequency (GHz); representative, only one sub-band number for channels w/ multiple subbands
        Rad.chanpol = {'QV','QV','QV','QV','QV'};
        Rad.chan_freq_nominal = {'89','150','183±7','183±3','183±1'}; % channel nominal freuency (Gz), uniue name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case 'atms'
        Rad.chanfreq = {23.8,31.4,50.3,51.76,52.8,[53.596-0.115,53.596+0.115],54.40,54.94,55.50,57.290344,[57.290344-0.217,57.290344+0.217],[57.290344-0.3222-0.048,57.290344-0.3222+0.048,57.290344+0.3222-0.048,57.290344+0.3222+0.048],[57.290344-0.322-0.022,57.290344-0.322+0.022,57.290344+0.322-0.022,57.290344+0.322+0.022],[57.2903-0.322-0.010,57.2903-0.322+0.010,57.2903+0.322-0.010,57.2903+0.322+0.010],[57.2903-0.322-0.0045,57.2903-0.322+0.0045,57.2903+0.322-0.0045,57.2903+0.322+0.0045],88.20,[164.575,166.425],[183.31-7,183.31+7],[183.31-4.5,183.31+4.5],[183.31-3,183.31+3],[183.31-1.8,183.31+1.8],[183.31-1,183.31+1]}; % frequency (GHz); representative, only one sub-band number for channels w/ multiple subbands
        Rad.chanpol = {'QV','QV','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QV','QH','QH','QH','QH','QH','QH'};
        Rad.chan_freq_nominal = {'22','37','50.3','51.76','52.8','53.596±0.115','54.40','54.94','55.50','57.2903','57.2903±0.115','57.2903','57.2903±0.322','57.2903±0.322±0.010','57.2903±0.322±0.004','89','166','183±7','183±4.5','183±3','183±1.8','183±1'}; % channel nominal freuency (Gz), uniue name
        Rad.num_chan = length(Rad.chanfreq); % channel number

    case {'gmi'}
%         Rad.chanfreq = {10.65,10.65,18.7,18.7,23.8,36.64,36.64,89,89,166,166,[183.31-3,183.31+3],[183.31-7,183.31+7]}; % channel frequency (GHz); support subband
%         Rad.chanpol = {'V','H','V','H','V','V','H','V','H','V','H','V','V'};
%         Rad.chan_freq_nominal = {'10.65','10.65','18.7','18.7','23.8','36.64','36.64','89','89','166','166','183.31±3','183.31±7'}; % channel nominal frequency (GHz), unique name
        Rad.chanfreq = {10.65}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V'};
        Rad.chan_freq_nominal = {'10.65'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case 'mhs'
        Rad.chanfreq = {[89],157,[183.311-1,183.311+1],[183.311-3,183.311+3],190.311}; % channel frequency (GHz); support subband
        Rad.chanpol = {'QV','QV','QH','QH','QV'};
        Rad.chan_freq_nominal = {'89','157','183.311±1','183.311±3','190.311'}; % name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case 'mwri'
        Rad.chanfreq = {10.65,10.65,18.7,18.7,23.8,23.8,36.5,36.5,89,89}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V','H','V','H','V','H','V','H','V','H'};
        Rad.chan_freq_nominal = {'10.65V','10.65H','18.7V','18.7H','23.8V','23.8H','36.5V','36.5H','89V','89H'}; % name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case 'mwhs-2'
%         Rad.chanfreq = {89,[118.75-0.08,118.75+0.08],[118.75-0.2,118.75+0.2],[118.75-0.3,118.75+0.3],[118.75-0.8,118.75+0.8],[118.75-1.1,118.75+1.1],[118.75-2.5,118.75+2.5],[118.75-3,118.75+3],[118.75-5,118.75+5],150,[183.31-1,183.31+1],[183.31-1.8,183.31+1.8],[183.31-3,183.31+3],[183.31-4.5,183.31+4.5],[183.31-7,183.31+7]}; % channel frequency (GHz); support subband
%         Rad.chanpol = {'QH','QV','QV','QV','QV','QV','QV','QV','QV','QH','QV','QV','QV','QV','QV'};
        Rad.chanfreq = {89,[118.75-0.08,118.75+0.08],[183.31-1,183.31+1]}; % channel frequency (GHz); support subband
        Rad.chanpol = {'QH','QV','QV'};
        Rad.chan_freq_nominal = {'89','118.75±0.08','183.311±1'}; % name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case 'mwts-2'
%         Rad.chanfreq = {50.3,51.76,52.8,53.596,54.4,54.94,55.5,57.29,[57.29-0.217,57.29+0.217],[57.29-0.322-0.048,57.29-0.322+0.048,57.29+0.322-0.048,57.29+0.322+0.048],[57.29-0.322-0.022,57.29-0.322+0.022,57.29+0.322-0.022,57.29+0.322+0.022],[57.29-0.322-0.01,57.29-0.322+0.01,57.29+0.322-0.01,57.29+0.322+0.01],[57.29-0.322-0.0045,57.29-0.322+0.0045,57.29+0.322-0.0045,57.29+0.322+0.0045]}; % channel frequency (GHz); support subband
%         Rad.chanpol = {'QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH','QH'};
        Rad.chanfreq = {50.3,[57.29-0.217,57.29+0.217]}; % channel frequency (GHz); support subband
        Rad.chanpol = {'QH','QH'};
        Rad.chan_freq_nominal = {'50.3QH','57.29±0.217'}; % name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case {'smap'}
        Rad.chanfreq = {1.41,1.41}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V','H'};
        Rad.chan_freq_nominal = {'1.41','1.41'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case {'ssmi'}
        Rad.chanfreq = {19,19,22,37,37,85,85}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V','H','V','V','H','V','H'};
        Rad.chan_freq_nominal = {'19','19','22','37','37','85','85'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case {'ssmis'}
        Rad.chanfreq = {19.35,19.35,22.235,37,37,91.655,91.655,[183.31-6.6,183.31+6.6],[183.31-3,183.31+3],[183.31-1,183.31+1]}; % channel frequency (GHz); support subband
        Rad.chanpol = {'V','H','V','V','H','V','H','H','H','H'};
        Rad.chan_freq_nominal = {'19','19','22','37','37','91','91','183±6','183±3','183±1'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case {'tempest-d'}
        Rad.chanfreq = {87.1,164.1,173.8,178.4,180.8}; % channel frequency (GHz); support subband
        Rad.chanpol = {'QV','QH','QH','QH','QH'};
        Rad.chan_freq_nominal = {'87','164','173','178','180'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    case {'tms'}
        Rad.chanfreq = {[91.656-1.4,91.656+1.4],114.5,115.95,116.65,117.25,117.8,118.24,118.58,184.41,186.51,190.31,204.8}; % channel frequency (GHz); support subband
        Rad.chanpol = {'H','H','H','H','H','H','H','H','V','V','V','V'};
        Rad.chan_freq_nominal = {'91.656±1.4','114.5','115.95','116.65','117.25','117.8','118.24','118.58','184.41','186.51','190.31','204.8'}; % channel nominal frequency (GHz), unique name
        Rad.num_chan = length(Rad.chanfreq); % channel number
        
    otherwise
        error('Rad.sensor is wrong')
end


% -----------------------------
% parse
% -----------------------------
n1 = length(Rad.chanfreq);
n2 = length(Rad.chanpol);
n3 = length(Rad.chan_freq_nominal);

if sum([n2,n3]-n1)~=0
    error('Rad.chan* size mismatch')
end
