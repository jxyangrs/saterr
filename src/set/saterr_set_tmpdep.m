function saterr_set_tmpdep
% set up temperature dependent scene noise 
%
% Input:
%       setting the tempeature depenence of scene noise
% 
% Output:
%       coefficient of tempeature dependence assuming a linear model
%
% Note:
%       Regarding scene noise dependence on temperature, a simple linear model can be applied that uses cold and warm noise
%       and assumes scene noise (variance) is a linear interpolation
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/17/2019: original code

global Noise Rad

% -----------------------------
% setting
% -----------------------------
Noise.scene_tmpdep.onoff = 0; % 0=off,1=on

if Noise.scene_tmpdep.onoff==1
    M = [];
    for nchan=1: Rad.num_chan
        y1 = Noise.addnoise.STD_TBC_Sub{nchan}.^2;
        y2 = Noise.addnoise.STD_TBW_Sub{nchan}.^2;
        x1 = Rad.Tc(nchan);
        x2 = Rad.Tw(nchan);
        x3 = Rad.Ts(nchan);
        y3 = (y2-y1)/(x2-x1)*(x3-x1) + y1;
        M{nchan} = sqrt(y3);
    end
    Noise.addnoise.STD_TBS_Sub = M;
    Noise.chan_std_scene_sub = Noise.addnoise.STD_TBS_Sub;
end


