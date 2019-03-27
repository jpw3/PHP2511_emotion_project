close all
clear all
nsdata_manual;

mask=load_nii('/Users/enrico/code/bramila/external/MNI152_T1_2mm_brain_mask.nii');
inmask=find(mask.img>0);

NW=100;
nsIDs=[];
nsdata=zeros(length(inmask),NW);
for w=1:NW
   list=data{w};
   if(length(list)==0) continue; end
   nsIDs=[nsIDs;w];
   avgimg=0;
   for f=1:length(list)
       if(exist(['data/ns/ns_images/' list{f}],'file') ==2)
            tempnii=load_nii(['data/ns/ns_images/' list{f}]);
       else
           disp(['FILE MISSING data/ns/ns_images/' list{f}])
           continue
       end
      avgimg=avgimg+tempnii.img;
   end
   if(avgimg==0) continue; end
   nsdata(:,w)=avgimg(inmask)/length(list);
end

ns_dm=1-corr(nsdata,'type','spearman');

save output/ns/nsdata.mat nsdata inmask
%save output/ns/ns_manual_mds.mat ns_dm nsIDs