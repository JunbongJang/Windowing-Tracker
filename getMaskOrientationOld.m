% 4/11/2020 by Junbong Jang at QCI lab
% Get Orientation of mask by looking at its four border intensities (black or white)
% 0 up, 1 right up, 2 right, 3 right down, 4 down, 5 down left, 6 left, 7 left up
% 100 if the white region is an island, not touching any edge

function orientation = getMaskOrientation(maskIn)
    [row, col] = size(maskIn);
    imshow(maskIn);
    left_edge = maskIn(1:end,1); % first column, all rows
    right_edge = maskIn(1:end,end); % last column, all rows
    up_edge = maskIn(1,1:end); % all columns, first row
    down_edge = maskIn(end,1:end); % all columns, last row
    
   % get intensity values from four edges
   left_edge_count = sum(left_edge > 0);
   right_edge_count = sum(right_edge > 0);
   up_edge_count = sum(up_edge > 0);
   down_edge_count = sum(down_edge > 0);
   % the side without any white is likely to be at the desired orientation.
   % If there are two or more side lines of black pixels
   if up_edge_count > down_edge_count
       if left_edge_count > right_edge_count
           orientation = 3;
       elseif left_edge_count < right_edge_count
           orientation = 5;
       else  % left_edge_count == right_edge_count
           orientation = 4;
       end
   elseif up_edge_count < down_edge_count
       if left_edge_count > right_edge_count
           orientation = 1;
       elseif left_edge_count < right_edge_count
           orientation = 7;
       else  % left_edge_count == right_edge_count
           orientation = 0;
       end
   else  % up_edge_count == down_edge_count
       if left_edge_count > right_edge_count
           orientation = 2;
       elseif left_edge_count < right_edge_count
           orientation = 6;
       else  % left_edge_count == right_edge_count
           orientation = 100;
       end
   end
   
end