clear all
close all
list=load('list_ids.txt');
% first columns is the dimenion ID, second col is the word ID

L=5; % 5 sets of random sequences
ND=max(list(:,1));
N=100;
mkdir sequences
rand('twister',5489);
for iter=0:L:99;
    disp(num2str(iter));
    presentations=zeros(N,1);
    for l=1:L-1
        for d=1:ND
            ids=find(list(:,1)==d); %items
            NperD=length(ids);         % get num of items for dimension 1
            allNperD(d)=NperD;
            Nrand=round((NperD/L)-.1); % trick to get groups of 25
            % identify which ids are still unused
            ids_unused=intersect(ids,find(presentations==0));
            % shuffle
            ids_unused=ids_unused(randperm(length(ids_unused)));
            % get Nrand items from ids_unused
            presentations(ids_unused(1:Nrand))=l;
        end
    end

    presentations(find(presentations==0))=L;

    for l=0:L-1
        temp=find(presentations==(l+1));
        for subiter=0:4
            temp=temp(randperm(length(temp)));
            dlmwrite(['sequences/' num2str(iter+subiter) '_' num2str(mod(l+subiter,5)+1) '.csv'],temp);
        end
    end
end


