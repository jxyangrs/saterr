% setting and loading simulation data
% Input:
%       simulation output
%
% Output:
%       tc,             cold-space temperature,     [crosstrack,alongtrack,channel]       
%       tw,             warm-load temperature,      [crosstrack,alongtrack,channel]
%       cc,             cold-space count,           [crosstrack,alongtrack,channel]
%       cw,             warm-load count,            [crosstrack,alongtrack,channel]
%       cs,             scene count,                [crosstrack,alongtrack,channel]
%       Rad.*,          radiometer setting
%       Noise.*,        noise 
%       WarmLoad.*,     warm-load 
%       Reflector.*,    reflector angle & emission
%       ScanBias.*,     scan bias 
%       TimeVarying.*,  oscillation
%       TBsrc.*,        tb source
%       AP.*,           antenna pattern
%       Orbit.*,        orbit and geo
%       PolOffset.*,    pol misalignment
%       Faraday.*,      Faraday
%       Path.*,         Path setting
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code


% -----------------------------
% load data
% -----------------------------
% loading

load([inpath,'/',infile]);

% -----------------------------
% pre-processing
% -----------------------------
% count
tc = double(tc);
tw = double(tw);
cs = double(cs);
cc = double(cc);
cw = double(cw);


