function tb = saterr_cal_conic_xpol(ta)
% correcting for cross-pol contamination for conical scanning radiometer
%
% Input:
%       ta,         antenna temperature,         [crosstrack,alongtrack,channel]
%                   (w/ spillover corrected)
%       CalPara.
%
% Output:
%       tb,         brightness tempereture,      [crosstrack,alongtrack,channel]
%
% Description:
%     Antenna temperature with cross-pol contamination is
%       Ta_v = (1-a_vh)Tb_v + a_vh*Tb_h;
%       Ta_h = (1-a_hv)Tb_h + a_hv*Tb_v;
%     Given a_vv=1-a_vh, a_hh=1-a_hv, there is
%       Ta_v = a_vv*Tb_v + a_hv*Tb_h;
%       Ta_h = a_hh*Tb_h + a_vh*Tb_v;
%     It is rewritten as
%       [Ta_v  = [a_vv,a_vh  * [Tb_v
%        Ta_h]    a_hv,a_hh]    Tb_h],
%     Define M and Ta
%       M=[a_vv,a_vh     Ta=[Ta_v   Tb=[Tb_v
%          a_hv,a_hh]  ,     Ta_h]      Tb_h]
%     There is
%       Ta = M*Tb
%     The solution is
%       Tb = inv(M)*Ta
%     Alternatively, the solution can be written as
%       Tb_v = ((1-a_hv)Ta_v - a_vh*Ta_h)/(1-a_vh-a_hv);
%       Tb_h = ((1-a_vh)Ta_h - a_hv*Ta_v)/(1-a_vh-a_hv);
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara Rad

if CalPara.crosspol.onoff
    M = CalPara.crosspol.X;
    
    if size(M,3)==1
        iM = inv(M);
        iM = iM(:,:,ones(Rad.num_chan,1));
    elseif size(M,3)==Rad.num_chan
        for nchan=1: Rad.num_chan
            iM(:,:,nchan) = inv(M(:,:,nchan));
        end
    else
        error('size of CalPara.crosspol.X is wrong')
    end
    
    
    [n1,n2,n3] = size(ta);
    tb = zeros(n1,n2,n3);
    for nchan = 1: Rad.num_chan
        ta1 = zeros(4,n1,n2); % [Stokes,crosstrack,alongtrack]
        
        % V
        ind1 = strcmp(Rad.chan_freq_nominal,Rad.chan_freq_nominal(nchan));
        ind2 = strcmp(Rad.chanpol,'V');
        ind = ind1 & ind2;
        if sum(ind)>0
            ta1(1,:,:) = ta(:,:,ind);
        end
        % H
        ind1 = strcmp(Rad.chan_freq_nominal,Rad.chan_freq_nominal(nchan));
        ind2 = strcmp(Rad.chanpol,'H');
        ind = ind1 & ind2;
        if sum(ind)>0
            ta1(2,:,:) = ta(:,:,ind);
        end
        % 3
        ind1 = strcmp(Rad.chan_freq_nominal,Rad.chan_freq_nominal(nchan));
        ind2 = strcmp(Rad.chanpol,'3');
        ind = ind1 & ind2;
        if sum(ind)>0
            ta1(3,:,:) = ta(:,:,ind);
        end
        % 4
        ind1 = strcmp(Rad.chan_freq_nominal,Rad.chan_freq_nominal(nchan));
        ind2 = strcmp(Rad.chanpol,'4');
        ind = ind1 & ind2;
        if sum(ind)>0
            ta1(4,:,:) = ta(:,:,ind);
        end
        
        % correction
        iM1 = iM(:,:,nchan);
        tb1 = mtimes_2d3d(iM1,ta1);
        
        ind = Rad.chanpol_ind(nchan);
        tb(:,:,nchan) = tb1(ind,:,:);
    end
    
    
else
    tb = ta;
end

return

