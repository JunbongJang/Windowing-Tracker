%% Author: Junbong Jang
%  Date: 4/15/2020
% used to run various functions in this folder
clear all;

%% Visualize tracking
% root_path = 'assets/Heejune_data/';
root_path = '../../HeeJune/Image_Data/PtK1_CyD/PtK1_CyD_Pair/Windowing_whole/111017_PtK1_S01_1ml_DMSO_08/';
img_path = 'images/';
protrusion_path = 'WindowingPackage/protrusion/protrusion_vectors.mat';
protrusion_data = load([root_path, protrusion_path])
target_pixel_history = protrusion_data.target_pixel_history;
drawTrackedLines(target_pixel_history, [root_path, img_path])

% addpath(genpath('extended-berkeley-segmentation-benchmark-master'));
% ref_img_path = 'generated/DMSO/111017_PtK1_S01_1ml_DMSO_080199.png'
% overlap_raw_with_mask(root_path, ref_img_path);

%% Orientation
% I = imread('assets/120217_S01_CK666_50uM_03/images/img_scaled0001.tif');
% clickImage(I)

% mask_img = imread('assets/orientation_testset/center.png');
% getMaskOrientation(mask_img) == 100
% mask_img = imread('assets/orientation_testset/down1.png');
% getMaskOrientation(mask_img) == 5
% mask_img = imread('assets/orientation_testset/down2.png');
% getMaskOrientation(mask_img) == 5
% mask_img = imread('assets/orientation_testset/down3.png');
% getMaskOrientation(mask_img) == 5
% mask_img = imread('assets/orientation_testset/down4.png');
% getMaskOrientation(mask_img) == 0
% mask_img = imread('assets/orientation_testset/left1.png');
% getMaskOrientation(mask_img) == 2
% mask_img = imread('assets/orientation_testset/left2.png');
% getMaskOrientation(mask_img) == 1
% mask_img = imread('assets/orientation_testset/right3.png');
% getMaskOrientation(mask_img) == 6
% mask_img = imread('assets/orientation_testset/up1.png');
% getMaskOrientation(mask_img) == 0
% mask_img = imread('assets/orientation_testset/up2.png');
% getMaskOrientation(mask_img) == 1
% mask_img = imread('assets/orientation_testset/up5.png');
% getMaskOrientation(mask_img) == 4