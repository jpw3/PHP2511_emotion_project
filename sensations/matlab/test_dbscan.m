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
    data=[randn(CS,2);randn(CS/2,2)+3;randn(CS/2,2)+6;];
    GTc=[ones(CS,1);2*ones(CS/2,1);3*ones(CS/2,1);];
end
figure
plot(data(:,1),data(:,2),'.')

%% using dbscan
figure(101)
close
figure(101)
EPS=[];
[class,type]=dbscan(data,minpts,EPS);
subplot(2,3,1)

for c=unique(GTc')
       ids=find(GTc==c);
    plot(data(ids,1),data(ids,2),'.')
    hold on 
end
title('Ground truth original data')


subplot(2,3,2)
for c=unique(class)
   ids=find(class==c);
   plot(data(ids,1),data(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(data(ids,1),data(ids,2),'ko')
ids=find(type==-1);
plot(data(ids,1),data(ids,2),'ks')

title('DBSCAN original data')
tsne_out=tsne(data);
subplot(2,3,3)

for c=unique(GTc')
       ids=find(GTc==c);
    plot(tsne_out(ids,1),tsne_out(ids,2),'.')
    hold on 
end

title('Ground truth labels with TSNE')
[class,type]=dbscan(tsne_out,minpts,EPS);
subplot(2,3,4)
for c=unique(class)
   ids=find(class==c);
   plot(tsne_out(ids,1),tsne_out(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(tsne_out(ids,1),tsne_out(ids,2),'ko')
ids=find(type==-1);
plot(tsne_out(ids,1),tsne_out(ids,2),'ks')

title('DBSCAN on TSNE')
% tsne locations using classes from original data

[class,type]=dbscan(data,minpts,EPS);
subplot(2,3,5)
for c=unique(class)
   ids=find(class==c);
   plot(tsne_out(ids,1),tsne_out(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(tsne_out(ids,1),tsne_out(ids,2),'ko')
ids=find(type==-1);
plot(tsne_out(ids,1),tsne_out(ids,2),'ks')

title('DBSCAN on data plotted over TSNE')



%% comparing dbscan and dbscan_d
figure(201)
EPS=[];
[class,type]=dbscan(data,minpts,EPS);
subplot(2,3,1)

for c=unique(GTc')
       ids=find(GTc==c);
    plot(data(ids,1),data(ids,2),'.')
    hold on 
end
title('Ground truth original data')

subplot(2,3,2)
for c=unique(class)
   ids=find(class==c);
   plot(data(ids,1),data(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(data(ids,1),data(ids,2),'ko')
ids=find(type==-1);
plot(data(ids,1),data(ids,2),'ks')

title('DBSCAN original data')

[class,type,datax]=dbscan_D(squareform(pdist(data)),minpts,EPS);
subplot(2,3,3)
for c=unique(class)
   ids=find(class==c);
   plot(datax(ids,1),datax(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(datax(ids,1),datax(ids,2),'ko')
ids=find(type==-1);
plot(datax(ids,1),datax(ids,2),'ks')
title('DBSCAN on distance matrix over projected coordinates')

subplot(2,3,4)
for c=unique(class)
   ids=find(class==c);
   plot(data(ids,1),data(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(data(ids,1),data(ids,2),'ko')
ids=find(type==-1);
plot(data(ids,1),data(ids,2),'ks')
title('DBSCAN on distance matrix over original coordinates')


% with tsne
tsne_out=tsne_d(squareform(pdist(data)));
subplot(2,3,5)
for c=unique(class)
   ids=find(class==c);
   plot(tsne_out(ids,1),tsne_out(ids,2),'.')
   hold on
end
ids=find(type==0);
plot(tsne_out(ids,1),tsne_out(ids,2),'ko')
ids=find(type==-1);
plot(tsne_out(ids,1),tsne_out(ids,2),'ks')
title('DBSCAN on distance matrix over TSNE distance matrix coordinates')


