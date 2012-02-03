function [ output, hidActif ] = netFeedFwd( network, input )
%NETFEEDFWD Summary of this function goes here
%   Detailed explanation goes here

[m n] = size(input);

if n ~= network.in
    error('Input vector size does not comply with network topology!');
else
    hidActif = feval(network.hiddenA,(input * network.weightsOne)...
        + network.biasHid);
    if network.out > 0
        output = feval(network.outputA,(hidActif * network.weightsTwo)...
            + network.biasOut);
    else
        output = hidActif;
    end
end

end

