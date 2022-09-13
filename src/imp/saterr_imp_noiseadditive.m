function saterr_imp_noiseadditive
% implement additive noise
%
% Input:
%       Noise type and magnitude
%       Noise.type
%       Noise.addnoise.STD_TBC_Sub
%       Noise.addnoise.STD_TBW_Sub
%       Noise.addnoise.STD_TBS_Sub
%       Noise.addnoise.STD_TBnull_Sub
% 
% Output:
%       Noise.addnoise.noise_subset
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/31/2019: scaling; 1/f adjustment
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/31/2019: reorganize

global Noise Rad

if Noise.addnoise.onoff==1
    % -----------------------------
    % additive noise
    % -----------------------------
    noise_subset = []; % [cross-track,along-track,(sumup,noise1,noise2,...),channel]
    
    for nchan = 1: Rad.num_chan
        Noise.addnoise.nchan = nchan;
        
        % -------------------------
        % noise simulation
        % -------------------------
        
        % cc,warm,scene,null of STD==1
        num_cross = sum(Rad.num_crosstrack);
        
        ind_orbit = Rad.alongtrack_orbit_ind_startend(Rad.norbit,:);
        num_1orbit_alongtrack = ind_orbit(2) - ind_orbit(1) +1;
        
        n = num_1orbit_alongtrack*num_cross;
        [~,noise_sub] = saterr_noise_sim_sub(n,Noise.addnoise.type,ones(size(Noise.addnoise.type)));
        
        n = size(noise_sub,2);
        noise_sub = reshape(noise_sub,[num_cross,num_1orbit_alongtrack,n]);
        
        % -------------------------
        % noise scaling
        % -------------------------
        std_tbc = Noise.addnoise.STD_TBC_Sub{nchan};
        std_tbw = Noise.addnoise.STD_TBW_Sub{nchan};
        std_tbs = Noise.addnoise.STD_TBS_Sub{nchan};
        std_tbnull = Noise.addnoise.STD_TBnull_Sub{nchan};
        
        % adjust 1/f if necessary
        Noise.f1.adjust = 1;
        if Noise.f1.adjust
            saterr_imp_1fadjust
        end
        
        % implement
        noise_subset(:,:,:,nchan) = saterr_noise_scale(Rad.ind_CT,noise_sub,std_tbs,std_tbc,std_tbw,std_tbnull); % [cross-track,along-track,(sumup,noise1,noise2,...),channel]
        
        Noise.addnoise.noise_subset = noise_subset;
    end
    
else
    % -----------------------------
    % no additive noise
    % -----------------------------
    Noise.addnoise.noise_subset = 0;
end


