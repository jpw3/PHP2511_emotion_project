function data=load_subj_batch(folder,Nbatches)
	
	for b=1:Nbatches
		list=csvread([folder '/presentation_' num2str(b) '.csv']);
		for lid=1:length(list)
			id=list(lid);
			file=[folder '/' num2str(id) '_' num2str(b) '.csv'];
			if(exist(file)==2)
				line=dlmread(file,',');
				delim=find(-1==line(:,1));
				data(id).mouse=line(1:delim(1)-1,:);
				data(id).paint=line((delim(1)+1):(delim(2)-1),:);
				data(id).mousedown=line((delim(2)+1):(delim(3)-1),:);
				data(id).mouseup=line((delim(3)+1):end,:);
			else
				data(id).mouse=NaN;
				data(id).paint=NaN;
				data(id).mousedown=NaN;
				data(id).mouseup=NaN;
			end
		end

	end
