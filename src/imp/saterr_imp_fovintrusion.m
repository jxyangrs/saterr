function Tas = saterr_imp_fovintrusion(Tas)
% implementation for FOV intrusion
%
% Input:
%       Tas,      Stokes w/o fov intrusion,          [Stokes,crosstrack,along-track]
% 
% Output:
%       Tas,      Stokes w/ fov intrusion,           [Stokes,crosstrack,along-track]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/16/2019: parameterize fraction w/ Gaussian pattern

global Rad ScanBias VarDynamic

nchan = VarDynamic.nchan;
indpol = Rad.chanpol_ind(nchan);

if ScanBias.fovintrusion.onoff==1
    switch ScanBias.fovintrusion.type
        case 'customize'
            tb = ScanBias.fovintrusion.tb(nchan);
            f = ScanBias.fovintrusion.frac(:,nchan);
            
            f = f(:)';
            
            Tas = tb.*f+Tas.*(1-f);
            
        case 'example'
            tb = ScanBias.fovintrusion.tb(nchan);
            f = ScanBias.fovintrusion.frac(:,nchan);
            
            f = f(:)';
            
            Tas = bsxfun(@plus, tb.*f, bsxfun(@times,Tas,1-f));
           
        otherwise
            error('Error of ScanBias.fovintrusion.type')
            
    end
end
