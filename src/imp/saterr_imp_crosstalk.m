% crosstalk correlation
%   crosstalk can take place across frequencies and can be described by covariance matrix
%   This is different from cross-pol contamination, where the later occurs for the same frequency but cross-polariation
% 
% Input:
%   uncorrelated counts
%       cc_chan_out,       cold-space count,    [cross-track,along-track,channel]
%       cw_chan_out,       warm-load count,     [cross-track,along-track,channel]
%       cs_chan_out,       scene count,         [cross-track,along-track,channel]
% 
% Output:
%   correlated counts
%       cc_chan_out,       cold-space count,    [cross-track,along-track,channel]
%       cw_chan_out,       warm-load count,     [cross-track,along-track,channel]
%       cs_chan_out,       scene count,         [cross-track,along-track,channel]
% 
% Descriptions:
%       The implementation of crosstalk correlation is dependent on the physical interpresentation
%       Two schemes are provided as in saterr_set_crosstalk.m
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/13/2018: original code

global Rad 

if Rad.crosstalk.onoff==1
    X = Rad.crosstalk.X;
    refl = Rad.crosstalk.refl;

    % implementing
    [n1,n2,n3] = size(cc_chan_out);
    cc_chan_out = reshape(cc_chan_out,[n1*n2,n3]);
    cc_chan_out = cc_chan_out*X*refl + cc_chan_out*(1-refl);
    cc_chan_out = reshape(cc_chan_out,[n1,n2,n3]);
    
    [n1,n2,n3] = size(cw_chan_out);
    cw_chan_out = reshape(cw_chan_out,[n1*n2,n3]);
    cw_chan_out = cw_chan_out*X*refl + cw_chan_out*(1-refl);
    cw_chan_out = reshape(cw_chan_out,[n1,n2,n3]);
    
    [n1,n2,n3] = size(cs_chan_out);
    cs_chan_out = reshape(cs_chan_out,[n1*n2,n3]);
    cs_chan_out = cs_chan_out*X*refl + cs_chan_out*(1-refl);
    cs_chan_out = reshape(cs_chan_out,[n1,n2,n3]);
end

