load('output/mind/mind_mds.mat');
load('output/body/body_mds.mat');
mind_dm=squareform(pdist(mind_mds.tsne));
body_dm=squareform(pdist(body_mds.tsne));

mantel_ids=find(triu(ones(100),1));
figure(1000)
subplot(2,2,1)
plot(mind_dm(mantel_ids),body_dm(mantel_ids),'o')
xlabel('mind distances')
ylabel('body distances')
subplot(2,2,2)
imagesc(mind_dm)
xlabel('mind distance matrix')
axis square
subplot(2,2,3)
imagesc(body_dm)
xlabel('body distance matrix')
axis square
[rr pp]=bramila_mantel(mind_dm,body_dm,1000,'spearman')