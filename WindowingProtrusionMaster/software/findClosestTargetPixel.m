function edge_pixel_row = findClosestTargetPixel(pixel_a, pixels)
    [rows, cols] = size(pixels);
    min_dist = 1000;
    min_dist_row = 0;
    for row = 1:rows
        pixel_b = pixels(row, :);
        dist = euclidean_distance(pixel_a, pixel_b);
        if min_dist > dist
            min_dist = dist;
            min_dist_row = row;
        end
    end
    edge_pixel_row = min_dist_row;
   
    function output = euclidean_distance(pixel_a, pixel_b)
        output = sqrt( (pixel_a(1)-pixel_b(1))^2 + (pixel_a(2)-pixel_b(2))^2 );
    end 
end

