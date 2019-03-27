clear all
close all
addpath(genpath('external'));
load('output/mind/M1_data');
load('output/mind/mind_mds.mat');
sensations_classes
%% behavioural data
if(0)
    behav_labels={
        'gender' % F = 1
        'age'
        'country residence'
        'country birth'
        'weight'
        'height'
        'handedness' % R = 1
        'education'
        'psychologist'
        'psychiatrist'
        'neurologist'
        'Items rated'
        }
    corrplot(behav_data,'varnames',behav_labels)
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gcf,'color',[1 1 1]);
    export_fig 'figs/mind_behav_data.png'
end


%% item count plot
figure(12)
stem(sens_count,'k')
grid on
set(gca,'XTick',[])
hold on
for s=1:100
    th=text(s,-.1,sensations{s},'Rotation',90,'Color',[0 0 0],'FontSize',7,'HorizontalAlignment','right');
    th=text(s,.1,sensations{s},'Rotation',90,'Color',[0 0 0],'FontSize',7,'HorizontalAlignment','right');
    
    th=text(s,0,sensations{s},'Rotation',90,'Color',classColors(classID(s),:),'FontSize',7,'HorizontalAlignment','right');
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 .3]);
set(gcf,'color',[1 1 1]);
saveas(gcf,['figs/mind_M1_itemCount.png'])
if(0)
    %old code
    for fitord=1:2
        for rrr=1:5
            for ccc=1:5
                if(rrr==ccc) continue; end
                viz_and_model_helper(mean_data,sem_data,rrr,ccc,dim_labels,sensations,classID,classID_labels,map,1000,fitord);
                close all
            end
        end
    end
    
    error('stop')
end


%% corr plot for the mean_dataZ
figure
corrplot(mean_dataZ,'varnames',dim_labels,'type','Spearman','testR','on')
hcp=gcf;
hcpC=get(hcp,'Children');
redmap=cbrewer('seq','Reds',9);
qualmap=cbrewer('qual','Set1',9);
set(gcf, 'OuterPosition', [0 0 900 900]);
for han=1:length(hcpC)
    temp=get(hcpC(han),'XLabel');
    set(temp,'Color',[0 0 0])
    temp=get(hcpC(han),'Children');
    if(strcmp(class(temp),'matlab.graphics.chart.primitive.Histogram'))
        set(temp,'FaceColor',qualmap(1,:))
        set(temp,'FaceAlpha',1)
        set(temp,'EdgeColor',redmap(end,:))
    else
        for tt=1:length(temp)
            set(hcpC(han),'XLim',[-3.5 3.5])
            set(hcpC(han),'YLim',[-3.5 3.5])
            set(temp(tt),'Color',redmap(end,:))
            set(temp(tt),'MarkerEdgeColor',qualmap(1,:))
        end
    end
end
set(gcf,'color',[1 1 1]);
%export_fig -m3 'figs/mind_mean_data_corrplot.png'

%% myCorr plot
close all
sim=load('output/sim/sim_cluster.mat')
PLOTSUBSET=1; % to plot only few regression lines
subset=zeros(5);
subset(1:3,1:3)=ones(3); % we do the plot of regression lines for the first three
dbscan_cluster_labels={
    'Negative emotions'
    'Positive emotions'
    'Somatic states and illnesses'
    'Cognitive processes'
    'Homeostatic states'
    'Between clusters'
    };
sensations_classes
load output/mind/mind_mds.mat
figure(1)
data=mean_dataZ;
N=size(data,2); % data size
IF=5; % interpolating factor for subplot
idxMat=zeros(N*IF);
idxMat(:)=(1:N*N*IF*IF);
idxMat=idxMat';
%dimlabels={
%    'Bodily sensation'
%    'Mental sensation'
%    'Emotion'
%    'Agency'
%    'Lapse'
%    };


    dimlabels={ 
        'Bodily saliency' % How much feels in body question
        'Mental saliency' % How much involves the mind
        'Emotion' % emotional valence question
        'Controllability' % how much you can control question (used to be agency)
        'Lapse' % last time question
    };
diagvals=1:(N+1):N^2
map=cbrewer('qual','Set2',9)
mapmap=cbrewer('seq','Greys',9)
map=mapmap(7:-2:1,:);

map=[0 0 0;0 0 0;0.8510    0.8510    0.8510];
for n=1:N^2
    % subplot interpolation
    temp=idxMat(1:IF,1:IF);
    temp=temp(:);
    dx=mod(IF*(n-1),IF*N);
    dy=floor((n-1)/N)*IF*N*IF;
    subplot(N*IF,N*IF,temp+dx+dy)
    [dim1 dim2]=ind2sub([N N],n);
    
    % if diagonal then plot histogram
    if(ismember(n,diagvals));
        if(0)
            hhh=histogram(data(:,dim1),10)
            set(hhh,'FaceColor',map(3,:))
        else
            [hhh hb]=hist(data(:,dim1),10)
            % we can't use bar
            %H=bar(hb,hhh,1,'w')
            % let's use patch
            DB=min(diff(hb))/2;
            for bID=1:10
                H=patch([hb(bID)-DB hb(bID)-DB hb(bID)+DB hb(bID)+DB],[0 hhh(bID) hhh(bID) 0],1);
                set(H,'FaceColor',map(3,:))
                set(H,'EdgeColor',[ 0 0 0])
                hold on
            end
        
        
            
        end
        
        axis([-3 3 0 30])
        hold on
        box on
        % plot also ksdensities of each sub cluster
        for sim_clu=1:max(sim.sim_cluster.DBSCAN.class_from_mean_data)
            xi=-3:.1:3;
            [fi]=ksdensity(data(find(sim.sim_cluster.DBSCAN.class_from_mean_data==sim_clu),dim1),xi);            
            plot(xi,5*fi,'Color',classColors(sim_clu,:),'LineWIdth',2)
            if(n==1)
                %plot(-2.7+12,28-9*(sim_clu-1),'o','MarkerEdgeColor',classColors(sim_clu,:),'MarkerFaceColor',classColors(sim_clu,:))
                text(-3+21,29-9*(sim_clu-1),'-','FontSize',40,'Color',classColors(sim_clu,:),'FontWeight','bold')
                text(-2+21,28-9*(sim_clu-1),dbscan_cluster_labels{sim_clu},'FontSize',16)
            end          
        end
        [fi]=ksdensity(data(find(sim.sim_cluster.DBSCAN.class_from_mean_data<=0),dim1),xi);
        plot(xi,5*fi,'Color',[0 0 0],'LineWIdth',2)
        sim_clu=6;
        if(n==1)
            %plot(-2.7,28-3*(sim_clu-1),'o','MarkerEdgeColor',[ 0 0 0],'MarkerFaceColor',[ 0 0 0])
            %text(-2.5,28-3*(sim_clu-1),dbscan_cluster_labels{sim_clu},'FontSize',16)
            text(-3+21,29-9*(sim_clu-1),'-','FontSize',40,'Color',[0 0 0],'FontWeight','bold')
                text(-2+21,28-9*(sim_clu-1),dbscan_cluster_labels{sim_clu},'FontSize',16)
        end
    else % we do a scatter plot
        if(dim1>dim2) 
            axis off
            continue; 
        
        end % let's try only the bottom triangle
        rng(0); % needed for k-means reprod
        clusID=cluster(linkage(pdist([data(:,dim1) data(:,dim2)],'correlation'),'complete'),'maxclust',2);
        [clusID C]=kmeans([data(:,dim1) data(:,dim2)],2,'Replicates',100);
        hold on
        box on
        shapes={
            'o'
            's'
            };
        for s=1:100 % for each sensation
            if(sim.sim_cluster.DBSCAN.class_from_mean_data(s)>0)
                col=classColors(sim.sim_cluster.DBSCAN.class_from_mean_data(s),:);
            else
                % out-of-clusters are in grey
                col=.3+[0 0 0];
            end
            if(PLOTSUBSET == 0 || (PLOTSUBSET == 1 && subset(dim1,dim2)==1))
                markershape=shapes{clusID(s)}
            else 
                markershape=shapes{1};
            end
            pppp=plot(data(s,dim1),data(s,dim2),markershape,'MarkerFaceColor','none','MarkerEdgeColor',col,'Markersize',5);
        end
        % same axis for everybody
        axis([-1 1 -1 1]*3)        
        
        % find the separating line between the two clusters
        ddx=(C(2,1)-C(1,1));
        ddy=(C(2,2)-C(1,2));
        dort=tan(atan(ddy/ddx)+pi/2);
        xyc=mean(C);
        tx=-3:.1:3;
        ty=dort*(tx-xyc(1))+xyc(2);
        % but plot it only if we want all subclusters or just for the
        % subset
        if(PLOTSUBSET == 0 || (PLOTSUBSET == 1 && subset(dim1,dim2)==1))
            plot(tx,ty,'--','Color',[.8 .8 .8]) % light grey
        end
        % plot regressions
        x=data(:,dim1);
        y=data(:,dim2);
        Fit = polyfit(x,y,1); % x = x data, y = y data, 1 = order of the polynomial.
        ttt=sort(x);
        yhat=polyval(Fit,ttt);
        plot([ttt(1) ttt(end)],[yhat(1) yhat(end)],'LineWidth',2,'Color',[0 0 0]);
        [rsp ppp]=corr(x,y,'type','spearman');
        star='';
        if(ppp<0.05)
            star='*';
        end
        if(ppp<0.005)
            star='**';
        end
        FS=16;
        if(dim1<dim2)
        th=text(-2.7,2.5,[num2str(rsp,2) star],'Color',[0 0 0],'FontSize',FS);
        if(length(star)>0)
            set(th,'FontWeight','bold')
        end
        end
        
        % and for each k-means cluster
        for dbc=1:max(unique(clusID))
            if(dbc>0)
                ids=find(clusID==dbc);
                x=data(ids,dim1);
                y=data(ids,dim2);
                Fit = polyfit(x,y,1); % x = x data, y = y data, 1 = order of the polynomial.
                ttt=sort(x);
                ttt=[ttt(1)-.25;ttt];
                yhat=polyval(Fit,ttt);
                
                % plot regression line ONLY if we want to plot it
                if(PLOTSUBSET == 0 || (PLOTSUBSET == 1 && subset(dim1,dim2)==1))
                    plot([ttt(1) ttt(end)],[yhat(1) yhat(end)],'LineWidth',1,'Color',map(dbc,:));
                    
                    [rsp ppp]=corr(x,y,'type','spearman');
                    star='';
                    if(ppp<0.05)
                        star='*';
                    end
                    if(ppp<0.005)
                        star='**';
                    end
                    %if(dbc==1)
                    
                    if(dim1<dim2)
                    if(ttt(1)>-2.7)
                        th=text(ttt(1)+.2,yhat(1),[num2str(rsp,2) star '  '],'Color',map(dbc,:),'FontSize',FS-2,'HorizontalAlignment','right');
                    else
                        th=text(ttt(end)+.2,yhat(end),[num2str(rsp,2) star '  '],'Color',map(dbc,:),'FontSize',FS-2,'HorizontalAlignment','left');
                    end
                    end
                end
                
            end
        end
    end
    
    
    % fix axes
    set(gca,'FontSize',FS)
    if(dx ~= 0)
        set(gca,'YTick',[0])
        set(gca,'YTickLabel',{' '})
    end
    if(dx == 0 && dy > 0)
        set(gca,'YTick',[-2:2])
        set(gca,'YTickLabel',num2str([-2:2]'))
    end
    
    if(dy ~=  N*IF*IF*(N-1))
        set(gca,'XTick',[-3])
        set(gca,'XTickLabel',{' '})
    end
    % fix axis labels
    if(dx == 0)
        ylabel(dimlabels{dim2});
    end
    
    if(dy==N*IF*IF*(N-1))
        xlabel(dimlabels{dim1})
    end
    axis square
end

% prepare for printing
set(gcf,'Units', 'Pixels', 'OuterPosition', [0 0 850 1000]);

set(gcf,'color',[1 1 1]);
if(PLOTSUBSET==1)
    export_fig('figs/mind_corrplot_subset.png','-m3')
    
    plot2svg('figs/mind_corrplot_subset.svg',gcf)
    
    %saveas(gcf,'figs/mind_corrplot_subset.eps')
    %print(gcf, '-dpdf', 'figs/mind_corrplot_subset_p.pdf'); 
else
    export_fig('figs/mind_corrplot.png','-m3')
    %plot2svg('figs/mind_corrplot.svg',gcf)
    %saveas(gcf,'figs/mind_corrplot.pdf')
end
error('stop here')


%% MDS plots

for plottype=1:2
    close all
    if(plottype==1)
        % do a 2DIM subplot using mind_mds.pca2D
        mds_out=mind_mds.pca2D;
        fileout='figs/mind_pca2D.png';
    else
        mds_out=mind_mds.tsne;
        fileout='figs/mind_tsne2D.png';
    end
    
    % rotate for fitting better into screen
    % tempD=squareform(pdist(mds_out));
    % [ii jj]=find(tempD==max(tempD(:)));
    % dx=mds_out(ii(1),1)-mds_out(jj(1),1);
    % dy=mds_out(ii(1),2)-mds_out(jj(1),2);
    % alpha=atan(dy/dx);
    % rot_mat=[cos(alpha) -sin(alpha);sin(alpha) cos(alpha)];
    % mds_out=mds_out*rot_mat;
    
    %scale
    mds_out=mds_out./max(abs(mds_out(:)))*380;
    
    
    figure(2020)
    IF=2;
    subplot(5*IF,5*IF,[1:20*(IF^2)])
    for s=1:100
        figure(2020)
        subplot(5*IF,5*IF,[1:20*(IF^2)])
        hold on
        plot(mds_out(s,1),mds_out(s,2),'o','MarkerSize',5,'Color',classColors(classID(s),:),'MarkerFaceColor',classColors(classID(s),:))
        al='left';
        %if(mod(s,2)==1)
        %    al='right';
        %end
        th=text(mds_out(s,1)+3,mds_out(s,2)+1,sensations{s},'Rotation',0,'Color',classColors(classID(s),:),'FontSize',11,'HorizontalAlignment',al);
    end
    
    d = daspect;
    box off
    axis off
    %daspect([1 1 1])
    %axis([-380 380 -200 200])
    % plot the dimensions below
    temp=round(mds_out-min(mds_out))+40;
    mapmap=flipud(cbrewer('div','RdBu',11));
    mapmap(6,:)=[1 1 1]
    mean_data_centered=zscore(mean_dataZ);
    for d=1:5
        dtemp=[1 2 11 12];
        figure(2020+d)
        subplot(5*IF,5*IF,IF*(d-1)+dtemp+20*(IF^2))
        tempMat=zeros(max(temp)+40);
        for s=1:100
            tempMat(temp(s,1), temp(s,2))=mean_data_centered(s,d);
        end
        tempMatB=imgaussfilt(tempMat,17,'FilterSize',81);
        
        for s=1:100
            MulFac(s)=tempMat(temp(s,1), temp(s,2))/tempMatB(temp(s,1), temp(s,2));
        end
        
        imagesc(median(MulFac)*tempMatB',[-3 3])
        axis xy
        colormap(mapmap)
        %colorbar
        xlabel(dim_labels{d})
        %daspect([1 1 1])
        set(gca,'XTickLabel',[])
        set(gca,'XTick',[])
        set(gca,'YTick',[])
        set(gca,'YTickLabel',[])
    end
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gcf,'color',[1 1 1]);
    export_fig(fileout,'-m3')
end
error('stop here')

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
%saveas(gcf,['figs/mind_pca3D.png'])

%% dendrograms
close all
pd=pdist(mean_dataZ,'euclidean');
z=linkage(pd,'complete');
[H,T,OUTPERM] = dendrogram(z,0)
%axis equal
%axis square
set(gca,'XTick',[])
for s=1:100
    th=text(s,-.005,sensations{OUTPERM(s)},'Rotation',90,'BackgroundColor',classColors(classID(OUTPERM(s)),:),'FontSize',6,'HorizontalAlign','right','Color',[1 1 1]);
end

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
%saveas(gcf,['figs/mind_dendrogram_euclidean.png'])


%% run tsne
addpath('./external/tsne/')
rng(1)
%tsne_out=tsne(mean_data,classID);
% use instead tsne from sim
sim_mds=load('output/sim/sim_mds.mat');
tsne_out_orig=sim_mds.sim_mds.tsne;
tsne_out=tsne_out_orig;

% % we should rotate so that maximum distance between items is aligned with
% % screen width
% if(1)
% tempD=squareform(pdist(tsne_out));
% [ii jj]=find(tempD==max(tempD(:)));
% dx=tsne_out(ii(1),1)-tsne_out(jj(1),1);
% dy=tsne_out(ii(1),2)-tsne_out(jj(1),2);
%
% alpha=atan(dy/dx);
% rot_mat=[cos(alpha) -sin(alpha);sin(alpha) cos(alpha)];
%
% tsne_out=tsne_out*rot_mat;
% end

tsne_out=tsne_out./max(abs(tsne_out(:)))*380;


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
    th=text(tsne_out(s,1)+3,tsne_out(s,2)+1,sensations{s},'Rotation',0,'Color',map(classID(s),:),'FontSize',6,'HorizontalAlignment',al);
end

d = daspect;
box off
daspect([1 2 1])
axis off
%%
close all
borderPX=20;
sim_mds=load('output/sim/sim_mds.mat');

tsne_out_orig=sim_mds.sim_mds.tsne;
tsne_out=tsne_out_orig;

temp=round(tsne_out-min(tsne_out))+borderPX;
mapmap=flipud(cbrewer('div','RdBu',19));
% hotmap=hot(256);
% coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
% hotcoldmap=[
%     coldmap
%     zeros(1,3);
%     hotmap
%     ];
%
% mapmap=hotcoldmap;
mapmap((size(mapmap,1)+1)/2,:)=[1 1 1];
mapmap=[mapmap(1:(size(mapmap,1)+1)/2,:);mapmap((size(mapmap,1)+1)/2:end,:)];


clear mapmapI
for rgb=1:3
    mapmapI(:,rgb)=(interp1(mapmap(:,rgb),1:size(mapmap,1)/20:size(mapmap,1),'cubic'))';
end
mapmapI=mapmap;
%mapmapI((size(mapmapI,1)+1)/2,:)=[1 1 1];
mean_dataZ=zscore(mean_data);
for d=1:5
    figure(202+d)
    %subplot(5,5,d+20)
    tempMat=zeros(max(temp)+40);
    for s=1:100
        tempMat(temp(s,1), temp(s,2))=mean_dataZ(s,d);
    end
    tempMatB=imgaussfilt(tempMat,17,'FilterSize',70*2+1);
    
    for s=1:100
        MulFac(s)=tempMat(temp(s,1), temp(s,2))/tempMatB(temp(s,1), temp(s,2));
    end
    
    imagesc(median(MulFac)*tempMatB',[-2.5 2.5])
    axis xy
    colormap(mapmapI)
    %colorbar
    %title(dim_labels{d})
    %axis equal
    %daspect([200 400 1])
    set(gca,'XTickLabel',[])
    set(gca,'YTickLabel',[])
    
    %set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    %set(gcf,'color',[1 1 1]);
    %saveas(gcf,['figs/mind_tsne.png'])
    %axis equal
    h=gcf;
    
    set(h,'PaperOrientation','landscape');
    
    set(h,'PaperUnits','normalized');
    
    %set(h,'PaperPosition', [0 0 1 1]);
    %print(gcf, '-depsc -tiff -r300', 'sensations_simMDS.eps');
    %print -depsc -tiff -r300 sensations_body_simMDS.eps
    set(gca,'FontName','Arial')
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gcf,'Color',[1 1 1])
    %saveas(gcf,['mind_plots_simMDS.pdf'])
    export_fig(['figs/mind_sim_tsne_' num2str(d) '.png'],'-m4')
end
error('stop')
if(0)
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
end
