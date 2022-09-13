% filtering for intercalibration single difference
% 
% follow-on outer-loop processing is needed

% =======================================================
%% setting
% =======================================================

% ---------------------------
% single difference
% ---------------------------
tar_tb_sd = tar_tb_obs - tar_tb_sim;

% ---------------------------
% tentative code
% ---------------------------
tar_tb_obs = tar_tb_obs(:,:,1:num_chan);
tar_tb_sim = tar_tb_sim(:,:,1:num_chan);
tar_tb_sd = tar_tb_sd(:,:,1:num_chan);
tar_eia = tar_eia(:,:,1:num_chan);
tar_azm = tar_azm(:,:,1:num_chan);


% =======================================================
%% filtering
% =======================================================

% index of ascending/descending
[tar_idx_asc,~] = idx_orbit_ascdes(tar_lat(round(end/2),:));

% reshape to [geo,channel]
[n1,n2,n3] = size(tar_tb_sim);
tar_tb_sim = reshape(tar_tb_sim,[n1*n2,n3]);
tar_tb_obs = reshape(tar_tb_obs,[n1*n2,n3]);
tar_tb_sd = reshape(tar_tb_sd,[n1*n2,n3]);
tar_eia = reshape(tar_eia,[n1*n2,n3]);
tar_lat = reshape(tar_lat,[n1*n2,1]);
tar_lon = reshape(tar_lon,[n1*n2,1]);
tar_time = reshape(tar_time,[n1*n2,1]);
tar_azm = reshape(tar_azm,[n1*n2,n3]);
tar_scanpos = reshape(tar_scanpos,[n1*n2,1]);
tar_scanangle = reshape(tar_scanangle,[n1*n2,1]);
tar_qual = tar_qual(:);

tar_idx_asc = repmat(tar_idx_asc(:)',[n1,1]);tar_idx_asc=tar_idx_asc(:);


% filter of latitude range
if 1
    n = size(tar_lat);
    idxfil = false(n(1),1); % 1=bad,0=good
    idx = abs(tar_lat)>90;
    idxfil = idxfil | idx;
    % apply filter
    [tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc);
end
% filter of quality flag
if 1
    idxfil = tar_qual; % 1=bad,0=good
    
    [tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc);
end
% land filter
if FilterCal.landfilter.onoff
    idxfil = filter_landmask(tar_lat,mod(tar_lon,360),LatMask,LonMask,LandMask);
    [tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc);
end
% filter of obs-sim
if FilterCal.tar_tb_sd.onoff
    idxfil = tar_tb_sd<FilterCal.tar_tb_sd.range(1) | FilterCal.tar_tb_sd.range(2)<tar_tb_sd;
    idxfil = sum(idxfil,2)>0;
    
    [tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc);
end

% filter with n-sigma
if FilterCal.sigma.tar_tb_sd.onoff
    sigma1 = std(tar_tb_sd,0,1);
    n = FilterCal.sigma.tar_tb_sd.n;
    d = (abs(tar_tb_sd) - n*sigma1) >0;
    
    idxfil = sum(d,2)>0;
    
    [tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_sim,tar_tb_obs,tar_tb_sd,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc);
end


% =======================================================
%% going through days
% =======================================================
for iorbitnode=1: NumOrbitNode % [dir]
    switch iorbitnode % index
        case 1
            idx_node = true(size(tar_idx_asc,1),1);
        case 2
            idx_node = idata.mtasc;
        case 3
            idx_node = ~idata.mtasc;
    end
    if sum(idx_node)<=2
        continue;
    end
    tar_tb_sd = tar_tb_obs-tar_tb_sim;
    
    % ---------------------------
    % basics
    % ---------------------------
    % histogram
    hist1_tar_tb_sd(:,:,iorbitnode) = hist1_tar_tb_sd(:,:,iorbitnode)+histc(tar_tb_sd,Stat.BinTBSD,1);
    hist1_tar_tb_obs(:,:,iorbitnode) = hist1_tar_tb_obs(:,:,iorbitnode)+histc(tar_tb_obs,Stat.BinTB,1);
    hist1_tar_tb_sim(:,:,iorbitnode) = hist1_tar_tb_sim(:,:,iorbitnode)+histc(tar_tb_sim,Stat.BinTB,1);
    
    % daily
    day_num(:,iday,iorbitnode) = sum(idx_node);
    
    day_tar_tb_obs(:,iday,iorbitnode) = mean(tar_tb_obs,1);
    day_tar_tb_sim(:,iday,iorbitnode) = mean(tar_tb_sim,1);
    day_tar_tb_sd(:,iday,iorbitnode) = mean(tar_tb_sd,1);
    
    day_tar_tb_sd_std(:,iday,iorbitnode) = std(tar_tb_sd,1,1);
    
    % ---------------------------
    % along-scan
    % ---------------------------
    % tar_tb_sd
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(tar_scanpos,tar_tb_sd);
    [~,~,idxcross] = intersect(ncross1,TarScanpos);
    cross_tar_tb_sd(idxcross,:,iorbitnode) = cross_tar_tb_sd(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    cross_tar_num(idxcross,:,iorbitnode) = cross_tar_num(idxcross,:,iorbitnode) + crossnum;
    
    % tar_tb_obs
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(tar_scanpos,tar_tb_obs);
    [~,~,idxcross] = intersect(ncross1,TarScanpos);
    cross_tar_tb_obs(idxcross,:,iorbitnode) = cross_tar_tb_obs(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    
    % ---------------------------
    % map
    % ---------------------------
    [gridz,gridnum]  = sub_gridMapMean_vargrid(GridLat,GridLon,tar_lat(idx_node),tar_lon(idx_node),tar_tb_sd);
    map_tar_gridnum(:,:,1,iorbitnode) = map_tar_gridnum(:,:,1,iorbitnode)+gridnum;
    map_tar_tb_sd(:,:,:,iorbitnode) = map_tar_tb_sd(:,:,:,iorbitnode)+bsxfun(@times,gridz,gridnum);
    
    % ---------------------------
    % hist2
    % ---------------------------
    for nchan = 1: num_chan
        x = tar_tb_obs(:,nchan);
        y = tar_tb_sd(:,nchan);
        ihist2d  = sub_hist2(x,y,Stat.Bin_Hist2_TB,Stat.Bin_Hist2_TBSD);
        hist2_tb_tbsd(:,:,nchan,iorbitnode) = hist2_tb_tbsd(:,:,nchan,iorbitnode)+ihist2d;
    end
    
end

% along-scan std
% tar_tb_sd std
[crossnum,ncross,~,crosstb] = sub_uniqmean(tar_scanpos,tar_tb_sd.^2);
[~,~,idxcross] = intersect(ncross,TarScanpos);
cross_tar_tb_sd2(idxcross,:) = cross_tar_tb_sd2(idxcross,:) + bsxfun(@times,crosstb,crossnum);
