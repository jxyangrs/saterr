function x = saterr_noise_fft1(alpha,n)
% FFT based noise simulating w/ double FFT transform
%
% Input:
%     alpha,    power spectrum slope,    PSD = f^alpha
%     n,        number of samples
%
% Output:
%     x,        noise w/ non-zero mean and non-unity std,       mean and std follow Gaussian noise
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/14/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/31/2019: rng
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/06/2019: non-zero mean and non-unity std

switch alpha
    case 0
        x = randn(n,1);
    otherwise
        if rem(n,2)
            n1 = (n+1)/2;
            n2 = n1;
        else
            n1 = n/2+1;
            n2 = n1-1;
        end
        
        x = randn(n,1);
        xm = mean(x);
        xstd = std(x);
        Y = fft(x);
        Y = Y(1:n1).*((1:n1)'.^(alpha/2));
        Y = [Y;conj(Y(n2:-1:2))];
        x = real(ifft(Y));
        
        x = x-mean(x);
        x = x/std(x);
        
        x = x*xstd;
        x = x + xm;
end
