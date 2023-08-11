% This script will loop through a directory to find a specific folder name that contains
% either .nii.gz or .nii files then convert them to _roi.mat files. The only things to change
% are the named folder which is the folder containing the images (this should be the same for
% all subjects if running multiple) and the root directory.

% Set the root directory containing the *NAMED* folders
rootDir = '/write/your/root/path/here';

% Replace *NAMED* with the folder that it will find for each subject

% Process *NAMED folders and subfolders recursively
processNIIFolders(rootDir);

function processNIIFolders(folderPath)
    % Get the name of the current folder
    [~, folderName, ~] = fileparts(folderPath);
    
    % Check if the current folder is named "*NAMED*"
        if strcmp(folderName, 'INPUT FOLDER NAME HERE')
        % Get a list of NIfTI.gz files in the current folder
        niiGzFiles = dir(fullfile(folderPath, '*.nii.gz'));
        
        % Check if NIfTI.gz files exist, else process NIfTI files
        if ~isempty(niiGzFiles)
            % Loop through each NIfTI.gz file
            for j = 1:numel(niiGzFiles)
                % Unzip the NIfTI.gz file
                niiGzFile = fullfile(folderPath, niiGzFiles(j).name);
                fprintf('Unzipping: %s\n', niiGzFile);
                gunzip(niiGzFile);
                
                % Get the unzipped NIfTI file name
                [~, filename, ~] = fileparts(niiGzFile);
                unzippedNiiFile = fullfile(folderPath, filename);
                
                % Load and process the NIfTI image
                processNiftiFile(unzippedNiiFile);
                
                % Clean up: remove the unzipped NIfTI file
                delete(unzippedNiiFile);
            end
        else
            % Get a list of NIfTI files in the current folder
            niiFiles = dir(fullfile(folderPath, '*.nii'));
            
            % Loop through each NIfTI file
            for j = 1:numel(niiFiles)
                % Process the NIfTI image
                niiFile = fullfile(folderPath, niiFiles(j).name);
                processNiftiFile(niiFile);
            end
        end
    end
  
    % Get a list of subdirectories in the current folder
    subdirs = dir(folderPath);
    subdirs = subdirs([subdirs.isdir]);
    subdirs = subdirs(~ismember({subdirs.name}, {'.', '..'}));
    
    % Recursively process subdirectories
    for i = 1:numel(subdirs)
        subfolderPath = fullfile(folderPath, subdirs(i).name);
        processNIIFolders(subfolderPath);
    end
end

function processNiftiFile(niftiFile)
    % Load the NIfTI image
    fprintf('Loading: %s\n', niftiFile);
    V = spm_vol(niftiFile);
    Y = spm_read_vols(V);
    
    % Create a new region of interest (ROI) from the NIfTI image
    P = niftiFile;
    roipath = fileparts(niftiFile);
    [~, rootn, ~] = fileparts(niftiFile);
    flags = 'i'; % assuming id image
    mars_img2rois(P, roipath, rootn, flags);
end

