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
for s=1:length(sensations)
    thisdata=squeeze(data(s,:,:));
    ids=find(~isnan(max(thisdata)));
    thisdata=thisdata(:,ids)/1000; % let's keep only those with data
    thisdata=atanh(thisdata-eps);
    mean_data(s,:)=mean(thisdata,2);
    sem_data(s,:)=std(thisdata,0,2)./sqrt(size(thisdata,2));
    thisdata=thisdata/DF;
    figure(1)
    x=1;
    y=2;
    hold on
    h=plot(mean_data(s,x),mean_data(s,y),'o','MarkerSize',10,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:));
    plot([mean_data(s,x)-sem_data(s,x) mean_data(s,x)+sem_data(s,x)],[mean_data(s,y) mean_data(s,y)],'Color',map(classID(s),:));
    plot([mean_data(s,x) mean_data(s,x)],[mean_data(s,y)-sem_data(s,y) mean_data(s,y)+sem_data(s,y)],'Color',map(classID(s),:));
    xlabel(dim_labels{x});
    ylabel(dim_labels{y});
    text(mean_data(s,x),mean_data(s,y),sensations{s},'EdgeColor',map(classID(s),:),'FontSize',5)
    
    
    figure(2)
    x=1;
    y=3;
    hold on
    h=plot(mean_data(s,x),mean_data(s,y),'o','MarkerSize',10,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:));
    plot([mean_data(s,x)-sem_data(s,x) mean_data(s,x)+sem_data(s,x)],[mean_data(s,y) mean_data(s,y)],'Color',map(classID(s),:));
    plot([mean_data(s,x) mean_data(s,x)],[mean_data(s,y)-sem_data(s,y) mean_data(s,y)+sem_data(s,y)],'Color',map(classID(s),:));
    xlabel(dim_labels{x});
    ylabel(dim_labels{y});
    
    figure(3)
    x=2;
    y=3;
    hold on
    h=plot(mean_data(s,x),mean_data(s,y),'o','MarkerSize',10,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:));
    plot([mean_data(s,x)-sem_data(s,x) mean_data(s,x)+sem_data(s,x)],[mean_data(s,y) mean_data(s,y)],'Color',map(classID(s),:));
    plot([mean_data(s,x) mean_data(s,x)],[mean_data(s,y)-sem_data(s,y) mean_data(s,y)+sem_data(s,y)],'Color',map(classID(s),:));
    xlabel(dim_labels{x});
    ylabel(dim_labels{y});
    
    figure(4)
    x=1;
    y=4;
    hold on
    h=plot(mean_data(s,x),mean_data(s,y),'o','MarkerSize',10,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:));
    plot([mean_data(s,x)-sem_data(s,x) mean_data(s,x)+sem_data(s,x)],[mean_data(s,y) mean_data(s,y)],'Color',map(classID(s),:));
    plot([mean_data(s,x) mean_data(s,x)],[mean_data(s,y)-sem_data(s,y) mean_data(s,y)+sem_data(s,y)],'Color',map(classID(s),:));
    xlabel(dim_labels{x});
    ylabel(dim_labels{y});
    
    
    
    if(0)
        angle=angle/180*pi;
        r=0:0.1:2*pi+0.1;
        p=[(a*cos(r))' (b*sin(r))'];

        alpha=[cos(angle) -sin(angle)
               sin(angle) cos(angle)];
   
        p1=p*alpha;
 
    patch(cx+p1(:,1),cy+p1(:,2),color,'EdgeColor',color);
    end
    % body vs mind, each subj is a dot
  
  %for k=1:size(thisdata,2)
%    map_bodymind(ceil(thisdata(1,k)),ceil(thisdata(2,k)),classID(s))=map_bodymind(ceil(thisdata(1,k)),ceil(thisdata(2,k)),classID(s))+1;
%  end
   
end


for f=1:4
    figure(f)
    axis square
    axis([0 3.4 0 3.4])
    for c=1:length(classID_labels)
        th=text(100,c*1000/20,classID_labels{c},'Color',map(c,:),'FontWeight','bold');
    end
end


% get the average of the averages for each plot
error('stop')
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