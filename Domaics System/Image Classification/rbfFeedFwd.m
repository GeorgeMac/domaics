function [ output, h ] = rbfFeedFwd( network, input, params )
%RBFFEEDFWD Feed Radial Basis Function Forward
%   Detailed explanation goes here
output = [];

[m n] = size(input);

if n ~= network.in
    error('Input vector size does not comply with network topology!');
else
    h = [];
    for i = 1 : m
        datum = input(i,:);
        [p1 p2] = size(params);
        [w1 w2] = size(network.weightsOne);
        x = [];
        for j = 1 : w1
            x = [x; datum .* network.weightsOne(j,:) + network.biasHid(:,j)];
        end
        outHid = [];
        for j = 1 : p2
            in = [];
            [x1 x2] = size(x);
            
            for k = 1 : x1
                in = [ in norm(x(k,:) - params(j).MU) ];
            end
            outHid = [outHid feval(network.hiddenA,in,params(j).MU,...
                params(j).VAR)];
        end
        h = [h; outHid];
        output = [output; feval(network.outputA,(outHid*network.weightsTwo)+network.biasOut)];
    end
end


end

