function [ image_bin ] = getBlobs( image_in, morph, thresh )
%GETBLOBS Summary of this function goes here
%   Detailed explanation goes here
mask = fspecial('gauss',10,3);

figure
imshow(image_in);
image_smooth = conv2(image_in,mask,'valid');

if nargin > 2
    image_bin = image_smooth<thresh;
else
    image_bin = image_smooth<0.4;
end

[x,y] = size(morph);

if nargin > 1
    for n = 1:x
        if strcmp(morph(n).op,'default')
            return;
        else
            image_bin = bwmorph(image_bin,morph(n).op,morph(n).it);
        end
    end
end

figure
imshow(image_bin);


end

