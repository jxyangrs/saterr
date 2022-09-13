% parse far-field antenna pattern for mainlobe, sidelobe, spillover
% near-field emission such as reflector emission is not set here, but in saterr_set_reflemis.m
% For Stokes 3,4, the fraction of AP is assumed to be the average of pp,pq, unless it is specifically set up
%
% Output:
%       AP.frac.mainlobe,       mainlobe fraction,      [pp/pq/3/4,crosstrack,alongtrack,channel]
%       AP.frac.sidelobe,       sidelobe fraction,      [pp/pq/3/4,crosstrack,alongtrack,channel]
%       AP.frac.spillover,      spillover fraction,     [pp/pq/3/4,crosstrack,alongtrack,channel]
%       pp=col-pol, pq=cross-pol
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/06/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes and reformat syntax

if AP.onoff==0
    % -------------------------
    % default setting
    % -------------------------
    AP.frac.mainlobe = 1*ones(4,1,1,Rad.num_chan); % [1,channel]/[crosstrack,along-track,channel], range [0,1]
    AP.frac.sidelobe = 0*ones(4,1,1,Rad.num_chan); % [1,channel]/[crosstrack,along-track,channel], range [0,1]
    AP.frac.spillover = 0*ones(4,1,1,Rad.num_chan); % [1,channel]/[crosstrack,along-track,channel], range [0,1]
    
else
    % -----------------------------
    % format
    % -----------------------------
    % check size
    n1 = size(pp_frac_mainlobe);
    n2 = size(pp_frac_sidelobe);
    n3 = size(pp_frac_spillover);
    n4 = size(pq_frac_mainlobe);
    n5 = size(pq_frac_sidelobe);
    n6 = size(pq_frac_spillover);
    
    s = bsxfun(@minus, n1, [n2;n3;n4;n5;n6]);
    if sum(abs(s(:)))~=0
        error('inconsistent size: frac of mainlobe, sidlobe, spillover')
    end
    
    % check summation
    M = pp_frac_mainlobe + pp_frac_sidelobe + pp_frac_spillover;
    if sum(abs(M(:)-1))~=0
        warning('sum of antenna pattern fraction ~= 1; normalized')
        if find(M==0,1)
            error('sum of antenna pattern fraction == 0')
        end
        
        pp_frac_mainlobe = pp_frac_mainlobe./M;
        pp_frac_sidelobe = pp_frac_sidelobe./M;
        pp_frac_spillover = pp_frac_spillover./M;
    end
    
    M = pq_frac_mainlobe + pq_frac_sidelobe + pq_frac_spillover;
    if sum(abs(M(:)-1))~=0
        warning('sum of antenna pattern fraction ~= 1; normalized')
        if find(M==0,1)
            error('sum of antenna pattern fraction == 0')
        end
        
        pq_frac_mainlobe = pq_frac_mainlobe./M;
        pq_frac_sidelobe = pq_frac_sidelobe./M;
        pq_frac_spillover = pq_frac_spillover./M;
    end
    
    % format
    if isequal(n1,[1,Rad.num_chan])
        m=[];m(1:2,:) = [pp_frac_mainlobe;pq_frac_mainlobe];m(3:4,:)=repmat(mean(m),[2,1]);
        AP.frac.mainlobe = permute(m,[1,3,4,2]); 
        
        m=[];m(1:2,:) = [pp_frac_sidelobe;pq_frac_sidelobe];m(3:4,:)=repmat(mean(m),[2,1]);
        AP.frac.sidelobe = permute(m,[1,3,4,2]);
        
        m=[];m(1:2,:) = [pp_frac_spillover;pq_frac_spillover];m(3:4,:)=repmat(mean(m),[2,1]);
        AP.frac.spillover = permute(m,[1,3,4,2]); 
        
    elseif isequal(n1,[Rad.ind_CT_num(1),Rad.num_alongtrack,Rad.num_chan])
        m1=permute(pp_frac_mainlobe,[4,1,2,3]);m2=permute(pq_frac_mainlobe,[4,1,2,3]);
        m=[];m(1:2,:,:,:)=[m1;m2];m(3:4,:,:,:)=repmat(mean(m,1),[2,1,1,1]);
        AP.frac.mainlobe = m;
        
        m1=permute(pp_frac_sidelobe,[4,1,2,3]);m2=permute(pq_frac_sidelobe,[4,1,2,3]);
        m=[];m(1:2,:,:,:)=[m1;m2];m(3:4,:,:,:)=repmat(mean(m,1),[2,1,1,1]);
        AP.frac.sidelobe = m; 
        
        m1=permute(pp_frac_spillover,[4,1,2,3]);m2=permute(pq_frac_spillover,[4,1,2,3]);
        m=[];m(1:2,:,:,:)=[m1;m2];m(3:4,:,:,:)=repmat(mean(m,1),[2,1,1,1]);
        AP.frac.spillover = m; 
        
    else
        error('size error in frac of mainlobe, sidlobe, spillover')
    end
    
end