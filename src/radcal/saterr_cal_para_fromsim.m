% using calibration parameters from those in simulation
%
% Input:
%       
% Output:
%       CalPara.
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path NGranuel CalPara

% ================================================
%% loading calibration parameters from simulation output
% ================================================

% -----------------------------
% nonlinearity
% -----------------------------
if Rad.nonlinear.onoff==1
    CalPara.nonlinear.onoff = 1;
    CalPara.nonlinear.T_nl = Rad.nonlinear.T_nl;
    
else
    CalPara.nonlinear.onoff = 0;
end

% -----------------------------
% instrument interference
% -----------------------------
if ScanBias.interference.onoff==1
    CalPara.scanbias.interference.onoff = 1;
    CalPara.scanbias.interference.tb = ScanBias.interference.tb;
    
else
    CalPara.scanbias.interference.onoff = 0;
end

% -----------------------------
% FOV intrusion
% -----------------------------
if ScanBias.fovintrusion.onoff==1
    CalPara.scanbias.fovintrusion.onoff = 1;
    CalPara.scanbias.fovintrusion.tb = ScanBias.fovintrusion.tb;
    CalPara.scanbias.fovintrusion.frac = ScanBias.fovintrusion.frac;
    
else
    CalPara.scanbias.fovintrusion.onoff = 0;
end

% -----------------------------
% conical-scanning cold-space mirror
% -----------------------------
if MirrorCold.error.onoff==1
    CalPara.mirrorcold.error.onoff = 1;
    CalPara.mirrorcold.error.slope = MirrorCold.error.slope;
    CalPara.mirrorcold.error.intercept = MirrorCold.error.intercept;
else
    CalPara.mirrorcold.error.onoff = 0;
end

% -----------------------------
% spillover etc
% -----------------------------
if AP.onoff==1
    CalPara.spillover.onoff = 1;
    CalPara.AP.frac.mainlobe = AP.frac.mainlobe;    % [Stokes,1,1,channel]
    CalPara.AP.frac.sidelobe = AP.frac.sidelobe;
    CalPara.AP.frac.spillover = AP.frac.spillover;
    
    CalPara.AP.tb.spillover = AP.tb.spillover;
    
    % parsing and converting Stokes to channel
    saterr_cal_para_parse_spillover
    
else
    CalPara.spillover.onoff = 0;
end

% -----------------------------
% reflector emission
% -----------------------------
if Reflector.emission.onoff==1
    CalPara.reflector.onoff = 1;
    CalPara.reflector.emission.E = Reflector.emission.E;
    CalPara.reflector.emission.tmp = Reflector.emission.tmp;
else
    CalPara.reflector.onoff = 0;
end

% -----------------------------
% warmload error
% -----------------------------
if WarmLoad.error.onoff==1
    CalPara.warmload.error.onoff = 1;
    CalPara.warmload.error.slope = WarmLoad.error.slope;
    CalPara.warmload.error.intercept = WarmLoad.error.intercept;
else
    CalPara.warmload.error.onoff = 0;
end

% -----------------------------
% crosspol contamiatnion
% -----------------------------
% crosspol 
if AP.crosspol.onoff==1
    CalPara.crosspol.onoff = 1;
    CalPara.crosspol.X = AP.crosspol.X;
    
    % Since only one polarization of a channel can be present in practice, the tb of cross-pol has to be specified
    CalPara.crosspol.scheme = 'same'; % same/linear/empirical
    switch CalPara.crosspol.scheme
        case 'same'
            CalPara.crosspol.coeff = [1,0]; % tb_pp = tb_pq*a + b; [2,channel]
        case 'linear'
            CalPara.crosspol.coeff = [0.9*ones(1,Rad.num_chan); 0*ones(1,Rad.num_chan)]; % tb_pp = tb_pq*a + b; [2,channel]
        case 'empirical'
            CalPara.crosspol.tb = zeros(Rad.ind_CT(1),Rad.num_alongtrack,Rad.num_chan); % tb of [crosstrack,alongtrack,channel]
    end
    
else
    CalPara.crosspol.onoff = 0;
end

% -----------------------------
% crosstalk
% -----------------------------
if Rad.crosstalk.onoff==1
    CalPara.crosstalk.onoff = 1;
    CalPara.crosstalk.X = Rad.crosstalk.X;
    
else
    CalPara.crosstalk.onoff = 0;
end

% -----------------------------
% Faraday
% -----------------------------
if Faraday.onoff==1
    CalPara.Faraday.onoff = 1;
    CalPara.Faraday.chan.omega = double(Faraday.chan.omega);
    CalPara.Faraday.chan.d = double(Faraday.chan.d);
    CalPara.Faraday.chan.U = double(Faraday.chan.U);
    
    Faraday = rmfield(Faraday,'chan');
else
    CalPara.Faraday.onoff = 0;
end

% -----------------------------
% reference tb
% -----------------------------
ref_tb_scene = double(AP.tb.tbscene);
ref_tb_mainlobe = double(AP.tb.mainlobe);
AP.tb = rmfield(AP.tb,'tbscene');
AP.tb = rmfield(AP.tb,'mainlobe');



