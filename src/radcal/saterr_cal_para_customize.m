% setting and customizing calibration parameters
% This overwrites parameters in simulation
%
% Input:
%       setting error sources
%
% Output:
%       individual error sources
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara Rad

% ================================================
%% customizing calibration parameters
% ================================================

% set overall control
CalPara.customize.onoff = 0;

% set individual error
if CalPara.customize.onoff == 1
    % -----------------------------
    % instrument interference
    % -----------------------------
    CalPara.ScanBias.interference.onoff = 0;
    if CalPara.ScanBias.interference.onoff==1
        CalPara.scanbias.interference.tb = ScanBias.interference.tb;
    end
    
    % -----------------------------
    % reflector emission
    % -----------------------------
    CalPara.reflector.onoff = 0;
    if CalPara.reflector.onoff == 1
        CalPara.reflector.emission.E = 0;
        CalPara.reflector.emission.tmp = 0;
    end
    
    % -----------------------------
    % conical-scanning cold-space mirror
    % -----------------------------
    CalPara.mirrorcold.onoff = 0;
    if CalPara.mirrorcold.onoff == 1
        CalPara.mirrorcold.error.slope = 0;
        CalPara.mirrorcold.error.intercept = 0;
    end
    
    % -----------------------------
    % setting warmload error
    % -----------------------------
    CalPara.warmload.error.onoff = 0;
    if CalPara.warmload.error.onoff == 1
        CalPara.warmload.error.slope = 0;
        CalPara.warmload.error.intercept = 0;
    end
    
    % -----------------------------
    % spillover etc
    % -----------------------------
    CalPara.spillover.onoff = 0;
    if CalPara.spillover.onoff==1
        CalPara.AP.frac.mainlobe = 0;
        CalPara.AP.frac.sidelobe = 0;
        CalPara.AP.frac.spillover = 0;
        
        CalPara.AP.tb.spillover = 0;
    end
    
    % -----------------------------
    % FOV intrusion
    % -----------------------------
    CalPara.ScanBias.fovintrusion.onoff = 0;
    if CalPara.ScanBias.fovintrusion.onoff == 1
        CalPara.scanbias.fovintrusion.onoff = 1;
        CalPara.scanbias.fovintrusion.tb = ScanBias.fovintrusion.tb;
        CalPara.scanbias.fovintrusion.frac = ScanBias.fovintrusion.frac;
        
    else
        CalPara.ScanBias.fovintrusion.onoff = 0;
    end
    
    % -----------------------------
    % crosspol contamiatnion
    % -----------------------------
    CalPara.crosspol.onoff = 0;
    if CalPara.crosspol.onoff == 1
        CalPara.crosspol.X = AP.crosspol.X;
        
        % Since only one polarization
        CalPara.crosspol.scheme = 'same'; % same/linear/empirical
        switch CalPara.crosspol.scheme
            case 'same'
                CalPara.crosspol.coeff = [1,0]; % [1
            case 'linear'
                CalPara.crosspol.coeff = [0.9,0]*ones(1,Rad.num_chan); % tb_pp = tb_pq*a + b; [2,channel]
            case 'empirical'
                CalPara.crosspol.tb = [1,0]; % tb of [crosstrack,alongtrack,channel]
        end
        
    end
    
    % -----------------------------
    % Faraday
    % -----------------------------
    CalPara.Faraday.onoff = 0;
    if CalPara.Faraday.onoff == 1
        CalPara.Faraday.chan.omega = Faraday.chan.omega;
        CalPara.Faraday.chan.d = Faraday.chan.d;
        CalPara.Faraday.chan.U = Faraday.chan.U;
    end
    
end