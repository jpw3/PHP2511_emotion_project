clear all
close all


cfg.outdata = '/m/nbe/scratch/braindata/eglerean/code/sensations/matlab/output/body/';
%cfg.datapath = '/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_embody_FI/subjects/';
cfg.datapath = '/m/nbe/scratch/braindata/eglerean/code/sensations/matlab/data/body/B1/';

cfg.Nstimuli = 100;
cfg.Nempty = 1;
cfg.list = [cfg.outdata 'body_list.txt'];


cfg.doaverage = 0;
%cfg.averageMatrix=(reshape([1:28]',[4 7]))';
%cfg.shuffleAverage = [2 1 3 5 7 6 4];
%cfg.hasBaseline = 1;
cfg.Nbatches=5;
cfg.posneg=0;
cfg.overwrite=1;
bspm = bodySPM_preprocess_batch(cfg);
save([cfg.outdata '/bspm.mat'])

%error('stop')
%% quality control and filtering
if(0)
for ss=1:cfg.Nstimuli
	figure(ss)
	loglog(squeeze(bspm.allTimes(ss,1,:)),squeeze(bspm.allTimes(ss,2,:)),'.');
	axis square
	saveas(gcf,[cfg.outdata '/allTimes_' num2str(ss)  '.png'])
end
end

% find amount of stimuli painted by each subjects
npainted=sum(~isnan(squeeze(bspm.allTimes(:,2,:))));
figure(1)
subplot(2,2,1)
stem(npainted);
subplot(2,2,2)
stem(sort(npainted));


ids=find(bspm.tocheck<=14);
ids=find(npainted>=15);
subjects=textread(cfg.list,'%s');
out=[];
for i = 1:length(ids)
    out{i,1}=subjects{ids(i)};
end

fileID=fopen([cfg.outdata '/whitelist.txt'],'w');
for i=1:length(out);
    if(~strcmp(out{i}(1),'F'))
        disp([out{i} ' has invalid ID for this study']);
        continue;
    end
    fprintf(fileID,'%s\n',[out{i}]);
end
fclose(fileID);



%% behav report

countryfile='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_sim/countries_FI.txt';
countries=textread(countryfile,'%s','delimiter','\n');
bdata=load([cfg.outdata '/behav_data.mat']);
behav_data=bdata.behav_data;
behav_labels=bdata.behav_labels;

if(length(out)~=length(bdata.out))
    behav_data=behav_data(ids,:);
end

disp( '---------------------------------')
disp( '>>> Summary statistics report <<<')
disp( '---------------------------------')
disp(['    Total number of subjects left less than 5 words empty: ' num2str(size(behav_data,1))])
disp(['    Median age, 5th and 95th percentiles: ' num2str(prctile(behav_data(:,2),[50 5 95]))])
disp(['    Male to female ratio: ' num2str(length(find(behav_data(:,1)==0))) '/' num2str(length(find(behav_data(:,1)==1)))])
% nationalities
cIDs=unique(behav_data(:,3));
disp(['    Country of residence:'])
for c=1:length(cIDs)
    temp=length(find(cIDs(c)==behav_data(:,3)));
    disp(['       ' countries{cIDs(c)} ': ' num2str(temp)])
end

cIDs=unique(behav_data(:,4));
disp(['    Country of origin'])
for c=1:length(cIDs)
    temp=length(find(cIDs(c)==behav_data(:,4)));
    disp(['       ' countries{cIDs(c)} ': ' num2str(temp)])
end
allTimes=bspm.allTimes;
save([cfg.outdata '/behav_data_whitelist.mat'],'behav_data','behav_labels','out','allTimes')

	
