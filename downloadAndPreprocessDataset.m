addpath("utils")
% Download the data set if it does not already exist
downloadDatasetFolder = tempdir;
disp('Downloading...')
datasetFolder = downloadDataset(downloadDatasetFolder);
disp('Finished!')

% Preprocess the data set and generate the files containing questions and
% answers inside folder 'text_data'
preprocessDataset(datasetFolder);

