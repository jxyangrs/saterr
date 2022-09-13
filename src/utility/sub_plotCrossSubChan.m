function sub_plotCrossSubChan(ncross,tb,plotstr)
% plot cross-track parameters for each channel (can have asc/des)
%
% Input:
%   ncross, number of cross-track; 1D
%   tb, TB; 2D or 3D; 2D [cross,subplot], 3D [cross,subplot,legend]
%   plotstr. (struct): 
%           legend,xlabel,ylabel,savename,outpath
%           optional: rangeylim
% 
% Output: plots of cross-track 2 subplot [asc/des]
%   e.g., TMI-hot-5ana-cross-20050701-20060630.png
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/15/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/09/2018: auto/manul ylim

% setting of delta ylim
if isfield(plotstr,'rangeylim')
    rangeylim = 1.5;
end

% setting plot
SLW = 2;
SFS = 14;

% execute
outfile = plotstr.savename;
% smooth TB
% tb = sub_tbSmoothNAN(tb);
%
[~,n2,n3] = size(tb);

% plot
figure(1)
set(gcf,'paperposition',[0.1 0.1 8 6]*2.5)

n1row = ceil(sqrt(n2));
n2col = ceil(n2/n1row);
    
XLim = [min(ncross)-1,max(ncross)+1];

if n3==1 % no asc/des
    for m=1: n2
        subplot(n1row,n2col,m)
        y = tb(:,m);
        plot(ncross,y,'LineWidth',SLW);
        hold on
        
        xlabel(plotstr.xlabel,'FontSize',SFS)
        ylabel([plotstr.ylabel],'FontSize',SFS)
        title(plotstr.title{m},'FontSize',SFS)
        set(gca,'FontSize',SFS)
        
        temp = nanmean(y(:));
        if isfield(plotstr,'rangeylim')
            YLim = [temp-rangeylim/2,temp+rangeylim/2];
        else
            YLim = 'auto';
        end
        ylim(YLim)
        xlim(XLim)
    end
elseif n3>=2 % asc/des
    % uni-legend for all subplots
    tb = permute(tb,[1 3 2]);
    for m=1: n2
        subplot(n1row,n2col,m)
        y = tb(:,:,m);
        plot(ncross,y,'LineWidth',SLW);
        hold on
        
        xlabel(plotstr.xlabel,'FontSize',SFS)
        ylabel([plotstr.ylabel],'FontSize',SFS)
        title(plotstr.title{m},'FontSize',SFS)
        if m==1
            if ~isempty(plotstr.legend)
                legend(plotstr.legend)
                legend('boxoff')
            end
        end
        set(gca,'FontSize',SFS)
        
        temp = nanmean(y(:));
        if isfield(plotstr,'rangeylim')
            YLim = [temp-rangeylim/2,temp+rangeylim/2];
        else
            YLim = 'auto';
        end
        ylim(YLim)
        xlim(XLim)
    end
end

print(1,'-dpng','-r150',[plotstr.outpath,outfile,'.png'])
close(1)