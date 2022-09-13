function n = saterr_noise_poisson(x)
% Poisson noise
% 
% Input:
%     x,    signal
%   
% Output:
%     n,    noise
% 
% Note:
%     Poisson noise is signal dependent. 
%     Poisson noise/shot noise has a white spectrum as Gaussian noise, though of different characteristics in time domain.
%     This is pseudo Poisson noise, as we need to make it adjustable. 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/13/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/23/2020: positive lamda

xm = min(x(:));
if xm<0
    idx = x<0;
    x(idx) = -x(idx);
end
y = random('Poisson',x);
n = y-x;

