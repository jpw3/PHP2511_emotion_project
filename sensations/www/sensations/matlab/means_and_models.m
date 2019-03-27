clear all
close all
addpath('/m/nbe/scratch/braindata/shared/toolboxes/cbrewer/');
load data 
% data = words x dimensions x good subjects
% 5 dimensions listed here:
Ndim=5;
dim_labels={'Bodily sensation strength','Mind sensation strength','Emotion intensity','Controllability','Last time'};

sensations_classes
map=cbrewer('qual','Set1',max(classID));
map(6,:)=[0 0 0];
data(find(data==0))=1; % just to avoid problems in binning
DF=10;
map_bodymind=zeros(1000/DF,1000/DF,max(classID));
mean_data=zeros(100,5);
sem_data=zeros(100,5);

mean_dataZ=zeros(100,5);
sem_dataZ=zeros(100,5);

for s=1:length(sensations)
    thisdata=squeeze(data(s,:,:));
    ids=find(~isnan(max(thisdata)));
    thisdata=thisdata(:,ids); % let's keep only those with data
    thisdataZ=atanh(thisdata/1000-eps);
    mean_data(s,:)=mean(thisdata,2);
    mean_dataZ(s,:)=mean(thisdataZ,2);
    Nitems(s,1)=size(thisdata,2);
    sem_data(s,:)=std(thisdata,0,2)./sqrt(size(thisdata,2));
    sem_dataZ(s,:)=std(thisdataZ,0,2)./sqrt(size(thisdataZ,2));   
end

for fitord=1:2
for rrr=1:5
    for ccc=1:5
        if(rrr==ccc) continue; end
        viz_and_model_helper(mean_data,sem_data,rrr,ccc,dim_labels,sensations,classID,classID_labels,map,1000,fitord);
        close all
    end
end
end

error('stop')


for f=1:4
    figure(f)
    axis square
    axis([0 3.4 0 3.4])
    for c=1:length(classID_labels)
        th=text(100,c*1000/20,classID_labels{c},'Color',map(c,:),'FontWeight','bold');
    end
end


% get the average of the averages for each plot
map=flipud(cbrewer('seq','Greys',5));
for c=1:9
    figure(1000)
    subplot(3,3,c)
    imagesc(map_bodymind(:,:,c),[0 5])
    colormap(map)
    colorbar
    axis xy
    axis square
end

% scatter plot average for each 