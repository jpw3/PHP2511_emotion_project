%% Experiment to see if we can find a meaningful mapping between the emBODY task and Neurosynth maps
%  Results sometimes make sense, sometimes are meaningless. Due to its experimental stage, this is not included in the paper, but maybe when people see this, they get inspired on how to solve this issue... :)

clear all
close all
load rois6mm_final_plus_IF2.mat
load output/ns/ns_data.mat
subNSdata=(nsdata(:,nsIDs));
load_labels
ns_labels=labels(nsIDs);
load('output/body/bspm_ttest.mat');
bodydata=reshape(bspm.ttest.es,[],100);
mm=sign(sum(abs(bspm.ttest.tval),3));
bodymask=find(mm>0);
subBODYdata=bodydata(:,nsIDs);


rng(0)
NICA_ns=30;
[ica_ns, A_ns, W_ns] = fastica(subNSdata','numOfIC',NICA_ns);
rng(0)

NICA=30;
[ica_body, A_body, W_body] = fastica(subBODYdata','numOfIC',NICA);
%% plot the ica ns
if(1)
figure(10)
close
for i=1:NICA_ns
    
    ica_ns_range(i,:)=prctile(ica_ns(i,:),[0 1 5 50 95 99  100])
    PM=max(ica_ns(i,:));
    NM=abs(min(ica_ns(i,:)));
    if NM>PM
        signflip_ns(i,1)=-1;
    else
        signflip_ns(i,1)=1;
    end
    
    temp=zeros(91,109,91);
    temp(inmask)=signflip_ns(i)*ica_ns(i,:);
    all_ica_ns_vols(:,:,:,i)=temp;
    continue;
    [x y z]=ind2sub(size(temp),find(temp==max(temp(:))))
    figure(10)
    subplot(2,5,i)
    p=patch(isosurface(mask.img,0));
    set(p,'EdgeAlpha',0)
    set(p,'FaceColor',[.5 .5 .5])
    set(p,'FaceAlpha',.25)
    axis equal
    grid on
    view(3)
    hold on
    pbp=patch(isosurface(temp,20));
    set(pbp,'EdgeAlpha',0)
    set(pbp,'FaceColor',[1 .1 .1])
    set(pbp,'FaceAlpha',.5)
    %pbn=patch(isosurface(-1*temp,20));
    %set(pbn,'EdgeAlpha',0)
    %set(pbn,'FaceColor',[.1 .1 1])
    %set(pbn,'FaceAlpha',.5)
    %zoom(2)
end
end

%% plot the ica maps for each body
temp=hot;
map=[
    %flipud(temp(:,[3 2 1]));
    temp;];


figure(1)
close
figure(1)
for i=1:NICA
    subplot(5,6,i)
    temp=zeros(size(bspm.ttest.es,1),size(bspm.ttest.es,2));
    
    PM=max(ica_body(i,:));
    NM=abs(min(ica_body(i,:)));
    if NM>PM
        signflip(i,1)=-1;
    else
        signflip(i,1)=1;
    end
    temp(:)=signflip(i)*ica_body(i,:)';
    h=imagesc(temp,[3 15])
    set(h,'AlphaData',mm)
    colormap(map)
    axis equal
    colorbar
end
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'Color',[1 1 1])

%% mix the icas
close all
BBnet=corr([A_body.*repmat(signflip',44,1) A_ns.*repmat(signflip_ns',44,1)]);
figure
imagesc(BBnet,[-1 1])

BBnet_body_ns=BBnet(1:NICA,(NICA+1):end);
bbnetmask=BBnet_body_ns>.4;
for i=1:NICA_ns
    temp=bbnetmask(:,i);
    if(sum(temp)==0)
        continue
    else
        
        figure(i+1000)
        body_ica_ids=find(temp>0);
        subplot(5,4,1:16)
        temp=all_ica_ns_vols(:,:,:,i);
        [x y z]=ind2sub(size(temp),find(temp==max(temp(:))));
        max(temp(:))
        for rr=1:length(rois)
            dd(rr,1)=sum([rois(rr).centroid(1)-x +rois(rr).centroid(2)-y rois(rr).centroid(3)-z].^2);
        end
        
        p=patch(isosurface(mask.img,0));
        title(rois(find(dd==min(dd))).better_label);
        set(p,'EdgeAlpha',0)
        set(p,'FaceColor',[.5 .5 .5])
        set(p,'FaceAlpha',.25)
        axis equal
        grid on
        view(3)
        hold on
        pbp=patch(isosurface(temp,max(temp(:))-max(temp(:))/2));
        set(pbp,'EdgeAlpha',0)
        set(pbp,'FaceColor',[1 .1 .1])
        set(pbp,'FaceAlpha',.5)
        
        for ii=1:length(body_ica_ids)
            subplot(5,4,ii+16)
            temp=zeros(size(bspm.ttest.es,1),size(bspm.ttest.es,2));
            temp(:)=signflip(body_ica_ids(ii))*ica_body(body_ica_ids(ii),:)';
            h=imagesc(temp,[2 15]);
            set(h,'AlphaData',mm)
            colormap(map)
            axis equal
            %colorbar
            axis off
            
            [aaa bbb]=sort(abs(A_body(:,body_ica_ids(ii))));
            templabels=ns_labels(bbb(end-7:end));
            for ttt=1:length(templabels)
                text(0,510+ttt*30,templabels{ttt},'Color',[0 0 0],'fontweight','bold','FontSize',7)
            end
            
        end
        %error('stop')
        
        set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
set(gcf,'Color',[1 1 1])
    mkdir('icafigs')
    saveas(gcf,['icafigs/' num2str(i) '.png'])
close all
    end
    
end
