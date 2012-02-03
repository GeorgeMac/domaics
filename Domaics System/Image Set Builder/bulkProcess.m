function [ output_args ] = bulkProcess( )
%BULKPROCESS Summary of this function goes here
%   Detailed explanation goes here
paths = dir('image/bin');

[m n] = size(paths);


buildpath = ['image/processed/tileset_' date];
while ~mkdir(buildpath)
    
'Building path...';
        
end

tile = '/tile_';
tick = 0;

for i = 3 : m
    cd(['image/bin/' paths(i,:).name]);
    ims = ls;
    [r c] = size(ims);
    for j = 3 : r
        path2Process = ims(j,:);
        
        if ~isempty(regexp(path2Process,'\W*(40x.jpg)'))
            currentIm = imread(path2Process);

            [imx imy imz] = size(currentIm);

            if ndims(currentIm) < 3
                out_tiles = mat2cell(currentIm,[imx/4 imx/4 imx/4 imx/4],[imy/4 imy/4 imy/4 imy/4]);
            else
                out_tiles = mat2cell(currentIm,[imx/4 imx/4 imx/4 imx/4],[imy/4 imy/4 imy/4 imy/4],imz);
            end

            [oi oj] = size(out_tiles);
            for ox = 1 : oi
                for oy = 1 : oj
                    imwrite(cell2mat(out_tiles(ox,oy,:)),['../../../' buildpath tile int2str(tick) '.jpg'],'jpg');
                    tick = tick + 1;
                end
            end
        end
    end
    cd '../../../';
end

end

