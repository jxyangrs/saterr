function saterr_set_attitudeoffset
% setting spacecraft attitude
%
% Input:
%       setting attitude
% 
% Output:
%       roll,       roll (degree),          scalar/[1,alongtrack]/[crosstrack,alongtrack]
%       pitch,      pitch (degree),         scalar/[1,alongtrack]/[crosstrack,alongtrack]
%       yaw,        yaw (degree),           scalar/[1,alongtrack]/[crosstrack,alongtrack]
% 
% Examples:
%    1) constant (size scalar)
%         roll = 1;
%         pitch = -1;
%         yaw = 1;
%    2) alongtrack oscillation (size [1,alongtrack])
%         n1 = Rad.ind_CT_num(1);
%         n2 = Rad.num_alongtrack;
%         roll = sin(2*pi/n2*(1:n2));
%         pitch = sin(2*pi/n2*(1:n2));
%         yaw = sin(2*pi/n2*(1:n2));
%    3) cross-along track oscillation (size [crosstrack,alongtrack])
%         n1 = Rad.ind_CT_num(1);
%         n2 = Rad.num_alongtrack;
%         roll = reshape(sin(2*pi/n2/n1*(1:n1*n2)),[n1,n2]);
%         pitch = reshape(sin(2*pi/n2/n1*(1:n1*n2)),[n1,n2]);
%         yaw = reshape(sin(2*pi/n2/n1*(1:n1*n2)),[n1,n2]);
%
% Description:
%       When scheme-B is performed, attitudes are fit to granuel observational data 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/04/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: flexible size input

global Rad Orbit

% -----------------------------
% setting
% -----------------------------
Orbit.attitude.onoff = 0; % 0=off,1=on

if Orbit.onoff==1 % attitude setting is only effective when orbit setting is on
    % -----------------------------
    % setting
    % -----------------------------
    
    % attitude angle (degree), 0=no offset; size: scalar/[1,alongtrack]/[crosstrack,alongtrack]
    if Orbit.attitude.onoff==1
        roll = 1;
        pitch = 1;
        yaw = 1;
        
    end
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_attitudeoffset
end
