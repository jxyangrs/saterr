function [ind,twm1,tcm1,cwm1,ccm1,Gm1,varargout] = cal2point_win(win_method,win_shape,nstr,tw,tc,cw,cc,varargin)
% two-point calibration w/ window moving average
% 
% Input:
%         win_method, smoothing method,       0/1/2, 0=constat,1=cut out tails,2=same length
%         win_shape,  smoothing window,       triang/rectwin
%         nstr,       size of stride window,  scalar
%         tw,         warm-load temperature,  2D [n1,n2] [along-track,cross-track]
%         tc,         cold space temperature, 1D [n1,1] [along-track,cross-track]
%         cw,         warm count,             2D [n1,n2] [along-track,cross-track]
%         cc,         cold space count,       2D [n1,n2] [along-track,cross-track]
%         cs,         scene count,            2D [n1,n2] [along-track,cross-track]
% Output:
%         ind,        index for smoothing,    1D [2,1]  [start-index, end-index]
%         twm1,       smoothed mean tw,       1D [n3,1] [along-track,cross-track]
%         tcm1,       smoothed mean tc,       1D [n3,1] [along-track,cross-track]
%         cwm1,       smoothed mean cw,       1D [n3,1] [along-track,cross-track]
%         ccm1,       smoothed mean cc,       1D [n3,1] [along-track,cross-track]
%         Gm1,        smoothed mean gain,     1D [n3,1] [along-track,cross-track]
%         varargout,  scene TB1,TB2,...,TBn,  2D [n3,n2] [along-track,cross-track]
% Examples:
%         [ind,twm1,tcm1,cwm1,ccm1,Gm1,tbs1,tbs2,tbs3] = cal2point_smooth(win_method,win_shape,nstr,tw,tc,cw,cc,cs1,cs2,cs3);
%         ind(1):ind(2)==size(twm1,1); cw(ind(1):ind(2),:) corresponds to valid smoothing sections of cwm1
% 
% Description:
%         Depending on win_method, n3<=n1
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/13/2018: allow multiple cs
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/04/2018: mean tcm
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/26/2019: constant cal added

% mean through cross-track
% -------------------------
ccm = mean(cc,2);
cwm = mean(cw,2);
twm = mean(tw,2); % tw has multiple PRTs
tcm = mean(tc,2); % tc often has only one PRT

% two-point calibration
% -------------------------

% methods
switch win_method
    case 0 % constant cal
        % moving average for the valid middle
        ccm1 = mean(ccm);
        cwm1 = mean(cwm) ;
        twm1 = mean(twm);
        tcm1 = mean(tcm);
        Gm1 = (cwm1-ccm1)./(twm1-tcm1);
                
        % 2-point calibration
        for i=1: length(varargin)
            cs = varargin{i};
            n1 = size(cs,1);
            tbs = (cs-ccm1)./Gm1+tcm1;
            varargout{i} = tbs;
        end
        ind = [1;n1];
        
    case 1 % shorter length w/ valid overlap
        [ccm1,cwm1,twm1,tcm1] = movingavg_cal(win_shape,0,nstr,ccm,cwm,twm,tcm);
        Gm1 = (cwm1-ccm1)./(twm1-tcm1);
        
        [n1] = size(ccm,1);
        ind = movingavg_idx_1D(n1,nstr);
        idx = false(n1,1);
        idx(ind(1):ind(end)) = 1;
        
        for i=1: length(varargin)
            cs = varargin{i};
            n2 = size(cs,2);
            tbs = (cs(idx,:)-ccm1(:,ones(n2,1)))./Gm1(:,ones(n2,1))+tcm1(:,ones(n2,1));
            varargout{i} = tbs;
        end
        
    case 2 % same length with expanded parameters to tails
        % moving average for the valid middle
        [ccm1,cwm1,twm1,tcm1] = movingavg_cal(win_shape,0,nstr,ccm,cwm,twm,tcm);
        Gm1 = (cwm1-ccm1)./(twm1-tcm1);
        [n1] = size(ccm,1);
        ind = movingavg_idx_1D(n1,nstr);
        
        % expand to tails 
        Gm2 = NaN(n1,1);
        ccm2 = NaN(n1,1);
        cwm2 = NaN(n1,1);
        twm2 = NaN(n1,1);
        tcm2 = NaN(n1,1);
        
        Gm2(ind(1):ind(2)) = Gm1;
        Gm2(1:ind(1)-1) = Gm1(1);
        Gm2(ind(2)+1:end) = Gm1(end);
        ccm2(ind(1):ind(2)) = ccm1;
        ccm2(1:ind(1)-1) = ccm1(1);
        ccm2(ind(2)+1:end) = ccm1(end);
        cwm2(ind(1):ind(2)) = cwm1;
        cwm2(1:ind(1)-1) = cwm1(1);
        cwm2(ind(2)+1:end) = cwm1(end);
        twm2(ind(1):ind(2)) = twm1;
        twm2(1:ind(1)-1) = twm1(1);
        twm2(ind(2)+1:end) = twm1(end);
        tcm2(ind(1):ind(2)) = tcm1;
        tcm2(1:ind(1)-1) = tcm1(1);
        tcm2(ind(2)+1:end) = tcm1(end);
        
        ccm1 = ccm2;
        cwm1 = cwm2;
        twm1 = twm2;
        tcm1 = tcm2;
        Gm1 = Gm2;
        
        ind = [1;n1];
        
        % 2-point calibration
        for i=1: length(varargin)
            cs = varargin{i};
            n2 = size(cs,2);
            tbs = (cs-ccm1(:,ones(n2,1)))./Gm1(:,ones(n2,1))+tcm1(:,ones(n2,1));
            varargout{i} = tbs;
        end
        
end

