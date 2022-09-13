function hist2d  = sub_hist2(x,y,xedges,yedges)
% compute 2 dimensional histogram
%
% Input:
% x, x coordinate; 1D [coordinate,1]
% y, y coordinate; 1D [coordinate,1]
% xedges, edge of x bin; 1D [coordinate,1]; for each bin, bin1<=x & x<bin2
% yedges, edge of y bin; 1D [coordinate,1]
%
% Output:
% hist2d, number of histogram; 2D [xedges,yedges]
%
% Example:
% x=rand(300,1)*10+280;y=rand(300,1)*10+100;xedges=[280:0.5:290];yedges=[100:1:110];
% hist2d  = sub_hist2(x,y,xedges,yedges);
% pcolor(xedges,yedges,hist2d); colorbar
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 9/15/2016

idx = xedges(1)<=x & x<=xedges(end) & yedges(1)<=y & y<=yedges(end);
x = x(idx);
y = y(idx);

[~,xbin] = histc(x,xedges);
[~,ybin] = histc(y,yedges);

nx = length(xedges);
ny = length(yedges);
xy = ybin+(xbin-1)*(ny);
xyuni = unique(xy);
n = histc(xy,xyuni);

hist2d = zeros(ny,nx);
hist2d(xyuni) = n;

