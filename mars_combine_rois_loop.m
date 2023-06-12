% Set the root directory
rootDir = 'write/your/root/directory/path/here';

% Get a list of folders in the root directory
folders = dir(rootDir);
folders = folders([folders.isdir]); % Keep only directories
folders = folders(~ismember({folders.name}, {'.', '..'})); % Remove '.' and '..' entries

% Loop through each folder
for i = 1:numel(folders)
    folderPath = fullfile(rootDir, folders(i).name);
    
    % Get a list of ROI files in the folder
    roiFiles = dir(fullfile(folderPath, '*.mat'));
    
    % Check if there are at least two ROI files
    if numel(roiFiles) < 2
        continue;
    end
    
    % Display the list of ROI files and ask for user selection
    fprintf('ROI files in folder %s:\n', folderPath);
    for j = 1:numel(roiFiles)
        fprintf('%d: %s\n', j, roiFiles(j).name);
    end
    
    roiIndices = input('Enter the indices of the ROIs to combine (e.g., [1 2]): ');
    
    % Check if the selected ROI indices are valid
    if any(roiIndices < 1) || any(roiIndices > numel(roiFiles))
        fprintf('Invalid ROI indices. Skipping folder %s.\n', folderPath);
        continue;
    end
    
    % Create a custom name for the combined ROI file
    combinedRoiName = 'custom_name'; % Customize the name here
    
    % Load the first ROI file to start combining
    roi1File = fullfile(folderPath, roiFiles(roiIndices(1)).name);
    roi1 = maroi('load', roi1File);
    roiCombined = roi1;
    
    % Loop through the remaining selected ROI files for combining
    for j = 2:numel(roiIndices)
        roi2File = fullfile(folderPath, roiFiles(roiIndices(j)).name);
        roi2 = maroi('load', roi2File);
        
        % Combine the ROIs
        roiCombined = roiCombined | roi2;
    end
    
    % Set the label and description for the combined ROI
    roiCombined = label(roiCombined, 'custom_label'); % Write your custom label here
    roiCombined = descrip(roiCombined, 'custom_description'); % Write your custom description here
    
    % Save the combined ROI as a separate file
    combinedRoiFile = fullfile(folderPath, [combinedRoiName '.mat']);
    roiCombined = saveroi(roiCombined, combinedRoiFile);
end
