function [Tac,Taw] = saterr_imp_reflc_tacw(Tac,Taw)
% radiance reflected off the reflector including reflector emission if any
% 
% Input:
%       Tac,      cold-space Stokes w/ reflector emission,,     [Stokes(V,H,3,4),crosstrack,alongtrack]
%       Taw,      warm-load Stokes w/ reflector emission,,      [Stokes(V,H,3,4),crosstrack,alongtrack]
% 
% Output:
%       Tac,      cold-space Stokes w/ reflector emission,      [Stokes,crosstrack,alongtrack] where V/H of Stokes -> QV/QH if any
%       Taw,      warm-load Stokes w/ reflector emission,,     	[Stokes,crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/11/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/31/2019: for both cross-scanning and conical-scanning radiometers
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/19/2019: Stokes

global Reflector Rad PolOffset VarDynamic
nchan = VarDynamic.nchan;

switch Rad.scantype
    case 'crosstrack'
        % Tf and E
        Tf = [];
        Tf(1,1,:) = Reflector.emission.tmp;
        E = Reflector.emission.E(:,nchan);
        
        % Tac
        [n1,n2,n3] = size(Tac);
        theta = Rad.scan.cc_angscan;
        
        theta1 = [];
        theta1(1,1,:) = theta;
        M = mueller_reflc_ct(theta1);
        
        S = stokes_reflc_ct(E,Tac,Tf);
        S = permute(S,[4,1,2,3]);
        Tac = squeeze(sum(bsxfun(@times,M,S),2));
        
        % Taw
        [n1,n2,n3] = size(Taw);
        theta = Rad.scan.cw_angscan;
        
        theta1 = [];
        theta1(1,1,:) = theta;
        M = mueller_reflc_ct(theta1);
        
        S = stokes_reflc_ct(E,Taw,Tf);
        S = permute(S,[4,1,2,3]);
        Taw = squeeze(sum(bsxfun(@times,M,S),2));
        
    case 'conical'
        E = Reflector.emission.E(:,nchan);
        
        % Tac
        [n1,n2,n3] = size(Tac);
        Tf=[];
        Tf(1,1,:) = Reflector.emission.tmp;
        Tac = stokes_reflc_conical(E,Tac,Tf); 
        
        if PolOffset.onoff
            theta1 = PolOffset.angle.offset_psi;
            M = mueller_reflc_ct(theta1);
            Tac = permute(Tac,[4,1,2,3]);
            Tac = reshape(sum(bsxfun(@times,M,Tac),2),[n1,n2,n3]);
        end
        
        % Taw
        [n1,n2,n3] = size(Taw);
        Tf=[];
        Tf(1,1,:) = Reflector.emission.tmp;
        Taw = stokes_reflc_conical(E,Taw,Tf); 
        
        if PolOffset.onoff
            theta1 = PolOffset.angle.offset_psi;
            M = mueller_reflc_ct(theta1);
            Taw = permute(Taw,[4,1,2,3]);
            Taw = reshape(sum(bsxfun(@times,M,Taw),2),[n1,n2,n3]);
        end
        
    otherwise
end





