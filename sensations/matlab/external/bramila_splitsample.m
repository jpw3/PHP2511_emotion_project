function [vals permu pvals]=bramila_splitsample(cfg)
% Usage
%   [icc permu pvals] = bramila_splitsample(cfg)
%   where cfg has these fields
%   cfg.data = matrix variables x subjects
%   cfg.niter = number of iterations
%
%   returned values
%       icc = Spearman (intraclass) correlations between the split groups
%       permu = actual permutations used (important if you want to use the
%       same permutations over multiple dimensions of data)
%       pvals = p values corresponding to each icc value
%
%   Note, if the number of variables is equal to 1, then instead of ICC the
%   function returns the difference of the mean between the two groups.
%   These values can then be tested with a t-test (or to be precise, a TOST
%   test of similarity)


Nsubj=size(cfg.data,2);
Nhalf=floor(Nsubj/2);

rng(0);
permu=zeros(cfg.niter,Nsubj);
vals=zeros(cfg.niter,1);
pvals=vals;
%% compute permu
if(isfield(cfg,'permu'));
    permu=cfg.permu;
else
    
    if(Nsubj<10)
        permu=perms(1:Nsubj);
    else
        ok=zeros(size(vals));
        for i=1:cfg.niter
            disp(num2str(i))
            while(ok(i)==0)
                temp=randperm(Nsubj);
                if(i==1)
                    permu(i,:)=temp;
                    ok(i)=1;
                else
                    cost=sum((permu(1:i,:)-repmat(temp,i,1)).^2,2);
                    if(min(cost)==0)
                        disp('we already had that')
                    else
                        permu(i,:)=temp;
                        ok(i)=1;
                    end
                end
            end
        end
    end
end

%% compute the actual values
for i=1:cfg.niter
    p1=nanmean(cfg.data(:,permu(i,1:Nhalf)),2);
    p2=nanmean(cfg.data(:,permu(i,(Nhalf+1):end)),2);
    if(length(p1)==1)
        vals(i)=p1-p2; %just the difference of the mean
        pvals(i)=NaN;
        disp('Computing just the difference of the mean as this is a one-dimensional data')
    else
        [vals(i) pvals(i)]=corr(p1,p2,'type','spearman');
    end
end
