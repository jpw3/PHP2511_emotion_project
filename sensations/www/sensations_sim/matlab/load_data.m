clear all
close all

%% load labels and categories
sensations=textread('/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations/sensations.txt','%s','delimiter','\n');
sensations_FI=textread('/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_FI/sensations_FI.txt','%s','delimiter','\n');
% words have been checked and lists are the same, using english labels from
% now on

sensations(1)=[]; % getting rid of first line, this is for easier CSV id matching
sensations_FI(1)=[];



%% load data
if(1)
    datapath='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_FI/subjects/';
    countryfile='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_FI/countries.txt';
    prefix='FI';
else
    datapath='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations/subjects/';
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
    if(Nresp == 0)
        disp(['Skipping ' list(id).name ' (no responses)']);
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
    
    if(thisdata(2)==0) 
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
dim_labels={'Bodily sensation strength','Mind sensation strength','Emotion intensity','Controllability','Last time'};
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

save data data sensations