clear all
close all

%% load labels and categories
sensations=textread('/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations/sensations.txt','%s','delimiter','\n');
sensations_FI=textread('/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_FI/sensations_FI.txt','%s','delimiter','\n');
% words have been checked and lists are the same, using english labels from
% now on

sensations(1)=[]; % getting rid of first line, this is for easier CSV id matching
sensations_FI(1)=[];



%% load data and performs some screening
for experID=1:2
    
    if(experID == 1)
        datapath='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_FI/subjects/';
        datapath='./data/mind/M1/';
        countryfile='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_FI/countries.txt';
        prefix='FI';
    else
        datapath='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations/subjects/';
        datapath='./data/mind/M2/';
        countryfile='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations/countries.txt';
        prefix='UK';
    end
    
    list=dir([datapath '/' prefix '*']);
    countries=textread(countryfile,'%s','delimiter','\n');
    
    % blacklist subjects with age == 0 or with no responses
    blacklist=[];
    
    Nvariables=11;
    % array contains 11 variables
    %   sex : 0 (male) 1 (female)
    %   age : number
    %   residence : string
    %   birth : string
    %   weight : number
    %   height : number
    %   handedness : 0 (left) right (1)
    %   education : 0 (low) 1 (high) 2 (higher)
    %   psychologist : 0 (no) 1 (yes)
    %   psychiatrist : 0 (no) 1 (yes)
    %   neurologist : 0 (no) 1 (yes)
    
    behav_data=zeros(length(list),Nvariables+1);
    for id=1:length(list)
        thisdata=zeros(1,Nvariables+1);
        
        temp=textread([datapath '/' list(id).name '/data.txt' ],'%s','delimiter','\n');
        resplist=dir([datapath '/' list(id).name '/*.csv']);
        resp={};
        for rl=1:length(resplist)
            if(regexp(resplist(rl).name,'^[0-9]'))
                resp{end+1}=resplist(rl).name;
            end
        end
        % number of responses
        Nresp=length(resp);
        thisdata(end)=Nresp;
        if(Nresp < 20)
            disp(['Skipping ' list(id).name ' (not enough responses)']);
            blacklist=[blacklist;id];
            
        end
        
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
            disp(['Skipping ' list(id).name ' (age is zero)']);
            blacklist=[blacklist; id];
            
        end
        behav_data(id,:)=thisdata;
    end
    
    blacklist=unique(blacklist);
    whitelist=ones(length(list),1);
    whitelist(blacklist)=0;
    
    good_subj_list=list(find(whitelist));
    Nsubj = length(good_subj_list);
    
    %% load the actual data
    % data = words x dimensions x good subjects
    % 5 dimensions listed here:
    Ndim=5;
    dim_labels={ %'Bodily sensation strength','Mind sensation strength','Emotion intensity','Agency','Last time'};
		'Bodily saliency' % How much feels in body question
		'Mental saliency' % How much involves the mind
		'Emotion' % emotional valence question
		'Controllability' % how much you can control question (used to be agency)
		'Lapse' % last time question
	};	
    data=NaN(length(sensations),Ndim,Nsubj);
    for s=1:Nsubj
        resplist=dir([datapath '/' good_subj_list(s).name '/*.csv']);
        resp={};
        for rl=1:length(resplist)
            if(regexp(resplist(rl).name,'^[0-9]'))
                resp{end+1}=resplist(rl).name;
                respIDtemp=strsplit(resplist(rl).name,'_');
                respID=str2num(respIDtemp{1});
                thisdata=load([datapath '/' good_subj_list(s).name '/' resplist(rl).name]);
                data(respID,:,s)=thisdata(end,:); % it needs the 'end' because it's the last answer recorded for when subj hit back button
            end
        end
    end
    
    save(['output/mind/M' num2str(experID) '_data'], 'data', 'sensations', 'dim_labels','behav_data','good_subj_list','blacklist','whitelist');
    
end


%% some subject stats
clear all
close all
load output/mind/M1_data.mat
disp(['Initial number of participants: ' num2str(size(behav_data,1))])

behav=behav_data(find(whitelist),:);
disp(['Number of participants after screening for age and number of responses: ' num2str(size(behav,1))])
disp(['Males/females: ' num2str(length(find(behav(:,1)==0))) '/' num2str(length(find(behav(:,1)==1)))])
age_Q=prctile(behav(:,2),[0 25 50 75 100]);
disp(['Age (min, q1, median, q2, max): ' num2str(age_Q)])

countryfile='../countries_FI.txt';
countries=textread(countryfile,'%s','delimiter','\n');
[nn bb]=histcounts(behav(:,3),length(countries));
cids=find(nn>0);
disp(['Country of residence'])
for iii=1:length(cids)
    disp([countries{ceil(bb(cids(iii)))} ': ' num2str(nn(cids(iii)))])
end

[nn bb]=histcounts(behav(:,4),length(countries));
disp(' ')
disp(['Country of birth'])
cids=find(nn>0);
for iii=1:length(cids)
    disp([countries{ceil(bb(cids(iii)))} ': ' num2str(nn(cids(iii)))])
end





