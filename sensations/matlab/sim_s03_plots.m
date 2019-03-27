clear all
close all
load output/sim/sim_data.mat
load('output/sim/sim_mds.mat');
load('output/sim/sim_cluster.mat')
% definitions
sensations_classes % loads the ground truth

%% behavioural data
behav_labels={
'gender' % F = 1
'age'
'country residence'
'country birth'
'weight'
'height'
'handedness' % R = 1
'education'
'psychologist'
'psychiatrist'
'neurologist'
'Items moved'
'Total time spent on task with pauses'
'Actual time spent on task'
}

% better labels
better_behav_labels={
'M/F' % F = 1
'Age'
'LocR'
'LocB'
'Kg'
'Cm'
'L/R' % R = 1
'Edu'
'PSYD1'
'PSYD2'
'Neur'
'#'
'Time1'
'Time2'
}

corrplot(behav_data,'varnames',better_behav_labels)
hcp=gcf;
hcpC=get(hcp,'Children');
redmap=cbrewer('seq','Reds',9);
qualmap=cbrewer('qual','Set1',9);
set(gcf, 'OuterPosition', [0 0 900 900]);
for han=1:length(hcpC)
    temp=get(hcpC(han),'XLabel');
    set(temp,'Color',[0 0 0])
    
    temp=allchild(hcpC(han));
    
    if(strcmp(class(temp),'matlab.graphics.chart.primitive.Histogram'))
        set(temp,'FaceColor',qualmap(1,:))
        set(temp,'FaceAlpha',1)
        set(temp,'EdgeColor',redmap(end,:))
    else
        for tt=1:length(temp)
            %class(temp)
           % set(hcpC(han),'XLim',[-3.5 3.5])
           % set(hcpC(han),'YLim',[-3.5 3.5])
            set(temp(tt),'Color',redmap(end,:))
            set(temp(tt),'MarkerEdgeColor',qualmap(1,:))   
        end
    end
end

A=allchild(gcf);
AA=get(A(11),'Children'); %annotationPane
for han=1:length(AA)
    set(AA(han),'FontSize',15)
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig 'figs/sim_behav_data.png'
%% plotting  task data

%labels=sim_mds.labels;
%mean_data_D=sim_mds.mean_data_D;
close all
figure(1)
h=imagesc(mean_data_D,[0 .7]);
map=cbrewer('seq','Reds',13);
map=[flipud(map);1 1 1];
colormap(map)
hcb = colorbar;
ylabel(hcb, 'Mean distance (a.u.)')
 set(h, 'AlphaData', tril(ones(100),0));

axis square
%set(gca,'YTick',1:100);
%set(gca,'YTickLabel',labels);
axis off
for n=1:100
    text(n+.5,n-.25,labels{n},'Rotation',45)
end
gtid=find(diff([0;classID;inf]));
axis([-10 110 -5 105])
% prepare top triangle

for g=1:length(gtid)-1
    hold on
    plot([gtid(g) gtid(g)]-.5,[gtid(g) gtid(g+1)]-.5,'k','LineWidth',2)
    
    text(-1,mean([gtid(g) gtid(g+1)]-.5),classID_labels{g},'Rotation',90,'HorizontalAlignment','center')
    %plot([gtid(g+1) gtid(g+1)]-.5,[gtid(g) gtid(g+1)]-.5,'k','LineWidth',2)
    %plot([gtid(g) gtid(g+1)]-.5,[gtid(g) gtid(g)]-.5,'k','LineWidth',2)
    plot([gtid(g) gtid(g+1)]-.5,[gtid(g+1) gtid(g+1)]-.5,'k','LineWidth',2)
    plot([-4 gtid(g+1)]-.5,[gtid(g+1) gtid(g+1)]-.5,'Color',[.5 .5 .5]/2,'LineWidth',1)
    plot([gtid(g) gtid(g)]-.5,[gtid(g) 105]-.5,'Color',[.5 .5 .5]/2,'LineWidth',1)
    text(mean([gtid(g) gtid(g+1)]-.5),102,classID_labels{g},'HorizontalAlignment','center')
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
%export_fig 'figs/sim_mean_data.png'

%% plot task data resorted by DBSCAN
close all
figure(1)
[aaa bbb]=sort(sim_cluster.DBSCAN.class_from_mean_data,'Descend');

h=imagesc(mean_data_D(bbb,bbb),[0 .7]);
map=cbrewer('seq','Reds',13);
map=[flipud(map);1 1 1];
colormap(map)
hcb = colorbar;
ylabel(hcb, 'Mean distance (a.u.)')
set(h, 'AlphaData', tril(ones(100),0));

axis square
%set(gca,'YTick',1:100);
%set(gca,'YTickLabel',labels);
axis off
for n=1:100
    text(n+.5,n-.25,labels{bbb(n)},'Rotation',45)
end
gtid=find(diff([0;aaa';inf]));
axis([-10 110 -5 105])
% prepare top triangle

dbscan_cluster_labels={
  'Homeostatic states'
  'Cognitive processes'
  'Somatic states and illnesses'
  'Positive emotions'
  'Negative emotions'
  'Between clusters'
};
for g=1:length(gtid)-1
    hold on
    plot([gtid(g) gtid(g)]-.5,[gtid(g) gtid(g+1)]-.5,'k','LineWidth',2)
    templabel=strrep(dbscan_cluster_labels{g},' ',newline);
    text(-1,mean([gtid(g) gtid(g+1)]-.5),templabel,'Rotation',90,'HorizontalAlignment','center','VerticalAlignment','bottom')
    %plot([gtid(g+1) gtid(g+1)]-.5,[gtid(g) gtid(g+1)]-.5,'k','LineWidth',2)
    %plot([gtid(g) gtid(g+1)]-.5,[gtid(g) gtid(g)]-.5,'k','LineWidth',2)
    plot([gtid(g) gtid(g+1)]-.5,[gtid(g+1) gtid(g+1)]-.5,'k','LineWidth',2)
    plot([-4 gtid(g+1)]-.5,[gtid(g+1) gtid(g+1)]-.5,'Color',[.5 .5 .5]/2,'LineWidth',1)
    plot([gtid(g) gtid(g)]-.5,[gtid(g) 105]-.5,'Color',[.5 .5 .5]/2,'LineWidth',1)
    text(mean([gtid(g) gtid(g+1)]-.5),102,templabel,'HorizontalAlignment','center','VerticalAlignment','top')
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig 'figs/sim_mean_data_resorted_dbscan.png'




%% plotting MDS results
mds_out=sim_mds.tsne;

sensations=labels;


% do a 2DIM subplot
figure(202)
hold on
% add contours
load('output/sim/sim_contours_dbscan.mat');
NCC=1;
for cID=1:length(CC)
    temp=CC{cID};
    ids=find(temp(1,:)<1);
    toi=(ids(NCC)+1):(ids(NCC+1)-1);
    
    if(length(toi)<100)
        toi=(ids(NCC+1)+1):(ids(NCC+2)-1);
    end
    p=patch(temp(1,toi)+min(mds_out(:,1))-40,temp(2,toi)+min(mds_out(:,2))-40,1);
    set(p,'EdgeAlpha',0)
    set(p,'FaceAlpha',.2)
    set(p,'FaceColor',classColors(cID,:))
end


for s=1:100
    figure(202)
    hold on
    plot(mds_out(s,1),mds_out(s,2),'o','MarkerSize',5,'Color',classColors(classID(s),:),'MarkerFaceColor',classColors(classID(s),:))
    al='left';
    %if(mod(s,2)==1)
    %    al='right';
    %end
    th=text(mds_out(s,1)+3,mds_out(s,2)+1,sensations{s},'Rotation',0,'Color',classColors(classID(s),:),'FontSize',12,'HorizontalAlignment',al);
end
d = daspect;
box off
%daspect([1 2 1])
axis off
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);


export_fig -m2 'figs/sim_TSNE_withContours.png'



error('stop')



%% do a dendrogram base on sim data

close all
pd=squareform(mean_data_D);
z=linkage(pd,'complete');
[H,T,OUTPERM] = dendrogram(z,0)
%axis equal
%axis square
axis([0 100 0 0.7])
set(gca,'XTick',[])
for s=1:100
    th=text(s,0,sensations{OUTPERM(s)},'Rotation',90,'BackgroundColor',classColors(classID(OUTPERM(s)),:),'FontSize',6,'HorizontalAlign','right','Color',[1 1 1]);
end

set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m2 'figs/sim_dendrogram_euclidean.png'

error('stop')

%% quality control plots to compare clustering solutions

figure(100);
close all
figure(100);
% 1. plot original ground truth cluster on cmdscale and tsne
for c=1:max(classID)
   ids=find(classID==c);
   subplot(2,4,1)
   title('Ground truth classes on CMDSCALE')
   plot(sim_mds.cmd(ids,1),sim_mds.cmd(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
   subplot(2,4,5)
   title('Ground truth classes on TSNE')
   plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
   
end

figure(101); %tsne on its own
for c=1:max(classID)
   ids=find(classID==c);
   hhh=plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'o','Color',classColors(c,:),'MarkerSize',15)
   set(hhh,'MarkerFaceColor',classColors(c,:));
   hold on
end
for cc=1:100
    text(sim_mds.tsne(cc,1)+5,sim_mds.tsne(cc,2)-5*sign(sim_mds.tsne(cc,2)),labels{cc})
    hold on
end
title('Ground truth classes plotted on TSNE')
% save figure
box off
axis off
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/sim_clustering_ground_truth.png'


% 2. plot dbscan
figure(100);
NCFD=max(sim_cluster.DBSCAN.class_from_mean_data); % num of clusters from data
if (NCFD<=max(classID)) % we have less than original num of clusters
   disp(['We have ' num2str(NCFD) ' clusters']);
else
    error('Add more colors!')
end
for c=1:max(sim_cluster.DBSCAN.class_from_mean_data)
   if(c<=0) continue; end
   
   ids=find(sim_cluster.DBSCAN.class_from_mean_data==c);
   subplot(2,4,2)
   title('DBSCAN on CMDSCALE')
   plot(sim_mds.cmd(ids,1),sim_mds.cmd(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
   subplot(2,4,6)
   title('DBSCAN on TSNE')
   plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
end
ids=find(sim_cluster.DBSCAN.type_from_mean_data==0);
subplot(2,4,2)
plot(sim_mds.cmd(ids,1),sim_mds.cmd(ids,2),'ko')
subplot(2,4,6)
plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'ko')

ids=find(sim_cluster.DBSCAN.type_from_mean_data==-1);
subplot(2,4,2)
plot(sim_mds.cmd(ids,1),sim_mds.cmd(ids,2),'ks')
subplot(2,4,6)
plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'ks')

figure(102); % tsne on its own
for c=1:max(sim_cluster.DBSCAN.class_from_mean_data)
   if(c<=0) continue; end
   ids=find(sim_cluster.DBSCAN.class_from_mean_data==c);
   
   hhh=plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'o','Color',classColors(c,:),'MarkerSize',15);
      set(hhh,'MarkerFaceColor',classColors(c,:));

   hold on
end
ids=find(sim_cluster.DBSCAN.type_from_mean_data==0);
hhh=plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'ko','MarkerSize',15);

ids=find(sim_cluster.DBSCAN.type_from_mean_data==-1);
hhh=plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'ko','MarkerSize',15);
set(hhh,'MarkerFaceColor',.8*[1 1 1]);
for cc=1:100
    text(sim_mds.tsne(cc,1)+5,sim_mds.tsne(cc,2)-5*sign(sim_mds.tsne(cc,2)),labels{cc})
    hold on
end
   title('DBSCAN plotted on TSNE')
% save figure
box off
axis off
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/sim_clustering_dbscan.png'


% 2. plot HC
figure(100)
NCFD=max(sim_cluster.HC.class_from_mean_data); % num of clusters from data
if (NCFD<=max(classID)) % we have less than original num of clusters
   disp(['We have ' num2str(NCFD) ' clusters']);
else
    error('Add more colors!')
end
for c=1:max(sim_cluster.HC.class_from_mean_data)
   ids=find(sim_cluster.HC.class_from_mean_data==c);
   subplot(2,4,3)
   title('Hier Clu on CMDSCALE')
   plot(sim_mds.cmd(ids,1),sim_mds.cmd(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
   subplot(2,4,7)
   title('Hier Clu on TSNE')

   plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
end

figure(103); % tsne on its own
for c=1:max(sim_cluster.HC.class_from_mean_data)
   ids=find(sim_cluster.HC.class_from_mean_data==c);
   hhh=plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'o','Color',classColors(c,:),'MarkerSize',15);
   set(hhh,'MarkerFaceColor',classColors(c,:));
   hold on
end
for cc=1:100
    text(sim_mds.tsne(cc,1)+5,sim_mds.tsne(cc,2)-5*sign(sim_mds.tsne(cc,2)),labels{cc})
    hold on
end
   title('Hierarchical Clustering plotted on TSNE')
% save figure
box off
axis off
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/sim_clustering_hierclu.png'

% 3. plot KMEANS
figure(100)
NCFD=max(sim_cluster.KMEANS.class_from_mean_data); % num of clusters from data
if (NCFD<=max(classID)) % we have less than original num of clusters
   disp(['We have ' num2str(NCFD) ' clusters']);
else
   
    warning('We need more colors!')
end
for c=1:max(sim_cluster.KMEANS.class_from_mean_data) 
   ids=find(sim_cluster.KMEANS.class_from_mean_data==c);
   subplot(2,4,4)
   title('K-means on CMDSCALE')
   plot(sim_mds.cmd(ids,1),sim_mds.cmd(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
   subplot(2,4,8)
      title('K-means on TSNE')

   plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'.','Color',classColors(c,:),'MarkerSize',20)
   hold on
end

figure(104); % tsne on its own
for c=1:max(sim_cluster.KMEANS.class_from_mean_data)
   ids=find(sim_cluster.KMEANS.class_from_mean_data==c);
   hhh=plot(sim_mds.tsne(ids,1),sim_mds.tsne(ids,2),'o','Color',classColors(c,:),'MarkerSize',15)
   set(hhh,'MarkerFaceColor',classColors(c,:));
   hold on
end
for cc=1:100
    text(sim_mds.tsne(cc,1)+5,sim_mds.tsne(cc,2)-5*sign(sim_mds.tsne(cc,2)),labels{cc})
    hold on
end
title('K-means plotted on TSNE')
% save figure
box off
axis off
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig -m3 'figs/sim_clustering_kmeans.png'


figure(100)
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
saveas(gcf,'figs/sim_clustering.fig')

error('stop')

%% plot the best tsne computed above as a network
%[aa best_seeds]=sort(total_cost);
%rng(best_seeds(5))
%tsne_out=tsne_d((mean_data_D),[],2,30,5000); % modified version that specifies num of permutations

close all
tsne_out=sim_mds.tsne;
%tsne_out(:,2)=1*tsne_out(:,2);
figure(1000)

% network plot
NNeigh=3; % amount of neighbours to be plotted for each node
% first identify range of numbers we have
all_data_temp=[];
for cc=1:100
    temp=mean_data_D(cc,:);
    [aa bb]=sort(temp);
    bb(1)=[]; % remove itself
    aa(1)=[]; % remove itself
    for n=1:NNeigh
                    all_data_temp=[all_data_temp; mean_data_D(cc,bb(n))]
    end
end

% bin them in 4
th=prctile(all_data_temp,[0 33 66]);
binned_colors=[
       0 0 0

    0.33 0.33 0.33
          0.66 0.66 0.66
    
 
 
];

binned_thicknesses=[
2
1
1
1
];

for cc=1:100
    temp=mean_data_D(cc,:);
    [aa bb]=sort(temp);
    bb(1)=[]; % remove itself
    aa(1)=[]; % remove itself
    for n=1:NNeigh
        if(aa(n)<4) % do not plot links that are too distant, it can be removed
            t = linspace(0,1,101);
            pt1 = [ tsne_out(cc,1);tsne_out(cc,2)];
            pt3 = [tsne_out(bb(n),1); tsne_out(bb(n),2)];
            pt2=(pt1+pt3)/2;
            
            
            if(sqrt(sum((pt1-pt3).^2))>50)
                pt2(1)=1.05*pt2(1);
                pt2(2)=1.05*pt2(2);
            else
                pt2=(pt1+pt3)/2;
            end
            %pt2(1)=pt2(1)/abs(70-sqrt(sum((pt1-pt3).^2)));
            pts = kron((1-t).^2,pt1) + kron(2*(1-t).*t,pt2) + kron(t.^2,pt3);

            hold on
            %plot(pts(1,:),pts(2,:),'Color',[1 1 1]*(n-1)/NNeigh) % the problem with this line is that overlapping links have different color
            
            % find bin
            binID=0;
            for bins=1:length(th)
                if(mean_data_D(cc,bb(n))>= th(bins))
                    binID=bins;
                end
            end
            
            plot(pts(1,:),pts(2,:),'Color',binned_colors(binID,:),'LineWidth',binned_thicknesses(binID))
            
            %plot([tsne_out(cc,1) tsne_out(bb(n),1) ] ,[tsne_out(cc,2) tsne_out(bb(n),2) ],'LineWidth',mean_data_D(cc,bb(n)),'Color',[1 1 1]*(n-1)/3)
        end
    end
end


for c=1:max(sim_cluster.DBSCAN.class_from_mean_data)
    if(c<=0) continue; end
   ids=find(sim_cluster.DBSCAN.class_from_mean_data==c);
   hhh=plot(tsne_out(ids,1),tsne_out(ids,2),'o','Color',classColors(c,:),'MarkerSize',15)
   set(hhh,'MarkerFaceColor',classColors(c,:))
   hold on
end
ids=find(sim_cluster.DBSCAN.type_from_mean_data==0);
plot(tsne_out(ids,1),tsne_out(ids,2),'ko','MarkerSize',15)
ids=find(sim_cluster.DBSCAN.type_from_mean_data==-1);
hhh=plot(tsne_out(ids,1),tsne_out(ids,2),'ko','MarkerSize',15)
   set(hhh,'MarkerFaceColor',0.8*[1 1 1])

lr={'right','left','left'};
FSZ=11*1.5;



for cc=1:100
    %text(tsne_out(cc,1)+sign(tsne_out(cc,1))*5,tsne_out(cc,2)+sign(tsne_out(cc,2))*5,labels{cc},'FontSize',15,'HorizontalAlignment',lr{sign(tsne_out(cc,1))+2})
    
    % if it belongs to a cluster, find the phase from the cluster centroid
    if(sim_cluster.DBSCAN.class_from_mean_data(cc)~= -1)
        tempCids=find(sim_cluster.DBSCAN.class_from_mean_data==sim_cluster.DBSCAN.class_from_mean_data(cc)); % the other items in this cluster
        CcentroidX=mean(tsne_out(tempCids,1));
        CcentroidY=mean(tsne_out(tempCids,2));
        thislabelPH=atan2(tsne_out(cc,1)-CcentroidX,tsne_out(cc,2)-CcentroidY);
        DX=abs(tsne_out(cc,1)-CcentroidX);
        DY=abs(tsne_out(cc,2)-CcentroidY);
        %error('stop')
    else
        thislabelPH=atan2(tsne_out(cc,1),tsne_out(cc,2));
        DX=7;
        DY=7;
    end
    
    thislabelPH=pi*round(4*thislabelPH/pi)/4;
    
    thislabelX=tsne_out(cc,1)+sign(tsne_out(cc,1))*7;
    thislabelY=tsne_out(cc,2)+sign(tsne_out(cc,2))*0;
    
    
    thislabelX=tsne_out(cc,1)+sign(thislabelPH)*7;
    thislabelY=tsne_out(cc,2)+sign(tsne_out(cc,2))*0;

    % manual changes aka "it is hard to make labels not overlap
    % automatically"
    manualPH=zeros(100,1);
    manualPH(1)=pi/2;
    manualPH(3)=pi/4;
    manualPH(8)=-3*pi/2+pi/8;
    manualPH(10)=-pi/4;
    manualPH(12)=-pi/2;
    manualPH(13)=-thislabelPH+pi/2;
    manualPH(14)=-pi/2;
    manualPH(15)=-pi/4;
    manualPH(16)=0;
    manualPH(17)=-pi/4;
    manualPH(19)=3*pi/2;
    manualPH(24)=-thislabelPH-pi/2;
    manualPH(26)=-thislabelPH+pi;
    manualPH(27)=pi/4;
    manualPH(31)=-thislabelPH+pi;
    manualPH(35)=-thislabelPH+pi;
    manualPH(40)=-thislabelPH;
    manualPH(41)=-thislabelPH+pi;
    manualPH(42)=-thislabelPH-pi/2-pi/4;
    manualPH(43)=-thislabelPH+pi/2;
    manualPH(45)=-thislabelPH+pi/2;
    manualPH(46)=-thislabelPH-pi/2;
    manualPH(47)=-thislabelPH;
    manualPH(48)=-thislabelPH-pi/2;
    manualPH(49)=-thislabelPH+pi/2;
    manualPH(50)=-pi;
    manualPH(51)=-thislabelPH+pi/2;
    manualPH(53)=-thislabelPH-pi/2;
    manualPH(57)=-thislabelPH-pi/2;
    manualPH(61)=pi+pi/2;
    manualPH(62)=pi/2;
    manualPH(63)=-thislabelPH-pi/32;
    manualPH(65)=-thislabelPH+pi;
    manualPH(66)=-thislabelPH+pi;
    
    manualPH(67)=-thislabelPH-pi/32;
    manualPH(68)=-thislabelPH+pi+pi/32;
    manualPH(69)=-thislabelPH+pi/2;
    manualPH(70)=-thislabelPH+pi;
    manualPH(72)=-thislabelPH-pi/2;
    manualPH(73)=-thislabelPH+pi/2;
    manualPH(74)=-thislabelPH+pi/2;
    manualPH(77)=-thislabelPH-pi/2;
    manualPH(78)=-thislabelPH-pi/2-pi/4;
    manualPH(79)=-thislabelPH;
    manualPH(83)=-thislabelPH+pi/2;
    manualPH(86)=-thislabelPH+pi;
    manualPH(87)=-thislabelPH-pi/2;
    manualPH(89)=-pi/2;
    manualPH(90)=pi/2;
    manualPH(91)=-thislabelPH+pi/2;
    manualPH(92)=-thislabelPH+pi/2;
    manualPH(93)=-thislabelPH+pi/2;
    manualPH(96)=-thislabelPH;
    manualPH(97)=-thislabelPH+pi/2+pi/4;;
    manualPH(99)=-thislabelPH;
    manualPH(100)=-thislabelPH+pi/2;
    labels{79}='Stomach flu';
    
    thislabelPH=wrapToPi(thislabelPH+manualPH(cc));
    thislabelX=tsne_out(cc,1)+sin(thislabelPH)*8;
    thislabelY=tsne_out(cc,2)+cos(thislabelPH)*8;
    if(thislabelPH<0)
        thislabelAlign='right';
    else
        thislabelAlign='left';
    end
    
    
    for x=-1:2:1
        for y=-1:2:1
    text(x+thislabelX,y+thislabelY,compose([strrep(labels{cc},' ',' ')]),'FontName','Arial','FontSize',FSZ,'FontWeight','bold','Color',[ 1 1 1],'HorizontalAlignment',thislabelAlign);
        end
    end
    ttt=text(thislabelX,thislabelY,compose([strrep(labels{cc},' ',' ')]),'FontName','Arial','FontSize',FSZ,'FontWeight','bold','HorizontalAlignment',thislabelAlign);
    

end

box off
axis off
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
%export_fig -m3 'figs/sim_network_tsne_dbscan.png'
plot2svg('figs/sim_network_tsne_dbscan.svg', gcf)


%% plot consistency of tool
clear all
close all
load output/sim/split_sample.mat
hp=histogram(icc_pvals_mantel)
pbins=get(hp,'BinEdges');
subplot(2,1,1)
h=histogram(icc,'BinLimits',[0.92,0.97])
axis([0.92,0.97 0 500])
xlabel('Split group consistency [Spearman correlation]')
ylabel('Number of iterations');
title('Consistency of the similarity tool 5000 split sample correlations of the means')

subplot(2,1,2)
[hc xe ye]=histcounts2(icc,icc_pvals_mantel,get(h,'BinEdges'),pbins)
imagesc(xe,ye,hc')

title('Heatmap of the p-values for each of the 5000 iterations')
xlabel('Split group consistency [Spearman correlation]')
ylabel('P-value (mantel test)');
axis xy
hold on
temptick=get(gca,'YTick');
temptick=(1:4).*10^-8;
set(gca,'YTick',temptick);
set(gca,'Yticklabel',num2str(temptick'))
axis([0.92,0.97 [1e-08 4.0254e-08]])
set(gca,'Ylim',[1e-08 4.0254e-08])
colormap(hot)
hc=colorbar('west')
ylabel(hc,'Number of iterations')
set(hc,'Color',[1 1 1])
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'color',[1 1 1]);
export_fig  'figs/sim_tool_consistency.png'



