clear all
close all
CS=500;
GT=3;
rng(0)
minpts=(2*CS)*.05; % minimum cluster size 10%
epsilon=0.02; % the 2 percent
if(GT==2)
   data=[randn(CS,2);randn(CS,2)+4;]; 
   GTc=[ones(CS,1);2*ones(CS,1);]; 
end

if(GT==3)
    data=[randn(CS,2);randn(CS/2,2)+8;randn(CS/2,2)+16;];
    GTc=[ones(CS,1);2*ones(CS/2,1);3*ones(CS/2,1);];
end
figure
plot(data(:,1),data(:,2),'.')

%% optics
if(0)
[ SetOfClusters, RD, CD, order ] = cluster_optics(data, minpts, epsilon);
NP=floor(1+sqrt(length(SetOfClusters)));
figure(2)
for c=unique(GTc')
    subplot(NP,NP,1)
       ids=find(GTc==c);
    plot(data(ids,1),data(ids,2),'.')
    hold on 
end



for i=1:length(SetOfClusters)
    subplot(NP,NP,i+1)
    plot(data(:,1),data(:,2),'k.')
    ids=order(SetOfClusters(i).start:SetOfClusters(i).end);
    hold on
    plot(data(ids,1),data(ids,2),'r.')
end

figure
tsne_out=tsne(data);
[ SetOfClusters, RD, CD, order ] = cluster_optics(tsne_out, minpts, epsilon);
NP=floor(1+sqrt(length(SetOfClusters)));



figure(10)

for c=unique(GTc')
    subplot(NP,NP,1)
       ids=find(GTc==c);
    plot(tsne_out(ids,1),tsne_out(ids,2),'.')
    hold on 
end



for i=1:length(SetOfClusters)
    subplot(NP,NP,i+1)
    plot(tsne_out(:,1),tsne_out(:,2),'k.')
    ids=order(SetOfClusters(i).start:SetOfClusters(i).end-1);
    hold on
    plot(tsne_out(ids,1),tsne_out(ids,2),'r.')
end
end

