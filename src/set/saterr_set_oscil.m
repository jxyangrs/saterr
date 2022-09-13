function saterr_set_oscil
% setting for radiometer state oscillation due to orbit oscillation
%   abrupt jump such as gain can also be taken as a speical oscillation with specfic pulse functions
%
% Input:
%         warm-load variation
%         gain variation
%         receiver temperature variation
%
%         0=turn off variation,
%         1=variation in forms of waveform
%         2=customize w/ empirical or external source
%
% Output:
%         TimeVarying.oscillation.
%
% Description:
%         E.g. a waveform can be: amp*sin(w*t+phase) + dc, where w=2*pi*num_period
%         amplitude < min(tw), otherwise zero comes out for gain
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: rename and add customization
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: split demo, cust, sensor

global Rad TimeVarying

% -----------------------------
% setting
% -----------------------------
TimeVarying.oscillation.onoff = 0; % 0=off,1=on

if TimeVarying.oscillation.onoff==1
    switch Rad.sensor
        case {'demo'}
            saterr_set_oscil_sub_demo
            
        case {'customize'}
            saterr_set_oscil_sub_cust
            
        otherwise
            % other sensors
            saterr_set_oscil_sub_sensor
            
    end
end
