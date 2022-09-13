function [Tas,Tac,Taw] = saterr_imp_poisson(Tas,Tac,Taw)
% implementing shot noise
%
% Input/Output:
%       Tas,      [crosstrack,alongtrack]   
%       Tac,      [crosstrack,alongtrack]
%       Taw,      [crosstrack,alongtrack]
% Note:
%     Shot noise is Poisson noise that is signal dependent. 
%     Poisson noise/shot noise has a white spectrum as Gaussian noise, though of different characteristics in time domain.
%     This is pseudo Poisson noise, as we need to make it adjustable. 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/13/2019: rng seed

global Rad Noise VarDynamic


if Noise.shotnoise.onoff==1
    saterr_imp_noiserng
    nchan = VarDynamic.nchan;
    
    M = [Tas;Tac;Taw];
    s = saterr_noise_poisson(M);
    
    if Noise.shotnoise.std_control==1
        [n1,n2,n3] = size(s);
        s = permute(s,[2,3,1]);
        s = reshape(s,[n2*n3,n1]);
        c = zeros(1,n1);
        t = std(s,0,1);
        idx = t~=0;
        c(idx) = 1./t(idx)*Noise.shotnoise.std(nchan);
        s = s.*c;
        s = reshape(s,[n2,n3,n1]);
        s = permute(s,[3,1,2]);
    end
    
    ind = 1: Rad.ind_CT_num(1);
    Tas = Tas + s(ind,:);
    ind = Rad.ind_CT_num(1)+1: sum(Rad.ind_CT_num(1:2));
    Tac = Tac + s(ind,:);
    ind = sum(Rad.ind_CT_num(1:2))+1: sum(Rad.ind_CT_num(1:3));
    Taw = Taw + s(ind,:);
    
end
