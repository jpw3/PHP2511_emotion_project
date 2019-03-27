%% experimental tests not included in the paper
% here the idea was to see if treating the similarity matrices as a multiplex network would yeald meaningful clusters across dimensions
% results were noisy and required some otpimisation of the link weights across layers. I decided to drop the idea in the end, but feel free to build on it if you find it ingeresting!

clear all
close all
load all_dm
N=8;
mnet=[];
for n=1:N
    temp=all_dm(:,:,n);
    temp=1-temp/max(temp(:));
    row=[repmat(eye(100),1,(n-1)) temp repmat(eye(100),1,(N-n))];
    mnet=[mnet;row];
    munet(:,:,n)=temp;
end

%adj2pajek(mnet,'multiplex_net')
%command='/Users/enrico/code/sensations/matlab/external/infomap/Infomap -N100 multiplex_net.net  /Users/enrico/code/sensations/matlab/';
%system(command)

adj2multiplex(munet(:,:,1:3)>.7,'munet')

command='/Users/enrico/code/sensations/matlab/external/infomap/Infomap -i ''multilayer'' --clu -N10 munet.net  /Users/enrico/code/sensations/matlab/';
system(command)
