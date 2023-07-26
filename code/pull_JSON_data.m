function data = pull_JSON_data(data, projDir)

% handle pre-MNs (file 1):
    dataFile = fullfile(projDir, 'data/PreMNs_T3-A1-A2_2023-02-16.json');
      fileContents = fileread(dataFile);
      fileData = jsondecode(fileContents);
    
    post_preMNs = [fileData.skeleton_id]';


 % handle MNs (file 2):
    dataFile = fullfile(projDir, 'data/MNs_T3-A1-A2_2023-02-16.json');
      fileContents = fileread(dataFile);
      fileData = jsondecode(fileContents);
    
    post_MNs = [fileData.skeleton_id]';

    data.post_PMNs = post_preMNs;
    data.post_MNs  = post_MNs;