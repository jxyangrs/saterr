function saterr_parse_noiseadditive_sensor
% parsing noise magnitude
%
% output:
%         Noise.addnoise.STD_TBC_Sub,           std of cold-end noise,          {channel-1(sub),channel-2(sub),...}/0
%         Noise.addnoise.STD_TBW_Sub,           std of warm-end noise,          {channel-1(sub),channel-2(sub),...}/0
%         Noise.addnoise.STD_TBS_Sub,           std of scene noise,             {channel-1(sub),channel-2(sub),...}/0
%         Noise.addnoise.STD_TBnull_Sub,        std of null-scanning noise,     {channel-1(sub),channel-2(sub),...}/0
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: split script
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/13/2019: parse sensor
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/11/2019: syntax change for var fraction

global Rad Noise

if Noise.addnoise.onoff==1
    
    % -----------------------------
    % check
    % -----------------------------
    % check size
    n = [numel(Noise.addnoise.chan_std_cold),numel(Noise.addnoise.chan_std_warm),numel(Noise.addnoise.chan_std_scene),numel(Noise.addnoise.chan_std_null)];
    if sum(n~=Rad.num_chan)>0
        error('Error of size of Noise.addnoise.chan_std_*')
    end
    
    n = [numel(Noise.addnoise.type_cold_varfrac),numel(Noise.addnoise.type_warm_varfrac),numel(Noise.addnoise.type_scene_varfrac),numel(Noise.addnoise.type_null_varfrac)];
    if sum(n~=Noise.addnoise.num_type)>0
        error('Error of size of Noise.addnoise.type_*_varfrac')
    end
    
    n = [cellfun(@numel,Noise.addnoise.type_cold_varfrac),cellfun(@numel,Noise.addnoise.type_warm_varfrac),cellfun(@numel,Noise.addnoise.type_scene_varfrac),cellfun(@numel,Noise.addnoise.type_null_varfrac)];
    if sum(n~=Rad.num_chan)>0
        error('Error of size of Noise.addnoise.type_*_varfrac')
    end
    
    % check sum of percentage
    x = [sum(cell2mat(Noise.addnoise.type_cold_varfrac(:)),1),sum(cell2mat(Noise.addnoise.type_warm_varfrac(:)),1),sum(cell2mat(Noise.addnoise.type_scene_varfrac(:)),1),sum(cell2mat(Noise.addnoise.type_null_varfrac(:)),1)];
    if sum(x~=1)
        warning('Sum of percent ~= 1: Noise.addnoise.type_*_varfrac; normalizing will be implemented \n')
    end

    % -----------------------------
    % additive noise
    % -----------------------------
    
    % var fraction
    var_frac_cold = [];
    var_frac_warm = [];
    var_frac_scene = [];
    var_frac_null = [];
    for ntype=1: Noise.addnoise.num_type
        var_frac_cold(:,ntype) = Noise.addnoise.type_cold_varfrac{ntype};
        var_frac_warm(:,ntype) = Noise.addnoise.type_warm_varfrac{ntype};
        var_frac_scene(:,ntype) = Noise.addnoise.type_scene_varfrac{ntype};
        var_frac_null(:,ntype) = Noise.addnoise.type_null_varfrac{ntype};
    end
    
    var_frac_cold = bsxfun(@rdivide,var_frac_cold,sum(var_frac_cold,2));
    var_frac_warm = bsxfun(@rdivide,var_frac_warm,sum(var_frac_warm,2));
    var_frac_scene = bsxfun(@rdivide,var_frac_scene,sum(var_frac_scene,2));
    var_frac_null = bsxfun(@rdivide,var_frac_null,sum(var_frac_null,2));
    
    % preprocessing for fraction
    for nchan=1: Rad.num_chan
        var_value = Noise.addnoise.chan_std_cold(nchan).^2;
        var_frac = var_frac_cold(nchan,:);
        chan_std_cold_sub{nchan} = sqrt(var_value.*var_frac);
        
        var_value = Noise.addnoise.chan_std_warm(nchan).^2;
        var_frac = var_frac_warm(nchan,:);
        chan_std_warm_sub{nchan} = sqrt(var_value.*var_frac);
        
        var_value = Noise.addnoise.chan_std_scene(nchan).^2;
        var_frac = var_frac_scene(nchan,:);
        chan_std_scene_sub{nchan} = sqrt(var_value.*var_frac);
        
        var_value = Noise.addnoise.chan_std_null(nchan).^2;
        var_frac = var_frac_null(nchan,:);
        chan_std_null_sub{nchan} = sqrt(var_value.*var_frac);
    end
    
    % output
    Noise.addnoise.STD_TBC_Sub = chan_std_cold_sub;
    Noise.addnoise.STD_TBW_Sub = chan_std_warm_sub;
    Noise.addnoise.STD_TBS_Sub = chan_std_scene_sub;
    Noise.addnoise.STD_TBnull_Sub = chan_std_null_sub;
    
else
    % -----------------------------
    % no additive noise
    % -----------------------------
    Noise.addnoise.STD_TBC_Sub = 0;
    Noise.addnoise.STD_TBW_Sub = 0;
    Noise.addnoise.STD_TBS_Sub = 0;
    Noise.addnoise.STD_TBnull_Sub = 0;
    
end
