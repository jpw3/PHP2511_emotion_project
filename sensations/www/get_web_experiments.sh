rsync -avztcp -e "ssh" --chmod=g+s,g+rw --group=braindata --exclude 'UK*' --exclude '.git' bml@bml.becs.aalto.fi:/var/www/emotion.becs.aalto.fi/sensations/ sensations/

# remove admin password
cat sensations/admin/admin.php| sed 's/key==\".*\"/key==\"1234\"/g' > temp.php 
mv temp.php sensations/admin/admin.php

rsync -avztcp -e "ssh" --chmod=g+s,g+rw --group=braindata --exclude 'FI*' --exclude '.git' bml@bml.becs.aalto.fi:/var/www/emotion.becs.aalto.fi/sensations_FI/ sensations_FI/

# remove admin password
cat sensations_FI/admin/admin.php| sed 's/key==\".*\"/key==\"1234\"/g' > temp.php
mv temp.php sensations_FI/admin/admin.php


rsync -avztcp -e "ssh" --chmod=g+s,g+rw --group=braindata --exclude 'FI*' --exclude '.git' bml@bml.becs.aalto.fi:/var/www/emotion.becs.aalto.fi/sensations_sim/ sensations_sim/
rsync -avztcp -e "ssh" --chmod=g+s,g+rw --group=braindata --exclude 'FI*' --exclude '.git' --exclude 'temp' bml@bml.becs.aalto.fi:/var/www/emotion.becs.aalto.fi/sensations_embody_FI/ sensations_embody_FI/

# remove admin password
cat sensations_embody_FI/admin/admin.php| sed 's/key==\".*\"/key==\"1234\"/g' > temp.php
mv temp.php sensations_embody_FI/admin/admin.php



