clear all
close all
addpath(genpath('/scratch/braindata/eglerean/code/bodyspm/'))

map=cbrewer('div','RdBu',21);
map=flipud(map);
map(11,:)=[.3 .3 .3];


cfg=[];


cfg.outdata = '/m/nbe/scratch/braindata/eglerean/code/sensations_embody/outdata/';
cfg.datapath = '/m/nbe/scratch/braindata/eglerean/code/sensations_embody/outdata/';
cfg.Nstimuli = 100;
cfg.Nempty = 1;
cfg.list = [cfg.outdata 'list.txt'];


cfg.doaverage = 0;
%cfg.averageMatrix=(reshape([1:28]',[4 7]))';
%cfg.shuffleAverage = [2 1 3 5 7 6 4];
%cfg.hasBaseline = 1;
cfg.Nbatches=5;
cfg.posneg=0;
cfg.overwrite=1;



%model = load('pheno_filtered.csv');
%sex = load('pheno_sex.csv'); % females =1;
%sex = 2*(sex-1.5); % now it's with zero mean.

%model=[sex model];
%model_labels={'sex','age','edu','EDPS1','SCL1','TAS1','TAS2','TAS3','TAStotal'};

%labels={'Anger' 'Fear' 'Disgust' 'Happiness' 'Sadness' 'Surprise' 'Neutral' 'Baseline'};

base=uint8(imread('bodySPM_base2.png'));
mask=uint8(imread('bodySPM_base3.png'));
mask=mask*.85;
inmask=find(mask>128);


cfg.niter=0; % do not run cluster correction
bspm = bodySPM_ttest(cfg);
save([cfg.outdata 'bspm_ttest'], 'bspm')
error('stop');
Nsubj=size(model,1);
G=round(Nsubj/3);
allttest2={}
for m=2:size(model,2);
	temp=model(:,m);
	[aa bb]=sort(temp,1,'descend');
	
	g1=bb(1:G);
	g2=bb((end-G+1):end);
	cfg.g1=g1;
	cfg.g2=g2;
	cfg.niter=0;
	cfg.uncorrected=1;
	bspm = bodySPM_ttest2(cfg);
	allttest2{m}=bspm.ttest2;
	figure(m)
	M=max(abs(bspm.ttest2.tval(:)));
	for cond=1:length(labels)
		subplot(2,4,cond)
		h=imagesc(bspm.ttest2.pmask(:,:,cond).*bspm.ttest2.tval(:,:,cond),[-M M]);
		set(h,'AlphaData',mask)
		title(labels{cond})
		colormap(map)
		colorbar
		axis off
		box off
	end
	saveas(gcf,['pngs/ttest2_' model_labels{m} '.png'])
end
error('stop')




% idea: since distr of subj is multimodal, we need a way to subdivide group
% we can pick one score and divide in quantiles
% or we can build a network on all scores and separate accordingly/clusters
% we can include or exclude age/edu (or regress them out in the model)


modeldist=pdist(model(:,3:end));
z=linkage(modeldist,'complete');
[h t perm]= dendrogram(z,0,'Orientation','Left');
clu=cluster(z,'Maxclust',7);
for cID=1:7
	cids=find(clu==cID);
	clurez(cID,:)=[mean(model(cids,:),1) length(cids)];
end

saveas(gcf,'pngs/model_dendrogram.png');
figure
modeldistnet=squareform(modeldist);
imagesc(modeldistnet(perm,perm));
colormap(map);
saveas(gcf,'pngs/model_net.png');
close



for modelID=1:length(model_labels);
	figure
	hist(model(:,modelID),50);
	title(model_labels{modelID})
	saveas(gcf,['pngs/hist_' model_labels{modelID} '.png'])
	close all

	for stimulus=1:length(labels);
		tempdata=bspm.pvals(:,modelID,stimulus);
		tempdataC=bspm.glm(:,modelID,stimulus);
		tempdata(find(isnan(tempdata)))=0;
		q=mafdr(tempdata(inmask),'BHFDR','true');
		tempmask=double(q<0.05);
		out(modelID,stimulus)=sum(tempmask);
		tempdataout=zeros(size(tempdata));
		tempdataout(inmask)=tempmask.*tempdataC(inmask);
		outfig=reshape(tempdataout,size(mask,1),size(mask,2));
		min(outfig(:))
		max(outfig(:))
		h=imagesc(outfig,[-.2 .2]);
		colormap(map);
		colorbar;
		set(h,'AlphaData',mask)
		axis equal
		title([model_labels{modelID} ' vs ' labels{stimulus}]);
		saveas(gcf,['pngs/model ' model_labels{modelID} ' - ' labels{stimulus} '.png']);
	end
end

