function overlap_raw_with_mask()

msk_path = 'Z:\HeeJune\Image_Data\Sample_Videos\2020_MQP_I\111017_Paird_cyD_segmented_images\111017_PtK1_S01_1ml_CyD100_05\refined_mask_png\refined_mask_'; % directory containing masked (labeled) images
img_path = 'Z:\HeeJune\Image_Data\PtK1_CyD\Windowing\111017\111017_PtK1_S01_1ml_CyD100_05\images'; % directory containing raw (original) images
img = imread('img_scaled0200.tif');

saved_folder = 'Z:\HeeJune\Image_Data\Sample_Videos\2020_MQP_I\111017_Paird_cyD_segmented_images\edge_evolution\';
files = dir([img_path, '*.tif']);
frame_interval = 15;
line_thickness = 1;

for frame_index = 1: frame_interval: length(files)
    %% Load the ground truth
    patch_name = files(frame_index, 1).name
%     if frame_index == 1
%         img = im2uint8(imread([img_path, patch_name]));
%         [row, col] = size(img);
%        img = img(30:row-31, 30:col-31);
%         img3 = uint8(cat(3, img, img, img));
     end

    %% Extracting the boundary of edge from Mask
    mask_region = double(imread([msk_path, patch_name]));
    mask = extract_edge(mask_region, 0);
    mask = imresize(mask, size(img));
%     mask = mask(30:row-31, 30:col-31); % cropping the edges of images

    %% Visualization of prediction
    se = strel('square',line_thickness);
    BW2_mask = imdilate(mask,se);
    red_mask = uint8(BW2_mask)*(frame_index/length(files));
    img(:, :, 1) = img(:, :, 1) + red_mask;
    green_mask = uint8(BW2_mask) - uint8(BW2_mask)*(frame_index/length(files));
    img(:, :, 2) = img(:, :, 2) + green_mask;
    
    figure(1)
    imshow(img);
end
%img = imresize(img, [451,451]);
imwrite(img, [saved_folder, 'tracked_', strrep(patch_name,'.tif','.png')]);
end
       
            
        
        
