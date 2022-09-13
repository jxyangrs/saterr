function [tw_PRT] = saterr_imp_noisePRT(tw_PRT)
% implement adding of PRT noise
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/23/2019: adding option of quantization
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: implement tw_PRT

global Noise VarDynamic
nchan = VarDynamic.nchan;
[n1,n2] = size(tw_PRT);

tw_PRT_noise = 0;
if Noise.PRT.onoff
    switch Noise.PRT.type
        case 'Gaussian'
            tw_PRT_noise = randn(n1*n2,1)*Noise.PRT.std(nchan);
            tw_PRT_noise = reshape(tw_PRT_noise,[n1,n2]);
        case 'Quantization'
            x = noise_fft1(2,n1*n2);
            tw_PRT_noise = x*Noise.PRT.std(nchan);
            tw_PRT_noise = reshape(tw_PRT_noise,[n1,n2]);
        otherwise
            error('Error of Noise.PRT.type')
    end
end
tw_PRT = tw_PRT + tw_PRT_noise;


