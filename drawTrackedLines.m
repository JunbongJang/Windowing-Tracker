function I = drawTrackedLines(target_pixel_history, img_path, save_path)
   mkdir(save_path)
   img_struct = dir(fullfile(img_path, '*.tif'));
   folder_path = img_struct.folder;
   img_names = {img_struct.name};
   
   max_n = length(img_names);
   clicked_counts = size(target_pixel_history,2);
   initial_n = 1;
   for n = initial_n : max_n
    disp(n)
    img_name = img_names{1,n};
    I = imread(fullfile(img_path, img_name));
    I = uint8(I);
    I = imadjust(I);
    if n == initial_n
       traced_img = zeros(size(I));
    else
        color_change = [(255/max_n)*n, 255-(255/max_n)*n, 0];
        for clicked_index = 1:clicked_counts
            traced_img = insertShape(traced_img,'Line',[target_pixel_history{n-1,clicked_index},target_pixel_history{n,clicked_index}],'LineWidth',3,'color',color_change);
        end
    end

    I = uint8(traced_img) + I;
    if n < max_n
        I = imresize(I, [451, 451]);
    end
    imwrite(I, [save_path,strrep(img_name,'.tif','.png')]);

   end

end