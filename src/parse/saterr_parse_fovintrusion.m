% parse setting for FOV intrusion
%
% Output:
%       ScanBias.fovintrusion.tb,       obstruction target TB,      [1,channel]  
%       ScanBias.fovintrusion.frac,     fraction of FOV fovintrusion due to obstruction,    [crosstrack,channel] (range [0,1],0=no obstruction,1=fulling obstructed)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/16/2019: parameterize fraction w/ Gaussian pattern

% -------------------------
% parse
% -------------------------
switch ScanBias.fovintrusion.type
    case 'customize'
        n1 = Rad.ind_CT_num(1);
        n2 = Rad.num_chan;
        
        for nchan=1: n2
            x = x_left{nchan};
            y = r_left{nchan};
            y1 = saterr_parse_fovintrusionsub(x,y,1);
            ScanBias.fovintrusion.frac(x,nchan) = y1;
            
            x = x_right{nchan};
            y = r_left{nchan};
            y1 = saterr_parse_beamfovintrusionsub(x,y,1);
            ScanBias.fovintrusion.frac(end:-1:end-length(x)+1,nchan) = y1;
        end
        
    case 'Example'
        n1 = Rad.ind_CT_num(1);
        n2 = Rad.num_chan;
        
        for nchan=1: n2
            x = x_left{nchan};
            y = r_left{nchan};
            y1 = saterr_parse_fovintrusionsub(x,y,1);
            ScanBias.fovintrusion.frac(x,nchan) = y1;
            
            x = x_right{nchan};
            y = r_left{nchan};
            y1 = saterr_parse_fovintrusionsub(x,y,1);
            ScanBias.fovintrusion.frac(end:-1:end-length(x)+1,nchan) = y1;
        end

end

