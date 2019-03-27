function viz_and_model_helper(mean_data,sem_data,x,y,dim_labels,sensations,classID,classID_labels,map,MM,fitord)
   NF=round(1000*rand);
figure(NF)
    hold on
    for s=1:length(classID)
        figure(NF)
        h=plot(mean_data(s,x),mean_data(s,y),'o','MarkerSize',10,'Color',map(classID(s),:),'MarkerFaceColor',map(classID(s),:));
        plot([mean_data(s,x)-sem_data(s,x) mean_data(s,x)+sem_data(s,x)],[mean_data(s,y) mean_data(s,y)],'Color',map(classID(s),:));
        plot([mean_data(s,x) mean_data(s,x)],[mean_data(s,y)-sem_data(s,y) mean_data(s,y)+sem_data(s,y)],'Color',map(classID(s),:));
        figure(NF+1)
        subplot(3,3,classID(s))
        hold on
        plot([mean_data(s,x)-sem_data(s,x) mean_data(s,x)+sem_data(s,x)],[mean_data(s,y) mean_data(s,y)],'Color',map(classID(s),:));
        plot([mean_data(s,x) mean_data(s,x)],[mean_data(s,y)-sem_data(s,y) mean_data(s,y)+sem_data(s,y)],'Color',map(classID(s),:));
        text(mean_data(s,x),mean_data(s,y),sensations{s},'FontSize',8)
    end
    figure(NF)
    xlabel(dim_labels{x});
    ylabel(dim_labels{y});
    axis square
    axis([0 MM 0 MM])
    
    
    
    % make a model for each class
    for c=1:length(classID_labels)
        ids=find(c==classID);
       xx=mean_data(ids,x);
       yy=mean_data(ids,y);
       [yfit p R2 R2adj]=bramila_polyfit(xx,yy,fitord);
       step=(max(xx)-min(xx))/100;
       xdomain=min(xx):step:max(xx);
       yfit=polyval(p,xdomain);
       figure(NF)
       plot(xdomain,yfit,'LineWidth',2,'Color',map(c,:));
       figure(NF+1)
       subplot(3,3,c)
       plot(xdomain,yfit,'LineWidth',2,'Color',map(c,:));
       allR(c,:)=[R2 R2adj];
       xlabel(dim_labels{x});
    ylabel(dim_labels{y});
    title([classID_labels{c} ' R^2:' num2str(allR(c,1),2) ' (R^2_{adj}:' num2str(allR(c,2),2) ')'])
  
    end
    
    figure(NF)
    for c=1:length(classID_labels)
        th=text(100,c*MM/20,[classID_labels{c} ' R^2:' num2str(allR(c,1),2) ' (R^2_{adj}:' num2str(allR(c,2),2) ')'],'Color',map(c,:),'FontWeight','bold');
    end
    
    figure(NF)
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); 
    set(gcf,'color',[1 1 1]);
    nameX=strrep(dim_labels{x},' ','');
    nameX=nameX(1:6);
    nameY=strrep(dim_labels{y},' ','');
    nameY=nameY(1:6);
    export_fig(['figs/' nameX '_vs_' nameY '_' num2str(fitord) 'fit.png'])
    figure(NF+1)
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]); 
    set(gcf,'color',[1 1 1]);
    export_fig(['figs/' nameX '_vs_' nameY '_detail_'  num2str(fitord) 'fit.png'])


    