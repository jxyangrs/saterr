function [tb,E] = saterr_imp_TBsourcesim_model(tb_source,freq)
% calculating TB per the tb source
%
% Input:
%       tb_source
%       freq,          frequency (GHz) for oceanic model,       scalar
%   implicit
%       TBsrc.Tas
%       Rad.
%           scanning info.    
%
% Output:
%       tb,           target tb (K),        [Stokes,1,1]/[Stokes,crosstrack,alongtrack]
%       E,            emissivity,           [Stokes,1,1]/[Stokes,crosstrack,alongtrack]
%
% Examples:
%       [tb,E] = saterr_imp_TBsource(TBsrc.source,[23.8])
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/21/2020: add TBsrc setting

global Rad TBsrc Orbit VarDynamic Const

tb = [];
E = [];

% build up scene TBsrc
switch tb_source

    case 'ocean'
        % -------------------------
        % ocean emission
        % -------------------------
        % setup is in saterr_set_poloffset.m
        % implement in saterr_imp_attitudeoffset.m
        if Orbit.onoff==1
            freq1 = freq;
            eia1 = Orbit.fov.eia;
            sst1 = TBsrc.ocean.sst;
            wind1 = TBsrc.ocean.wind;
            
            [EV1,EH1] = ocean_emissivity(sst1,freq1,wind1,eia1);
            
            tb(1,:,:) = sst1.*EV1;
            tb(2,:,:) = sst1.*EH1;
            tb(3,:,:) = 0;
            tb(4,:,:) = 0;
            
            E(1,:,:) = EV1;
            E(2,:,:) = EH1;
            E(3,:,:) = zeros(size(EV1));
            E(4,:,:) = zeros(size(EV1));
        else
            error('Turn on Orbit.onoff to get Earth incidence angle for calculating oceanic emission')
        end
        
    case 'cosmic'
        % -------------------------
        % cosmic background
        % -------------------------
        n1 = 1;
        n2 = 1;

        tb = zeros(4,n1,n2);
        E = zeros(4,n1,n2);
        
        tb(1:2,:,:) = Const.Tcosmic;
        E(1:2,:,:) = 1;
        
    case 'land'
        % -------------------------
        % land emission (constant emissivity)
        % -------------------------
        % setup is in saterr_set_poloffset.m
        % implement in saterr_imp_attitudeoffset.m
        if Orbit.onoff==1
            sfc_tmp = TBsrc.land.tmp;
            sfc_emis = TBsrc.land.E;
            
            tb(1,:,:) = sfc_tmp.*sfc_emis;
            tb(2,:,:) = sfc_tmp.*sfc_emis;
            tb(3,:,:) = 0;
            tb(4,:,:) = 0;
            
            E(1,:) = sfc_emis;
            E(2,:) = sfc_emis;
            E(3,:) = 0;
            E(4,:) = 0;
        else
            error('Turn on Orbit.onoff to get Earth incidence angle for calculating oceanic emission')
        end
        
    otherwise
        error('Error of tb_source')
        
end  



