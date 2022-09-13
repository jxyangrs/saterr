function [noise_mix,noise_sub] = saterr_noise_sim_sub(n,noise_name,noise_amp_std,vargin)
% simulate different noises w/ std=1
%
% Input:
%       n,              number of noise,        scalar
%       noise_name,     noise name,             string          
%       noise_amp_std,  noise std,              
%       vargin,         slope of noise PSD, or polynomial coefficients
%
% Output:
%       noise_mix,      blended noise,          [n1,1];n1=length,n2=noise type,     std=1;mean is random, std(noise_mix,0,1) = 1  
%       noise_sub,      sub-noise,              [n1,n2];n1=length,n2=noise type,    std=1;mean is random, std(noise_sub,0,1) = noise_amp_std
%
% Examples:
%       n = 1000; % number of noise
%       [noise_mix,noise_sub] = saterr_noise_sim_sub(1000,{'white','1/f'},[1,1]);
%       [noise_mix,noise_sub] = saterr_noise_sim_sub(1000,{'fft','fft'},[1,1],[-2,-1]);
%       [noise_mix,noise_sub] = saterr_noise_sim_sub(1000,{'poly','poly'},[1,1],{[1,1,1],[-1,2]});
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/10/2019: polynomial drift and parse


% -------------------------
% generate noise_mix with unit STD
% -------------------------
noise_set = [];
for i=1: length(noise_name)
    
    % -------------------------
    % parse
    % -------------------------
    % fft
    if strcmp(noise_name{i},'fft')
        if nargin~=4
            error('FFT input should have alpha input')
        end
        alpha = vargin;
        if ~isnumeric(alpha)
            error('FFT input should have alpha input')
        end
        if length(noise_amp_std)~=length(alpha)
            error('length of noise_amp_std and alpha is mismatch')
        end
    end
    
    % polynomial
    if strcmp(noise_name{i},'poly')
        if nargin~=4
            error('poly input should have alpha input')
        end
        p = vargin;
        if length(noise_amp_std)~=length(p)
            error('length of noise_amp_std and p is mismatch')
        end
    end
    
    % -------------------------
    % noise simulation
    % -------------------------
    switch noise_name{i}
        case 'poly'
            % linear drift
            t = linspace(0,1,n);
            p1 = p{i};
            y1 = polyval(p1,t);
            y1 = y1 - mean(y1);
            y1 = y1/std(y1);
            y1 = y1(:);
            noise_set(:,i) = y1;
        case {'thermal','AWGN','1/f','flicker','quantization',...
                'RRFM','FWFM','RWFM','FFM','WFM','FPM','WPM',...
                'violet','blue','white','pink','red'}
            y1 = saterr_noise_source(noise_name{i},n);
            noise_set(:,i) = y1;
        case {'fft'}
            y1 = saterr_noise_source(noise_name{i},n,alpha(i));
            noise_set(:,i) = y1;
        otherwise
            error(['noise name is wrong: ',noise_name{i}])
    end
end

% -------------------------
% adjust noise_mix STD
% -------------------------
std1 = std(noise_set,0,1);
noise_sub = bsxfun(@rdivide,noise_set,std1);
noise_sub = bsxfun(@times,noise_sub,noise_amp_std);

% -------------------------
% sum noise_mix
% -------------------------
noise_mix = sum(noise_sub,2);
noise_mix = noise_mix/std(noise_mix,1);

