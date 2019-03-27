clear all
close all

addpath(genpath('/m/nbe/scratch/braindata/eglerean/code/bodyspm/'));

cfg.outdata = '/m/nbe/scratch/braindata/eglerean/code/sensations/matlab/output/body/';

% original source:
% cfg.datapath = '/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_embody_FI/subjects/';
% data was synced to folder below:
cfg.datapath = '/m/nbe/scratch/braindata/eglerean/code/sensations/matlab/data/body/B1/';
cfg.Nstimuli = 100;
cfg.Nempty = 1;
cfg.phenodata = 0;
bspm=bodySPM_parseSubjects_batch(cfg);


%% filter subjects and output report
countryfile='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_sim/countries_FI.txt';
countries=textread(countryfile,'%s','delimiter','\n');

disp( '---------------------------------')
disp( '>>> Summary statistics report <<<')
disp( '---------------------------------')
disp(['    Total number of subjects who registered for the experiment: ' num2str(size(bspm.data_filter,1))])
ids=find(bspm.data_filter(:,1)>=26);
disp(['    Total number of subjects who completed at least one batch: ' num2str(size(ids,1))])
Nvariables=11;
% behav variables

behav_labels={
    'gender' %(F=1)
    'age'
    'living'
    'born'
    'weight'
    'height'
    'handedness' % (1 = right)
    'education'
    'psychologist'
    'psychiatrist'
    'neurologist'
};

behav_data=zeros(length(ids),Nvariables);
blacklist=[];
for i = 1:length(ids)
	out{i,1}=bspm.subjects(ids(i)).name;
    % load phenodata
   

    thisdata=zeros(1,Nvariables);
    
    temp=textread([cfg.datapath '/' out{i,1} '/data.txt' ],'%s','delimiter','\n');
    
    
    % go through each line
    
    for t=1:Nvariables % 11 variables
        if(t==3 || t == 4)
            for c=1:length(countries)
                if(strcmp(strtrim(temp{t}),strtrim(countries{c})))
                    thisdata(1,t)=c;
                    continue
                end
            end
        else
            thisdata(1,t)=str2num(temp{t});
        end
    end
    
    if(thisdata(2)<13) % we could filter out kids
        disp(['Skipping ' list(id).name ' (age is lower than 13)']);
        blacklist=[blacklist; id];
        
    end
    behav_data(i,:)=thisdata;
end
if(length(blacklist)==0) 
    disp(['    All subjects were older than 13 (minimum age = ' num2str(min(behav_data(:,2))) ')'])
else
   out(blacklist)=[];
   behav_data(blacklist,:)=[];
end
save([cfg.outdata '/behav_data.mat'],'behav_data','behav_labels','blacklist','out')

fileID=fopen([cfg.outdata '/body_list.txt'],'w');
for i=1:length(out); 
	if(~strcmp(out{i}(1),'F')) 
		disp([out{i} ' has invalid ID for this study']); 
		continue;
	end
	fprintf(fileID,'%s\n',[out{i}]);
end
fclose(fileID);


