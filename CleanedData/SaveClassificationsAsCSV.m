%% Initialize

% Define data directories relative to script location
scriptDirectory = [pwd '/'];
cd ../; parentDirectory = [pwd '/'];
cd(scriptDirectory);
rawDataDirectory = [parentDirectory 'sensations/matlab/output/sim/'];
sensationLabelsDirectory = [parentDirectory 'sensations/matlab/output/mind/'];

% Load raw data
load([sensationLabelsDirectory 'mind_mds.mat'])
load([rawDataDirectory 'sim_cluster.mat'])


%% Create table

t.DBSCAN_class = sim_cluster.DBSCAN.class_from_mean_data';
t.DBSCAN_type = sim_cluster.DBSCAN.type_from_mean_data';
t.KMEANS_class = sim_cluster.KMEANS.class_from_mean_data;
t.HC_class = sim_cluster.HC.class_from_mean_data;
t.sensations = sensations;
t = struct2table(t);


%% Save as CSV

% Export
writetable(t, [scriptDirectory 'Exp2Classifications.csv'])

