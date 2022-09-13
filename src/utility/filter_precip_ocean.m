function idxfil = filter_precip_ocean(tb19v,tb19h,tb37v,tb37h)
% filtering precipitation over the ocean
%
% Input:
%       tb19v,      tb of 19v
%       tb19h,      tb of 19h
%       tb37v,      tb of 37v
%       tb37h,      tb of 37h
%
% Output:
%       idxfil,     logical;1=rain;0=no-rain
%
% Description:
%       Previously used for TMI
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2016: from code in 8/31/2014

% settings
n1 = size(tb19v,1);

% filter index
idxfil = true(n1,1);

% rain filters (1==non-rain, 0 == rain)
%37V-37H > 50K
idx = tb37v-tb37h>50;
idxfil = idxfil & idx;
%19v<37v
idx = tb19v<tb37v;
idxfil = idxfil & idx;
%19h<185K
idx = tb19h<185;
idxfil = idxfil & idx;
%37h<210K
idx = tb37h<210;
idxfil = idxfil & idx;

idxfil = ~idxfil;

