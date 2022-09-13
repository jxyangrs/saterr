% filtering for dd
%


% =======================================================
% target
% =======================================================

% index of ascending/descending
[tar_idx_asc,~] = idx_orbit_ascdes(tar_lat(round(end/2),:));

% reshape to [geo,channel]
[n1,n2,n3] = size(tar_tb_obs);
tar_tb_obs = reshape(tar_tb_obs,[n1*n2,n3]);
tar_eia = reshape(tar_eia,[n1*n2,n3]);
tar_lat = reshape(tar_lat,[n1*n2,1]);
tar_lon = reshape(tar_lon,[n1*n2,1]);
tar_time = reshape(tar_time,[n1*n2,1]);
tar_azm = reshape(tar_azm,[n1*n2,n3]);
tar_scanpos = reshape(tar_scanpos,[n1*n2,1]);
tar_scanangle = reshape(tar_scanangle,[n1*n2,1]);
tar_qual = tar_qual(:);

tar_idx_asc = repmat(tar_idx_asc(:)',[n1,1]);tar_idx_asc=tar_idx_asc(:);

tar_tb_sim = reshape(tar_tb_sim,[n1*n2,n3]);

% filter of latitude range
if 1
    n = size(tar_lat);
    idxfil = false(n(1),1); % 1=bad,0=good
    idx = abs(tar_lat)>90;
    idxfil = idxfil | idx;
    % apply filter
    [tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim);
end
% filter of quality flag
if 1
    idxfil = tar_qual; % 1=bad,0=good
    
    [tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim);
end
% land filter
if FilterCal.landfilter.onoff
    idxfil = filter_landmask(tar_lat,mod(tar_lon,360),LatMask,LonMask,LandMask);
    [tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim);
end

% =======================================================
% reference
% =======================================================

% index of ascending/descending
[ref_idx_asc,~] = idx_orbit_ascdes(ref_lat(round(end/2),:));

% reshape to [geo,channel]
[n1,n2,n3] = size(ref_tb_obs);
ref_tb_obs = reshape(ref_tb_obs,[n1*n2,n3]);
ref_eia = reshape(ref_eia,[n1*n2,n3]);
ref_lat = reshape(ref_lat,[n1*n2,1]);
ref_lon = reshape(ref_lon,[n1*n2,1]);
ref_time = reshape(ref_time,[n1*n2,1]);
ref_azm = reshape(ref_azm,[n1*n2,n3]);
ref_scanpos = reshape(ref_scanpos,[n1*n2,1]);
ref_scanangle = reshape(ref_scanangle,[n1*n2,1]);
ref_qual = ref_qual(:);

ref_idx_asc = repmat(ref_idx_asc(:)',[n1,1]);ref_idx_asc=ref_idx_asc(:);

ref_tb_sim = reshape(ref_tb_sim,[n1*n2,n3]);

% filter of latitude range
if 1
    n = size(ref_lat);
    idxfil = false(n(1),1); % 1=bad,0=good
    idx = abs(ref_lat)>90;
    idxfil = idxfil | idx;
    % apply filter
    [ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim] = ...
        sub_filterInd1D(1,~idxfil, ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim);
end
% filter of quality flag
if 1
    idxfil = ref_qual; % 1=bad,0=good
    
    [ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim] = ...
        sub_filterInd1D(1,~idxfil, ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim);
end
% land filter
if FilterCal.landfilter.onoff
    idxfil = filter_landmask(ref_lat,mod(ref_lon,360),LatMask,LonMask,LandMask);
    [ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim] = ...
        sub_filterInd1D(1,~idxfil, ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim);
end

% =======================================================
% obs-sim of target and reference
% =======================================================
% target
if FilterCal.tar_tb_sd.onoff
    tar_tb_sd = tar_tb_obs - tar_tb_sim;
    idxfil = tar_tb_sd<FilterCal.tar_tb_sd.range(1) | FilterCal.tar_tb_sd.range(2)<tar_tb_sd;
    idxfil = sum(idxfil,2)>1;
    [tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim,tar_tb_sd] = ...
        sub_filterInd1D(1,~idxfil, tar_tb_obs,tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_idx_asc,tar_tb_sim,tar_tb_sd);
end

% reference
if FilterCal.ref_tb_sd.onoff
    ref_tb_sd = ref_tb_obs - ref_tb_sim;
    idxfil = ref_tb_sd<FilterCal.ref_tb_sd.range(1) | FilterCal.ref_tb_sd.range(2)<ref_tb_sd;
    idxfil = sum(idxfil,2)>1;
    [ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim,ref_tb_sd] = ...
        sub_filterInd1D(1,~idxfil, ref_tb_obs,ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_idx_asc,ref_tb_sim,ref_tb_sd);
end



