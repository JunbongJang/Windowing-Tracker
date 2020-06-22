function overlap_raw_with_mask(root_path, reference_img_path)

msk_path = [root_path, 'WindowingPackage/refined_masks/refined_masks_for_channel_1/']; % directory containing masked (labeled) images
img = imread(reference_img_path);

saved_folder = 'generated/edge_evolution/';
files = dir([msk_path, '*.tif']);
frmae_interval = 15;
line_thickness = 1;

for frame_index = 1: frmae_interval: length(files)
    %% Load the ground truth
    patch_name = files(frame_index, 1).name
%     if frame_index == 1
%         img = im2uint8(imread([img_path, patch_name]));
%         [row, col] = size(img);
%         img = img(30:row-31, 30:col-31);
%         img3 = uint8(cat(3, img, img, img));
%     end

    %% Extracting the boundary of edge from Mask
    mask_region = double(imread([msk_path, patch_name]));
    mask = extract_edge(mask_region, 0);
    mask = imresize(mask, size(img,1,2));
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
       
            
        
        
