clear all
close all

addpath(genpath('/m/nbe/scratch/braindata/eglerean/code/bodyspm/'));

cfg.outdata = '/m/nbe/scratch/braindata/eglerean/code/sensations_embody/outdata/';
cfg.datapath = '/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_embody_FI/subjects/';
cfg.Nstimuli = 100;
cfg.Nempty = 1;
cfg.phenodata = 0;
bspm=bodySPM_parseSubjects_batch(cfg);

ids=find(bspm.data_filter(:,1)>=26);
for i = 1:length(ids)
	out{i,1}=bspm.subjects(ids(i)).name;
end

fileID=fopen([cfg.outdata '/list.txt'],'w');
for i=1:length(out); 
	if(~strcmp(out{i}(1),'F')) 
		disp([out{i} ' has invalid ID for this study']); 
		continue;
	end
	fprintf(fileID,'%s\n',[out{i}]);
end
fclose(fileID)


