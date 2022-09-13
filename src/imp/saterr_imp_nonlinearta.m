function Tas = saterr_imp_nonlinearta(T_nl,Tc,Tw,Cc,Cw,Cs)
% implementing nonlinear correction to ta
% 
% Input:
%       T_nl,           peak nonlinearity of each channel (K),  scalar
%       Tc,             cold-space TB (K),                      [crosstrack,alongtrack]
%       Tw,             warm-load  TB (K),                      [crosstrack,alongtrack]
%       Cc,             cold-space count (Count),               [crosstrack,alongtrack]
%       Cw,             warm-load count (Count),                [crosstrack,alongtrack]
%       Cs,             scene count (Count),                    [crosstrack,alongtrack]
% 
% Output:
%       Tas,            scene count w/ nonlinearity (Count),    [crosstrack,alongtrack]
% 
% Description:
%       The receiver nonlinearity is written as
%               Tas  = Tc + X(Tw-Tc) + 4*T_nl*X*(1-X),          (1)
%       where Tas is the scene antenna temperature w/ nonlinearity (K), Tc is cold-space TB (K), Tw is warm-load TB (K), T_nl is the peak nonlinearity (K)
%       and X=(Cs-Cc)/(Cw-Cc) with Cs,Cc,Cw for scene count, cold count, and warm count respectively.
%       The first term, Tc + X(Tw-Tc), is the linear part, and 4*T_nl*X*(1-X) is the nonlinear part.
%       To remove the nonlinearity
%               Tas' = Tas - 4*T_nl*X*(1-X),                     (4)
%       where Tas' is nonlinearity free, Tas is w/ nonlinearity
%       
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/31/2019: original code

Tc = mean(Tc,1);
Tw = mean(Tw,1);
Cc = mean(Cc,1);
Cw = mean(Cw,1);

X = bsxfun(@times, bsxfun(@minus, Cs, Cc), 1./(Cw-Cc));
Tas  = bsxfun(@plus, bsxfun(@times,X,Tw-Tc), Tc+4*T_nl*X.*(1-X));


