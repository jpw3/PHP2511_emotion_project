clear all
close all


cfg.outdata = '/m/nbe/scratch/braindata/eglerean/code/sensations_embody/outdata/';
cfg.datapath = '/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_embody_FI/subjects/';
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
bspm = bodySPM_preprocess_batch(cfg);

error('stop')

for ss=1:cfg.Nstimuli
	figure(ss)
	loglog(squeeze(bspm.allTimes(ss,1,:)),squeeze(bspm.allTimes(ss,2,:)),'.');
	axis square
	saveas(gcf,[cfg.outdata '/allTimes_' num2str(ss)  '.png'])
end


ids=find(bspm.tocheck<=14);
subjects=textread(cfg.list,'%8c');

for i = 1:length(ids)
    out{i,1}=subjects(ids(i),:);
end

fileID=fopen([cfg.outdata '/whitelist.txt'],'w');
for i=1:length(out);
    if(~strcmp(out{i}(1),'F'))
        disp([out{i} ' has invalid ID for this study']);
        continue;
    end
    fprintf(fileID,'%s\n',[out{i}]);
end
fclose(fileID)
	
