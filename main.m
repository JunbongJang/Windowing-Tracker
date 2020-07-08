%% Author: Junbong Jang
%  Date: 4/15/2020
% used to run various functions in this folder
clear all;

%% Visualize tracking
% root_path = '../../HeeJune/Image_Data/PtK1_CyD/PtK1_CyD_Pair/Windowing_whole/111017_PtK1_S01_1ml_DMSO_08/';
root_path = '../../HeeJune/Image_Data/PtK1_CyD/PtK1_CyD_Pair/Windowing_whole/111017_PtK1_S01_1ml_DMSO_08_test/';

save_path = 'protrusion_tracking/'
img_path = 'images/';
protrusion_path = 'WindowingPackage/protrusion/protrusion_vectors.mat';
protrusion_data = load([root_path, protrusion_path])
target_pixel_history = protrusion_data.target_pixel_history;
drawTrackedLines(target_pixel_history, [root_path, img_path], [root_path, save_path])

% addpath(genpath('extended-berkeley-segmentation-benchmark-master'));
% ref_img_path = 'generated/DMSO/111017_PtK1_S01_1ml_DMSO_080199.png'
% overlap_raw_with_mask(root_path, ref_img_path);
