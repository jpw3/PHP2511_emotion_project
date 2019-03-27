clear all
close all
% make sure bodyspm toolbox code is updated and open
addpath(genpath('/m/nbe/scratch/braindata/eglerean/code/bodyspm/'))
addpath('external')
map=cbrewer('div','RdBu',21);
map=flipud(map);
map(11,:)=[.3 .3 .3];

cfg=[];
cfg.outdata = '/m/nbe/scratch/braindata/eglerean/code/sensations/matlab/output/body/';
cfg.datapath = '/m/nbe/scratch/braindata/eglerean/code/sensations/matlab/output/body/';

cfg.Nstimuli = 100;
cfg.Nempty = 1;
cfg.list = [cfg.outdata 'whitelist.txt'];
cfg.doaverage = 0;
% options below are not needed
%cfg.averageMatrix=(reshape([1:28]',[4 7]))';
%cfg.shuffleAverage = [2 1 3 5 7 6 4];
%cfg.hasBaseline = 1;
cfg.Nbatches=5;
cfg.posneg=0;
cfg.overwrite=1;
cfg.niter=0; % do not run cluster correction
if(0)

bspm = bodySPM_ttest(cfg);


%% transform t-tests into effect sizes
% replace tvalues with effect sizes
for cc=1:100
   bspm.ttest.es(:,:,cc)= bspm.ttest.tval(:,:,cc)/sqrt(bspm.ttest.df(cc)+1);
end
save([cfg.outdata 'bspm_ttest'], 'bspm')

end

%% compute reliability of means
% prepare data as vectors
base=uint8(imread('bodySPM_base2.png'));
mask=uint8(imread('bodySPM_base3.png'));
mask=mask*.85;
base2=base(10:531,33:203,:);
in_mask=find(mask>128);
subjects=textread(cfg.list,'%s');
Nsubj=size(subjects,1);


for ns=1:Nsubj;
    disp(['Processing subject ' subjects{ns} ' which is number ' num2str(ns) ' out of ' num2str(Nsubj)]);
    matname=[cfg.datapath '/' subjects{ns} '.mat'];
    load (matname) % 'resmat','resmat2','times'
    if(cfg.doaverage==0)
        tempdata=reshape(resmat,[],size(resmat,3));
    else 
        tempdata=reshape(resmat2,[],size(resmat2,3));
    end
	if(ns==1)
        [ length(in_mask) Nsubj size(tempdata,2) ]
		alldata=zeros(length(in_mask),Nsubj,size(tempdata,2));
	end
	alldata(:,ns,:)=tempdata(in_mask,:);
end

% for pixel 1 we run it to get the permu
cfg=[]
cfg.data=(squeeze(alldata(1,:,:)))';
cfg.niter=100;
[icc permu iccp]=bramila_splitsample(cfg);
cfg.permu=permu;

% for each pixel we compute a median value of reliability
for pixel=1:size(alldata,1);
    cfgtemp=cfg;
    %if(mod(pixel,100)==1)
        disp([num2str(pixel) ' out of ' num2str(size(alldata,1))])
    %end
    cfgtemp.data=(squeeze(alldata(pixel,:,:)))';
    [icc permu iccp]=bramila_splitsample(cfgtemp);
    pvm(pixel,1)=median(icc);
    pvmp(pixel,1)=median(iccp);
end

save output/body/split_sample.mat pvm pvmp permu mask

%% plot results
load output/body/split_sample.mat
subplot(1,2,1)
body_consistency=zeros(size(mask));
body_consistency(find(mask>128))=pvm;
imagesc(mask)
hold on
imagesc((body_consistency),([.53 1]))
hotmap=hot(64);
hotmap=[[1 1 1]/2;hotmap]
colormap(hotmap)
h=colorbar
ylabel(h,['Median split group consistency' newline '[Spearmann corr.]'])
axis equal
axis off

subplot(1,2,2)
body_consistency_median_p=zeros(size(mask));
body_consistency_median_p(find(mask>128))=-log10(pvmp+eps*eps);
%pvmp=pvmp*length(pvmp);
pvmQ=mafdr(pvmp,'BHFDR','true');
imagesc((body_consistency_median_p))
colormap(hotmap)
h=colorbar
%pticks=get(h,'Ticks');
%set(h,'Ticks',sort([min(-log10(pvmQ)) pticks]));
pticks=get(h,'Ticks');
set(h,'TickLabels',num2str(10.^-pticks'))
axis equal
axis off

ylabel(h,['Median split group consistency' newline '[FDR corrected p-values]'])
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/body_consistency_of_tool.png'
plot2svg('figs/body_consistency_of_tool.svg', gcf)
    

