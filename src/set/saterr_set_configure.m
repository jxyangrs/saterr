function saterr_set_configure
% configuring the on/off of a number of error sources
%   there are other settings or sources that are not a simple on/off, and they are set in specific scripts
%
% Input:
%       Turning on/off a number of error sources
% 
% Output:
%       With options turned on/off, further settings in specific scripts. 
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path CalPara

% -----------------------------
% setting
% -----------------------------
Orbit.onoff = 0;                % Orbit.attitude; 
Orbit.attitude = 0;
Noise.addnoise.onoff = 0;
Noise.shotnoise.onoff = 0;
Noise.scene_tmpdep.onoff = 0;
Rad.nonlinear.onoff = 0;
AP.crosspol.onof = 0;
Rad.crosstalk.onoff = 0;
Rad.sr.onoff = 0;
PolOffset.onoff = 0;
TimeVarying.oscillation.onoff = 0;
WarmLoad.error.onoff = 0;
Noise.PRT.onoff = 0;
MirrorCold.error.onoff = 0;
ScanBias.fovintrusion.onoff = 0;
ScanBias.interference.onoff = 0;
Faraday.onoff = 0;

% -----------------------------
% parse
% -----------------------------
saterr_parse_poloffset

