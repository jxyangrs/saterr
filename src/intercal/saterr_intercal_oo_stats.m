% counting statistics through days
%



% =======================================================
% counting statistics through days
% =======================================================

for iorbitnode=1: NumOrbitNode % [dir]
    switch iorbitnode % index
        case 1
            idx_node = true(size(mtar_idx_asc,1),1);
        case 2
            idx_node = mtar_idx_asc;
        case 3
            idx_node = ~mtar_idx_asc;
    end
    if sum(idx_node)<=2
        continue;
    end
    
    % ---------------------------
    % basics
    % ---------------------------
    % histogram
    hist1_tar_tb_dif(:,:,iorbitnode) = hist1_tar_tb_dif(:,:,iorbitnode)+histc(mtar_tb_dif,Stat.BinTBSD,1);
    hist1_tar_tb_obs(:,:,iorbitnode) = hist1_tar_tb_obs(:,:,iorbitnode)+histc(mtar_tb_obs,Stat.BinTB,1);
    
    % daily
    day_num(:,iday,iorbitnode) = sum(idx_node);
    
    day_tar_tb_obs(:,iday,iorbitnode) = mean(mtar_tb_obs,1);
    day_tar_tb_dif(:,iday,iorbitnode) = mean(mtar_tb_dif,1);
    
    day_tar_tb_dif_std(:,iday,iorbitnode) = std(mtar_tb_dif,1,1);
    
    % ---------------------------
    % along-scan
    % ---------------------------
    % mtar_tb_dif
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(mtar_scanpos,mtar_tb_dif);
    [~,~,idxcross] = intersect(ncross1,1:tar_sensor.num_crosstrack);
    cross_tar_tb_dif(idxcross,:,iorbitnode) = cross_tar_tb_dif(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    cross_tar_num(idxcross,:,iorbitnode) = cross_tar_num(idxcross,:,iorbitnode) + crossnum;
    
    % mtar_tb_obs
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(mtar_scanpos,mtar_tb_obs);
    [~,~,idxcross] = intersect(ncross1,1:tar_sensor.num_crosstrack);
    cross_tar_tb_obs(idxcross,:,iorbitnode) = cross_tar_tb_obs(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    
    % ---------------------------
    % map
    % ---------------------------
    [gridz,gridnum]  = sub_gridMapMean_vargrid(GridLat,GridLon,mtar_lat(idx_node),mtar_lon(idx_node),mtar_tb_dif);
    map_tar_gridnum(:,:,1,iorbitnode) = map_tar_gridnum(:,:,1,iorbitnode)+gridnum;
    map_tar_tb_dif(:,:,:,iorbitnode) = map_tar_tb_dif(:,:,:,iorbitnode)+bsxfun(@times,gridz,gridnum);
    
    % ---------------------------
    % hist2
    % ---------------------------
    for nchan = 1: match_num_chan
        x = mtar_tb_obs(:,nchan);
        y = mtar_tb_dif(:,nchan);
        ihist2d  = sub_hist2(x,y,Stat.Bin_Hist2_TB,Stat.Bin_Hist2_TBSD);
        hist2_tar_tb_dif(:,:,nchan,iorbitnode) = hist2_tar_tb_dif(:,:,nchan,iorbitnode)+ihist2d;
    end
    
end

% along-scan std
% mtar_tb_dif std
[crossnum,ncross,~,crosstb] = sub_uniqmean(mtar_scanpos,mtar_tb_dif.^2);
[~,~,idxcross] = intersect(ncross,1:tar_sensor.num_crosstrack);
cross_tar_tb_dif2(idxcross,:) = cross_tar_tb_dif2(idxcross,:) + bsxfun(@times,crosstb,crossnum);


