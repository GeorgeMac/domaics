function [ ] = trainNTrace( network, dataIn, dataOut, epoch )
%TRAINNTRACE Summary of this function goes here
%   Detailed explanation goes here

% Plot initial config and target outputs

initOut = [];
[ r c ] = size(dataIn);
method = {'BackProp',0.1,1};

for i = 1 : r
    initOut = [ initOut; netFeedFwd(network,dataIn(i,:)) ];
end

figure('name','Network Evolution Trace')

hold on;

% plot(dataIn,initOut,'-b');
plot(dataIn,dataOut,'xr');

% Show evolution

[ network ] = netTrain(network,dataIn,dataOut,method);
out = [];
for i = 1 : r
    out = [ out; netFeedFwd(network,dataIn(i,:)) ];
end

for i = 1 : epoch
    plot(dataIn,out,'-c');
    pause(0.01);
    [ network ] = netTrain(network,dataIn,dataOut,method);
    out = [];
    for i = 1 : r
        out = [ out; netFeedFwd(network,dataIn(i,:)) ];
    end
end

plot(dataIn,dataOut,'xr');
plot(dataIn,out,'-b');

hold off;

end

