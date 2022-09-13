function saterr_set_conic_mirrorcold
% setting cold-space mirror for conical scanning radiometers
% The cold-space mirror, separated from the main reflector, can have error due to emission
%
% Input:
%       setting
%
% Output:
%       MirrorCold.error.slope,       slope error,           [1,channel]
%       MirrorCold.error.bias,        intercept error(K),    [1,channel]
%
% Descriptions:
%       The error is
%               Tac' = Tac*slope + intercept
%       e.g., a model can be
%               Tac' = Tac*alpha + Tmirror*(1-alpha)
%       where Tac is cosmic temperature, Tmirror is mirror temperature
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global MirrorCold Rad

% -----------------------------
% setting
% -----------------------------
switch Rad.scantype
    case 'conical'
        MirrorCold.error.onoff = 0; % 0=off,1=on
        
        if MirrorCold.error.onoff==1
            
            MirrorCold.error.slope = 0.98*ones(1,Rad.num_chan);        % slope, [1,channel]
            MirrorCold.error.intercept = 1*ones(1,Rad.num_chan);       % intercept, [1,channel]
            
        end
        
        % -----------------------------
        % parse
        % -----------------------------
        saterr_parse_conic_mirrorcold
    case 'crosstrack'
        MirrorCold.error.onoff = 0; % 0=off,1=on
end
