function saterr_parse_noiseadditive_cust
% parsing noise magnitude
%
% output:
%         Noise.addnoise.STD_TBC_Sub,           std of cold-end noise,          {channel-1(sub),channel-2(sub),...}/0
%         Noise.addnoise.STD_TBW_Sub,           std of warm-end noise,          {channel-1(sub),channel-2(sub),...}/0
%         Noise.addnoise.STD_TBS_Sub,           std of scene noise,             {channel-1(sub),channel-2(sub),...}/0
%         Noise.addnoise.STD_TBnull_Sub,        std of null-scanning noise,     {channel-1(sub),channel-2(sub),...}/0
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/07/2019: parse STD of idealized model
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: type-chan sytax change

global Noise Rad

if Noise.addnoise.onoff==1
    % -----------------------------
    % additive noise
    % -----------------------------
    switch Noise.addnoise.source
        case {'demo'} % a simple example
            % -----------------------------
            % Demo_TimeVarying.oscillation.ation
            % -----------------------------
            
            % check input
            n = [numel(Noise.addnoise.chan_std)];
            if sum(n~=Rad.num_chan)
                error('Size error')
            end
            n = [numel(Noise.addnoise.type_varfrac)];
            if sum(n~=Noise.addnoise.num_type)
                error('Size error')
            end
            x = sum(cell2mat(Noise.addnoise.type_varfrac(:)),1);
            if sum(x==0)
                error('total fraction is zero')
            elseif sum(x~=1)
                warning('Sum of fraction ~= 1: Noise.addnoise.type_varfrac; normalizing will be implemented \n')
            end
            
            % preprocessing for Fraction
            
            % var fraction
            var_frac = []; % [channel,type]
            for ntype=1: Noise.addnoise.num_type
                var_frac(:,ntype) = Noise.addnoise.type_varfrac{ntype};
            end
            var_frac = var_frac./sum(var_frac,2);
            
            % channel
            for nchan=1: Rad.num_chan
                var_value = Noise.addnoise.chan_std(nchan).^2;
                chan_std_cold_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                
                chan_std_warm_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                
                chan_std_scene_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                
                chan_std_null_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
            end
        case 'customize'
            % -----------------------------
            % customize
            % -----------------------------
            switch Noise.addnoise.mode
                case 'Fraction'
                    % -----------------------------
                    % Fraction: input are NEDT of total-noise, percentage of sub-noise
                    % -----------------------------
                    
                    % check input
                    n = [numel(Noise.addnoise.chan_std_cold),numel(Noise.addnoise.chan_std_warm),numel(Noise.addnoise.chan_std_scene),numel(Noise.addnoise.chan_std_null)];
                    if sum(n~=Rad.num_chan)
                        error('Error of size of Noise.addnoise.chan_std_*')
                    end
                    n = numel(Noise.addnoise.type_varfrac);
                    if sum(n~=Noise.addnoise.num_type)
                        error('Error of size of Noise.addnoise.type_varfrac')
                    end
                    x = sum(cell2mat(Noise.addnoise.type_varfrac(:)),1);
                    if sum(x==0)
                        error('total fraction is zero')
                    elseif sum(x~=1)
                        warning('Sum of fraction ~= 1: Noise.addnoise.type_varfrac; normalizing will be implemented \n')
                    end
                    
                    % preprocessing for Fraction
                    var_frac = []; % [channel,type]
                    for ntype=1: Noise.addnoise.num_type
                        var_frac(:,ntype) = Noise.addnoise.type_varfrac{ntype};
                    end
                    var_frac = var_frac./sum(var_frac,2);
                    
                    for nchan=1: Rad.num_chan
                        var_value = Noise.addnoise.chan_std_cold(nchan).^2;
                        chan_std_cold_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                        var_value = Noise.addnoise.chan_std_warm(nchan).^2;
                        chan_std_warm_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                        var_value = Noise.addnoise.chan_std_scene(nchan).^2;
                        chan_std_scene_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                        var_value = Noise.addnoise.chan_std_null(nchan).^2;
                        chan_std_null_sub{nchan} = sqrt(var_value.*var_frac(nchan,:));
                    end
                    
                case 'Absolute'
                    % -----------------------------
                    % Absolute: input are NEDT of sub-noise
                    % -----------------------------
                    
                    % check input
                    n = [numel(Noise.addnoise.type_std_cold_sub),numel(Noise.addnoise.type_std_warm_sub),numel(Noise.addnoise.type_std_scene_sub),numel(Noise.addnoise.type_std_null_sub)];
                    if sum(n~=Noise.addnoise.num_type)
                        error('Size of numel(Noise.addnoise.type_std_*_sub)~=Noise.addnoise.num_type')
                    end
                    n = [cellfun(@numel,Noise.addnoise.type_std_cold_sub),cellfun(@numel,Noise.addnoise.type_std_warm_sub),cellfun(@numel,Noise.addnoise.type_std_scene_sub),cellfun(@numel,Noise.addnoise.type_std_null_sub)];
                    if sum(n~=Rad.num_chan)
                        error('Size of numel(Noise.addnoise.type_std_*_sub{i})==Rad.num_chan')
                    end
                    
                    % parse
                    M1 = cell2mat(Noise.addnoise.type_std_cold_sub(:))'; % [channel,type]
                    M2 = cell2mat(Noise.addnoise.type_std_warm_sub(:))';
                    M3 = cell2mat(Noise.addnoise.type_std_scene_sub(:))';
                    M4 = cell2mat(Noise.addnoise.type_std_null_sub(:))';
                    for nchan=1: Rad.num_chan
                        chan_std_cold_sub{nchan} = M1(nchan,:);
                        chan_std_warm_sub{nchan} = M2(nchan,:);
                        chan_std_scene_sub{nchan} = M3(nchan,:);
                        chan_std_null_sub{nchan} = M4(nchan,:);
                    end
                    
                otherwise
                    error('Noise.addnoise.mode')
            end
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
