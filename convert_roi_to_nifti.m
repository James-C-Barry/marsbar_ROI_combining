% Define the parent directory
parentDirectory = 'write/your/root/directory/path/here';

% Get a list of all files and folders in the parent directory
filesAndFolders = dir(parentDirectory);

% Loop through each item in the parent directory
for i = 1:numel(filesAndFolders)
    item = filesAndFolders(i);
    
    % Check if the item is a folder and not . or ..
    if item.isdir && ~strcmp(item.name, '.') && ~strcmp(item.name, '..')
        folderPath = fullfile(parentDirectory, item.name);
        
        % Look for _roi.mat files within the current folder
        roiFiles = dir(fullfile(folderPath, '*_roi.mat'));
        
        % Loop through each _roi.mat file found
        for j = 1:numel(roiFiles)
            roiFile = roiFiles(j);
            
            % Load the ROI data from the _roi.mat file
            load(fullfile(folderPath, roiFile.name));
            
            % Get the path and file name without the extension
            [filePath, fileName, ~] = fileparts(roiFile.name);
            
            % Define the output file name with the .nii extension
            outputFileName = fullfile(folderPath, [fileName, '.nii']);
            
            % Save the ROI as a NIfTI image using the same name
            save_as_image(roi, outputFileName);
            
        end
    end
end

% Get a list of all folders one level below the parent directory
folders = dir(parentDirectory);
folders = folders([folders.isdir]);  % Keep only folders
folders = folders(~ismember({folders.name}, {'.', '..'}));  % Exclude . and ..

% Loop through each folder
for i = 1:numel(folders)
    folderName = folders(i).name;
    folderPath = fullfile(parentDirectory, folderName);
    
    % Look for .nii files within the current folder
    niiFiles = dir(fullfile(folderPath, '*.nii'));
    
    % Loop through each .nii file found
    for j = 1:numel(niiFiles)
        niiFile = niiFiles(j);
        
        % Get the file name without the extension
        [filePath, fileName, fileExt] = fileparts(niiFile.name);
        
        % Check if the file name ends with '_roi'
        if ~isempty(fileName) && numel(fileName) > 4 && strcmp(fileName(end-3:end), '_roi')
            % Remove the '_roi' from the file name
            newFileName = fileName(1:end-4);
            
            % Rename the file without the '_roi'
            oldFilePath = fullfile(folderPath, niiFile.name);
            newFilePath = fullfile(folderPath, [newFileName, fileExt]);
            movefile(oldFilePath, newFilePath);
        end
    end
end