function [ stats ] = getIQRangeData( image_cell )
%GETIQRANGEDATA Summary of this function goes here
%   Detailed explanation goes here

image_cleaned = image_cell(image_cell>0);

image_arran = image_cleaned(:);

stats = prctile(image_arran,[5,25,50,75,95]);

stats = [stats abs(stats(4) - stats(2))];

end

