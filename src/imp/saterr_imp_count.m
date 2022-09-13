% populate counts
% 
% Output:
%       cc,cw,cs
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/13/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/23/2019: separate scripts
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: remove redundant variables

% -------------------------
% initilizing receiver basic paramaters
% -------------------------
Tr0 = Rad.Tr(nchan);
G0 = Rad.G(nchan);

% -------------------------
% cc
% -------------------------
Trcc = Tr0 + Tr_cc_ovar;
Tsys = Trcc + tac;
ind = Rad.ind_CT{2};
if Noise.addnoise.onoff==1
    noiserad = noise_ts(ind,:);
else
    noiserad = 0;
end
G1 = G0+G_cc_ovar;
cc = (Tsys+noiserad).*G1;

% -------------------------
% cw
% -------------------------
Trcw = Tr0 + Tr_cw_ovar;
Tsys = Trcw + taw;
ind = Rad.ind_CT{3};
if Noise.addnoise.onoff==1
    noiserad = noise_ts(ind,:);
else
    noiserad = 0;
end
G1 = G0+G_cw_ovar;
cw = (Tsys+noiserad).*G1;

% -------------------------
% cs
% -------------------------
ind = Rad.ind_CT{1};
if Noise.addnoise.onoff==1
    noiserad = noise_ts(ind,:);
else
    noiserad = 0;
end

if Rad.nonlinear.onoff==1
    T_nl = Rad.nonlinear.T_nl(nchan);
    Trcs = Tr0 + Tr_cs_ovar;
    
    cc1 = (Trcc + tac).*(G0+G_cc_ovar);
    cw1 = (Trcw + taw).*(G0+G_cw_ovar);
    cs1 = (Trcs + tas).*(G0+G_cw_ovar);
    tas = saterr_imp_nonlinearta(T_nl,tac,taw,cc1,cw1,cs1);
    
    Tsys = Trcs + tas;
    G1 = G0+G_cs_ovar;
    cs = (Tsys + noiserad).*G1;
else
    Trcs = Tr0 + Tr_cs_ovar;
    Tsys = Trcs + tas;
    G1 = G0+G_cs_ovar;
    cs = (Tsys + noiserad).*G1;
end

% -------------------------
% output
% -------------------------
tc_chan_out(:,:,nchan) = mean(tc,1);
tw_chan_out(:,:,nchan) = mean(tw_PRT,1);
cc_chan_out(:,:,nchan) = cc;
cw_chan_out(:,:,nchan) = cw;
cs_chan_out(:,:,nchan) = cs;

