function sub_plotDirectHist2DFit(x,y,z,plotstr)
% 2D colorful and linear regression; calculate hist2d in this code
% e.g., DD Vs TB for one single channel, plus linear regression
%
% Input:
%       x, 2D [n2,1]; y, 2D [n1,1]; z, 2D [n1,n2]
%       plotstr. (strcut),
%           savename,outpath,xlabel,ylabel,title
%
% Output:
%       figure saved
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/27/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 2/15/2017: add xlim ylim

% setting of plot
PlotShading = 'flat'; % interp/flat; have difference when NaN elements exist
J = plot_colormap_whitejet(64);
J = J(end/2:end,:);

PlotSizeLabel = 14;
PlotSizeLegend = 14;
PlotSizeTick = 14;

% preprocess
x1 = x(:)';y1 = y(:);
n1 = size(y1,1);n2 = size(x1,2);
x1 = x1(ones(n1,1),:);x1 = x1(:);
y1 = y1(:,ones(n2,1));y1 = y1(:);
z1 = z(:);

% filter out NaN and 0
idx = ~(isnan(z1) | z1==0);
if sum(idx)>0
    x1 = x1(idx); y1=y1(idx);z1=z1(idx);
else
    z1(idx) = 0;
end

% xlim, ylim
if isfield(plotstr,'xlim')
    XLim = plotstr.xlim;
else
    XLim = [floor(min(x1)),ceil(max(x1))];
end
if isfield(plotstr,'ylim')
    YLim = plotstr.ylim;
else
    YLim = [floor(min(y1)),ceil(max(y1))];
end

% linear fitting
if ~isempty(x1)
    fitp = polyfitweighted(x1,y1,1,z1);
    p1 = fitp(1);
    p2 = fitp(2);
end

% plot
figure(1)
set(gcf,'paperposition',[1 1 6 4]*1.5)

idx = z==0;
z(idx) = NaN;
pcolor(x,y,z)
shading(PlotShading)
colormap(J)

h = colorbar;
title(h,'No.')

hold on

if ~isempty(x1)
    plot(XLim,[0,0],'k')
    h = plot(XLim,[XLim(1)*p1+p2,XLim(end)*p1+p2],'r');
    hl = legend(h,sprintf('Y=%.3f*X%+.3f',p1,p2));
    legend boxoff
    set(hl,'FontSize',PlotSizeLegend)
end

xlim(XLim)
ylim(YLim)

xlabel(plotstr.xlabel,'FontSize',PlotSizeLabel)
ylabel(plotstr.ylabel,'FontSize',PlotSizeLabel)
set(gca,'fontsize',PlotSizeTick)
% if isfield(plotstr,'title')
    title(plotstr.title,'FontSize',PlotSizeLabel);
% end

print(1,'-dpng','-r300',[plotstr.outpath,plotstr.savename,'.png'])
close 1
