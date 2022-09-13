% from tb to ta to count
%   
% 
% Input:
%       TOA TB
% Output:
%       count
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

% ===================================================
%% simulation
% ===================================================

% -------------------------
% orbital file information
% -------------------------
saterr_imp_file_simorbit

% -------------------------
% orbital scanning geometry
% -------------------------
saterr_imp_scanning_1fromscanset

% -------------------------
% going through date range
% -------------------------
for nday=1: size(Path.date.ndatestr,1)
    disp(['Date ',Path.date.ndatestr(nday,:)])
    Path.date.nday = nday;
    
    % -------------------------
    % orbital scanning geometry
    % -------------------------
    ind = ind_filedaily1(nday): ind_filedaily2(nday);
    files_daily = files_simorbit(ind);

    for norbit=1: size(files_daily,1)
        disp(['Orbit ',num2str(norbit)])
        
        % -------------------------
        % load orbital data
        % -------------------------
        inpath = [pathin_root,'/',ndatestr(nday,1:4),'/',ndatestr(nday,:)];
        infile = files_daily(norbit).name;
        data = load([inpath,'/',infile]);
        
        if ~isempty(data.tb_scene)
            VarDynamic.Tas = double(data.tb_scene);
        else
            VarDynamic.Tas = double(data.tb_mainlobe);
        end
        
        % -------------------------
        % pre-processing
        % -------------------------
        % generating spillover
        saterr_imp_TB_mainsidespillover
        
        % alongtrack number of one orbit
        [n1,n2] = size(data.lat); % [crosstrack,alongtrack]
        Rad.num_alongtrack_1orbit = n2;
        Rad.num_orbit = 1;
        saterr_parse_no_alongtrack
        
        % -------------------------
        % receiver
        % -------------------------
        % scene
        saterr_imp_receiverpre_tas
        
        % cold and warm reference target
        saterr_imp_receiverpre_tcw
        
        % receiver
        saterr_imp_receiver
        
        % =====================================================
        %% output
        % =====================================================
        saterr_imp_simioout_more_count
        
    end
    
end
