clear all
close all
% definitions
sensations_classes
load_labels % makes variable labels

% loads the data
load output/sim/sim_data.mat

% probability density functions of the answers
all_distr=[];
netdistNaN=zeros(100);
for s1=1:100;
    for s2=(s1+1):100;
        temp=squeeze(simmat(s1,s2,:));

        
        [F]=ksdensity(temp,0:0.01:1);
        netdistNaN(s1,s2)=sum(isnan(temp))/size(simmat,3);
        netdistNaN(s2,s1)=sum(isnan(temp))/size(simmat,3);
        %netdist(l1,l2,:)=F;
        %netdistCV(l1,l2,:)=nanstd(temp)/nanmean(temp);
        %netdistM(l1,l2,:)=nanmean(temp);
        all_distr=[all_distr;F];
        
	end
end

% Note: we should check the gaussianity or other distribution of the curves i.e.
% that it is not bimodal so that it is good to look at the means
% At least we check that mean and median give same information:
mean_data_D=nanmean(simmat,3);
median_data_D=nanmedian(simmat,3);
vsim=nanvar(simmat,[],3);

% do median and mean look very similar? yes
[r_mM p_mM]=bramila_mantel(mean_data_D,median_data_D,5000,'spearman')

% does amount of Number of answers correlate with mean? No
[r_mnan p_mnan]=bramila_mantel(mean_data_D,netdistNaN,5000,'spearman')

% mantel test between mean distance matrix and distance based on classes
model_dist=sign(squareform(pdist(classID)));
[r_GT p_GT]=bramila_mantel(mean_data_D,model_dist,5000,'spearman');

%% split sample reliability
cfg=[];
% reshape the data so that they are one vector per subject
tempids=find(triu(ones(100),1));
cfg.data=zeros(length(tempids),size(simmat,3));
for s=1:size(simmat,3);
    temp=simmat(:,:,s);
    cfg.data(:,s)=temp(tempids);
end

cfg.niter=5000;

[icc permu icc_pvals]=bramila_splitsample(cfg);

% plot 
figure(123)
histogram(icc)
xlabel('Spearman Correlation')
ylabel('Distribution of split-sample correlations across each sensations pair')
% as the pvalues cannot be trust in similarity matrices, we need multiple
% calls to bramila_mantel
Nsubjhalf=floor(size(simmat,3)/2);
for i=1:cfg.niter
    disp(['Mantel test for split sample ' num2str(i)])
    gmat1=nanmean(simmat(:,:,permu(i,1:Nsubjhalf)),3);
    gmat2=nanmean(simmat(:,:,permu(i,(Nsubjhalf+1:end))),3);
    [rtemp(i,1) icc_pvals_mantel(i,1)]=bramila_mantel(gmat1,gmat2,5000,'spearman');
end

save output/sim/split_sample icc permu icc_pvals icc_pvals_mantel rtemp

error('stop')


%% multidimensional scaling
disp('CMDscale')
sim_mds.cmd=cmdscale(mean_data_D,2);

% MDS 3D
disp('cmd3D 3d')
sim_mds.cmd3D=cmdscale(mean_data_D,3);

% TSNE - only for visualization purposes
disp('tsne')
addpath('./external/tsne/')
load output/sim/best_tsne_seed.mat
[aa best_seeds]=sort(total_cost);
rng(best_seeds(5)) % identified with iterations, first 4 are degenerate cases
tsne_out=tsne_d(mean_data_D,classID,2,30,5000); % modified version that specifies num of permutations

% we should rotate so that maximum distance between items is aligned with
% screen width. We also change sign since it's arbitrary anyway.
mds_out=tsne_out;
tempD=squareform(pdist(mds_out));
[ii jj]=find(tempD==max(tempD(:)));
dx=mds_out(ii(1),1)-mds_out(jj(1),1);
dy=mds_out(ii(1),2)-mds_out(jj(1),2);
alpha=atan(dy/dx);
rot_mat=[cos(alpha) -sin(alpha);sin(alpha) cos(alpha)];
mds_out=mds_out*rot_mat;
mds_out=mds_out./max(abs(mds_out(:)))*380;
sim_mds.tsne=-1*mds_out; % we flip the sign only to have positive clusters on top right


save(['output/sim/sim_mds.mat'],'sim_mds','mean_data_D','labels','classID');

%% clustering  using dbscan
% using spatial distribution from original mean distances
EPS=[];
minpts = 5; % minimum items per cluster from smallest ground truth cluster
for minpts_loop=1:10; % optimising numbers of items
    % loop to identify best EPS that maximises number of clusters and
    % minimises outliers
    temp=[];
    for EPS=0:0.01:0.35    % optimising
        [class_from_data,type_from_data]=dbscan_D(mean_data_D,minpts_loop,EPS);
        NCFD=max(class_from_data); % num of clusters from data
        temp=[temp;NCFD EPS];
    end
    % use optimal EPS
    EPS=median(temp(find(temp(:,1)==max(temp(:,1))),2));
    [class_from_mean_data,type_from_mean_data]=dbscan_D(mean_data_D,minpts_loop,EPS);

    numoutliers(minpts_loop)=length(find(class_from_mean_data==-1))
end
minptsOPT=find(min(numoutliers)==numoutliers);

if(minptsOPT==minpts)
    disp('Optimal solution corresponds to min items per cluster from ground truth')
else
    disp('Optimal solution is:')
    minpts=minptsOPT
end

% given minpts, find fine-grained EPS optimal value
for EPS=0:0.001:0.35    % optimising
    [class_from_data,type_from_data]=dbscan_D(mean_data_D,minpts,EPS);
    NCFD=max(class_from_data); % num of clusters from data
    temp=[temp;NCFD EPS];
end
% use optimal EPS
EPS=median(temp(find(temp(:,1)==max(temp(:,1))),2));
[class_from_mean_data,type_from_mean_data]=dbscan_D(mean_data_D,minpts,EPS);
sim_cluster.DBSCAN.class_from_mean_data=class_from_mean_data;
sim_cluster.DBSCAN.type_from_mean_data=type_from_mean_data;
sim_cluster.DBSCAN.minpts=minpts;
sim_cluster.DBSCAN.EPS=EPS;

%% clustering with hierarchical clustering
z=linkage(squareform(mean_data_D),'complete');
for c=2:30
    h_cluster_solution=cluster(z,'MaxClust',c);
    mhc(c)=min(histc(h_cluster_solution,unique(h_cluster_solution)));
end
opt_c=min(find(diff(mhc>5)==-1)); % optimal numbers of clusters so that the smallest cluster is of size comparable to DBSCAN
sim_cluster.HC.class_from_mean_data=cluster(z,'MaxClust',opt_c);
sim_cluster.HC.NC=opt_c;

%% k-means clustering
% using spatial distribution from original mean distances
mds_out=sim_mds.cmd;
for NC=2:30
    k_cluster_solution=kmeans(mds_out,NC);
    mkc(NC)=min(histc(k_cluster_solution,unique(k_cluster_solution)));
end

opt_c=min(find(diff(mkc>5)==-1)); % optimal numbers of clusters so that the smallest cluster is of size comparable to DBSCAN
sim_cluster.KMEANS.class_from_mean_data=kmeans(mds_out,opt_c);
sim_cluster.KMEANS.NC=opt_c;

save(['output/sim/sim_cluster.mat'],'sim_cluster');

%% code for finding best seed for tsne plots
% it can still produce outliers due to the number of iteration, visually
% inspect each of them

% we tried also initializing TSN with known distances, not good results:
% tsne_out=tsne_d((mean_data_D),classID,cmdscale(mean_data_D,2),30,5000);

if(0)
close all
for rseed=1:100;
    rng(rseed)
	disp(num2str(rseed))
    tsne_out=tsne_d((mean_data_D),[],2,30,5000); % modified version that specifies num of permutations
    % normalize and scale, we should compensate for rotation...
    tsne_out=tsne_out-repmat(min(tsne_out),100,1);
    tsne_out=tsne_out./repmat(max(tsne_out),100,1);
    NNeigh=2;
    for cc=1:100
        temp=mean_data_D(cc,:);
        [aa bb]=sort(temp);
        bb(1)=[];
        aa(1)=[];
        for n=1:NNeigh
        
            dcost(rseed,cc,n)=sqrt((tsne_out(cc,1)-tsne_out(bb(n),1)).^2 +(tsne_out(cc,2) - tsne_out(bb(n),2)).^2);
        end
    end
    total_cost(rseed,1)=sum(sum(squeeze(dcost(rseed,:,:))));
end

best_seed=find(min(total_cost)==total_cost);
disp(['>>> The best TSNE viz is for rng seed ' num2str(find(min(total_cost)==total_cost)) ]);
save output/sim/best_tsne_seed total_cost dcost best_seed 
end

%% contour plots 

% spatial distribution from TSNE output
mds_out=sim_mds.tsne;

close all
NC=max(sim_cluster.DBSCAN.class_from_mean_data); % setting cluster numbers as ground truth clusters
clusterids=sim_cluster.DBSCAN.class_from_mean_data;
temp=round(mds_out-min(mds_out))+40;

% plots only to determine contours
mapmap=cbrewer('div','Spectral',11);
mapmap=[1 1 1;flipud(mapmap)];
for c=1:NC
    tempMat=zeros(max(temp)+40);

    for s=1:100
        if(clusterids(s)~=c) continue; end
        tempMat(temp(s,1), temp(s,2))=clusterids(s);
    end
    tempMatB=imgaussfilt(tempMat,17,'FilterSize',81);
    
    for s=1:100
        MulFac(s)=tempMat(temp(s,1), temp(s,2))/tempMatB(temp(s,1), temp(s,2));
    end
    figure(c)
    %imagesc(median(MulFac)*tempMatB',[0 12])
    %imagesc(tempMatB')
    [CC{c} HH]=contourf(tempMatB');
    axis xy
    colormap(mapmap)
    %colorbar
    %xlabel(dim_labels{d})
    %daspect([1 1 1])
    set(gca,'XTickLabel',[])
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    set(gca,'YTickLabel',[])
end
save output/sim/sim_contours_dbscan.mat CC



