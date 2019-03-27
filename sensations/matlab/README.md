
output/body/bspm_ttest.mat
output/mind/mind_mds.mat
output/body/body_mds.mat
output/sim/sim_mds.mat

# Sensations, mind
Two experiments at
M1) http://emotion.nbe.aalto.fi/sensations_FI
M2) http://emotion.nbe.aalto.fi/sensations

Data cloned in
data/mind/

Data output in
output/mind/

Total num of "clean" subjects at 7/6/2017

### Steps
1. mind_s01_loadData.m - loads data for both experiments and filters out empty subjects or age == 0
2. mind_s01_meansAndModels.m



# Sensation, body
One experiment at
B1) http://emotion.nbe.aalto.fi/sensations_embody_FI/
See folder sensations_embody

# Sensations, concepts similarity
One experiment at
S1)  http://emotion.nbe.aalto.fi/sensations_sim/
See sim_ scripts


# Sensations, neuro
TO create nsdata.m

num=1;for n in $(cat sensations.txt|sed 's/ /_/g');do echo -n "data{$num}=[ "; let num=num+1;list=$(grep "$n" ns.csv|cut -d, -f2-);a='';for l in $(echo $list|tr ',' ' ');do a="$a {'"$l"_pFgA_z_FDR_0.01.nii'};";done;echo $a"]";done>nsdata.m

num=1;for n in $(cat sensations.txt|sed 's/ /_/g');do echo -n "data{$num}=[ "; let num=num+1;list=$(grep "$n" ns_manual.csv|cut -d, -f2-);a='';for l in $(echo $list|tr ',' ' ');do a="$a {'"$l"_pFgA_z_FDR_0.01.nii'};";done;echo $a"]";done>nsdata_manual.m

# Sensations, LSA+wordnet
