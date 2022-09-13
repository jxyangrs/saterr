function x = saterr_noise_source(noise_type,n,alpha)
% simulate different noises with different slope in power spectrum
%
% Input:
%       noise_type,     type of noise,                  string (fft/specified type as in Table of noise type)
%       n,              length of noise array,          sclar
%       alpha,          log slope of power spectrum,    sclar 
%                       (alpha in S=f^alpha)
% Output:
%       noise,          random noise,                   [n,1]
% 
% Example:
%       noise_type = 'fft'; n = 1000; alpha = -2;
%       x = noise_simulator_source(noise_type,n,alpha)
% 
%       noise_type = 'white'; n = 1000;
%       x = noise_simulator_source(noise_type,n)
% 
% Table of noise type:
%       Noise type,     Description,                                    Slope of PSD  (S=f^alpha; S is PSD; slope=alpha)      
%       RWFM,           random walk frequency modulation (RWFM),        -4                    
%       FFM,            flicker frequency modulation (FFM),             -3                    
%       WFM,            white frequency modulation (WFM),               -2                    
%       1/f,            flicker noise,                                  -1                    
%       FPM,            flicker phase modulation (FPM),                 -1                    
%       thermal,        thermal (Additive White Gaussian Noise,AWGN),   0
%       WPM,            white phase modulcation (WFM),                  0
%       FPM,            frequency phase modulation (FPM),               1                    
%       quantization,   quantization                                    2,              
%       others,         other power-law noise or w/ diff. names,        alpha
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/01/2019: add help
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/18/2019: randn normalizing
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/06/2019: non-zero mean and non-unity std

global Noise

saterr_imp_noiserng

switch noise_type
    % -------------------
    % input slope
    % -------------------
    case 'fft'
        x = saterr_noise_fft1(alpha,n);
    
    % -------------------
    % input name of noise
    % -------------------
    case {'RRFM'}
        x = saterr_noise_fft1(-4,n);
    case {'FWFM'}
        x = saterr_noise_fft1(-3,n);
    case {'RWFM','red'}
        x = saterr_noise_fft1(-2,n);
    case {'1/f','flicker','FFM','pink'}
        x = saterr_noise_fft1(-1,n);
    case {'thermal','white','AWGN','WFM'}
        x = randn(n,1);
    case {'FPM','blue'}
        x = saterr_noise_fft1(1,n);
    case {'quantization','WPM','violet'}
        x = saterr_noise_fft1(2,n);
end


