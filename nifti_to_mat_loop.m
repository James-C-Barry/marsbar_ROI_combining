% Set the directory containing the NIfTI files
rootDir = '/write/your/root/path/here';

% Get a list of folders in the root directory
folders = dir(rootDir);
folders = folders([folders.isdir]); % Keep only directories
folders = folders(~ismember({folders.name}, {'.', '..'})); % Remove '.' and '..' entries

% Loop through each folder
for i = 1:numel(folders)
    folderPath = fullfile(rootDir, folders(i).name);
    
    % Get a list of NIfTI files in the folder
    niiFiles = dir(fullfile(folderPath, '*.nii'));
    
    % Loop through each NIfTI file
    for j = 1:numel(niiFiles)
        % Load the NIfTI image
        niiFile = fullfile(folderPath, niiFiles(j).name);
        V = spm_vol(niiFile);
        Y = spm_read_vols(V);
        
        % Create a new region of interest (ROI) from the NIfTI image
        roi = maroi_image(struct('vol', V, 'binarize', 0.5));
        
        % Create the ROI filename with the same name as the NIfTI file
        [~, filename, ~] = fileparts(niiFile);
        roiFile = fullfile(folderPath, [filename '_roi.mat']);
        
        % Save the ROI as a separate file
        save(roiFile, 'roi');
    end
end
