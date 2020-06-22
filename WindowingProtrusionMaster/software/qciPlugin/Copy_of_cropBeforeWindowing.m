%% 4/1/2020 by Junbong Jang at QCI lab
% Crop mask based on two tracked points in protrusion step.
function maskIn = cropBeforeWindowing(target_pixel_history, smoothedEdge, iFrame, maskIn)
    [orig_row, orig_col] = size(maskIn);
    % first get index of corresponding tracked pixel in the smoothedEdge
    pixel_a = target_pixel_history{iFrame, 1};
    pixel_b = target_pixel_history{iFrame, 2};
    smoothedEdge = smoothedEdge{iFrame,1};
    pixel_a_index =  findClosestTargetPixel(pixel_a, smoothedEdge);
    pixel_b_index =  findClosestTargetPixel(pixel_b, smoothedEdge);
    %% determine x and y indices by comparing chosen points and the boundaries of images
    % to crop the area flushed to the boundary of the image frame in
    % between two tracked points
    [x_min, x_min_index] = min(smoothedEdge(:,1));
    [y_min, y_min_index] = min(smoothedEdge(:,2));
    [x_max, x_max_index] = max(smoothedEdge(:,1));
    [y_max, y_max_index] = max(smoothedEdge(:,2));
    
    [temp, temp_min_x_index] = min([smoothedEdge(pixel_a_index,1),smoothedEdge(pixel_b_index,1)]);
    if temp_min_x_index == 1
        x_min_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, x_min_index, pixel_a_index);
    else
        x_min_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, x_min_index, pixel_b_index);
    end
        
    [temp, temp_min_y_index] = min([smoothedEdge(pixel_a_index,2),smoothedEdge(pixel_b_index,2)]);
    if temp_min_y_index == 1
        y_min_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, y_min_index, pixel_a_index);
    else
        y_min_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, y_min_index, pixel_b_index);
    end
        
    [temp, temp_max_x_index] = max([smoothedEdge(pixel_a_index,1),smoothedEdge(pixel_b_index,1)]);
    if temp_max_x_index == 1
        x_max_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, x_max_index, pixel_a_index);
    else
        x_max_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, x_max_index, pixel_b_index);
    end
        
    [temp, temp_max_y_index] = max([smoothedEdge(pixel_a_index,2),smoothedEdge(pixel_b_index,2)]);
    if temp_max_y_index == 1
        y_max_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, y_max_index, pixel_a_index);
    else
        y_max_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, y_max_index, pixel_b_index);
    end
    
    x_min = smoothedEdge(x_min_index,1);
    y_min = smoothedEdge(y_min_index,2);
    x_max = smoothedEdge(x_max_index,1);
    y_max = smoothedEdge(y_max_index,2);
    
    x_min = floor(x_min);
	y_min = floor(y_min);
	x_max = ceil(x_max);
	y_max = ceil(y_max);
    
    %% cropping using chosen x,y coordinates
    rect = [x_min y_min x_max-x_min y_max-y_min]; % [xmin ymin width height]
    maskIn = imcrop(maskIn,rect);
    
    % assumes the orientation is right
    %% reexpands the image bottom and top
    top_expand = y_min;
    bottom_expand = orig_row - y_max;
    left_expand = x_min;
    right_expand = orig_col - x_max;
    maskIn = padarray(maskIn, top_expand, 0, 'pre');
    maskIn = padarray(maskIn, bottom_expand-1, 0, 'post');
    maskIn = padarray(maskIn,[0 left_expand], 0, 'pre'); 
    maskIn = padarray(maskIn,[0 right_expand], 0, 'post'); 

    %% image processing to fill holes
    [row, col] = size(maskIn);
    img_percentage = ceil(row * col * 0.05);
    maskIn = bwareaopen(maskIn, img_percentage);
    maskIn = bwareaopen(~maskIn, img_percentage);
    maskIn = imfill(~maskIn,'holes');
    
    %%
    function given_index = getIndexBetweenTwoPixels(pixel_a_index, pixel_b_index, given_index, alternate_index)
        if_min_condition = min([pixel_a_index, pixel_b_index]);
        if_max_condition = max([pixel_a_index, pixel_b_index]);
        if given_index < if_min_condition || given_index > if_max_condition
            % choose either pixel a index or pixel b index
            given_index = alternate_index;
        else
            given_index = given_index;
        end
    end
end