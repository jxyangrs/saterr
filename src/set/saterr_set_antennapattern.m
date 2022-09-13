function saterr_set_antennapattern
% set far-field antenna pattern for mainlobe, sidelobe, spillover
% near-field effect such as reflector emission is set in saterr_set_reflcemiss.m
%
% Input:
%       setting antenna pattern
% 
% Output:
%       AP.frac.mainlobe,       mainlobe fraction,      [pp/pq/3/4,crosstrack,alongtrack,channel]
%       AP.frac.sidelobe,       sidelobe fraction,      [pp/pq/3/4,crosstrack,alongtrack,channel]
%       AP.frac.spillover,      spillover fraction,     [pp/pq/3/4,crosstrack,alongtrack,channel]
%       pp=col-pol, pq=cross-pol
%
% Description:
%       summation of antenna pattern subfraction equals 1
%           mainlobe + sidelobe + spillover = 1
%       If you have a measured antenna pattern, you can do the integration to get fractions of mainlobe, sidelobe and spillover
%       The sidelobe refers to the Earth sidelobe.
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/06/2019: add customize option
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes

global AP Rad 
% -----------------------------
% setting
% -----------------------------
AP.onoff = 0; % 0=default setting,1=customize

if AP.onoff==1 
    % -------------------------
    % fraction of mainlobe, sidelobe, spillover for co-pol (pp) and cross-pol (pq)
    %   mainlobe+sidelobe+spillover = 1
    %   dimension:
    %   [1,channel]/[crosstrack,along-track,channel]
    % -------------------------

    % col-pol (pp) antenna pattern
    pp_frac_mainlobe = 0.95*ones(1,Rad.num_chan); % mainlobe
    pp_frac_sidelobe = 0.03*ones(1,Rad.num_chan); % sidelobe
    pp_frac_spillover = 0.02*ones(1,Rad.num_chan); % spillover
    
    % cross-pol (pq) antenna pattern
    pq_frac_mainlobe = 0.95*ones(1,Rad.num_chan); % mainlobe
    pq_frac_sidelobe = 0.03*ones(1,Rad.num_chan); % sidelobe
    pq_frac_spillover = 0.02*ones(1,Rad.num_chan); % spillover
    
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_antennapattern
