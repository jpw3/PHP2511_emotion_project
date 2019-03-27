clear all
close all
sensations_classes % loads the ground truth

% data from the similarity task, we can also access individual data for
% reproducibility and stability of results
simdata=load('output/sim/sim_mds.mat');

% data from the dimension rating task
minddata=load('output/mind/mind_mds.mat');

% data from the body painting task
bodydata=load('output/body/body_mds.mat'); % one could argue that we should use Eff sizes

% semantic data
load_semantics % script makes semdata

% neurosynth
% how to deal with missing values?
nsdata=load('output/ns/ns_manual_mds.mat')

%% Approach 1: robust regression between distance matrices
ids=find(triu(ones(100),1)); % top triangle

Y_dm=simdata.mean_data_D;
all_dm(:,:,1)=Y_dm;
Y=zscore(Y_dm(ids));
X1=[];
% X1 mind
for mr=1:5 % 5 regressors
    X1_dm(:,:,mr)=squareform(pdist(minddata.mean_data(:,mr)));
    temp=X1_dm(:,:,mr);
    X1=[X1 zscore(temp(ids))];
end
all_dm(:,:,2:6)=X1_dm;
% X2 body, we use multiple distances
X2_dm_1=squareform(pdist(bodydata.mean_data));
X2_dm_2=squareform(pdist(bodydata.mean_data,'spearman'));
X2_dm_3=squareform(pdist(bodydata.mean_data,'cosine'));
X2_dm=X2_dm_1;
X2=[zscore(X2_dm_1(ids)) zscore(X2_dm_2(ids)) zscore(X2_dm_3(ids))];

all_dm(:,:,7)=X2_dm_1;
all_dm(:,:,8)=X2_dm_2;
all_dm(:,:,9)=X2_dm_3;

% X3 semantics
X3_dm=semdata.mean_data_D;
X3=[zscore(X3_dm(ids))];
all_dm(:,:,10)=X3_dm;
X4_dm=nsdata.ns_dm;
X4_dm(1:101:end)=0;
mmm=nanmedian(X4_dm(ids));
X4_dm(find(isnan(X4_dm)))=mmm;
X4=[zscore(X4_dm(ids))];
all_dm(:,:,11)=X4_dm;

dim_labels={%'Bodily sensation strength','Mind sensation strength','Emotion intensity','Agency','Last time', 'Bodily sensation maps (Eucl.)','Bodily sensation maps (Spear.)','Bodily sensation maps (Cos.)','Semantic similarity', 'NeuroSynth'};
'Bodily saliency'
'Mental saliency'
'Emotion'
'Controllability'
'Lapse'
'Bodily sensation maps (Eucl.)'
'Bodily sensation maps (Spear.)'
'Bodily sensation maps (Cos.)'
'Semantic similarity'
'NeuroSynth'
}


%save all_dm all_dm dim_labels
X=[X1 X2 X3 X4];
[betas stats]=robustfit(X,Y);
if(0)
    % permutations for betas
    NPERM=5000;
    if(1)
        surrobetas=zeros(length(betas),NPERM);
        rng(0,'twister')
        for iter=1:NPERM
            disp(num2str(iter))
            shuff=randperm(100);
            temp=Y_dm(shuff,shuff);
            surroY=zscore(temp(ids));
            [tempbetas]=robustfit(X,surroY);
            surrobetas(:,iter)=tempbetas;
        end
        save surrobetas10 surrobetas
    else
        load surrobetas10
    end
    
    %% plot results
    for bID=2:length(betas)
        figure(100)
        subplot(length(dim_labels),1,bID-1)
        [h b]=hist(surrobetas(bID,:));
        plot(b,h)
        hold on
        axis([-0.08 0.8 0 2000])
        plot([betas(bID) betas(bID)],[0 2000],'k')
        p=length(find(surrobetas(bID,:)>betas(bID)))/NPERM;
        title([dim_labels{bID-1} ' beta = ' num2str(betas(bID),3) ' p = ' num2str(p,3)] )
    end
end

%% Approach 2: mantel between each pair of distance matrices
alldimlabels(1)={'Feeling space'};
alldimlabels(2:(length(dim_labels)+1))=dim_labels;

%alldimlabels={
%
%'Bodily saliency'
%'Mental saliency'
%'Emotion'
%'Controllability'
%'Lapse'
%'Bodily sensation maps'
%'Semantic similarity'
%'NeuroSynth'
%};

tempdata=[Y X];
rda_r=zeros(size(tempdata,2));
rda_p=zeros(size(tempdata,2));
% run mantel to test significance
if(0)
    for d1=1:size(tempdata,2)
        
        for d2=(d1+1):size(tempdata,2)
            idsOI=(1:4950)';
            SS=100;
            if(d1==11 || d2==11)
                idsOI=find(nsdata.ns_dm(ids)>0);
                SS=44;
            end
            mat1=zeros(SS);
            mat1(find(triu(ones(SS),1)))=tempdata(idsOI,d1);
            mat1=mat1+mat1';
            
            mat2=zeros(SS);
            mat2(find(triu(ones(SS),1)))=tempdata(idsOI,d2);
            mat2=mat2+mat2';
            rng(0); % same permutations for each pair of dimensions
            [rtemp ptemp]=bramila_mantel(mat1,mat2,5000,'spearman')
            rda_r(d1,d2)=rtemp;
            rda_p(d1,d2)=ptemp;
        end
    end
    save output/mantel_rda rda_r rda_p
else
    load output/mantel_rda
end
rda_r=rda_r+rda_r'+eye(size(rda_r));

q=mafdr(rda_p(find(triu(ones(size(rda_p)),1))),'BHFDR','true');
mask_p=zeros(size(rda_p));
mask_p(find(triu(ones(size(rda_p)),1)))=q<0.05;

mask_p(find(triu(ones(size(rda_p)),1)))=mask_p(find(triu(ones(size(rda_p)),1)))+(q<0.005); %



%% make the figure


figure(1)
imagesc(rda_r,.6*[0 1])
hold on
% add a plot of stars
for d1=1:size(mask_p,2)
    for d2=(d1+1):size(mask_p,2)
        if(mask_p(d1,d2)==1) text(d1,d2,'*','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==2) text(d1,d2,'**','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==1) text(d2,d1,'*','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==2) text(d2,d1,'**','FontSize',20,'HorizontalAlignment','center'); end
    end
end

map=cbrewer('seq','YlOrRd',16);
map=[0.5020/2         0    0.1490/2;flipud(map);1 1 1;];
colormap(map)
hcb=colorbar
ylabel(hcb,'Similarity (Spearman''s correlation)')
set(gca,'YTick',1:length(alldimlabels))
set(gca,'YTickLabel',alldimlabels)
set(gca,'XTick',1:length(alldimlabels))
set(gca,'XTickLabel',alldimlabels,'XTickLabelRotation',90)
axis square
set(gcf,'Color','white')
export_fig -m4 'figs/merged_RDA_full.png'
plot2svg('figs/merged_RDA_full.svg',gcf) 
%% repeat figure but remove columns 8 and 9
rda_r(8:9,:)=[];
rda_r(:,8:9)=[];
mask_p(8:9,:)=[];
mask_p(:,8:9)=[];
alldimlabels(8:9)=[];
alldimlabels{7}='Bodily sensation maps';
figure(2)
imagesc(rda_r,.6*[0 1])
hold on
% add a plot of stars
for d1=1:size(mask_p,2)
    for d2=(d1+1):size(mask_p,2)
        if(mask_p(d1,d2)==1) text(d1,d2,'*','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==2) text(d1,d2,'**','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==1) text(d2,d1,'*','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==2) text(d2,d1,'**','FontSize',20,'HorizontalAlignment','center'); end
    end
end

map=cbrewer('seq','YlOrRd',16);
map=[0.5020/2         0    0.1490/2;flipud(map);1 1 1;];
colormap(map)
hcb=colorbar
ylabel(hcb,'Similarity (Spearman''s correlation)')
set(gca,'YTick',1:length(alldimlabels))
set(gca,'YTickLabel',alldimlabels)
set(gca,'XTick',1:length(alldimlabels))
set(gca,'XTickLabel',alldimlabels,'XTickLabelRotation',90)
axis square
set(gcf,'Color','white')
export_fig -m4 'figs/merged_RDA.png'


%% perform RDA for each cluster separately
load output/sim/sim_cluster.mat
dbscan_cluster_labels={
  'Homeostatic states'
  'Cognitive processes'
  'Somatic states and illnesses'
  'Positive emotions'
  'Negative emotions'
  'Between clusters'
};

tempdata=[Y X];
tempdata(:,8:9)=[]; % we stopped using other metrics for body map distances
figure(100)
subplot(2,3,1)
imagesc(corr(tempdata,'type','spearman'),.6*[0 1])
title('Across all sensations')
gmap=cbrewer('seq','Greys',16);
map2=[(gmap);0 0 0;0 0 0;0 0 0;map];
map2(1,:)=[];

% add a plot of stars
for d1=1:size(mask_p,2)
    for d2=(d1+1):size(mask_p,2)
        if(mask_p(d1,d2)==1) text(d1,d2,'*','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==2) text(d1,d2,'**','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==1) text(d2,d1,'*','FontSize',20,'HorizontalAlignment','center'); end
        if(mask_p(d1,d2)==2) text(d2,d1,'**','FontSize',20,'HorizontalAlignment','center'); end
    end
end

colormap(map)
colorbar
set(gca,'YTick',1:length(alldimlabels))
set(gca,'YTickLabel',alldimlabels)
set(gca,'XTick',[])

% for each cluster
rda_r_clu=zeros(size(tempdata,2),size(tempdata,2),5);
rda_p_clu=zeros(size(tempdata,2),size(tempdata,2),5);
for c=1:5
    cids=find(sim_cluster.DBSCAN.class_from_mean_data==c);
    % run stats for each pair
    for d1=1:size(tempdata,2)
        for d2=(d1+1):size(tempdata,2)
            idsOI=(1:4950)';
            SS=100;
            if(d1==9 || d2==9) % now it is 9 for neurosynth
                idsOI=find(nsdata.ns_dm(ids)>0);
                SS=44;
            end
            mat1=zeros(SS);
            mat1(find(triu(ones(SS),1)))=tempdata(idsOI,d1);
            mat1=mat1+mat1';
            
            mat2=zeros(SS);
            mat2(find(triu(ones(SS),1)))=tempdata(idsOI,d2);
            mat2=mat2+mat2';
            rng(0); % same permutations for each pair of dimensions
            
            if(d1==9 || d2==9)
                joined=intersect(nsdata.nsIDs,cids);
                cids_temp=[];
                for tt=1:length(joined)
                    cids_temp=[cids_temp;find(joined(tt)==nsdata.nsIDs)];
                end
            else
                cids_temp=cids;
            end
            
            
            [rtemp ptemp]=bramila_mantel(mat1(cids_temp,cids_temp),mat2(cids_temp,cids_temp),5000,'spearman')
            rda_r_clu(d1,d2,c)=rtemp;
            rda_p_clu(d1,d2,c)=ptemp;
        end
        
    end
    %tempdata_clu=tempdata(cids,:);
    figure(100)
    subplot(2,3,c+1)
    %rda_clu=corr(tempdata_clu,'type','spearman');
    rda_clu=rda_r_clu(:,:,c);
    rda_clu=rda_clu+rda_clu'+eye(size(rda_clu));
    rda_clu(find(isnan(rda_clu)))=0;
    imagesc(rda_clu,.6*[0 1])
    axis square
    colormap(map)
    colorbar
    title([dbscan_cluster_labels{c} ' (items = ' num2str(length(cids)) ', ns-items = ' num2str(length(cids_temp)) ')'])
    
    
    temp_p = rda_p_clu(:,:,c);
    
    q=mafdr(temp_p(find(triu(ones(size(temp_p)),1))),'BHFDR','true');
    mask_p=zeros(size(temp_p));
    mask_p(find(triu(ones(size(temp_p)),1)))=q<0.05;
    
    mask_p(find(triu(ones(size(temp_p)),1)))=mask_p(find(triu(ones(size(temp_p)),1)))+(q<0.005); %
    
    %error('stop')
    
    for d1=1:size(mask_p,2)
        for d2=(d1+1):size(mask_p,2)
            if(mask_p(d1,d2)==1) text(d1,d2,'*','FontSize',20,'HorizontalAlignment','center'); end
            if(mask_p(d1,d2)==2) text(d1,d2,'**','FontSize',20,'HorizontalAlignment','center'); end
            if(mask_p(d1,d2)==1) text(d2,d1,'*','FontSize',20,'HorizontalAlignment','center'); end
            if(mask_p(d1,d2)==2) text(d2,d1,'**','FontSize',20,'HorizontalAlignment','center'); end
        end
    end
    set(gca,'YTick',[])
    set(gca,'XTick',[])
    
    if(c==3)
    set(gca,'YTick',1:length(alldimlabels))
    set(gca,'YTickLabel',alldimlabels)
    end
    if(c>2)
    set(gca,'XTick',1:length(alldimlabels))
    set(gca,'XTickLabel',alldimlabels,'XTickLabelRotation',90)
    end
    pause(5)
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    set(gcf,'color',[1 1 1]);
export_fig -m4 'figs/merged_RDA_percluster.png'
error('stop')

%% partial correlation between all variables
% datasim=[Y X];
%
% for d1=1:8
%     var11=
%     for d2=(d1+1):8
%     end
% end
%


%% network overlap
nd=zeros(100,8);
for dID=1:8
    tempnet=all_dm(:,:,dID);
    tempnet=tempnet/max(tempnet(:));
    tempnet=1-tempnet.^2; % they are now similarities
    nd(:,dID)=sum(tempnet);
    [aaa bbb]=sort(nd(:,dID));
    nd_rank(bbb,dID)=(1:100)';
end
corr(nd_rank)
avg_nd_rank=mean(nd_rank,2);
figure(1000)
stem(avg_nd_rank)
set(gca,'XTick',[])
hold on
load('output/mind/M1_data')

map=cbrewer('qual','Set1',max(classID));
map(6,:)=[0 0 0];

for s=1:100
    th=text(s,-.1,sensations{s},'Rotation',90,'Color',[0 0 0],'FontSize',7,'HorizontalAlignment','right');
    th=text(s,.1,sensations{s},'Rotation',90,'Color',[0 0 0],'FontSize',7,'HorizontalAlignment','right');
    
    th=text(s,0,sensations{s},'Rotation',90,'Color',map(classID(s),:),'FontSize',7,'HorizontalAlignment','right');
end


