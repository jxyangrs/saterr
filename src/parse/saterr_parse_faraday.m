% parsing Faraday rotation
%
% Output:
%       Faraday.iono.VTEC,      total electron content (TECU),              [cross-track,alongtrack]/scalar
%       Faraday.iono.h,         ionosphere altitude (km),                   scalar
%       Faraday.magfield.B,     magnetic field (nano Tesla),                'IGRF'/'customize'([cross-track,alongtrack]/scalar)
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code


if Faraday.onoff == 1 % 0=off,1=on
    
    % check size
    if strcmp(Faraday.magfield.source,'customized')
        n1 = Faraday.magfield.B;
        n2 = [Rad.num_alongtrack,Rad.num_crosstrack];
        
        if ~isequal(n1,n2)
            error('size error in customized magnetic field, Faraday.magfield.B')
        end
    end
    
    % check imported VTEC size
    if strcmp(Faraday.iono.source,'Import')
        n = size(Faraday.iono.VTEC);
        m = [Rad.ind_CT_num(1),Rad.num_alongtrack];
        if ~isequal(n,m)
            error('size of imported VTEC is wrong')
        end
    end
    
    % check timestep
    s = 0;
    s1 = sum(strcmp(Faraday.magfield.timestep,'EveryOrbit'));
    s = s + s1;
    s1 = sum(strcmp(Faraday.magfield.timestep,'EveryScan'));
    s = s + s1;
    s1 = sum(strcmp(Faraday.magfield.timestep,'constantTime'));
    s = s + s1;
    if s==0
        error('Faraday.magfield.timestep is wrong')
    end
end