function saterr_set_fovintrusion
% setting for FOV intrusion at edge of scanning
% FOV is obstructed by spacecraft
%
% Input:
%       beam fovintrusion setting
% Output:
%       ScanBias.fovintrusion.tb,       obstruction target TB,          [1,channel]
%       ScanBias.fovintrusion.frac,     fraction of FOV fovintrusion    [crosstrack,channel] (range [0,1],0=no obstruction,1=fulling obstructed)
%                                       due to obstruction,    
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/16/2019: parameterize fraction w/ Gaussian pattern

global ScanBias Rad
% -----------------------------
% setting
% -----------------------------
ScanBias.fovintrusion.onoff = 0; % 0=off,1=on
ScanBias.fovintrusion.type = 'example'; % customize/example, example is FOV obstruction at edge of scanning

if ScanBias.fovintrusion.onoff==1
    switch ScanBias.fovintrusion.type
        case 'customize'
            % setup
            n1 = Rad.ind_CT_num(1);
            n2 = Rad.num_chan;
            
            % customize the observed/simulated parameters here:
            x_left = cell(1,n2);
            x_right = cell(1,n2);
            r_left = cell(1,n2);
            r_right = cell(1,n2);
            
            for nchan=1: n2
                x_left{nchan} = [1:8];
                x_right{nchan} = [1:10];
                r_left{nchan} = 0.05*exp(-(x_left{nchan}));
                r_right{nchan} = 0.03*exp(-(x_right{nchan}));
            end
            
            % intrusion object TB (K), [1,n2]
            ScanBias.fovintrusion.tb = 100*ones(1,n2);
            % fraction of FOV fovintrusion due to obstruction, [n1,n2], ranging [0,1] 0=see completely Earth scene,1=see completely obstruction scene
            ScanBias.fovintrusion.frac = zeros(n1,n2);
            
        case 'example' % beam fovintrusion at edge of scan
            % setup
            n1 = Rad.ind_CT_num(1);
            n2 = Rad.num_chan;
            
            % customize the observed/simulated parameters here:
            x_left = cell(1,n2);
            x_right = cell(1,n2);
            r_left = cell(1,n2);
            r_right = cell(1,n2);
            
            for nchan=1: n2
                x_left{nchan} = [1:8];
                x_right{nchan} = [1:10];
                r_left{nchan} = 0.05*exp(-(x_left{nchan}));
                r_right{nchan} = 0.03*exp(-(x_right{nchan}));
            end
            
            % obstruction TB (K), [1,n2]
            ScanBias.fovintrusion.tb = 100*ones(1,n2);
            % fraction of beam fovintrusion, [n1,n2], ranging [0,1] 0=see completely Earth scene,1=see completely obstruction scene
            ScanBias.fovintrusion.frac = zeros(n1,n2);
            
        otherwise
            error('Error of ScanBias.fovintrusion.type')
    end
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_fovintrusion
end
