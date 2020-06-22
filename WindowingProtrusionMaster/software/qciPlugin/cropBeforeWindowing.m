%% 4/1/2020 by Junbong Jang at QCI lab
% Crop mask based on two tracked points in protrusion step.
function [maskIn, x_min, y_min, x_max, y_max] = cropBeforeWindowing(target_pixel_history, smoothedEdge, iFrame, maskIn)
    % first get index of corresponding tracked pixel in the smoothedEdge
    pixel_a = target_pixel_history{iFrame, 1};
    pixel_b = target_pixel_history{iFrame, 2};
    smoothedEdge = smoothedEdge{iFrame,1};
    pixel_a_index =  findClosestTargetPixel(pixel_a, smoothedEdge);
    pixel_b_index =  findClosestTargetPixel(pixel_b, smoothedEdge);
    %% determine x and y indices by comparing chosen points and the boundaries of images
    % to find the area flushed to the boundary of the image frame in
    % between two tracked points
    if pixel_a_index>pixel_b_index
        betweenSmoothEdge = smoothedEdge(pixel_b_index:pixel_a_index,:);
        pixel_a_index = pixel_a_index - pixel_b_index + 1;
        pixel_b_index = 1;
    else
        betweenSmoothEdge = smoothedEdge(pixel_a_index:pixel_b_index,:);
        pixel_b_index = pixel_b_index - pixel_a_index + 1;
        pixel_a_index = 1;
    end
    [x_min, x_min_index] = min(betweenSmoothEdge(:,1));
    [y_min, y_min_index] = min(betweenSmoothEdge(:,2));
    [x_max, x_max_index] = max(betweenSmoothEdge(:,1));
    [y_max, y_max_index] = max(betweenSmoothEdge(:,2));
    
    x_min = floor(x_min);
	y_min = floor(y_min);
	x_max = ceil(x_max);
	y_max = ceil(y_max);
    
    %% cropping using chosen x,y coordinates
    rect = [x_min, y_min, x_max-x_min, y_max-y_min]; % [xmin ymin width height]
    maskIn = imcrop(maskIn,rect);

    %% image processing to fill holes
    [row, col] = size(maskIn);
    img_percentage = ceil(row * col * 0.05);
    maskIn = bwareaopen(maskIn, img_percentage);
    maskIn = bwareaopen(~maskIn, img_percentage);
    maskIn = imfill(~maskIn,'holes');
    
end