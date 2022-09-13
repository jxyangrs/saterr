function [Tas] = saterr_imp_reflc_tas(Tas)
% main reflector emission
% 
% Input:
%       Tas,      [Stokes(V,H,3,4),crosstrack,alongtrack]
% 
% Output:
%       Tas,      [Stokes(V/H/QV/QH as approporiate),3,4),crosstrack,alongtrack] where V/H of Stokes -> QV/QH if any
%
% Description:
%       twist angle offset is included here if any
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/31/2019: enabling both crosstrack- and conical-scanning
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/19/2019: Stokes

global Reflector Rad PolOffset VarDynamic
nchan = VarDynamic.nchan;

switch Rad.scantype
    case 'crosstrack'
        % Trflc and E
        Trflc = [];
        Trflc(1,1,:) = Reflector.emission.tmp;
        E = Reflector.emission.E(:,nchan);
        
        % Tas
        [n1,n2,n3] = size(Tas); % [4-stokes,cross-track,along-track]
        if PolOffset.onoff
            theta = PolOffset.angpoloff_cs;
        else
            theta = Rad.scan.cs_angscan;
        end
        
        theta1 = [];
        theta1(1,1,:) = theta; % [1,1,crosstrack]
        M = mueller_reflc_ct(theta1); % [4,4,crosstrack];
        
        S = stokes_reflc_ct(E,Tas,Trflc); % [4-stokes,crosstrack,alongtrack]
        S = permute(S,[4,1,2,3]);   % [1,4-stokes,crosstrack,alongtrack]
        Tas = reshape(sum(bsxfun(@times,M,S),2),[n1,n2,n3]); % [4-stokes,crosstrack,alongtrack]
        
    case 'conical'
        E = Reflector.emission.E(:,nchan);
        
        [n1,n2,n3] = size(Tas);
        Trflc=[];
        Trflc(1,1,:) = Reflector.emission.tmp;
        Tas = stokes_reflc_conical(E,Tas,Trflc); % [4-stokes,crosstrack,alongtrack]
        
        if PolOffset.onoff
            theta1 = PolOffset.angle.offset_psi;
            M = mueller_reflc_ct(theta1);
            Tas = permute(Tas,[4,1,2,3]);
            Tas = reshape(sum(bsxfun(@times,M,Tas),2),[n1,n2,n3]);
           
        end
    otherwise
end





