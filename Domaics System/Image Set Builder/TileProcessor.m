function [ ] = TileProcessor( image, name )
%TILEPROCESSOR Summary of this function goes here
%   Detailed explanation goes here

[m n] = size(image);
out_tiles = mat2cell(image,[m/4 m/4 m/4 m/4],[n/4 n/4 n/4 n/4]);

xmlRoot = struct('entry',[]);

if nargin < 1
    
else
    [m n] = size(name);
    new_name = [];
    for i = 1 : n
        if name(i) ~= '.'
            new_name = [new_name name(i)];
        else
            break;
        end
    end
    path = ['image/processed/' new_name '_tiles'];
    if ~isdir(path)
        mkdir(path);
        tick = 1;
        for k = 1 : 4
            for j = 1 : 4
                file_name = [[path '/im_'] num2str(tick)];
                imwrite(cell2mat(out_tiles(k,j)),file_name,'jpg');
                tick = tick + 1;
                
                %% XML Storing
                entry = struct('imageURL',[file_name],'diagnosis',['CLEAR'],'features',[]);
                feature = struct('data',[],'type',[],'id',[]);
                entry.features = [feature];
                xmlRoot.entry = [xmlRoot.entry entry];
            end
        end
        xmlStore([path '/markup.xml'],xmlRoot);
    else
        errordlg('Image Already Processed!');
    end
end

end

