function [ ] = blobAnalyser( image_path )
%BLOBANALYSER Summary of this function goes here
%   Detailed explanation goes here

morph = [struct('op','erode','it',0)];

morph = [morph struct('op','dilate','it',0)]; 

im = inReadFormat(image_path);

imshow(im);

blobs = getBlobs(im,morph);
colBlobs = label2rgb(bwlabel(blobs));

imshow(colBlobs);

end

