function image = inReadFormat(image_in, gamma)
%% Read In Image
if isstr(image_in)
    image = imread(image_in);
else
    image = image_in;
end
%%
image = rgb2gray(image);
%%
image = double(image)/256;
%% Gamma Correction
if nargin > 1 && gamma
    image = image .^ (5/6);
else
    image = image .^ (5/6);
end
