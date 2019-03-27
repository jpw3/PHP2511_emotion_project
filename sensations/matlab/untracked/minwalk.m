function tour=minwalk(xy,n);
 % xy locations
 % n = starting node
 tour=n;
 N=size(xy,1);
 D=squareform(pdist(xy));
 while(length(tour)<N)
     curr=tour(end);
     temp=D(curr,:);
     temp(tour)=inf;
     [aaa bbb]=sort(temp);
     if(ismember(bbb(1),tour))
         disp('we should stop')
     else
        tour=[tour bbb(1)];
     end
     
 end
 