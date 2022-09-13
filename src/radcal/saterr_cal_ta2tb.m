% calibration for converting TA to TB
%
% Input:
%       tas,            scene antenna temperature
%
% Output:
%       tbs,            scene brightness temperature,                   [crosstrack,alongtrack,channel]
%
% Description:
%       A typical calibration sequence with APC is applied. It can be reordered in accomdance with sensor specifics and circumstance
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

% -------------------------
% processing calibration
% -------------------------
tas0 = tas;
switch Rad.scantype
    
    case 'conical'
        
        % instrument inference
        tas = saterr_cal_interference(tas);
        
        % edge-of-scan intrusion correction
        tas = saterr_cal_conic_fovintrusion(tas);
        
        % spillover correction
        tas = saterr_cal_spillover(tas);
        
        % reflector emission correction
        tas = saterr_cal_conic_refl_main(tas);
        
        % cross-pol contamination correction
        tas = saterr_cal_conic_xpol(tas);
        
        % crosstalk correction
        tas = saterr_cal_crosstalk(tas);
        
        % Faraday rotation correction
        tas = saterr_cal_conic_faraday(tas);
        
    case 'crosstrack'
        % reflector emission correction
        [tac,taw,tas] = saterr_cal_ct_refl_main(tc,tw,tas,cs,cc,cw);
        
        % instrument inference
        tas = saterr_cal_interference(tas);
        
        % edge-of-scan intrusion correction
        tas = saterr_cal_conic_fovintrusion(tas);
        
        % spillover correction
        tas = saterr_cal_spillover(tas);
        
        % cross-pol contamination correction
        tas = saterr_cal_ct_xpol(tas);
        
        % crosstalk correction
        tas = saterr_cal_crosstalk(tas);
end

tbs = tas;
tas = tas0;
clear tas0

