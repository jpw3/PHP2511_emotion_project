clear all
close all
addpath('/m/nbe/scratch/braindata/shared/toolboxes/cbrewer/');
load('output/mind/M1_data')
load_labels
sensations=labels;
%% data = words x dimensions x good subjects
% 5 dimensions listed here:
Ndim=5;
dim_labels={ %'Bodily sensation strength','Mind sensation strength','Emotion intensity','Agency','Last time'};
    'Bodily saliency' % How much feels in body question
    'Mental saliency' % How much involves the mind
    'Emotion' % emotional valence question
    'Controllability' % how much you can control question (used to be agency)
    'Lapse' % last time question
    };

sensations_classes % loads the ground truth
map=cbrewer('qual','Set1',max(classID));
map(6,:)=[0 0 0];
data(find(data==0))=1; % just to avoid problems in binning

mean_data=zeros(100,5);
median_data=zeros(100,5);
sem_data=zeros(100,5);
mean_dataZ=zeros(100,5);
median_dataZ=zeros(100,5);
sem_dataZ=zeros(100,5);

% for plotting distros
Nres=100;
distros=zeros(100,Nres+1,5);
distrosZ=distros;
maph=flipud(cbrewer('div','Spectral',31));


% compute means, medians and distributions
for s=1:length(sensations)
    thisdata=squeeze(data(s,:,:));
    thisdata=(thisdata-500)/500;
    ids=find(~isnan(max(thisdata)));
    thisdata=thisdata(:,ids); % let's keep only those with data
    xi=((0:Nres)-Nres/2)/(Nres/2);
    xiZ=5*(((0:Nres)-(Nres/2))/(Nres/2));
    for subdim=1:5
        [fi]=ksdensity(thisdata(subdim,:)',xi);
        distros(s,:,subdim)=fi/sum(fi);
    end
    thisdataZ=atanh(thisdata-eps);
    for subdim=1:5
        [fi]=ksdensity(thisdataZ(subdim,:)',xiZ);
        distrosZ(s,:,subdim)=fi/sum(fi);
    end
    mean_data(s,:)=mean(thisdata,2);
    mean_dataZ(s,:)=mean(thisdataZ,2);
    median_data(s,:)=median(thisdata,2);
    median_dataZ(s,:)=median(thisdataZ,2);
    Nitems(s,1)=size(thisdata,2);
    sem_data(s,:)=std(thisdata,0,2)./sqrt(size(thisdata,2));
    sem_dataZ(s,:)=std(thisdataZ,0,2)./sqrt(size(thisdataZ,2));
    sens_count(s,1)=size(thisdata,2);
end
%% visualize case of using normal mean
figure(2)
for subdim=1:5
    subplot(1,5,subdim)
    imagesc(xi,1:100,distros(:,:,subdim),[0 prctile(distros(:),99)])
    colormap(maph)
    set(gca,'YTick',[])
    xlabel(dim_labels{subdim})
    hold on
    for s=1:100
        if(subdim==1)
            text(-1.1,s,sensations{s},'HorizontalAlignment','right')
        end
        if(subdim==5)
            text(1.1,s,sensations{s},'HorizontalAlignment','left')
        end
        plot(mean_data(s,subdim),s,'o','Color',0*[1 1 1])
        plot(median_data(s,subdim),s,'x','Color',0*[1 1 1])
    end
    if(subdim==3)
        title('Probability distribution functions for each item and each dimension. o = mean. x = median')
    end
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/mind_PDFs_and_mean_data.png'

% case using z transformed means
figure(3)
for subdim=1:5
    subplot(1,5,subdim)
    imagesc(xiZ,1:100,distrosZ(:,:,subdim))
    colormap(maph)
    set(gca,'YTick',[])
    xlabel([dim_labels{subdim} ' (Z-score)'])
    hold on
    for s=1:100
        if(subdim==1)
            text(-5.1,s,sensations{s},'HorizontalAlignment','right')
        end
        if(subdim==5)
            text(5.1,s,sensations{s},'HorizontalAlignment','left')
        end
        plot(mean_dataZ(s,subdim),s,'o','Color',0*[1 1 1])
        plot(median_dataZ(s,subdim),s,'x','Color',0*[1 1 1])
        
    end
    if(subdim==3)
        title('Probability distribution functions for each item and each dimension. o = mean. x = median')
    end
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/mind_PDFs_and_mean_data_zscore.png'


%% label sorting with dim 3 (emotions) for mean_data and mean_dataZ
[temp emomedian]=sort(median_data(:,3));

emomean_mean_data=mean_data(emomedian,:);
emomean_median_data=median_data(emomedian,:);
emomean_distros=distros(emomedian,:,:);
emomean_sensations=sensations(emomedian);
%visualize case of using normal mean
figure(22)
for subdim=1:5
    subplot(1,5,subdim)
    imagesc(xi,1:100,emomean_distros(:,:,subdim),[0 prctile(emomean_distros(:),99)])
    colormap(maph)
    set(gca,'YTick',[])
    xlabel(dim_labels{subdim})
    hold on
    for s=1:100
        if(subdim==1)
            text(-1.1,s,emomean_sensations{s},'HorizontalAlignment','right')
        end
        if(subdim==5)
            text(1.1,s,emomean_sensations{s},'HorizontalAlignment','left')
        end
        plot(emomean_mean_data(s,subdim),s,'o','Color',0*[1 1 1])
        plot(emomean_median_data(s,subdim),s,'x','Color',0*[1 1 1])
    end
    if(subdim==3)
        title('Probability distribution functions for each item and each dimension. o = mean. x = median')
    end
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/mind_PDFs_and_mean_data_EMOSORT.png'

%% visualize as violin plots
load output/sim/sim_cluster.mat
figure(2200)
close
figure(2200)
for subdim=1:5
    subplot(1,10,subdim)
    
    
    for s=100:-1:1
        p=patch([xi'; flipud(xi')],[s+(squeeze(30*emomean_distros(s,:,subdim)))'; s*ones(length(xi),1)] ,1);
        colID=sim_cluster.DBSCAN.class_from_mean_data(emomedian(s));
        if(colID<=0)
            col=classColors(end,:);
        else
            col=classColors(colID,:);
        end
        set(p,'EdgeColor',[1 1 1]*.9)
        set(p,'FaceColor',col);
        hold on
        if(subdim==1)
            text(-1.1,s+.25,emomean_sensations{s},'HorizontalAlignment','right','FontSize',6)
        end
        if(subdim==5)
            text(1.1,s+.25,emomean_sensations{s},'HorizontalAlignment','left','FontSize',6)
        end
        %plot(emomean_mean_data(s,subdim),s,'o','Color',0*[1 1 1])
        %plot(emomean_median_data(s,subdim),s,'x','Color',0*[1 1 1])
    end
    if(subdim==3)
        title('Probability distribution functions for each item and each dimension. o = mean. x = median')
    end
    set(gca,'YTick',[])
    xlabel(dim_labels{subdim})
    axis([-1 1 0 110])
    axis off
    text(0,0,'500','HorizontalAlignment','center')
    text(1,0,'1000','HorizontalAlignment','center')
    text(-1,0,'0','HorizontalAlignment','center')
    text(0,-2,dim_labels{subdim},'HorizontalAlignment','center')
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
%export_fig -m3 'figs/mind_PDFs_and_mean_data_EMOSORT_violin.png'
plot2svg('figs/mind_PDFs_and_mean_data_EMOSORT_violin.svg')


%% case using z transformed means
[temp emomedianZ]=sort(median_dataZ(:,3));

emomean_mean_dataZ=mean_dataZ(emomedianZ,:);
emomean_median_dataZ=median_dataZ(emomedianZ,:);
emomean_distrosZ=distrosZ(emomedianZ,:,:);
emomean_sensationsZ=sensations(emomedianZ);

figure(33)
for subdim=1:5
    subplot(1,5,subdim)
    imagesc(xiZ,1:100,emomean_distrosZ(:,:,subdim))
    colormap(maph)
    set(gca,'YTick',[])
    xlabel([dim_labels{subdim} ' (Z-score)'])
    hold on
    for s=1:100
        if(subdim==1)
            text(-5.1,s,emomean_sensationsZ{s},'HorizontalAlignment','right','FontSize',6)
        end
        if(subdim==5)
            text(5.1,s,emomean_sensationsZ{s},'HorizontalAlignment','left','FontSize',6)
        end
        plot(emomean_mean_dataZ(s,subdim),s,'o','Color',0*[1 1 1])
        plot(emomean_median_dataZ(s,subdim),s,'x','Color',0*[1 1 1])
        
    end
    if(subdim==3)
        title('Probability distribution functions for each item and each dimension. o = mean. x = median')
    end
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/mind_PDFs_and_mean_data_zscore_EMOSORT.png'

error('stop')

[sensations(emomedian) sensations(emomedianZ)]

%% visualize as violin plots using z
load output/sim/sim_cluster.mat
figure(22000)
close
figure(22000)
for subdim=1:5
    subplot(1,10,subdim)
    
    
    for s=100:-1:1
        odd_or_even=mod(s,2);
        p=patch([xiZ'; flipud(xiZ')],[s+(squeeze(30*emomean_distrosZ(s,:,subdim)))'; s*ones(length(xiZ),1)] ,1);
        colID=sim_cluster.DBSCAN.class_from_mean_data(emomedianZ(s));
        if(colID<=0)
            col=classColors(end,:);
        else
            col=classColors(colID,:);
        end
        %set(p,'EdgeAlpha',0)
        set(p,'EdgeColor',[1 1 1]*.9)
        set(p,'FaceColor',col);
        hold on
        switch(3)
            case 1 % labels on both side alternating
                if(subdim==1)
                    th=text(-1*(4.1+odd_or_even*7),s+.25,emomean_sensationsZ{s},'HorizontalAlignment','right','FontSize',6)
                    if(odd_or_even) text(-1*(4+odd_or_even*7),s+.9,'___________','Color',[1 1 1]*.88,'Interpreter','none','HorizontalAlignment','left');end
                end
                if(subdim==5)
                    text(4.1+odd_or_even*7,s+.25,emomean_sensationsZ{s},'HorizontalAlignment','left','FontSize',6)
                    if(odd_or_even) text((4),s+.9,'__________','Color',[1 1 1]*.88,'Interpreter','none');end
                end
            case 2 % only on the left alternatinv
                if(subdim==1)
                    th=text(-1*(4.1+odd_or_even*7),s+.25,emomean_sensationsZ{s},'HorizontalAlignment','right','FontSize',6)
                    if(odd_or_even) text(-1*(4+odd_or_even*7),s+.9,'___________','Color',[1 1 1]*.88,'Interpreter','none','HorizontalAlignment','left');end
                end
            case 3 % alternating between dimensions
                if(subdim==1 && odd_or_even==0)
                    th=text(-1*(4.1),s+.25,emomean_sensationsZ{s},'HorizontalAlignment','right','FontSize',6)
                end
                if(subdim==5 && odd_or_even==1)
                    th=text(4.1,s+.25,emomean_sensationsZ{s},'HorizontalAlignment','left','FontSize',6)
                end
                
        end
        
        %plot(emomean_mean_dataZ(s,subdim),s,'o','Color',0*[1 1 1])
        %plot(emomean_median_dataZ(s,subdim),s,'x','Color',0*[1 1 1])
    end
    if(subdim==3)
        title('Probability distribution functions for each item and each dimension. o = mean. x = median')
    end
    set(gca,'YTick',[])
    xlabel(dim_labels{subdim})
    axis([-4 4 0 110])
    axis off
    %plot([0 0],[0 100],'--','Color',[1 1 1]*.9)
    %plot([-2 -2],[0 100],'--','Color',[1 1 1]*.9)
    %plot([2 2],[0 100],'--','Color',[1 1 1]*.9)
    p  = patch([ 0 0],[0 101],1,'linestyle',':','edgecolor',[0 0 0]+.15,'linewidth',.3,'edgealpha',0.15);
    %p  = patch([ 0 0]-3,[0 101],1,'linestyle',':','edgecolor',[0 0 0]+.15,'linewidth',.3,'edgealpha',0.2);
    %p  = patch([ 0 0]+3,[0 101],1,'linestyle',':','edgecolor',[0 0 0]+.15,'linewidth',.3,'edgealpha',0.2);
    text(0,-.4,'0','HorizontalAlignment','center','FontSize',6)
    text(4,-.4,'4','HorizontalAlignment','center','FontSize',6)
    text(-4,-.4,'-4','HorizontalAlignment','center','FontSize',6)
    text(0,-2.6,dim_labels{subdim},'HorizontalAlignment','center')
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
%export_fig -m3 'figs/mind_PDFs_and_mean_data_EMOSORT_Z_violin.png'
plot2svg('figs/mind_PDFs_and_mean_data_EMOSORT_Z_violin.svg')
%% Multidimensional scaling
% PCA 2D
pcadata=[(mean_dataZ)];
[coeff, score, latent, tsquared, explained] = pca(pcadata);

[L1, T]=rotatefactors(coeff(:,1:2));
score_rot=pcadata*L1;
mind_mds.pca2D=score_rot;
% cmdscale function
mind_mds.cmd=cmdscale(squareform(pdist(mean_data)),2);
% PCA 3D
pcadata=[mean_dataZ];
[coeff, score, latent, tsquared, explained] = pca(pcadata);
[L1, T]=rotatefactors(coeff(:,1:3));
mind_mds.pca3D=pcadata*L1;
% TSNE
addpath('./external/tsne/')
rng(0)
figure
tsne_out=tsne(mean_dataZ,classID);
mind_mds.tsne=tsne_out;

save(['output/mind/mind_mds.mat'],'mind_mds','mean_data','mean_dataZ','median_data','median_dataZ','sensations','classID','sens_count');

error('stop here before plots')



%% run a PCA and a dendrogram based on the means across subjects 3D plot
pcadata=[mean_data];
[coeff, score, latent, tsquared, explained] = pca(pcadata);

[L1, T]=rotatefactors(coeff(:,1:3));
score_rot=pcadata*L1;
%imagesc(coeff)
figure(1001)
subplot(1,2,1)
imagesc(L1)
colorbar
title('PCA loadings')
xlabel('PCs');
set(gca,'YTick',[1:5])
set(gca,'YTickLabel',dim_labels)

for s=1:size(score_rot,1)
    figure(1001)
    subplot(1,2,2)
    hold on
    plot3(score_rot(s,1),score_rot(s,2),score_rot(s,3),'o','MarkerSize',10,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:))
end
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
grid on
view(3)
camlight
lighting PHONG
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
saveas(gcf,['figs/mind_pca3D.png'])

% dendrogram

pd=pdist(pcadata,'correlation');
z=linkage(pd,'complete');
[H,T,OUTPERM] = dendrogram(z,0)
set(gca,'XTick',[])
for s=1:100
    th=text(s,-.005,sensations{OUTPERM(s)},'Rotation',90,'BackgroundColor',map(classID(OUTPERM(s)),:),'FontSize',6,'HorizontalAlign','right','Color',[1 1 1]);
end

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
saveas(gcf,['figs/mind_dendrogram_correlation.png'])


%% run tsne
addpath('./external/tsne/')
rng(1)
tsne_out=tsne(mean_data,classID);
tsne_out_orig=tsne_out;
tsne_out=tsne_out_orig./max(abs(tsne_out_orig(:)))*380;


% do a 2DIM subplot
figure(202)
subplot(5,5,[1:20])
for s=1:100
    figure(202)
    subplot(5,5,[1:20])
    hold on
    plot(tsne_out(s,1),tsne_out(s,2),'o','MarkerSize',5,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:))
    al='left';
    %if(mod(s,2)==1)
    %    al='right';
    %end
    th=text(tsne_out(s,1)+3,tsne_out(s,2)+1,sensations{s},'Rotation',0,'Color',map(classID(s),:),'FontSize',9,'HorizontalAlignment',al);
end

d = daspect;
box off
daspect([1 2 1])

temp=round(tsne_out-min(tsne_out))+20;
mapmap=flipud(cbrewer('div','RdBu',11));
mean_dataZ=zscore(mean_data);
for d=1:5
    figure(202)
    subplot(5,5,d+20)
    tempMat=zeros(max(temp)+40);
    for s=1:100
        tempMat(temp(s,1), temp(s,2))=mean_dataZ(s,d);
    end
    tempMatB=imgaussfilt(tempMat,17,'FilterSize',81);
    
    for s=1:100
        MulFac(s)=tempMat(temp(s,1), temp(s,2))/tempMatB(temp(s,1), temp(s,2));
    end
    
    imagesc(median(MulFac)*tempMatB',[-3 3])
    axis xy
    colormap(mapmap)
    %colorbar
    title(dim_labels{d})
    daspect([1 2 1])
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
saveas(gcf,['figs/mind_tsne.png'])

%% run tsne using distance
addpath('./external/tsne/')
rng(1)
tsne_out=tsne_d(squareform(pdist(mean_data,'spearman')),classID);
tsne_out_orig=tsne_out;
tsne_out=tsne_out_orig./max(abs(tsne_out_orig(:)))*380;


% do a 2DIM subplot
figure(203)
subplot(5,5,[1:20])
for s=1:100
    figure(203)
    subplot(5,5,[1:20])
    hold on
    plot(tsne_out(s,1),tsne_out(s,2),'o','MarkerSize',5,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:))
    al='left';
    %if(mod(s,2)==1)
    %    al='right';
    %end
    th=text(tsne_out(s,1)+3,tsne_out(s,2)+1,sensations{s},'Rotation',0,'Color',map(classID(s),:),'FontSize',9,'HorizontalAlignment',al);
end

d = daspect;
box off
daspect([1 2 1])

temp=round(tsne_out-min(tsne_out))+20;
mapmap=flipud(cbrewer('div','RdBu',11));
mean_dataZ=zscore(mean_data);
for d=1:5
    figure(203)
    subplot(5,5,d+20)
    tempMat=zeros(max(temp)+40);
    for s=1:100
        tempMat(temp(s,1), temp(s,2))=mean_dataZ(s,d);
    end
    tempMatB=imgaussfilt(tempMat,17,'FilterSize',81);
    
    for s=1:100
        MulFac(s)=tempMat(temp(s,1), temp(s,2))/tempMatB(temp(s,1), temp(s,2));
    end
    
    imagesc(median(MulFac)*tempMatB',[-3 3])
    axis xy
    colormap(mapmap)
    %colorbar
    title(dim_labels{d})
    daspect([1 2 1])
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
saveas(gcf,['figs/mind_tsne_distanceMatrix.png'])

%% assessing reliability of the tool
rng(0)
cfg=[];
for dim=1:5
    cfg.data=squeeze(atanh((data(:,dim,:)-500)/500));
    cfg.niter=5000;
    if(dim>1)
        cfg.permu=permu; % use same permutations
    end
    [icc(:,dim) permu pvals(:,dim)] = bramila_splitsample(cfg);
end
%% plotting reliabilities
for dim=1:5
    figure(100)
    subplot(2,5,dim)
    histogram(icc(:,dim))
    set(gca,'XLim',[0 1])
    xlabel('Spearman correlation')
    ylabel('Number of iterations')
    title(dim_labels{dim})
    axis square
    subplot(2,5,dim+5)
    plot(icc(:,dim),-log10(pvals(:,dim)),'.')
    axis([0 1 0 80])
    yticks=get(gca,'YTick');
    yticks=yticks(1:end)';
    set(gca,'YTick',yticks)
    set(gca,'YTickLabel',num2str(10.^-yticks))
    xlabel('Spearman correlation')
    ylabel('P-value')
    title(['Largest p-value: ' num2str(max(pvals(:,dim)),3)])
    axis square
    grid on
end

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 .5]);
set(gcf,'color',[1 1 1]);
saveas(gcf,['figs/reliability_of_rating_tool.png'])

