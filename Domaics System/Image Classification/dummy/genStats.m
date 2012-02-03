function genStats( dataIn, dataOut, func, network )
%GENSTATS Summary of this function goes here
%   Detailed explanation goes here
figure('name','Network Practice','position',[400 450 1184 500]);
%%
[r c] = size(func);
[ void clean ] = practiceData(cell2mat(func(1)),[min(dataIn) max(dataIn)],abs(dataIn(1) - dataIn(2)),0,cell2mat(func(2:c)));

%%
init = plotNetwork(dataIn,network);

%%
error = [];

for x = 1 : 500
    subplot(1,2,2);

    [ network, err ] = netTrain(network,dataIn,dataOut,{'BackProp',0.01,1});

    error = [ error err ];
    
    plot(error);
    pause(0.001);

    subplot(1,2,1)
    cla
    hold on;

    plot(dataIn,dataOut,'xr');

    plot(dataIn,clean,'-b');
    
    plot(dataIn,init,'--m');

    plotNetwork(dataIn,network,'-.g');

    hold off;

end
%%

    function [ res ] = plotNetwork(dataIn,network,marker)
        
        initialNetworkStats = [];

        [m n] = size(dataIn);

        for i = 1 : m
            initialNetworkStats = [ initialNetworkStats netFeedFwd(network,dataIn(i,:)) ];
        end
        
        if nargout == 1
            res = initialNetworkStats;
        else
            plot(dataIn,initialNetworkStats,marker);
        end
        
    end

end

