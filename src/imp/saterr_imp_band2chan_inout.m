function Tas_out = saterr_imp_band2chan_inout(Tas_in)
% channel Stokes (unique frequency to channel) w/ spectral response applied if any
%   explicit arguments in/out
%
% Input:
%       Tas_in,         TB Stokes of subband,       [Stokes(V,H,3,4),crosstrack,alongtrack,uniq-frequency]
%       Rad.subband.*,  subband information
%       Rad.sr.*        spectral response      
% 
% Output:
%       Tas_out,        TB Stokes of channel,       [Stokes(V,H,3,4),crosstrack,alongtrack,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global Rad

Tas_out = [];

for nchan=1: Rad.num_chan
    idx = Rad.subband.ind2chan==nchan;
    ind = Rad.subband.uniq_ind_freq2band(idx);
    
    Tas1 = Tas_in(:,:,:,ind);
    
    % apply spectral response if it is turned on
    if Rad.sr.onoff==1
        if ~isempty(find(nchan==Rad.sr.chan_number,1))
            Tas1 = saterr_imp_sr(Tas1,nchan);
        end
    end
    
    % average w/ boxcar window
    if length(ind)>1 
        Tas1 = mean(Tas1,4);
    end
    
    % output
    Tas_out(:,:,:,nchan) = Tas1;
    
end
