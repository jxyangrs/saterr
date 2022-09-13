function saterr_set_rad_sr
% spectral response (sr)
%
% Input:
%       setting spectral response
% 
% Output:
%       Rad.sr.sr_chan_number,      channel number of sr
%       Rad.sr.sr_freq,             frequency of sr at specific channels (GHz)
%       Rad.sr.sr_amp,              amplitude of sr (unit is power not dB)
%       
% Syntax:
%       Rad.sr.sr_chan_number = [channel number to be applied to SR,...]
%       Rad.sr.sr_freq        = {sr frequency at chan-1,...,chan-n,...}
%       Rad.sr.sr_amp         = {sr amplitude at chan-1,...,chan-n,...}
% 
% Examples:
%       Given the mhs frequency is set in saterr_set_radspc_adv.m as
%           Rad.chanfreq = {[89-1:0.2:89+2],157,[183.311-1,183.311+1],[183.311-3,183.311+3],190.311};
%       We want to set a SR for channel-1 of 89 GHz.
% 
%       example 1: set SR for channel 1 (89GHz) of mhs, where the SR is a triangle window
%           Rad.sr.sr_chan_number = [1];
%           Rad.sr.sr_freq = {[89-1: 0.1: 89+1]};
%           Rad.sr.sr_amp = {[1:11,10:-1:1]};
% 
%       example 2: use empirical/measured SR
%           data = load('sample_sr_89V');
%           Rad.sr.chan_number = 1; 
%           Rad.sr.sr_freq = {data.sr_freq};
%           Rad.sr.sr_amp = {data.sr_amp};
%
% Note:
%       Given a SR, a linear interpolation is applied to preset band frequencies. SR should cover the entire band frquencies,
%       otherwise SR will not be applied.
%               _____            _____
%         _____|     |__________|     |_____     ->   line=SR as a function of frequency
%       *        . . .     .     . . .        *  ->   dot=good, *=bad frequencies
% 
%               _____            _____
%         _____|     |          |     |_____     ->   line=SR as a function of frequency
%       *        . . .     *     . . .        *  ->   dot=good, *=bad frequencies
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code

global Rad

% -----------------------------
% setting
% -----------------------------
Rad.sr.onoff = 0; % 0=off,1=on

% cutomize spectral response if it is turned on
if Rad.sr.onoff==1
    % customize spectral response
    
    % example 1
    %Rad.sr.sr_chan_number = [1];
    %Rad.sr.sr_freq = {[89-1: 0.1: 89+1]};
    %Rad.sr.sr_amp = {ones(1,21)};
    
    % example 2
    data = load('sample_sr_89V');
    Rad.sr.chan_number = 1; % for 89V
    Rad.sr.sr_freq = {data.sr_freq};
    Rad.sr.sr_amp = {data.sr_amp};
    
    % parse
    saterr_parse_rad_sr
    
end


