function [ collection ] = Grab( image_in )
%GRAB Collects the individual cell images based on their bounding boxes
%   [1] Performs blob detection using the getBlobs function (see getBlobs.m)
%   [2] Labels blobs using bwlabel
%   [3] Aquires the bounding boxes 'bounds' using regionprops
%   [4] Iterates through the image in both grayscale and binary (blobs)
%   [5] Uses the binary representation as a mask to extract only important
%   features from the grayscale image
%   [6] Returns a collection of the new image regions


%% [1]
image_in = inReadFormat(image_in,0);
morph(1) = struct('op','dilate','it',2);
morph(2) = struct('op','majority','it',2);
morph(3) = struct('op','thicken','it',2);
morph(4) = struct('op','erode','it',0);

image_bin = getBlobs(image_in,morph,0.25);
%% [2]
labels = bwlabel(image_bin);
imshow(label2rgb(labels));
%% [3]
bounds = regionprops(labels,'BoundingBox');

[m,n] = size(bounds);

collection = [];
%% [4] -> [5] -> [6]
for i = 1:m
    % [4]
    box = bounds(i);
    
    BBox = box.BoundingBox;
    
    % Co-ords
    w = BBox(2);
    x = (BBox(2)+BBox(4));
    y = BBox(1);
    z = (BBox(1)+BBox(3));
    
    [p,q] = size(image_in);
    
    if x > p
        x = p;
    end
    
    if z > q
        z = q;
    end
    
    image_inner = image_in(w:x,y:z);
    mask_inner = labels(w:x,y:z);
    % [5]
    cell = image_inner .* double(mask_inner);
    
    cells = struct('image',image_in(w:x,y:z),'ext',cell);
    % [6]
    collection = [collection cells];
    
end

end

