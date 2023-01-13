function datasetFolder = downloadDataset(downloadDatasetFolder)
    filename = "qasc_dataset.tar.gz";
    url = "http://data.allenai.org/downloads/qasc/" + filename;
    
    datasetFolder = fullfile(downloadDatasetFolder,"QASC_Dataset");
    
    if ~isfolder(datasetFolder)
        gunzip(url,downloadDatasetFolder);
        unzippedFile = fullfile(downloadDatasetFolder,filename);
        untar(unzippedFile{1}(1:end-3),downloadDatasetFolder);
    end
end