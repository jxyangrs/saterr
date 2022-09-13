function saterr_set_noisesigdep
% setting signal-dependent noise 
%
% Input:
%       setting shot noise that is signal-dpenent 
%
% Output:
%       shot noise setting
%
% Note:
%     Shot noise is Poisson noise that is signal dependent. 
%     Poisson noise/shot noise has a white spectrum as Gaussian noise, but of different characteristics in time domain.
%     This is pseudo Poisson noise, as we need to make it adjustable. 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/13/2019: subset of noise

global Noise Rad

% -----------------------------
% setting
% -----------------------------
Noise.shotnoise.onoff = 0; % 0=off,1=on

Noise.shotnoise.std_control = 1; % 0=no control,1=control
if Noise.shotnoise.std_control==1
    Noise.shotnoise.std = 1*ones(Rad.num_chan,1); % std of shot noise (Kelvin), [channel,1]
end



