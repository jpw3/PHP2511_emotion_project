clear all
close all
addpath('/m/nbe/scratch/braindata/shared/toolboxes/cbrewer/');

datapath='./data/similarity/S1/';
countryfile='/m/nbe/archive/braindata/2015/bml_www/backup/emotion.becs.aalto.fi/sensations_sim/countries_FI.txt';
prefix='FI';
load_labels
sensations=labels;
sensations_classes
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

behav_data=zeros(length(list),Nvariables+2);
for id=1:length(list)
    thisdata=zeros(1,Nvariables+2);
    
    temp=textread([datapath '/' list(id).name '/data.txt' ],'%s','delimiter','\n');
    resplist=dir([datapath '/' list(id).name '/*.csv']);
    resp={};
    for rl=1:length(resplist)
        if(regexp(resplist(rl).name,'^[0-9]'))
            resp{end+1}=resplist(rl).name;
        end
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
        disp(['Skipping ' list(id).name ' (age is lower than 13)']);
        blacklist=[blacklist; id];
        
    end
    behav_data(id,:)=thisdata;
end

blacklist=unique(blacklist);
whitelist=ones(length(list),1);
whitelist(blacklist)=0;
behav_data_unfiltered=behav_data;
behav_data(blacklist,:)=[];
good_subj_list=list(find(whitelist));
Nsubj = length(good_subj_list);

%% load the actual data
% 
DOPLOT=0;
moved=zeros(100,Nsubj);
for s=1:Nsubj
    fid = fopen([datapath '/' good_subj_list(s).name '/outdata.csv'],'rt');
    indata = textscan(fid, '%s', 'HeaderLines',1);
    fclose(fid);
    yourdata = indata{1};
    if(length(yourdata)==0) 
        disp('found a bad subject')
        
        continue; 
    end
    
    datastart=str2num(yourdata{1}); % used only for the timestamp
    %x_start(:,s)=datastart(1:2:200);
    %y_start(:,s)=datastart(2:2:200);
    
    %timestamps=zeros(length(yourdata),1);
    %for tt=1:length(yourdata)
    %    datatemp=str2num(yourdata{tt});
    %    timestamps(tt,1)=datatemp(end);
    %end
    
    
    data=str2num(yourdata{end});
    x=data(1:2:200);
    y=data(2:2:200);
    
    
    % QC percentage of X that are under pixel coordinate 350
    behav_data(s,12)=sum(x>350); % how many items were moved inside the square
    behav_data(s,13)=data(end)-datastart(end); % seconds from beginning to end
    behav_data(s,14)=15*length(yourdata); % time spent on task in seconds. This is an approximation with an error of 15 seconds
    
    
    if(DOPLOT)
        for t=1:length(yourdata)
            data=str2num(yourdata{t});
            x=data(1:2:200);
            y=data(2:2:200);
            figure(s);
            plot(x,y,'.')
            axis([0 1000 0 1000])
            pause(1/25)

        end
        
          
    end
    moved(find(x>=350),s)=1;
    y(find(x<350))=NaN;
    x(find(x<350))=NaN;
    temp=squareform(pdist([x' y']));
    temp=temp/max(abs(temp(:)));
    simmat(:,:,s)=temp;
    
end

% more subject cleaning
new_blacklist=find(behav_data(:,12)<25);

good_subj_list(new_blacklist)=[];
behav_data(new_blacklist,:)=[];
simmat(:,:,new_blacklist)=[];

        



% check if behaviour explains any distance between items
R=ones(100,100,14);
P=ones(100,100,14);
for s1=1:100;
    for s2=(s1+1):100;
        temp=squeeze(simmat(s1,s2,:));
        [rr pp]=corr(temp(~isnan(temp)),behav_data(~isnan(temp),:),'type','spearman');
        R(s1,s2,:)=rr;
        R(s2,s1,:)=rr;
        P(s1,s2,:)=pp;
        P(s2,s1,:)=pp;
	end
end

map=cbrewer('div','RdBu',9)
for bID=1:14
    figure(100)
    subplot(2,7,bID)
    rmat=R(:,:,bID);
    pmat=P(:,:,bID);
    q=mafdr(pmat(find(triu(ones(100),1))),'BHFDR','true');
    mask=zeros(100);
    mask(find(triu(ones(100),1)))=double(q<=0.05);
    Nposvals=sum(mask(:));
    
    mask=mask+mask';
    
    imagesc(rmat.*mask,[-.5 .5])
    colormap(map)
    axis square
    title(num2str(Nposvals))
    if(Nposvals>0 )
        figure(bID)
        imagesc(rmat.*mask,[-.5 .5])
        colormap(map)
        axis square
        title(num2str(Nposvals))
        tempIDs=find(sum(mask)>0);
        set(gca,'XTick',tempIDs)
        set(gca,'XTickLabel',sensations(  tempIDs))
        set(gca,'XTickLabelRotation',90);
        set(gca,'YTick',tempIDs)
        set(gca,'YTickLabel',sensations(  tempIDs))
        
    end
    
end





msim=nanmean(simmat,3);
medsim=nanmedian(simmat,3);
vsim=nanvar(simmat,[],3);


p=squareform(msim);






save output/sim/sim_data.mat simmat good_subj_list behav_data behav_data_unfiltered

error('stop')  

z=linkage(p,'complete');
%dendrogram(z,0,'orientation','left','labels',sensations)

addpath('./tsne/')
%mappedX = tsne(X, labels, no_dims, init_dims, perplexity)
P = d2p(msim, 30, 1e-5);
ydata = tsne_p(P, labels, no_dims);

error('stop')

figure
[Y,e] = cmdscale(msim);
for n=1:length(sensations)
    
    plot(Y(n,1), Y(n,2),'o','Color',map(classID(n),:),'MarkerSize',10,'MarkerFaceColor',map(classID(n),:));
    hold on
    text(Y(n,1), Y(n,2)+sign(randn)*0.005,sensations{n},'Color',map(classID(n),:));
    
    
end
grid on

figure
for n=1:length(sensations)
    
    plot3(Y(n,1), Y(n,2),Y(n,3),'o','Color',map(classID(n),:),'MarkerSize',10,'MarkerFaceColor',map(classID(n),:));
    hold on
    text(Y(n,1), Y(n,2),Y(n,3)+sign(randn)*0.005,sensations{n},'Color',map(classID(n),:));
    
    
end
grid on
