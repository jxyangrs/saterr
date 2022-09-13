function saterr_parse_rad_sr
% parse spectral response
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code
global Rad


% index for subband
n1 = length(Rad.sr.chan_number);
n2 = length(Rad.sr.sr_freq);
n3 = length(Rad.sr.sr_amp);

if sum([n2,n3]-n1)~=0
    error('Spectral response does not match: Rad.sr.*')
end




