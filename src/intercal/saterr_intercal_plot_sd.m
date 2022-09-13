    %% plot setting
    
    % setting common strings
    strsavenameX = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename];
    strX = [TarRadDataInfo.rad,'-',RefRadDataInfo.rad];
    strX = strrep(strX,' Uni','');
    strRef = [RefRadDataInfo.rad];
    strRef = strrep(strRef,' Uni','');
    strTar = [TarRadDataInfo.rad];
    strTar = strrep(strTar,' Uni','');
    
    % set channel name for labeling
    if sum(strcmp(TarRadSpc.rad,{'AMSUA','atms'})) % chan-No(full name)
        tarchanname=strcat('chan-',cellstr(num2str(TarRadSpc.chanind')),'(',TarRadSpc.chanstrdecimal',')');
        tarchanname=strrep(tarchanname,' ','');
    else % full name
        tarchanname=TarRadSpc.chanstrdecimal;
        tarchanname=strrep(tarchanname,' ','');
    end
    if sum(strcmp(RefRadSpc.rad,{'AMSUA','atms'})) % chan-No(full name)
        refchanname=strcat('chan-',cellstr(num2str(RefRadSpc.chanind')),'(',RefRadSpc.chanstrdecimal',')');
        refchanname=strrep(refchanname,' ','');
    else % full name
        refchanname=RefRadSpc.chanstrdecimal;
        refchanname=strrep(refchanname,' ','');
    end
    
    % basic statistics
    % hist1 DD
    figure(1)
    plot(BinTBDD,hist1_tbdd(:,:,1));
    xlabel([strX,' TB DD (K)']);ylabel('No.');legend(TarRadSpc.chanstr{TarIndDD});legend boxoff
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-hist1-tbdd','-',DateBegin,'-',DateEnd])
    close 1
    % hist1 tbdif
    figure(1)
    plot(BinTBDD,hist1_tbdif(:,:,1));
    xlabel([strX,' TB Dif (K)']);ylabel('No.');legend(TarRadSpc.chanstr{TarIndDD});legend boxoff
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-hist1-tbdif','-',DateBegin,'-',DateEnd])
    close 1
    % hist1 ttb
    figure(1)
    plot(BinTB,hist1_ttb(:,:,1));
    xlabel([strTar,' TB Obs (K)']);ylabel('No.');legend(TarRadSpc.chanstr);legend boxoff
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-hist1-ttb','-',DateBegin,'-',DateEnd])
    close 1
    % hist1 ttbsim
    figure(1)
    plot(BinTB,hist1_ttbsim(:,:,1));
    xlabel([strTar,' TB Sim (K)']);ylabel('No.');legend(tarchanname);legend boxoff
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-hist1-ttbsim','-',DateBegin,'-',DateEnd])
    close 1
    % hist1 ttbsd
    figure(1)
    plot(BinTBDD,hist1_ttbsd(:,:,1));
    xlabel([strTar,' TB SD (K)']);ylabel('No.');legend(tarchanname);legend boxoff
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-hist1-ttbsd','-',DateBegin,'-',DateEnd])
    close 1
    % hist1 rtbsd
    figure(1)
    plot(BinTBDD,hist1_rtbsd(:,:,1));
    xlabel([strRef,' TB SD (K)']);ylabel('No.');legend(refchanname);legend boxoff
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-hist1-rtbsd','-',DateBegin,'-',DateEnd])
    close 1
    
    % time series mean
    % common setting
    tsplotstr.outpath=outpath;
    x = ndate(:);
    % merged plot for all channels
    % day_num
    y = day_num(:,:,1); y=y';
    tsplotstr.modesub=1;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strX,' No.'];tsplotstr.title={''};tsplotstr.savename=[strX,'-',CodeFun,'-time-daynum-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.modefit.opt=0;
    sub_plottimeseries(x,y,tsplotstr)
    % day_rtime
    y = day_rtime(:,:,1); y=y(:);
    y = datevec(y);y=y(:,4)+y(:,5)/60;
    tsplotstr.modesub=1;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strX,' UTC Hour'];tsplotstr.title={''};tsplotstr.savename=[strX,'-',CodeFun,'-time-dayhourUTC-',DateBegin,'-',DateEnd];
    tsplotstr.ylim=[0 24];
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % day_hourlocal
    y = day_timelocal(:,:,1); y=y(:);
    y = datevec(y);y=y(:,4)+y(:,5)/60;
    tsplotstr.modesub=1;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strX,' Local Hour'];tsplotstr.title={''};tsplotstr.savename=[strX,'-',CodeFun,'-time-dayhourLocal-',DateBegin,'-',DateEnd];
    tsplotstr.ylim=[0 24];
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % day_tbdd
    y = day_tbdd(:,:,1); y=y';
    tsplotstr.modefit.opt=0;
    tsplotstr.modesub=0;
    title_major=[strX,' TB DD'];tsplotstr.title{1}={title_major};
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB DD (K)'];
    tsplotstr.legend=TarRadSpc.chanstrdecimal;
    tsplotstr.savename=[strX,'-',CodeFun,'-time-tbdd-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.datetick='yy/mm';
    sub_plottimeseries(x,y,tsplotstr)
    % day_ttb
    y = day_ttb(:,:,1); y=y';
    tsplotstr.modefit.opt=0;
    tsplotstr.modesub=0;
    title_major=[strX,' TB'];tsplotstr.title{1}={title_major};
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
    tsplotstr.legend=TarRadSpc.chanstrdecimal;
    tsplotstr.savename=[strX,'-',CodeFun,'-time-ttb-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.datetick='';
    sub_plottimeseries(x,y,tsplotstr)
    % day_ttbsd
    y = day_ttbsd; y=y';
    tsplotstr.modefit.opt=0;
    tsplotstr.modesub=0;
    title_major=[strTar,' TB SD'];title_sub=TarRadSpc.chanstrdecimal;tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strTar,' TB SD (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-ttbsd-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    sub_plottimeseries(x,y,tsplotstr)
    % day_ttbsim
    y = day_ttbsd; y=y';
    tsplotstr.modefit.opt=0;
    tsplotstr.modesub=0;
    title_major=[strTar,' TB Sim'];title_sub=TarRadSpc.chanstrdecimal;tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strTar,' TB Sim (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-ttbsim-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    sub_plottimeseries(x,y,tsplotstr)
    
    % subplot for each channel
    % subplot of day_tbdd
    y = day_tbdd(:,:,1); y=y';ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
    tsplotstr.modesub=1;
    title_major=[strX,' TB DD'];title_sub=strcat(tarchanname,' (mean=',num2str(ymean','%.1f'),'K)');
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB DD (K)'];
    tsplotstr.legend=TarRadSpc.chanstrdecimal;
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-tbdd-',DateBegin,'-',DateEnd];
    tsplotstr.ylim=[-1,1];
    tsplotstr.datetick='yy/mm';
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % subplot of day_tbdd in every-5 subplots
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    numchan = size(day_tbdd,1);
    if numchan>5
        nstep=5;
        n = 1:nstep:numchan;
        if n(end)<numchan;
            n = [n,numchan];
        end
        for i=1: size(n,2)-1
            idx = n(i):n(i+1);
            y = day_tbdd(idx,:); y=y';ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
            title_major=[strX,' TB DD'];title_sub=strcat(tarchanname(idx),' (mean=',num2str(ymean','%.1f'),'K)');
            tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
            tsplotstr.datetick='yy/mm';
            tsplotstr.legend=TarRadSpc.chanstrdecimal(idx);
            tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-tbdd-group5-chan_',num2str(TarRadSpc.chanind(idx(1))),'_',num2str(TarRadSpc.chanind(idx(end))),'-',DateBegin,'-',DateEnd];
            sub_plottimeseries(x,y,tsplotstr)
        end
    end
    % subplot of day_tbdd in every-2 subplots
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    numchan = size(day_tbdd,1);
    if numchan>5
        nstep=2;
        n = 1:nstep:numchan;
        if n(end)<numchan;
            n = [n,numchan];
        end
        for i=1: size(n,2)-1
            idx = n(i):n(i+1);
            y = day_tbdd(idx,:); y=y';ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
            title_major=[strX,' TB DD'];title_sub=strcat(tarchanname(idx),' (mean=',num2str(ymean','%.1f'),'K)');
            tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
            tsplotstr.datetick='yy/mm';
            tsplotstr.legend=TarRadSpc.chanstrdecimal(idx);
            tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-tbdd-group2-chan_',num2str(TarRadSpc.chanind(idx(1))),'_',num2str(TarRadSpc.chanind(idx(end))),'-',DateBegin,'-',DateEnd];
            sub_plottimeseries(x,y,tsplotstr)
        end
    end
    % subplot of day_tbdd in every-5 subplots w/ sigma filtering
    numchan = size(day_tbdd,1);
    if numchan>5
        nstep=5;
        n = 1:nstep:numchan;
        if n(end)<numchan;
            n = [n,numchan];
        end
        for i=1: size(n,2)-1
            idx = n(i):n(i+1);
            y = day_tbdd(idx,:); y=y';
            idxfil = sub_filterIndSigma(3,y);y(idxfil)=nan;
            ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
            title_major=[strX,' TB DD'];title_sub=strcat(tarchanname(idx),' (mean=',num2str(ymean','%.1f'),'K)');
            tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
            tsplotstr.datetick='yy/mm';
            tsplotstr.legend=TarRadSpc.chanstrdecimal(idx);
            tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-tbdd-sigma3-group5-chan_',num2str(TarRadSpc.chanind(idx(1))),'_',num2str(TarRadSpc.chanind(idx(end))),'-',DateBegin,'-',DateEnd];
            tsplotstr.ylim = [-0.5 0.5];
            sub_plottimeseries(x,y,tsplotstr)
        end
    end
    % subplot of day_tbdd in every-2 subplots
    numchan = size(day_tbdd,1);
    if numchan>5
        nstep=2;
        n = 1:nstep:numchan;
        if n(end)<numchan;
            n = [n,numchan];
        end
        for i=1: size(n,2)-1
            idx = (n(i)-1)*nstep+1:n(i+1)-1;
            y = day_tbdd(idx,:); y=y';
            idxfil = sub_filterIndSigma(3,y);y(idxfil)=nan;
            ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
            title_major=[strX,' TB DD'];title_sub=strcat(tarchanname(idx),' (mean=',num2str(ymean','%.1f'),'K)');
            tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
            tsplotstr.datetick='yy/mm';
            tsplotstr.legend=TarRadSpc.chanstrdecimal(idx);
            tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-tbdd-sigma3-group2_chan_',num2str(TarRadSpc.chanind(idx(1))),'_',num2str(TarRadSpc.chanind(idx(end))),'-',DateBegin,'-',DateEnd];
            tsplotstr.ylim = [-0.5 0.5];
            sub_plottimeseries(x,y,tsplotstr)
        end
    end
    
    % subplot of day_ttbsd
    y = day_ttbsd(:,:,1); y=y';ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
    tsplotstr.modesub=1;
    title_major=[strTar,' TB SD'];title_sub=strcat(TarRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.legend=TarRadSpc.chanstrdecimal;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=['TB SD (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-ttbsd-',DateBegin,'-',DateEnd];
    tsplotstr.ylim=[-1,1];
    tsplotstr.datetick='yy/mm';
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % subplot of day_rtbsd
    y = day_rtbsd(:,:,1); y=y';ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
    tsplotstr.modesub=1;
    title_major=[strRef,' TB SD'];title_sub=strcat(RefRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.legend=RefRadSpc.chanstrdecimal;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB SD (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-rtbsd-',DateBegin,'-',DateEnd];
    tsplotstr.ylim=[-1,1];
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % subplot of day_rtb
    y = day_rtb(:,:,1); y=y';
    tsplotstr.modesub=1;
    title_major=[strRef,' TB'];title_sub=RefRadSpc.chanstrdecimal;
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.legend=RefRadSpc.chanstrdecimal;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-rtb-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % subplot of day_rtbsim
    y = day_rtbsim(:,:,1); y=y';
    tsplotstr.modesub=1;
    title_major=[strRef,' TB Sim'];title_sub=RefRadSpc.chanstrdecimal;
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.legend=RefRadSpc.chanstrdecimal;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB Sim (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-rtbsim-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % subplot of day_ttb
    y = day_ttb(:,:,1); y=y';
    tsplotstr.modesub=1;
    title_major=[strTar,' TB'];title_sub=TarRadSpc.chanstrdecimal;
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.legend=TarRadSpc.chanstrdecimal;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-ttb-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    % subplot of day_ttbsim
    y = day_ttbsim(:,:,1); y=y';
    tsplotstr.modesub=1;
    title_major=[strTar,' TB Sim'];title_sub=TarRadSpc.chanstrdecimal;
    tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
    tsplotstr.legend=TarRadSpc.chanstrdecimal;
    tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB Sim (K)'];
    tsplotstr.savename=[strX,'-',CodeFun,'-time-sub-ttbsim-',DateBegin,'-',DateEnd];
    tsplotstr.ylim='auto';
    tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
    sub_plottimeseries(x,y,tsplotstr)
    
    if 0
        % moving average
        day_moving=180;
        % moving average of day_tbdd
        x = ndate(:);y=day_tbdd';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strX,' TB DD'];title_sub=strcat(TarRadSpc.chanstrdecimal(TarIndDD)',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB DD (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-tbdd-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-0.5,0.5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_ttbsd
        x = ndate(:);y=day_ttbsd';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strTar,' TB SD'];title_sub=strcat(TarRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB SD (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-ttbsd-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-0.5,0.5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_ttb
        x = ndate(:);y=day_ttb';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strTar,' TB'];title_sub=strcat(TarRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-ttb-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-5,5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_ttbsim
        x = ndate(:);y=day_ttbsim';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strTar,' TBsim'];title_sub=strcat(TarRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-ttbsim-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-5,5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_rtbsd
        x = ndate(:);y=day_rtbsd';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strRef,' TB SD'];title_sub=strcat(RefRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB SD (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-rtbsd-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-0.5,0.5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_rtb
        x = ndate(:);y=day_rtb';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strRef,' TB'];title_sub=strcat(RefRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-rtb-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-5,5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_rtbsim
        x = ndate(:);y=day_rtbsim';
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        ymean=nanmean(y,1);y=bsxfun(@minus,y,ymean);
        tsplotstr.modesub=1;
        title_major=[strRef,' TBsim'];title_sub=strcat(RefRadSpc.chanstrdecimal',' (mean=',num2str(ymean','%.1f'),'K)');
        tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB (K)'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-rtbsim-',DateBegin,'-',DateEnd];
        tsplotstr.ylim=[-5,5];
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_rtime of Ref
        x = ndate(:);
        y=day_rtime';y=datevec(y);y=y(:,4)+y(:,5)/60;
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        tsplotstr.modesub=1;
        tsplotstr.title={''};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strRef,' UTC hour'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-hourUTCref-',DateBegin,'-',DateEnd];
        tsplotstr.ylim='auto';
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of day_rtime of Tar
        x = ndate(:);
        y=day_rtime';y=datevec(y);y=y(:,4)+y(:,5)/60+day_timedif'/60;
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        tsplotstr.modesub=1;
        tsplotstr.title={''};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strTar,' UTC hour'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-hourUTCtar-',DateBegin,'-',DateEnd];
        tsplotstr.ylim='auto';
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
        % moving average of local hour
        x = ndate(:);
        y=day_timelocal';y=datevec(y);y=y(:,4)+y(:,5)/60;
        idx=~sum(isnan(y),2);x=x(idx);y=y(idx,:);
        [x,y] = filter_movingaverage('with tail',day_moving,x,y);
        tsplotstr.modesub=1;
        tsplotstr.title={''};
        tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[strRef,' local hour'];
        tsplotstr.savename=[strX,'-',CodeFun,'-time-move-hourLocal-',strRef,'-',DateBegin,'-',DateEnd];
        tsplotstr.ylim='auto';
        tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
        sub_plottimeseries(x,y,tsplotstr)
    end
    
    
    % time series FFT power spectra
    day_moving=180;
    % day_ttb
    x = ndate(:);y = day_ttb(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-ttb-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strTar,' TB'];fft_plotstr.time_legend=TarRadSpc.chanstrdecimal(TarIndDD);
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend=TarRadSpc.chanstrdecimal(TarIndDD);fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % day_tbdd
    x = ndate(:);y = day_tbdd(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-tbdd-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strX,' TB DD'];fft_plotstr.time_legend=TarRadSpc.chanstrdecimal(TarIndDD);
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend=TarRadSpc.chanstrdecimal(TarIndDD);fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % day_rtime UTC of ref
    x = ndate(:);y = day_rtime(:,:,1); y=y';
    y = datevec(y);y=y(:,4)+y(:,5)/60;
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [x1,y1] = filter_movingaverage('with tail',day_moving,x1,y1);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-dayhourUTC-',strRef,'-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strRef,' UTC Hour'];fft_plotstr.time_legend='';
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend='';fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % day_rtime UTC of tar
    x = ndate(:);y = day_rtime(:,:,1); y=y';
    y = datevec(y);y=y(:,4)+y(:,5)/60+day_timedif(:,:,1)'/60;
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [x1,y1] = filter_movingaverage('with tail',day_moving,x1,y1);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-dayhourUTC-',strTar,'-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strTar,' UTC Hour'];fft_plotstr.time_legend='';
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend='';fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % day_timelocal of ref
    x = ndate(:);y = day_timelocal(:,:,1); y=y';
    y = datevec(y);y=y(:,4)+y(:,5)/60;
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [x1,y1] = filter_movingaverage('with tail',day_moving,x1,y1);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-dayhourLocal-',strRef,'-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strRef,' Local Hour'];fft_plotstr.time_legend='';
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend='';fft_plotstr.freq_xlim=[0,6*day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % day_timelocal of tar
    x = ndate(:);y = day_timelocal(:,:,1); y=y';
    y = datevec(y);y=y(:,4)+y(:,5)/60+day_timedif(:,:,1)'/60;
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [x1,y1] = filter_movingaverage('with tail',day_moving,x1,y1);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-dayhourLocal-',strTar,'-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strTar,' Local Hour'];fft_plotstr.time_legend='';
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend='';fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % day_timedif
    x = ndate(:);y = day_timedif(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [x1,y1] = filter_movingaverage('with tail',day_moving,x1,y1);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-dayMinuteDif-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strX,' Dif (minute)'];fft_plotstr.time_legend='';
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend='';fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    % moving day_tbdd
    x = ndate(:);y = day_tbdd';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [x1,y1] = filter_movingaverage('with tail',day_moving,x1,y1);
    [f,ps] = math_FFT(x1,y1); fT = 1./f*(x1(end)-x1(1)+1);idx=~isinf(fT);fT=fT(idx);ps=ps(idx,:);
    fft_plotstr.outpath=outpath;fft_plotstr.savename=[strX,'-',CodeFun,'-timeFFT-move-tbdd-',DateBegin,'-',DateEnd];
    fft_plotstr.time_xlabel=[DateBegin,'-',DateEnd];fft_plotstr.time_ylabel=[strX,' TB DD'];fft_plotstr.time_legend='';
    fft_plotstr.freq_xlabel='Day';fft_plotstr.freq_ylabel='Power Spectra';fft_plotstr.freq_legend='';fft_plotstr.freq_xlim=[0,day_moving];
    math_plotFFTdomain2(x1,y1,fT,ps,fft_plotstr)
    
    % hist2
    % common plot setting
    clear plotstr
    plotstr.titlecolorbar='No.';plotstr.outpath=outpath;
    % hist2_ttb_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = [TarRadSpc.rad,' TB (K)'];plotstr.ylabel=['TB DD (K)'];
        plotstr.title=[strTar,' ',tarchanname{TarIndDD(ichan)}];
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-hist2-ttb-tbdd-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTB,BinTBDD,hist2_ttb_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_ttb_tbdifobs for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = [TarRadSpc.rad,' TB (K)'];plotstr.ylabel=['TB Dif (K)'];
        plotstr.title=[strX,' ',tarchanname{TarIndDD(ichan)}];
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-hist2-ttb-tbdifobs-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTB,BinTBDD,hist2_ttb_tbdif(:,:,ichan,1),plotstr)
    end
    % hist2_teia_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = [TarRadSpc.rad,' EIA (degree)'];plotstr.ylabel=['TB DD (K)'];
        plotstr.title=[strTar,' ',tarchanname{TarIndDD(ichan)}];
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-hist2-teia-tbdd-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTarEIA,BinTBDD,hist2_teia_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_teia_tbdifobs for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = [TarRadSpc.rad,' EIA (degree)'];plotstr.ylabel=[' TB Dif (K)'];
        plotstr.title=[strTar,' ',tarchanname{TarIndDD(ichan)}];
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-hist2-teia-tbdifobs-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTarEIA,BinTBDD,hist2_teia_tbdifobs(:,:,ichan,1),plotstr)
    end
    % hist2_eiadif_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['EIA Dif (degree)'];plotstr.ylabel=[' TB DD (K)'];
        plotstr.title=[strTar,' ',tarchanname{TarIndDD(ichan)}];
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-hist2-eiadif-tbdd-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinEIAdif,BinTBDD,hist2_eiadif_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_eiadif_tbdifobs for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['EIA Dif (degree)'];plotstr.ylabel=[' TB Dif (K)'];
        plotstr.title=[strTar,' ',tarchanname{TarIndDD(ichan)}];
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-hist2-eiadif-tbdifobs-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinEIAdif,BinTBDD,hist2_eiadif_tbdifobs(:,:,ichan,1),plotstr)
    end
    
    % map
    % common setting
    plotstr.caxis.opt=1;plotstr.caxis.value=[-3,3];
    % map of DD
    for ichan=1: length(TarIndDD) % map of DD
        z = map_tbdd(:,:,ichan,1);zmean = nanmean(z(:));z=z-zmean;
        plotstr.titlecolorbar='(K)';
        plotstr.title={[strX,' TB DD Variability '],...
            [tarchanname{ichan},'(Mean ',sprintf('%0.1f',zmean),'K)']};
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-map-tbdd-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    end
    
    % map of gridnum
    plotstr.caxis.opt=0;
    z = map_gridnum(:,:,1,1);
    idx = z==0; z(idx)=NaN;
    plotstr.titlecolorbar='No.';plotstr.title=[strX,' Collocation No.'];plotstr.savename=[strX,'-',CodeFun,'-map-gridNo-',DateBegin,'-',DateEnd];
    sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    
    % scan position
    % common setting
    clear plotstr
    plotstr.xlabel='Scan Position';plotstr.outpath=outpath;
    % TB DD
    ncross = tncross; crosstb=rp_crosstbdd(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strX,' TB DD (K)'];plotstr.title=TarRadSpc.chanstrdecimal(TarIndDD);plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-tbdd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB obs-obs
    ncross = tncross; crosstb=rp_crosstbdifobs(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.str_legend=TarRadSpc.chanstrdecimal(TarIndDD);
    plotstr.ylabel=[strX,' TB Obs-Obs (K)'];plotstr.title=TarRadSpc.chanstrdecimal(TarIndDD);plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-tbdifobs-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % ttb
    ncross = tncross; crosstb=rp_crossttb(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strTar,' TB (K)'];plotstr.title=TarRadSpc.chanstrdecimal;plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-ttb-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % ttbsd
    ncross = tncross; crosstb=rp_crossttbsd(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strTar,' TB SD (K)'];plotstr.title=TarRadSpc.chanstrdecimal;plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-ttbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % ttbsim
    ncross = tncross; crosstb=rp_crossttbsim(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strTar,' TB Sim (K)'];plotstr.title=TarRadSpc.chanstrdecimal;plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-ttbsim-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % rtb
    ncross = rncross; crosstb=rp_crossrtb(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strRef,' TB (K)'];plotstr.title=RefRadSpc.chanstrdecimal;plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-rtb-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % rtbsd
    ncross = rncross; crosstb=rp_crossrtbsd(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strRef,' TB SD (K)'];plotstr.title=RefRadSpc.chanstrdecimal;plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-rtbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % rtbsim
    ncross = rncross; crosstb=rp_crossrtbsim(:,:,1,1);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strRef,' TB Sim (K)'];plotstr.title=RefRadSpc.chanstrdecimal;plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-rtbsim-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % cross_tbddstd
    ncross= tncross;crosstb=rp_crosstbddstd;
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[strX,' DD STD'];plotstr.title=TarRadSpc.chanstrdecimal;plotstr.legend='';
    plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-std-tbdd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % cross_ttbsdstd
    ncross= tncross;crosstb=rp_crossttbsdstd;
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[TarRadSpc.rad,' SD STD'];plotstr.title=TarRadSpc.chanstrdecimal;plotstr.legend='';
    plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-std-ttbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % cross_rtbsdstd
    ncross= rncross;crosstb=rp_crossrtbsdstd;
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[RefRadSpc.rad,' SD STD'];plotstr.title=RefRadSpc.chanstrdecimal;plotstr.legend='';
    plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-std-rtbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % crosstnum
    ncross= tncross;crosstb=sum(day_crosstnum,3);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[TarRadSpc.rad,' No.'];plotstr.title={''};
    plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-tnum-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % crossrnum
    ncross= rncross;crosstb=sum(day_crossrnum,3);
    idx=crosstb==0;crosstb(idx)=NaN;
    plotstr.ylabel=[RefRadSpc.rad,' No.'];plotstr.title={''};
    plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-rnum-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    
    % plots of tb-tier
    if OptTBtier.opt
        % OptTBtier.tbtier day_tbdd
        for ichan=1: length(TarIndDD)
            % data
            x = ndate(:);
            y = permute(tbtier_day_tbdd(ichan,:,:),[3 2 1]);
            idx = ~(sum(isnan(y),2));x=x(idx);y=y(idx,:);
            % mode of subplot
            tsplotstr.modesub=1;
            % label
            tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB DD (K) '];
            tsplotstr.datetick='yy/mm';
            % title and savename
            title_major=[strX,' TB DD ',tarchanname{ichan}];
            title_sub = OptTBtier.tbtier(:,ichan);title_sub = round([title_sub(1:end-1),title_sub(2:end)]);title_sub = strcat(num2str(title_sub(:,1)),'-',num2str(title_sub(:,2)),'K');title_sub=cellstr(title_sub);
            tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
            chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
            tsplotstr.savename=[strX,'-',CodeFun,'-time-tbtier-tbdd-',chansave,'-',DateBegin,'-',DateEnd];
            tsplotstr.outpath=outpath;
            % fitting
            tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
            % plot
            sub_plottimeseries(x,y,tsplotstr)
        end
        
        % OptTBtier.tbtier day_tbdd: moving average
        day_moving=ceil(PeriodOscObs);
        for ichan=1: length(TarIndDD)
            % data
            x = ndate(:);
            y = permute(tbtier_day_tbdd(ichan,:,:),[3 2 1]);
            idx = ~(sum(isnan(y),2));x=x(idx);y=y(idx,:);
            [x,y] = filter_movingaverage('with tail',day_moving,x,y);
            
            % mode of subplot
            tsplotstr.modesub=1;
            % label
            tsplotstr.xlabel=[DateBegin,'-',DateEnd];tsplotstr.ylabel=[' TB DD (K) '];
            tsplotstr.datetick='yy/mm';
            % title and savename
            title_major=[strX,' TB DD ',tarchanname{ichan}];
            title_sub = OptTBtier.tbtier(:,ichan);title_sub = round([title_sub(1:end-1),title_sub(2:end)]);title_sub = strcat(num2str(title_sub(:,1)),'-',num2str(title_sub(:,2)),'K');title_sub=cellstr(title_sub);
            tsplotstr.title=title_sub;tsplotstr.title{1}={title_major;title_sub{1}};
            chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
            tsplotstr.savename=[strX,'-',CodeFun,'-time-tbtier-tbdd-move-',chansave,'-',DateBegin,'-',DateEnd];
            tsplotstr.outpath=outpath;
            % fitting
            tsplotstr.modefit.opt=1;tsplotstr.modefit.degree=1;tsplotstr.modefit.alpha=0.1;
            % plot
            sub_plottimeseries(x,y,tsplotstr)
        end
        
        % OptTBtier.tbtier scan-dependence
        x = tncross;y=rp_tbtier_cross_tbdd(:,:,:);
        idx=y==0;y(idx)=NaN;
        plotstr.xlabel='Scan Position';plotstr.ylabel=[strX,' TB DD (K)'];
        plotstr.title=TarRadSpc.chanstrdecimal(TarIndDD);
        str_legend = OptTBtier.tbtier(:,1);str_legend = round([str_legend(1:end-1),str_legend(2:end)]);str_legend = strcat(num2str(str_legend(:,1)),'-',num2str(str_legend(:,2)),'K');str_legend=cellstr(str_legend);plotstr.legend=str_legend;
        plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-tbtier-cross-tbdd-',DateBegin,'-',DateEnd];
        sub_plotCrossSubChan(x,y,plotstr);
        
        % OptTBtier.tbtier hist1
        x = tncross;y=rp_tbtier_cross_tbdd(:,:,:);
        idx=y==0;y(idx)=NaN;
        plotstr.xlabel='Scan Position';plotstr.ylabel=[strX,' TB DD (K)'];
        plotstr.title=TarRadSpc.chanstrdecimal(TarIndDD);
        str_legend = OptTBtier.tbtier(:,1);str_legend = round([str_legend(1:end-1),str_legend(2:end)]);str_legend = strcat(num2str(str_legend(:,1)),'-',num2str(str_legend(:,2)),'K');str_legend=cellstr(str_legend);plotstr.legend=str_legend;
        plotstr.savename=[strX,'-',CodeFun,'-scan-subchan-tbtier-cross-tbdd-',DateBegin,'-',DateEnd];
        sub_plotCrossSubChan(x,y,plotstr);
    end
    % day bin plot
    % common plot setting
    x=1:numday;plotstr.xlabel = ['Time Series'];plotstr.ylabel=['Latitude'];plotstr.titlecolorbar=['(K)'];plotstr.outpath=outpath;plotstr.caxis.opt=1;plotstr.caxis.value=[-3,3];plotstr.title.opt=1;plotstr.colors.opt=1;temp=colormap;temp=temp(1:3:end,:);plotstr.colors.value=temp;
    % daybin_latDD
    for ichan=1: length(TarIndDD)
        y=BinLat;z=squeeze(daybin_latDD(:,ichan,:,1));z(z==0)=NaN;
        zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.title.value={[strX,' Latitude-DD Variability '],...
            [tarchanname{ichan},sprintf(' Mean=%0.1f',zmean)]};
        chansave=sub_radchannameshort(TarRadSpc.chanind(TarIndDD(ichan)),TarRadSpc.chanstrdecimal{TarIndDD(ichan)},TarRadSpc.chanpol{TarIndDD(ichan)});
        plotstr.savename=[strX,'-',CodeFun,'-temporal2D-DDlat-',chansave,'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
    
    % diurnal
    diurnal_UTC_DD = bsxfun(@rdivide,diurnal_UTC_DD,diurnal_UTC_num);
    diurnal_UTC_ttb = bsxfun(@rdivide,diurnal_UTC_ttb,diurnal_UTC_num);
    diurnal_local_DD = bsxfun(@rdivide,diurnal_local_DD,diurnal_local_num);
    diurnal_local_ttb = bsxfun(@rdivide,diurnal_local_ttb,diurnal_local_num);
    figure(1)
    subplot(2,2,1)
    plot(0:23,diurnal_UTC_DD,'linewidth',2);
    xlim([0 24])
    xlabel('UTC hour','fontsize',18)
    ylabel([strX,' DD (K)'],'fontsize',18)
    subplot(2,2,2)
    plot(0:23,diurnal_UTC_ttb,'linewidth',2);
    xlim([0 24])
    xlabel('UTC hour','fontsize',18)
    ylabel([strTar,' TB (K)'],'fontsize',18)
    legend(TarRadSpc.chanstr{TarIndDD})
    legend boxoff
    subplot(2,2,3)
    plot(0:23,diurnal_local_DD,'linewidth',2);
    xlim([0 24])
    xlabel('Diurnal hour','fontsize',18)
    ylabel([strX,' DD (K)'],'fontsize',18)
    subplot(2,2,4)
    plot(0:23,diurnal_local_ttb,'linewidth',2);
    xlim([0 24])
    xlabel('Diurnal hour','fontsize',18)
    ylabel([strTar,' TB (K)'],'fontsize',18)
    print(1,'-dpng','-r300',[outpath,strX,'-',CodeFun,'-diurnal','-',DateBegin,'-',DateEnd])
    close 1
    
    % manual plot
    manual_plottimefft;
    manual_lat2d;
    