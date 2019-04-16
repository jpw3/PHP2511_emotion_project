% Load matlab/output/sim/sim_mds.mat first

% Dissimilarity matrix
outDissim = array2table(mean_data_D);
outDissim.Properties.VariableNames = labels';
outDissim.Properties.RowNames = labels;
writetable(outDissim, 'DissimilarityMatrixForFig2.csv', 'WriteRowNames', 1);

% tSNE coordinates
outTSNE = array2table(sim_mds.tsne);
outTSNE.Properties.RowNames = labels;
writetable(outTSNE, 'Fig2_tSNE_coords.csv', 'WriteRowNames', 1);

% Classes from sensations_classes.m
temp.classID = (1:9)';
temp.classLabels = {'Emotional'
    'Motivational'
    'Social'
    'Psychiatric'
    'Homeostatic'
    'Physiological'
    'Cognition'
    'Sickness'
    'Sensation-perception'};
temp = struct2table(temp);
sensationClasses = array2table(classID);
outClasses = innerjoin(sensationClasses, temp);
outClasses.sensationLabels = labels;
writetable(outClasses, 'Fig2_classLabels.csv');


