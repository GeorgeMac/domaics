function [ dataOut ] = netBlkFeedFwd( network, dataIn )
%NETBLKFEEDFWD Process a large set of inputs to outputs through a network
%   Detailed explanation goes here
[row col] = size(dataIn);
dataOut = [];
for i = 1 : row
    dataOut = [dataOut; netFeedFwd(network, dataIn(i,:));];
end

end

