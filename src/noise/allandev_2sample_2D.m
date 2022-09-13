function adev = allandev_2sample_2D(A)
% columnar two-sample Allan deviation of 2D matrix
%
% Input:
%       A,     time series signal,    [n1,n2,n3,...]     n1=cross-track,n2=along-track,n3=channel,...
%
% Output:
%       adev,  allan deviation,       [n3,...]      variance along the column direction
%
% Example:
%       A=rand(4,2200,15); % 4=cross-track, 2200=along-track,15=channel
%       adev = allandev_2sample_2D(A); % one adev
%       A=rand(1,2200,15); 
%       adev = allandev_2sample_2D(A);
%   
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/07/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/20/2020: allow for n1=1

n1 = size(A,1);
if n1==1
    adev = sqrt(mean(1/2*diff(A,1,2).^2,2));
else
    adev = sqrt(mean(mean(1/2*diff(A,1,1).^2,1),2));
end

adev = squeeze(adev);
