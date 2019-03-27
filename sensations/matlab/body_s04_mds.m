clear all
close all

%% setting up
addpath(genpath('external/'))
load('output/body/bspm_ttest.mat');
mask=uint8(imread('bodySPM_base3.png'));
in_mask=find(mask>128); % list of pixels inside the mask
base=uint8(imread('bodySPM_base2.png'));
base2=base(10:531,33:203,:); % single image base
sensations_classes
load_labels % makes variable labels

mean_data=zeros(length(in_mask),100); % will contain effect sizes vectors
for n=1:100
	temp=bspm.ttest.es(:,:,n); % uses the effect sizes
	mean_data(:,n)=temp(in_mask); % only pixel in masks
end
mean_data=mean_data'; % sensations are now rows of effect sizes

%% Multidimensional scaling
% PCA 2D
%disp('pca 2d')
%pcadata=[(mean_data)]; % data as it is
%[coeff, score, latent, tsquared, explained] = pca(pcadata);
%[L1, T]=rotatefactors(coeff(:,1:2));
%score_rot=pcadata*L1;
%body_mds.pca2D=score_rot;

% cmdscale function
disp('CMDscale')
body_mds.cmd=cmdscale(squareform(pdist(mean_data)),2);
% PCA 3D
%disp('pca 3d')
%pcadata=[mean_data];
%[coeff, score, latent, tsquared, explained] = pca(pcadata);
%[L1, T]=rotatefactors(coeff(:,1:3));
%body_mds.pca3D=pcadata*L1;

%% TSNE

% note: tsne can be done on the original data as they are, but also by
% constructing distance matrices as done for the 'sim' case. Since these
% are just exploratory, we stick with the most simple approach (no
% similarity computed)

% optimisation cycle
if(0)
for rseed=1:100;
    rng(rseed)
    disp(num2str(rseed))
    [tsne_out tsne_D]=tsne(mean_data,classID,2,30,30,5000); % modified version that specifies num of permutations
    % normalize and scale, we should compensate for rotation...
    tsne_out=tsne_out-repmat(min(tsne_out),100,1);
    tsne_out=tsne_out./repmat(max(tsne_out),100,1);
    NNeigh=2;
    for cc=1:100
        temp=tsne_D(cc,:);
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
save output/body/best_tsne_seed total_cost dcost best_seed
else
    load output/body/best_tsne_seed
end
[aa best_seeds]=sort(total_cost);
close all
rng(best_seeds(1)) % needs to be quality checked
[tsne_out tsne_D]=tsne(mean_data,classID,2,30,30,5000);
% we should rotate so that maximum distance between items is aligned with
% screen width
mds_out=tsne_out;
tempD=squareform(pdist(mds_out));
[ii jj]=find(tempD==max(tempD(:)));
dx=mds_out(ii(1),1)-mds_out(jj(1),1);
dy=mds_out(ii(1),2)-mds_out(jj(1),2);
alpha=atan(dy/dx);
rot_mat=[cos(alpha) -sin(alpha);sin(alpha) cos(alpha)];
mds_out=mds_out*rot_mat;
mds_out=mds_out./max(abs(mds_out(:)))*380;

body_mds.tsne=mds_out;
figure
plot(mds_out(:,1),mds_out(:,2),'o')
hold on
for s=1:100
    text(mds_out(s,1),mds_out(s,2),labels{s})
end
save(['output/body/body_mds.mat'],'body_mds','mean_data','labels','classID');

