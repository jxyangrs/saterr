% counting intercalibration statistics through days
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/21/2019: original code


% ---------------------------
% counting statistics through days
% ---------------------------
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
    hist1_tb_dd(:,:,iorbitnode) = hist1_tb_dd(:,:,iorbitnode)+histc(mtb_dd,Stat.BinTBDD,1);
    hist1_tar_tb_obs(:,:,iorbitnode) = hist1_tar_tb_obs(:,:,iorbitnode)+histc(mtar_tb_obs,Stat.BinTB,1);
    
    % daily
    day_num(:,iday,iorbitnode) = sum(idx_node);
    
    day_tar_tb_obs(:,iday,iorbitnode) = mean(mtar_tb_obs,1);
    day_ref_tb_obs(:,iday,iorbitnode) = mean(mref_tb_obs,1);
    
    day_tb_dd(:,iday,iorbitnode) = mean(mtb_dd,1);
    day_tb_dd_std(:,iday,iorbitnode) = std(mtb_dd,1);
    
    % ---------------------------
    % along-scan
    % ---------------------------
    
    % mtar_tb_obs
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(mtar_scanpos,mtar_tb_obs);
    [~,~,idxcross] = intersect(ncross1,1:tar_sensor.num_crosstrack);
    cross_tar_tb_obs(idxcross,:,iorbitnode) = cross_tar_tb_obs(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    
    cross_tar_num(idxcross,:,iorbitnode) = cross_tar_num(idxcross,:,iorbitnode) + crossnum;
    
    % mtb_dd
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(mtar_scanpos,mtb_dd);
    [~,~,idxcross] = intersect(ncross1,1:tar_sensor.num_crosstrack);
    cross_tb_dd(idxcross,:,iorbitnode) = cross_tb_dd(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    
    % mtb_dd std
    [crossnum,ncross1,~,crosstb] = sub_uniqmean(mtar_scanpos,mtb_dd.^2);
    [~,~,idxcross] = intersect(ncross1,1:tar_sensor.num_crosstrack);
    cross_tb_dd2(idxcross,:,iorbitnode) = cross_tb_dd2(idxcross,:,iorbitnode) + bsxfun(@times,crosstb,crossnum);
    
    % ---------------------------
    % map
    % ---------------------------
    [gridz,gridnum]  = sub_gridMapMean_vargrid(GridLat,GridLon,mtar_lat(idx_node),mtar_lon(idx_node),mtar_tb_obs(idx_node,:));
    map_tar_gridnum(:,:,1,iorbitnode) = map_tar_gridnum(:,:,1,iorbitnode)+gridnum;
    map_tar_tb_obs(:,:,:,iorbitnode) = map_tar_tb_obs(:,:,:,iorbitnode)+bsxfun(@times,gridz,gridnum);
    
    [gridz,gridnum]  = sub_gridMapMean_vargrid(GridLat,GridLon,mtar_lat(idx_node),mtar_lon(idx_node),mtb_dd(idx_node,:));
    map_tb_dd(:,:,:,iorbitnode) = map_tb_dd(:,:,:,iorbitnode)+bsxfun(@times,gridz,gridnum);

    % ---------------------------
    % hist2
    % ---------------------------
    for nchan = 1: match_num_chan
        x = mtar_tb_obs(:,nchan);
        y = mtb_dd(:,nchan);
        ihist2d  = sub_hist2(x,y,Stat.Bin_Hist2_TB,Stat.Bin_Hist2_TBDD);
        hist2_tar_tb_tb_dd(:,:,nchan,iorbitnode) = hist2_tar_tb_tb_dd(:,:,nchan,iorbitnode)+ihist2d;
    end
    
end



