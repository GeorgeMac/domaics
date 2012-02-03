function [ cell_collection ] = extractCells( image_in, limit )
%EXTRACTCELLS Summary of this function goes here
%   Detailed explanation goes here
thresholds = [0.2:0.05:0.4];

[t1 t2] = size(thresholds);

init_collec = [ Grab(image_in,thresholds(1)) ];

for i = 2 : t1
    
end


end

