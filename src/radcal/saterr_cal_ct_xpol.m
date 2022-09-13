function tb = saterr_cal_ct_xpol(ta)
% correcting for cross-pol contamination of crosstrack scanning radiometers
%
% Input:
%       ta,         antenna temperature,         [crosstrack,alongtrack,channel]
%                   (w/ spillover corrected)
%       CalPara.
%
% Output:
%       tb,         brightness tempereture,      [crosstrack,alongtrack,channel]
%
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
        
        % QV
        ind1 = strcmp(Rad.chan_freq_nominal,Rad.chan_freq_nominal(nchan));
        ind2 = strcmp(Rad.chanpol,'QV');
        ind = ind1 & ind2;
        if sum(ind)>0
            s_qv = 1;
            ta_qv1 = ta(:,:,ind);
        else
            s_qv = 0;
        end
        
        % QH
        ind1 = strcmp(Rad.chan_freq_nominal,Rad.chan_freq_nominal(nchan));
        ind2 = strcmp(Rad.chanpol,'QH');
        ind = ind1 & ind2;
        if sum(ind)>0
            s_qh = 1;
            ta_qv1 = ta(:,:,ind);
        else
            s_qh = 0;
        end
        
        % complement missing QV or QH from empirical calibration
        if s_qv==1 && s_qh==0 % missing QH
            switch CalPara.crosspol.scheme
                case 'same'
                    ta_qh1 = ta_qv1;
                case 'linear'
                    ta_qh1 = ta_qv1*CalPara.crosspol.coeff(1,nchan) + ta_qv1*CalPara.crosspol.coeff(2,nchan);
                case 'empirical'
                    ta_qh1 = CalPara.crosspol.tb(:,:,nchan);
            end
            
        elseif s_qv==0 && s_qh==1 % missing QV
            switch CalPara.crosspol.scheme
                case 'same'
                    ta_qv1 = ta_qh1;
                case 'linear'
                    ta_qv1 = ta_qh1*CalPara.crosspol.coeff(1,nchan) + ta_qh1*CalPara.crosspol.coeff(2,nchan);
                case 'empirical'
                    ta_qv1 = CalPara.crosspol.tb(:,:,nchan);
            end
        end
        
        ta1(1,:,:) = ta_qv1;
        ta1(2,:,:) = ta_qh1;
        
        % correction
        iM1 = iM(:,:,nchan);
        tb1 = mtimes_2d3d(iM1,ta1);
        
        ind = Rad.chanpol_ind(nchan);
        tb(:,:,nchan) = tb1(ind,:,:);
    end
    
else
    tb = ta;
end


