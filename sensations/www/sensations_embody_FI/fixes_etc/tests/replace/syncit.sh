for f in $(ls|grep F); do
	echo sudo chmod 777 ~/emotion.becs.aalto.fi/sensations_FI/subjects/$f
	sudo chmod 777 ~/emotion.becs.aalto.fi/sensations_FI/subjects/$f
	echo sudo rsync -avztcp $f/ ~/emotion.becs.aalto.fi/sensations_FI/subjects/$f/ --delete-after 
	sudo rsync -avztcp $f/ ~/emotion.becs.aalto.fi/sensations_FI/subjects/$f/ --delete-after
done
