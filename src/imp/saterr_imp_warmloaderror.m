function Taw = saterr_imp_warmloaderror(Taw)
% implementing warm-load error
% warm-load error can be due to non-ideal blakbody w/ errorivity less than 1, temperature gradient not captured by PRT, solar
% intrusion induced temperature gradient.
%    
% Input:
%       setting warmload error
%
% Output:
%       WarmLoad.error.slope,            slope error,           [1,channel]
%       WarmLoad.error.intercept,        intercept (K),         [1,channel]
%
% Descriptions:
%       The error is 
%               Tw2 = Tw1*slope + bias
%       Tw2 is the actual warm-load temperature seen by the receiver, Tw1 is PRT measurement 
% 
% Examples:
%       WarmLoad.error.slope = 0.98*ones(1,Rad.num_chan);     % 0.98 slope for emissivity
%       WarmLoad.error.intercept = -1*ones(1,Rad.num_chan);    % -1 K bias, i.e., warm-load temperature is underestimated
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global WarmLoad VarDynamic

nchan = VarDynamic.nchan;

if WarmLoad.error.onoff==1
    
    Taw(1,:,:) = Taw(1,:,:)*WarmLoad.error.slope(nchan) + WarmLoad.error.intercept(nchan);
    
    Taw(2,:,:) = Taw(2,:,:)*WarmLoad.error.slope(nchan) + WarmLoad.error.intercept(nchan);
    
end