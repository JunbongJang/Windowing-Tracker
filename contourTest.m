function contourTest(maskIn)
    %Get distance transform of mask
    figure(1)
    imshow(maskIn);
    distX = bwdist(~maskIn);
    figure(2)
    imshow(distX);
    maxDist = max(distX(:));
    
    %Convert these sizes into distance-transform isovalues
    distXvals = 0:10:maxDist;
    
    %Find the isocontours of the distance transform at these values
    contours = contourc(double(distX),double(distXvals)); %contourc only takes in doubles
    figure(3);
    imcontour(double(distX),double(distXvals))
    
    [contours,contourValues] = separateContours(contours) %We need to retrieve the values also, because a given value may have more than 1 contour
    
end
