clear all
close all

load output/sim/sim_data.mat
Nsubj=size(simmat,3);
subj_sim=eye(Nsubj);
idsTop=find(triu(ones(100),1));
subj_items=zeros(Nsubj);
subj_p=zeros(Nsubj);
for s1=1:Nsubj
    disp(num2str(s1/Nsubj))
    for s2=(s1+1):Nsubj
        temp1=simmat(:,:,s1);
        temp2=simmat(:,:,s2);
        ids=find(triu(~isnan(temp1.*temp2),1));
        
        subj_items(s1,s2)=length(ids);
        [r p]=corr(temp1(ids),temp2(ids),'type','Spearman');
        subj_sim(s1,s2)=r;
        subj_sim(s2,s1)=r;
        subj_p(s1,s2)=p;
        subj_p(s2,s1)=p;
    end
end
subj_D=1-subj_sim;

z=linkage(squareform(subj_D),'complete');
[H,T,OUTPERM] = dendrogram(z,0);
figure
imagesc(subj_sim(OUTPERM,OUTPERM),[0 1]);colorbar

q=mafdr(subj_p(find(triu(ones(Nsubj),1))),'BHFDR','true');

qmat=zeros(Nsubj);
qmat(find(triu(ones(Nsubj),1)))=q;
qmat=qmat+qmat';
qmask=qmat<0.05;

figure
imagesc(qmask(OUTPERM,OUTPERM))