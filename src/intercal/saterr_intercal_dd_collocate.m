% collocating
%

% =======================================================
% collocating
% =======================================================

% ---------------------------
% degree to distance
% ---------------------------
switch Collocate.distance_type
    case 'km'
        [ref_lon_dist,ref_lat_dist1] = dist_earthxy(0,0,ref_lat,ref_lon);
        ref_lon_dist=ref_lon_dist(:);
        ref_lat_dist=ref_lat_dist1(:);
        [tlon_dist,tlat_dist] = dist_earthxy(0,0,tar_lat,tar_lon);
        tlon_dist=tlon_dist(:);
        tlat_dist=tlat_dist(:);
        
    case 'degree'
        ref_lon_dist = ref_lon;
        ref_lat_dist = ref_lat;
        tar_lon_dist = tar_lon;
        tar_lat_dist = tar_lat;
        
    otherwise
        error(['Col.distance_type is wrong: ',Collocate.distance_type])
        
end

% ---------------------------
% collocating
% ---------------------------
[cID,mlat,mlon,mtime,ref_ID,ref_idx,tar_ID,tar_idx] = ...
    sub_collocate(Collocate.time,Collocate.distance,ref_lat_dist,ref_lon_dist,ref_time,tlat_dist,tlon_dist,tar_time);

if isempty(cID)
    return
end

ref_tb_obs=ref_tb_obs(ref_idx,:);ref_scanpos=ref_scanpos(ref_idx);ref_eia=ref_eia(ref_idx,:);ref_idx_asc=ref_idx_asc(ref_idx);ref_time=ref_time(ref_idx);ref_lat=ref_lat(ref_idx);ref_lon=ref_lon(ref_idx);
ref_tb_sim=ref_tb_sim(ref_idx,:);
tar_tb_obs=tar_tb_obs(tar_idx,:);tar_scanpos=tar_scanpos(tar_idx);tar_eia=tar_eia(tar_idx,:);tar_idx_asc=tar_idx_asc(tar_idx);tar_time=tar_time(tar_idx);tar_lat=tar_lat(tar_idx);tar_lon=tar_lon(tar_idx);
tar_tb_sim=tar_tb_sim(ref_idx,:);

% mean and std
[mref_num,~,~,mref_tb_obs,mref_tbstd] = sub_uniqmeanstd(ref_ID,ref_tb_obs);
[mtar_num,~,~,mtar_tb_obs,mtar_tbstd] = sub_uniqmeanstd(tar_ID,tar_tb_obs);

[~,~,~,mref_eia,mref_scanpos,mref_idx_asc,mref_time,mref_lat,mref_lon] = sub_uniqmean(ref_ID,ref_eia,ref_scanpos,ref_idx_asc,ref_time,ref_lat,ref_lon);
[~,~,~,mtar_eia,mtar_scanpos,mtar_idx_asc,mtar_time,mtar_lat,mtar_lon] = sub_uniqmean(tar_ID,tar_eia,tar_scanpos,tar_idx_asc,tar_time,tar_lat,tar_lon);
mref_idx_asc = logical(mref_idx_asc);
mtar_idx_asc = logical(mtar_idx_asc);

[~,~,~,mref_tb_sd] = sub_uniqmean(ref_ID,ref_tb_sd);
[~,~,~,mtar_tb_sd] = sub_uniqmean(tar_ID,tar_tb_sd);

mtb_dd = mtar_tb_sd - mref_tb_sd;

% filter with EIA difference
switch Rad.scantype
    case 'crosstrack'
        eia_dif = mtar_eia-mref_eia;
        idx = abs(eia_dif(:,1))<Collocate.eia; % 1=same scanpos,2=same/adjacent scanpos
        [mlat,mlon] = sub_filterInd1D(1,idx,mlat,mlon);
        [mref_lat,mref_lon,mref_tb_obs,mref_eia,mref_time,mref_scanpos] = ...
            sub_filterInd1D(1,idx,mref_lat,mref_lon,mref_tb_obs,mref_eia,mref_time,mref_scanpos);
        [mtar_lat,mtar_lon,mtar_tb_obs,mtar_eia,mtar_time,mtar_scanpos] = ...
            sub_filterInd1D(1,idx,mtar_lat,mtar_lon,mtar_tb_obs,mtar_eia,mtar_time,mtar_scanpos);
        [mref_idx_asc,mref_num,mtar_idx_asc,mtar_num] = ...
            sub_filterInd1D(1,idx,mref_idx_asc,mref_num,mtar_idx_asc,mtar_num);
        [mtb_dd] = sub_filterInd1D(1,idx,mtb_dd);
end

% time and geo difference
mtimedif = (mtar_time-mref_time)*24*60; % time difference, minutes
mtar_tb_dif = mtar_tb_obs-mref_tb_obs;
meia_dif = mtar_eia-mref_eia;

% ---------------------------
% filtering
% ---------------------------
if FilterCal.tb_dd.onoff
    idxfil = mtb_dd<FilterCal.tar_tb_sd.range(1) | FilterCal.tar_tb_sd.range(2)<mtb_dd;
    idxfil = sum(idxfil,2)>1;
    [mref_eia,mref_scanpos,mref_idx_asc,mref_time,mref_lat,mref_lon,mref_tb_sd] = ...
        sub_filterInd1D(1,~idxfil, mref_eia,mref_scanpos,mref_idx_asc,mref_time,mref_lat,mref_lon,mref_tb_sd);
    [mtar_eia,mtar_scanpos,mtar_idx_asc,mtar_time,mtar_lat,mtar_lon,mtar_tb_sd] = ...
        sub_filterInd1D(1,~idxfil, mtar_eia,mtar_scanpos,mtar_idx_asc,mtar_time,mtar_lat,mtar_lon,mtar_tb_sd);
end


