# marsbar_ROI_combining
Basic scripts to convert nifti to _roi.mat, combine multiple ROIs and then export them to nifti format

This project uses three separate matlab scripts to combine ROIs using the MarsBar toolbox based on SPM.

The nifti_to_mat script converts all nifti files in a directory and one level lower to the roi.mat format that is readable by MarsBar. 

The mars_combine_rois script will read all roi.mat files in a directory and one level lower and will combine ROIs based on user input. At the moment, this user input will need to be done for each subject
folder that it finds. There is also the option to create a custom label and a custom description.

The roi_to_nifti script simply exports all roi.mat files found in a parent directory and one level lower back to nifti format.

Please ensure you have SPM and MarsBar toolbox added to your Matlab path.
