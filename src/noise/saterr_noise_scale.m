function noise_ts = saterr_noise_scale(ind_CT,noise_sub,std_tbs,std_tbc,std_tbw,std_tbnull)
% scale individual noises of scene, cold, warm, null and produce sum-up and individual noise
%   when number of individual noises>=2, individual sub noise is scaled w/ total variance in addition to sum-up. 
%   E.g. std_tbc = [1,1]; 
%   std(noise_ts,0,1) = [1.4,1.4,1.4];
% 
% Input:
%       ind_CT      {ind1,ind2,ind3,ind4}   for cs,cc,cw,cnull
%       noise_sub   [n1,n2,n3]              [cross-track,along-track,noise type]
%       std_tbs     [1,n3]                  scene
%       std_tbc     [1,n3]                  cold cosmic background
%       std_tbw     [1,n3]                  warm-load
%       std_tbnull  [1,n3]                  null measurement
%        
% Output:
%       noise_ts,   sumup and individual    [n1,n2,n4], n4=[sumup,individual_1,individual_2,...]   n3=1: n4=1; n3>1: n4=n3+1
% 
% Example:
%   e.g.1
%       ind_CT = {[1,4],[5,8],[9 10;11 12],[13 20]};
%       noise_sub = rand(10,1);
%       std_tbc = 1;...
%       noise_ts = saterr_noise_scale(noise_sub,std_tbs,std_tbc,std_tbw,std_tbnull)
%       size(noise_ts) = [10,1]
%   e.g.2
%       ind_CT = {[1,4],[5,8],[9 10;11 12],[13 20]};
%       noise_sub = rand(10,2);
%       std_tbc = [1,1];...
%       noise_ts = saterr_noise_scale(noise_sub,std_tbs,std_tbc,std_tbw,std_tbnull)
%       size(noise_ts) = [10,3]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2018: reorder starting w/ cs
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/07/2019: enable flexible cross-track input


if size(noise_sub,3)==1
    % sum up individual per their percentage
    scale_tbc = std_tbc;
    scale_tbw = std_tbw;
    scale_tbs = std_tbs;
    scale_tbnull = std_tbnull;
    noise_ts = sub_noise_scale(ind_CT,noise_sub,scale_tbs,scale_tbc,scale_tbw,scale_tbnull);
else
    % sum up individual with STD=total
    scale_tbc = std_tbc;
    scale_tbw = std_tbw;
    scale_tbs = std_tbs;
    scale_tbnull = std_tbnull;
    noise_ts(:,:,1) = sub_noise_scale(ind_CT,noise_sub,scale_tbs,scale_tbc,scale_tbw,scale_tbnull);
    
    % individual with STD=total
    scale_tbc = sqrt(sum(scale_tbc.^2));
    scale_tbw = sqrt(sum(scale_tbw.^2));
    scale_tbs = sqrt(sum(scale_tbs.^2));
    scale_tbnull = sqrt(sum(scale_tbnull.^2));
    for i=1: size(noise_sub,3)
        noise_ts(:,:,1+i) = sub_noise_scale(ind_CT,noise_sub(:,:,i),scale_tbs,scale_tbc,scale_tbw,scale_tbnull);
    end
end


function noise_ts = sub_noise_scale(ind_CT,noise_sub,scale_tbs,scale_tbc,scale_tbw,scale_tbnull)
% Input:
%       ind_CT          index of cross-track      {ind_tbs,ind_tbc,ind_tbw,ind_null}
%       noise_sub       [n1,n2,n3]                [cross-track,along-track,noise type]
%       scale_tbs       std                       [1,n3], [noise type]    
%       scale_tbc       std                       [1,n3], [noise type]    
%       scale_tbw       std                       [1,n3], [noise type]    
%       scale_tbnull,   std                       [1,n3], [noise type]    
% 
% Output:
%       noise_ts        time series noise         [n1,n2], [FOV noise]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2018: reorder starting w/ cs
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/07/2019: enable flexible cross-track input

% cs noise scaled
ind = ind_CT{1};
if ~isempty(ind)
    M = scale_tbs;
    w = [];
    w(1,1,:) = M(:);
    
    % normalize std=1
    A = noise_sub(ind,:,:);
    [n1,n2,n3] = size(A);
    A = reshape(A,[n1*n2,n3]);
    b = std(A,0,1);
    A = bsxfun(@rdivide,A,b);
    A = reshape(A,[n1,n2,n3]);
    
    noise_sub(ind,:,:) = bsxfun(@times,A,w);
end

% cc noise scaled
ind = ind_CT{2};
if ~isempty(ind)
    M = scale_tbc;
    w = [];
    w(1,1,:) = M(:);

    % normalize std=1
    A = noise_sub(ind,:,:);
    [n1,n2,n3] = size(A);
    A = reshape(A,[n1*n2,n3]);
    b = std(A,0,1);
    A = bsxfun(@rdivide,A,b);
    A = reshape(A,[n1,n2,n3]);
    
    noise_sub(ind,:,:) = bsxfun(@times,A,w);
end

% cw noise scaled
ind = ind_CT{3};
if ~isempty(ind)
    M = scale_tbw;
    w = [];
    w(1,1,:) = M(:);

    % normalize std=1
    A = noise_sub(ind,:,:);
    [n1,n2,n3] = size(A);
    A = reshape(A,[n1*n2,n3]);
    b = std(A,0,1);
    A = bsxfun(@rdivide,A,b);
    A = reshape(A,[n1,n2,n3]);
    
    noise_sub(ind,:,:) = bsxfun(@times,A,w);
end
% c_null noise scaled
ind = ind_CT{4};
if ~isempty(ind)
    M = scale_tbnull;
    w = [];
    w(1,1,:) = M(:);

    % normalize std=1
    A = noise_sub(ind,:,:);
    [n1,n2,n3] = size(A);
    A = reshape(A,[n1*n2,n3]);
    b = std(A,0,1);
    A = bsxfun(@rdivide,A,b);
    A = reshape(A,[n1,n2,n3]);
    
    noise_sub(ind,:,:) = bsxfun(@times,A,w);
end

% sum up if any
noise_ts = sum(noise_sub,3);
