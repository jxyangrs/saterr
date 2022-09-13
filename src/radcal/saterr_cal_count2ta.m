% calibration for scene 
% 
% Input:
%       simulation count etc
%
% Output:
%       --calibrated ta of scene, warm-load, cold-space
%       tas,            scene ta,                   [crosstrack,alongtrack,channel]       
%       tas_noise,      scene ta noise,             [crosstrack,alongtrack,channel]       
%       taw,            warm-load ta,               [crosstrack,alongtrack,channel]       
%       taw_noise,      warm-load ta noise,         [crosstrack,alongtrack,channel]       
%       tac,            cold-space ta,              [crosstrack,alongtrack,channel]       
%       tac_noise,      cold-space ta noise,        [crosstrack,alongtrack,channel]       
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

% -------------------------
% calibration
% -------------------------
switch Rad.scantype
    
    case 'conical'
        tc = saterr_cal_conic_mirrorcold(tc);
        
        tw = saterr_cal_warmloaderror(tw);
        
        saterr_cal_2point
        
    case 'crosstrack'
        tw = saterr_cal_warmloaderror(tw);

        saterr_cal_2point
        
    otherwise
        error('Rad.scantype is wrong')

end


