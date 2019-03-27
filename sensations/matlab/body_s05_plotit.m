clear all
close all
load('output/body/bspm_ttest.mat');
load('output/mind/mind_mds.mat');
load('output/body/body_mds.mat');
load('output/sim/sim_mds.mat');

%% prepare for body plot
mask=uint8(imread('external/bodyspm/bodySPM_base3.png'));
in_mask=find(mask>128); % list of pixels inside the mask
base=uint8(imread('external/bodyspm/bodySPM_base2.png'));
base2=base(10:531,33:203,:); % single image base
sensations_classes
load_labels % makes variable labels
NC=size(bspm.ttest.es,3); % number of conditions
M=max(abs(bspm.ttest.es(:)))

% rounding M
%M=round(prctile(abs(bspm.ttest.es(:)),99.9)/5)*5   % for T values
M=round(prctile(abs(bspm.ttest.es(:)),99.9)/.1)*.1  % for ES
NumCol=64; % number of colors

% map t threshold into ES thresholds
th=bspm.ttest.tTH(2)/sqrt(min(bspm.ttest.df+1));

non_sig=round(th/M*NumCol); % proportion of non significant colors
hotmap=hot(NumCol-non_sig);
coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
hotcoldmap=[
    coldmap
    zeros(2*non_sig,3);
    hotmap
    ];

% choose location of bodies given the experiment
tsne_out=sim_mds.tsne;  % based on the sim experiment
%tsne_out_orig=body_mds.tsne;
%tsne_out_orig=mind_mds.tsne;

% we fix the x and y so that bodies do not overlap
MMTSNE=max(abs(tsne_out(:)));
tsne_out=tsne_out./MMTSNE*380*10;
tsne_out(:,2)=-tsne_out(:,2); % flipping orientation for matching plots with strings
H=size(bspm.ttest.es,1);
W=size(bspm.ttest.es,2);


%% plot as TSNE
figure(1)



% start with contours for the clusters based on dbscan
OUTLINEONLY=1; % set to zero to have filled coloured blobs under the bodies
load('output/sim/sim_contours_dbscan.mat');
NCC=1;
for cID=1:length(CC)
    temp=CC{cID};
    ids=find(temp(1,:)<1);
    toi=(ids(NCC)+1):(ids(NCC+1)-1);
    if(length(toi)<100)
        toi=(ids(NCC+1)+1):(ids(NCC+2)-1);
    end
    p=patch(temp(1,toi)/MMTSNE*380*10+min(tsne_out(:,1))-380,-temp(2,toi)/MMTSNE*380*10+min(tsne_out(:,2))+H+40+10*380,1);
    set(p,'EdgeAlpha',0)
    set(p,'FaceAlpha',.2)
    set(p,'FaceColor',classColors(cID,:))
    if(OUTLINEONLY==1)
        set(p,'FaceColor','none')
        set(p,'FaceAlpha',0)
        set(p,'EdgeColor',classColors(cID,:))
        set(p,'EdgeAlpha',1)
        set(p,'LineStyle','--')
        set(p,'LineWidth',2)
    end
end


% then add the body maps
for n=1:NC
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    fh=imagesc(tsne_out(n,1),tsne_out(n,2),bspm.ttest.es(:,:,n),[-M M]);
    set(fh,'AlphaData',mask)
    axis('off');
    axis equal
    colormap(hotcoldmap);
    axis ij
end
axis([-4000 4000 -2300 2600])

% then the labels on top of the bodies
map=cbrewer('qual','Set1',max(classID));
map(6,:)=[0 0 0];

if(0)
    %labels on the corner
    for n=1:NC
        templabel=sprintf(strrep(labels{n},' ','\n'));
        ttth=text(tsne_out(n,1)+W,tsne_out(n,2)-10,templabel);
        set(ttth,'Color',map(classID(n),:));
        set(ttth,'HorizontalAlignment','center');
        set(ttth,'FontSize',5);
        set(ttth,'FontWeight','bold');
    end
end

if(1)
    % labels on top
    for n=1:NC
        %    rr=mod(n-1,plotrows)+1;
        %   cc=ceil(n/plotrows);
        templabel=sprintf(strrep(labels{n},' ','\n'));
        if(n==33)
            templabel=sprintf(strrep(strrep(['Closeness (in_social relations)'],' ','\n'),'_',' '));
        end
        for xx =-1:1
            for yy=-1:1
                th=text(tsne_out(n,1)+W/2+yy*5,5*xx+tsne_out(n,2)+H/4,templabel);
                if(xx==0 && yy==0) set(th,'Color','white'); else
                    set(th,'Color',[0 0 0]); end
                set(th,'HorizontalAlignment','center');
                set(th,'FontSize',6);
                set(th,'FontWeight','bold');
                
            end
        end
        xx=0;
        yy=0;
        ttth=text(tsne_out(n,1)+W/2+yy*5,5*xx+tsne_out(n,2)+H/4,templabel);
        if(xx==0 && yy==0) set(ttth,'Color','white'); else
            set(ttth,'Color',[0 0 0]); end
        set(ttth,'HorizontalAlignment','center');
        set(ttth,'FontSize',6);
        set(ttth,'FontWeight','bold');
        
        %set(th,'BackgroundColor',.8*[1 1 1]);
    end
end


%% adding network layer
% it does not look good
if(0)
    % network plot
    NNeigh=3; % amount of neighbours to be plotted for each node
    % first identify range of numbers we have
    %mean_data_D=sim_mds.mean_data_D;
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
                pt1 = [ tsne_out(cc,1)+W/2;tsne_out(cc,2)+H/4];
                pt3 = [tsne_out(bb(n),1)+W/2; tsne_out(bb(n),2)+H/4];
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
    
end

%% fixin axes etc for printing
h=gcf;

ax = gca;
ax.XLim(1)=1.1*ax.XLim(1);
ax.XLim(2)=1.1*ax.XLim(2);
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left-0.0554 bottom ax_width+0.07 ax_height];
ax.Position=[0 0 1 1];


set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
%print(gcf, '-depsc -tiff -r300', 'sensations_simMDS.eps');
%print -depsc -tiff -r300 sensations_body_simMDS.eps
set(gca,'FontName','Arial')
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'Color',[1 1 1])

if(OUTLINEONLY ==1 )
    export_fig -m4 'figs/body_sim_tsne_dbscan_w_contour_outlines.png'
else
    export_fig -m4 'figs/body_sim_tsne_dbscan_w_contour.png'
end
ccc=colorbar;
set(ccc,'Limits',[0 1])
set(ccc,'Location','eastoutside');

ttx=xlabel(ccc,'Effect Size');
set(ttx,'FontWeight','bold')
temppos=get(ccc,'Position');
set(ccc,'Position',[1 1 1/2 .9].*temppos+[0 .025 0 0]);

if(OUTLINEONLY ==1 )
    export_fig -m4 'figs/body_sim_tsne_dbscan_w_contour_outlines_colorbar.png'
else
    export_fig -m4 'figs/body_sim_tsne_dbscan_w_contour_colorbar.png'
end


error('stop')
% other filenames used
% export_fig -m4 'figs/body_sim_tsne_dbscan.png'
% export_fig -m4 'figs/body_sim_tsne_dbscan_w_network.png'

%% plot as TSNE of bodies
close all
body_mds=load(['output/body/body_mds.mat']); % variables,'body_mds','mean_data','labels','classID');
tsne_out=body_mds.body_mds.tsne;
MMTSNE=max(abs(tsne_out(:)));
tsne_out=tsne_out./MMTSNE*380*10;
tsne_out(:,2)=-tsne_out(:,2); % flipping orientation for matching plots with strings

H=size(bspm.ttest.es,1);
W=size(bspm.ttest.es,2);

figure(101)





% then add the body maps
for n=1:NC
    axis('off');
    set(gcf,'Color',[1 1 1]);
    hold on;
    fh=imagesc(tsne_out(n,1),tsne_out(n,2),bspm.ttest.es(:,:,n),[-M M]);
    set(fh,'AlphaData',mask)
    axis('off');
    axis equal
    colormap(hotcoldmap);
    axis ij
end
axis([-4000 4000 -2300 2600])

% then the labels on top of the bodies
map=cbrewer('qual','Set1',max(classID));
map(6,:)=[0 0 0];

if(0)
    %labels on the corner
    for n=1:NC
        templabel=sprintf(strrep(labels{n},' ','\n'));
        ttth=text(tsne_out(n,1)+W,tsne_out(n,2)-10,templabel);
        set(ttth,'Color',map(classID(n),:));
        set(ttth,'HorizontalAlignment','center');
        set(ttth,'FontSize',5);
        set(ttth,'FontWeight','bold');
    end
end

if(1)
    % labels on top
    for n=1:NC
        %    rr=mod(n-1,plotrows)+1;
        %   cc=ceil(n/plotrows);
        templabel=sprintf(strrep(labels{n},' ','\n'));
        if(n==33)
            templabel=sprintf(strrep(strrep(['Closeness (in_social relations)'],' ','\n'),'_',' '));
        end
        for xx =-1:1
            for yy=-1:1
                th=text(tsne_out(n,1)+W/2+yy*5,5*xx+tsne_out(n,2)+H/4,templabel);
                if(xx==0 && yy==0) set(th,'Color','white'); else
                    set(th,'Color',[0 0 0]); end
                set(th,'HorizontalAlignment','center');
                set(th,'FontSize',6);
                set(th,'FontWeight','bold');
                
            end
        end
        xx=0;
        yy=0;
        ttth=text(tsne_out(n,1)+W/2+yy*5,5*xx+tsne_out(n,2)+H/4,templabel);
        if(xx==0 && yy==0) set(ttth,'Color','white'); else
            set(ttth,'Color',[0 0 0]); end
        set(ttth,'HorizontalAlignment','center');
        set(ttth,'FontSize',6);
        set(ttth,'FontWeight','bold');
        
        %set(th,'BackgroundColor',.8*[1 1 1]);
    end
end

% fixin axes etc for printing
h=gcf;

ax = gca;
%ax.XLim(2)=1.1*ax.XLim(2);
ax.YLim(2)=1.1*ax.YLim(2);
ax.YLim(1)=.9*ax.YLim(1);
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];
%ax.Position=[0 0 1 1];

set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);
%print(gcf, '-depsc -tiff -r300', 'sensations_simMDS.eps');
%print -depsc -tiff -r300 sensations_body_simMDS.eps
set(gca,'FontName','Arial')
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'Color',[1 1 1])

% if(OUTLINEONLY ==1 )
%     export_fig -m4 'figs/body_sim_tsne_on_bodies_outlines.png'
% else

ccc=colorbar;
set(ccc,'Limits',[0 1])
set(ccc,'Location','eastoutside');

ttx=xlabel(ccc,'Effect Size');
set(ttx,'FontWeight','bold')
temppos=get(ccc,'Position');
set(ccc,'Position',[1 1 1/2 .9].*temppos+[0 .025 0 0]);

   export_fig -m4 'figs/body_sim_tsne_on_bodies.png'
%end
error('stop')

ccc=colorbar;
set(ccc,'Limits',[0 1])
set(ccc,'Location','eastoutside');

ttx=xlabel(ccc,'Effect Size');
set(ttx,'FontWeight','bold')
temppos=get(ccc,'Position');
set(ccc,'Position',[1 1 1/2 .9].*temppos+[0 .025 0 0]);

% if(OUTLINEONLY ==1 )
%    % export_fig -m4 'figs/body_sim_tsne_dbscan_w_contour_outlines_colorbar.png'
% else
%    export_fig -m4 'figs/body_sim_tsne_on_bodies_contours.png'
%end


%% new figure as a grid
mask(find(mask<16))=0;
close all
load output/sim/sim_cluster.mat
NR=5; % 5 or 10
ONTOP=1;
if(NR==10)
   XF=3;
   YF=1.5;
else
    if(ONTOP)
        XF=1.1;
        YF=1.05;
    else
    XF=1.5;
    YF=1.3;
    end
end

grid_of_bodies=zeros([NR ceil(100/NR)]);
grid_of_bodies_cluster=grid_of_bodies;
kk=size(grid_of_bodies);
GR=kk(1);
GC=kk(2);
[gridX gridY]=meshgrid(1:GR,1:GC);
% put each body into its best location in the grid
locs=(tsne_out);
locs(:,1)=locs(:,1)-552;

d_temp=sqrt(locs(:,1).^2+locs(:,2).^2); % distance from origin
[aaa bbb]=sort(d_temp,'descend');

% from the most far away
for bID=1:100
    xy=locs(bbb(bID),:);
    sxy=sign(xy);
    % pick a corner [1 1] [GR 1] [1 GC] [GR GC]
    if(sxy(1)<0 && sxy(2)>0)
        wincorner=[1 1];
    end
    if(sxy(1)<0 && sxy(2)<0)
        wincorner=[GR 1];
    end
    if(sxy(1)>0 && sxy(2)>0)
        wincorner=[1 GC];
    end
    if(sxy(1)>0 && sxy(2)<0)
        wincorner=[GR GC];
    end
    
    % find a free spot
    % distances from the winning corner
    x=(gridX(:)-wincorner(1)).^2;
    y=(gridY(:)-wincorner(2)).^2;
    gd=x+y;
    [gdvalues gdorder]=sort(gd);
    for t=1:length(gdorder)
        [winx]=gridX(gdorder(t));
        [winy]=gridY(gdorder(t));
        %error('stop')
        if(grid_of_bodies(winx,winy)==0)
            disp('Found a freespot')
            grid_of_bodies(winx,winy)=bbb(bID);
            grid_of_bodies_cluster(winx,winy)=sim_cluster.DBSCAN.class_from_mean_data(bbb(bID));
            break
        end
        
    end
    
end

close all
figure(1)
% plot the labels
for x=1:GR
    for y=1:GC
        if(grid_of_bodies(x,y)==0) continue; end
        hhh=plot(y*10,x*10,'ko','MarkerSize',15);
        if(grid_of_bodies_cluster(x,y)>0)
            set(hhh,'MarkerFaceColor',classColors(grid_of_bodies_cluster(x,y),:))
        end
        
        hold on
        text(y*10,x*10,labels{grid_of_bodies(x,y)})
        
    end
end

figure(100)
FS=12;
for x=1:GR
    for y=1:GC
        if(grid_of_bodies(x,y)==0) continue; end
        
        axis('off');
        set(gcf,'Color',[1 1 1]);
        hold on;
        fh=imagesc(y*W*XF,(GR-x)*H*YF,bspm.ttest.es(:,:,grid_of_bodies(x,y)),[-M M]);
        set(fh,'AlphaData',mask)
        axis('off');
        axis equal
        colormap(hotcoldmap);
        axis ij
        if(0)
            %plotting a dot
            hhh=plot(y*W*XF,x*H*YF+H,'ko','MarkerSize',10);
            set(hhh,'MarkerFaceColor',.8*[1 1 1])
            set(hhh,'MarkerEdgeColor',.8*[1 1 1])
            
            if(grid_of_bodies_cluster(x,y)>0)
                set(hhh,'MarkerFaceColor',classColors(grid_of_bodies_cluster(x,y),:))
                set(hhh,'MarkerEdgeColor',classColors(grid_of_bodies_cluster(x,y),:))
            end
        end
        hold on
        templabel=sprintf(strrep(labels{grid_of_bodies(x,y)},' ','\n'));
        if(strcmp(templabel(1:4),'Clos'))
            templabel=sprintf(strrep(strrep(['Closeness (in_social relations)'],' ','\n'),'_',' '));
        end
        if(ONTOP)
            AF=3;
        for dx=-1:1
            for dy=-1:1
                th=text(y*W*XF+W/2+AF*dx,(GR-x)*H*YF+H*(1+YF)/2+AF*dy-150*ONTOP+100*mod(y,2)*ONTOP,templabel);
                set(th,'Color',1*[1 1 1]);
                %if(grid_of_bodies_cluster(x,y)>0)
                %    set(th,'Color', classColors(grid_of_bodies_cluster(x,y),:));   
                %end
                %set(th,'Color',[1 1 1]*0);
                
                set(th,'HorizontalAlignment','center');
                set(th,'FontSize',FS);
                set(th,'FontWeight','bold');
            end
        end
        end
        dx=0;
        dy=0;
        % plot the labels
        th=text(y*W*XF+W/2+dx,(GR-x)*H*YF+H*(1+YF)/2+dy-150*ONTOP+100*mod(y,2)*ONTOP,templabel);
        if(dx==0 && dy==0)
            
            if(grid_of_bodies_cluster(x,y)>0)
                    set(th,'Color', classColors(grid_of_bodies_cluster(x,y),:));
                    
            else
                set(th,'Color',[1 1 1]*.5);
            end
        end
        set(th,'HorizontalAlignment','center');
        set(th,'FontSize',FS);
        set(th,'FontWeight','bold');
        
    end
end
% fixin axes etc for printing
figure(100)
h=gcf;

ax = gca;
outerpos = ax.OuterPosition;
ti = ax.TightInset;
left = outerpos(1) + ti(1);
bottom = outerpos(2) + ti(2);
ax_width = outerpos(3) - ti(1) - ti(3);
ax_height = outerpos(4) - ti(2) - ti(4);
ax.Position = [left bottom ax_width ax_height];

set(h,'PaperOrientation','landscape');
set(h,'PaperUnits','normalized');
set(h,'PaperPosition', [0 0 1 1]);



%print(gcf, '-depsc -tiff -r300', 'sensations_simMDS.eps');
%print -depsc -tiff -r300 sensations_body_simMDS.eps
set(gca,'FontName','Arial')
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'Color',[1 1 1])

ccc=colorbar;
set(ccc,'Limits',[0 1])
set(ccc,'Location','eastoutside');

ttx=xlabel(ccc,'Effect Size');
set(ttx,'FontWeight','bold')
temppos=get(ccc,'Position');
%set(ccc,'Position',[1 1 1 1].*temppos);
if(NR==10)
    set(ccc,'Position',[.81 0 1/2 1].*temppos+[0 .01 0 .03]);
else
    set(ccc,'Position',[1 1 1/2 .85].*temppos+[0 .06 0 0]);
    if(ONTOP)
    set(ccc,'Position',[1 1 1/2 .92].*temppos+[0 .04 0 0]);
    
    end
    
end
export_fig(['figs/body_grid_' num2str(NR) '_dbscan.png'],'-m4')



