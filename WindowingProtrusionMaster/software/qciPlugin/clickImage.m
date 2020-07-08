% Author: Junbong Jang
% Created at 4/11/2020
function [clicked_x, clicked_y] = clickImage(I, allow_multiple_points)
msgbox_track_points_info = msgbox({'Please click on two points in the image and press Enter.'; 'Backspace to undo click'},'How to do it');
set(msgbox_track_points_info,'Position',[350 499 220 70])
while (true)
    impixel_fig = figure(1);
    [clicked_x,clicked_y,P] = impixel(I);
    if allow_multiple_points == 1
        if size(clicked_x,1) >= 2 && size(clicked_y,1) >= 2
            f = msgbox(sprintf('%f points are selected successfuly', size(clicked_x,1)),'Success');
            delete(msgbox_track_points_info);
            if exist('msgbox_track_points_error','var')
                delete(msgbox_track_points_error);
            end
            close(impixel_fig);
            break;
        else
            msgbox_track_points_error = msgbox('Please Select at least two points in the image', 'Error','error');
        end
    else
         if size(clicked_x,1) == 2 && size(clicked_y,1) == 2
            f = msgbox('Two points are selected successfuly','Success');
            delete(msgbox_track_points_info);
            if exist('msgbox_track_points_error','var')
                delete(msgbox_track_points_error);
            end
            close(impixel_fig);
            break;
        else
            msgbox_track_points_error = msgbox('Please Select only two points in the image', 'Error','error');
        end
        
    end
    
end