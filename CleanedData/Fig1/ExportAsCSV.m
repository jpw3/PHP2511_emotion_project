%% Initialize

% Define data directories relative to script location
scriptDirectory = [pwd '/'];
cd ../; cd ../; parentDirectory = [pwd '/'];
cd(scriptDirectory);
exp2Directory = [parentDirectory 'sensations/matlab/output/sim/'];
exp1Directory = [parentDirectory 'sensations/matlab/output/mind/'];

% Load raw data
load([exp1Directory 'mind_mds.mat'])
load([exp2Directory 'sim_cluster.mat'])


%% Table of classifications

classifications.DBSCAN_class = sim_cluster.DBSCAN.class_from_mean_data';
classifications.DBSCAN_type = sim_cluster.DBSCAN.type_from_mean_data';
classifications.KMEANS_class = sim_cluster.KMEANS.class_from_mean_data;
classifications.HC_class = sim_cluster.HC.class_from_mean_data;
classifications.sensations = sensations;
classifications = struct2table(classifications);


%% Table of mean

% Convert mean data to a table
t_mean = array2table(mean_data);

% Dimension labels
dim_labels = {'BodilySensationStrength_mean', 'MindSensationStrength_mean', ...
    'EmotionIntensity_mean', 'Controllability_mean', 'LastTime_mean'};
t_mean.Properties.VariableNames = dim_labels;


%% Table of meanZ

% Convert mean data to a table
t_meanZ = array2table(mean_dataZ);

% Dimension labels
dim_labels = {'BodilySensationStrength_meanZ', 'MindSensationStrength_meanZ', ...
    'EmotionIntensity_meanZ', 'Controllability_meanZ', 'LastTime_meanZ'};
t_meanZ.Properties.VariableNames = dim_labels;


%% Table of median

% Convert mean data to a table
t_median = array2table(median_data);

% Dimension labels
dim_labels = {'BodilySensationStrength_median', 'MindSensationStrength_median', ...
    'EmotionIntensity_median', 'Controllability_median', 'LastTime_median'};
t_median.Properties.VariableNames = dim_labels;


%% Table of medianZ

% Convert mean data to a table
t_medianZ = array2table(median_dataZ);

% Dimension labels
dim_labels = {'BodilySensationStrength_medianZ', 'MindSensationStrength_medianZ', ...
    'EmotionIntensity_medianZ', 'Controllability_medianZ', 'LastTime_medianZ'};
t_medianZ.Properties.VariableNames = dim_labels;


%% Final table

% Table of all summary statistics
summaryStats = [t_mean t_meanZ t_median t_medianZ];

% Add sensation labels
summaryStats.sensations = sensations;

% Add classification IDs to summary stats
output = innerjoin(summaryStats, classifications);

% Add classification labels
temp.DBSCAN_class = [-1 1 2 3 4 5]';
temp.DBSCAN_labels = {'Between', 'NegEmo', 'PosEmo', ...
    'Illness', 'Cognition', 'Homeostasis'}';
temp = struct2table(temp);
classifications = innerjoin(classifications, temp);


%% Export as CSV

writetable(summaryStats, [scriptDirectory 'Exp1MeanData.csv'])
writetable(classifications, [scriptDirectory 'Exp2Classifications.csv'])
writetable(output, [scriptDirectory 'AllDataForFig1.csv'])

