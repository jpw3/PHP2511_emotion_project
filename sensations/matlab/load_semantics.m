%% preprocessing in bash
% file sensations/scripts/prepro.sh

semfiles={
'concept_gigawords.net.csv'
'concept_webbase.net.csv'
'relation_gigawords.net.csv'
'relation_webbase.net.csv'    
}

ids=find(tril(ones(100),-1)); % bottom triangle
for ff=1:4
    temp=zeros(100);
    temp(ids)=load(['../scripts/' semfiles{ff}]);
    %max(temp(:))
    temp=temp+temp'+eye(100); % they are similarities
    semdist(:,:,ff)=1-temp;
end

%semdata.mean_data_D
%semdata.mean_data_D=mean(semdist,3);
%figure(1)
%subplot(1,2,1)
%imagesc(semdata.mean_data_D)
%figure(1)
%subplot(1,2,2)
semdata.mean_data_D=min(semdist,[],3);
%imagesc(semdata.mean_data_D)