% analyzing noise of with PCA

n_pc = 4; % decompose the first few PCs
Z_chan = [];
var_explain_chan = [];
for nchan=1: Rad.num_chan
    
    % -----------------------------
    % PCA
    % -----------------------------
    A = tas_noise(:,:,nchan); % [along-track,cross-track]
    Am = mean(A,2);
    [n1,n2] = size(A);
    [Z,U,S] = pca_svds(A,n1);
    U_scaled = bsxfun(@times,U,sqrt(S'));
    var_explained = S/sum(S);
    
    Z_chan(:,:,nchan) = Z(:,1:n_pc);
    var_explain_chan(:,nchan) = var_explained;
    
end

% -----------------------------
% plot
% -----------------------------
% explained variance
figure(1)
clf
plot(var_explain_chan)

title([Rad.spacecraft,' ',upper(Rad.sensor)])
legend(strcat('Chan ',num2str((1:Rad.num_chan)')))
xlabel('crosstrack')
ylabel('Explained Variance')

outfile = [Rad.spacecraft,'-',upper(Rad.sensor),'_pca_tas.noise_var','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])


% first 4 PC
figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)
for nchan=1: Rad.num_chan
    [n1row,n2col] = plot_subplotnum(Rad.num_chan);
    Z1 = Z_chan(:,:,nchan);
    subplot(n1row,n2col,nchan);
    
    plot(Z1)
    grid on
    grid minor
    
    title(['Chan ',num2str(nchan)])
    xlabel('crosstrack')
    legend(strcat('PC',num2str((1:n_pc)')))
end

outfile = [Rad.spacecraft,'-',upper(Rad.sensor),'_pca_tas.noise_pc','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])


