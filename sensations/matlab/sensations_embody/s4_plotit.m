clear all
close all
load bspm_ttest
cfg.bspm=bspm;
mask=uint8(imread('bodySPM_base3.png'));
in_mask=find(mask>128); % list of pixels inside the mask
base=uint8(imread('bodySPM_base2.png'));
base2=base(10:531,33:203,:); % single image base
load_labels % makes variable labels


	NC=size(cfg.bspm.ttest.tval,3); % number of conditions
	M=max(abs(cfg.bspm.ttest.tval(:)))
	M=round(prctile(abs(cfg.bspm.ttest.tval(:)),99.9)/5)*5
	NumCol=64
	th=cfg.bspm.ttest.tTH(2);

	non_sig=round(th/M*NumCol); % proportion of non significant colors
	hotmap=hot(NumCol-non_sig);
	coldmap=flipud([hotmap(:,3) hotmap(:,2) hotmap(:,1) ]);
	hotcoldmap=[
		coldmap
		zeros(2*non_sig,3);
		hotmap
		];
	
	% plotting
	plotcols = 20; %set as desired
	plotrows = 5; % number of rows is equal to number of conditions+1 (for the colorbar)
	H=size(bspm.ttest.tval,1);
    W=size(bspm.ttest.tval,2);
    allmaps=zeros(plotrows*H,plotcols*W);
    allbases=repmat(base2,plotrows,plotcols);
    allmask=repmat(mask,plotrows,plotcols);
    figure
    imagesc(allbases);
    axis equal
    allover=zeros(size(allmaps));
    for n=1:NC
		rr=mod(n-1,plotrows)+1;
        cc=ceil(n/plotrows);
		axis('off');
		set(gcf,'Color',[1 1 1]);
		hold on;
		%over2=tvals_for_ploat(:,:,n);
		over2=cfg.bspm.ttest.tval(:,:,n);
        allover((1:H)+(rr-1)*H,(1:W)+(cc-1)*W)=over2;
    end
    hold on
    fh=imagesc(allover,[-M M]);
    set(fh,'AlphaData',allmask)
    axis('off');
		axis equal
		colormap(hotcoldmap);
        
        for n=1:NC
		rr=mod(n-1,plotrows)+1;
        cc=ceil(n/plotrows);
		templabel=sprintf(strrep(labels{n},' ','\n'));
        
        for xx =-1:1
            for yy=-1:1
        th=text(cc*W-W/2+yy*5,5*xx+rr*H-H/4,templabel);
        if(xx==0 && yy==0) set(th,'Color','white'); else
            set(th,'Color',[0 0 0]); end
        set(th,'HorizontalAlignment','center');
        set(th,'FontSize',6);
        set(th,'FontWeight','bold');
        
            end
        end
        xx=0;
        yy=0;
        th=text(cc*W-W/2+yy*5,5*xx+rr*H-H/4,templabel);
        if(xx==0 && yy==0) set(th,'Color','white'); else
            set(th,'Color',[0 0 0]); end
        set(th,'HorizontalAlignment','center');
        set(th,'FontSize',6);
        set(th,'FontWeight','bold');
        
        %set(th,'BackgroundColor',.8*[1 1 1]);
        end

    
        h=gcf;

set(h,'PaperOrientation','landscape');

set(h,'PaperUnits','normalized');

set(h,'PaperPosition', [0 0 1 1]);

print(gcf, '-dpdf', 'sensations_body.pdf');

        
        error('stop')

		%fh=imagesc(over2,[-M,M]);
		
		
		%title(labels(n),'FontSize',10)
		%if(n==NC)
		%	subplot(plotrows,plotcols,n+1)
		%	title('Colorbar')
		%	fh=imagesc(zeros(size(base2)),[-M-eps,M+eps]);
		%	axis('off');
		%	colorbar;
		%end
	
