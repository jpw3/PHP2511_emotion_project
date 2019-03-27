clear all
close all

data=randn(100,1000);
data(1:20,:)=data(1:20,:)+5;
data(21:40,:)=data(21:40,:)+3;
data(41:60,:)=data(41:60,:)+2;
data(81:100,:)=data(81:100,:)+1;

labels=repmat((1:5),20,1);


out=tsne(data,labels(:))

