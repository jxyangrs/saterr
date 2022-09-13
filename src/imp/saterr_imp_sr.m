function ta = saterr_imp_sr(ta,nchan)
% implementing spectral response
%
% Input:
%       ta,         TA w/o spectral response,               [4,crosstrack,alongtrack,uniq-frequency]
%       Rad.sr.*,   spectral response
% 
% Output:
%       ta,         TA weighted by spectral response,       [4,crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code

global Rad

% -----------------------------
% apply spectral response
% -----------------------------
[n1,n2,n3,n4] = size(ta);

if n4>1
    % spectral response function
    ind = find(Rad.sr.chan_number==nchan);
    sr_freq = Rad.sr.sr_freq{ind};
    sr_amp = Rad.sr.sr_amp{ind};
    sr_freq = double(sr_freq);
    sr_amp = double(sr_amp);
    
    % channel sub-frequencies
    idx = Rad.subband.ind2chan==nchan;
    ind = Rad.subband.uniq_ind_freq2band(idx);
    freq = Rad.subband.uniq_freq(ind);
    
    % interpolate
    amp = interp1(sr_freq,sr_amp,freq);
    
    if sum(isnan(amp))>0
        warning('Frequency out of bound in spectral response')
        amp = ones(size(amp)); % use boxcar in case of NaN
    end
    
    % weighted by spectral response
    w(1,1,1,:) = amp/sum(amp);
    ta = sum(ta.*w,4);
end



