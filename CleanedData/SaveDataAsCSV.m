%% Initialize

% Define data directories relative to script location
scriptDirectory = [pwd '/'];
cd ../; parentDirectory = [pwd '/'];
cd(scriptDirectory);
rawDataDirectory = [parentDirectory 'sensations/matlab/output/mind/'];

% Load raw data
load([rawDataDirectory 'mind_mds.mat'])


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


%% Save as CSV

% Overall table
t = [t_mean t_meanZ t_median t_medianZ];

% Sensation labels
t.Sensations = sensations;

% Export
writetable(t, [scriptDirectory 'Exp1TestData.csv'])

