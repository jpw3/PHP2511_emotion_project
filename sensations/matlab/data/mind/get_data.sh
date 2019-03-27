rsync -avztcp -e "ssh" --chmod=g+s,g+rw --group=braindata bml@bml.becs.aalto.fi:/var/www/emotion.becs.aalto.fi/sensations_FI/subjects/ M1
rsync -avztcp -e "ssh" --chmod=g+s,g+rw --group=braindata bml@bml.becs.aalto.fi:/var/www/emotion.becs.aalto.fi/sensations/subjects/ M2
