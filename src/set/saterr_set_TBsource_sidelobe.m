function saterr_set_TBsource_sidelobe
% customizing sidelobe tb
%
% Input:
%       tb_source,                  customize_Table/customize_Function_Mainlobe
% Output:
%       TBsrc.tb_sidelobe.tb,       [Stokes,crosstrac,alongtrack,channel]
%       TBsrc.tb_sidelobe.func,     function of mainlobe
%
% Stokes is modified Stokes parameter [V,H,3,4]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/06/2019: original code

global Rad TBsrc AP

% -----------------------------
% setting
% -----------------------------
switch AP.tbsrc.sidelobe

    case 'customize_table'
        % -------------------------
        % customize sidelobe TB from an empirical Table
        % size of TB should be [Stokes,crosstrac,alongtrack,channel]
        % -------------------------
        
        % examples:
        % e.g. a uniform scene
        n1=4;n2=Rad.ind_CT_num(3);n3=Rad.num_alongtrack;n4=Rad.num_chan;
        tb = 10*ones(n1,n2,n3,n4);
        
        % output
        TBsrc.tb_sidelobe.tb = tb;
        
    case 'customize_sidefuncmain'
        % -------------------------
        % customize sidelobe TB from an empirical function of tb of mainlobe
        % making a function handle
        % -------------------------
        
        % examples:
        % tb_sidelobe = a*tb_mainlobe, where a=0.01
        f = @(x)0.01*x;
        % output
        TBsrc.tb_sidelobe.func = f;
        
    case {'constant'}
        % -------------------------
        % constant
        % -------------------------
        tb(1,1,1,:) = 280*ones(1,Rad.num_chan);
        tb(2,1,1,:) = 280*ones(1,Rad.num_chan);
        tb(3,1,1,:) = 0;
        tb(4,1,1,:) = 0;
        
        TBsrc.tb_sidelobe.tb = tb;

    otherwise
        error('TBsrc.source error')
end


% -------------------------
% check input
% -------------------------
switch AP.tbsrc.sidelobe
    case {'customize_table'}
        % check
        % ------------
        n = size(TBsrc.Tas);
        n1=4;n2=Rad.ind_CT_num(3);n3=Rad.num_alongtrack;n4=Rad.num_chan;
        if ~isequal(n,[n1,n2,n3,n4])
            error(['size of Tas should equal ',num2str(n(:)')])
        end
end

