function [ network ] = netBackProp( network, dataInput, dataTarget, options )
%NETBACKPROP Summary of this function goes here
%   Detailed explanation goes here

% splitting training and testing set
complete = [ dataInput dataTarget ];
[s1 s2] = size(complete);
c = ceil(s1 * 0.3);
testInput = [];
testTarget = [];

[sd1 sd2 ] = size(dataInput);
[st1 st2] = size(dataTarget);

for x = 1 : c
    [s1 s2] = size(complete);
    pnt = randi(s1,1);
    testInput = [testInput; complete(pnt,1:sd2)];
    testTarget = [testTarget; complete(pnt,sd2+1:sd2+st2)];
    complete(pnt,:) = [];
end

dataInput = complete(:,1:sd2);
dataTarget = complete(:,sd2+1:sd2+st2);

[row col] = size(dataInput);
epoch = 0;
errorReport = [];
genErrorReport = [];

type = options.type;
eta = options.eta;
iter = options.iter;
plotError = options.plotError;
plotFunc = options.plotFunc;
plotDB = options.plotDB;
limits = options.limits;

while epoch < iter
    avgError = [];
    for pointer = 1 : row
        % Get each datum from the dataset
        datum = dataInput(pointer,:);
        % Calculate output
        [output, hidA] = netFeedFwd(network, datum);
        % Get target for datum
        target = dataTarget(pointer,:);
        % Classification requires step function
        if strcmp(type,'classification')
            if output >= 0
                output = 2;
            else
                output = 1;
            end
        end
        % Get system error
        error = (target - output);
        avgError = [avgError error.^2];
        sosError = sum(error.^2)/2;
        % Calculate delta for output layer nodes
        if strcmp(network.outputA,'void')
            deltaO = error;
        elseif strcmp(network.outputA,'sigmoid')
            transO = transFunc(network.outputA,output);
            deltaO = (transO .* (1 - transO)) .* error;
        end
        % Calculate delta for hidden layer nodes
        if strcmp(network.hiddenA,'void')
            deltaH = error;
        elseif strcmp(network.hiddenA,'sigmoid')
            deltaH = hidA .* (1 - hidA) .* (deltaO * network.weightsTwo');
        elseif strcmp(network.hiddenA,'tanh')
            deltaH = sech((datum * network.weightsOne)+network.biasHid) .* (deltaO * network.weightsTwo');
        end
        % Update weights into output
        if network.out > 0
            network.weightsTwo = network.weightsTwo + (eta.*(hidA' * deltaO));
            network.biasOut = network.biasOut + (eta .* (network.biasOut .* deltaO));
        end
        % Update weights into hidden
        network.weightsOne = network.weightsOne + (eta.*((datum)' * deltaH));
        network.biasHid = network.biasHid + (eta .* (network.biasHid .* deltaH));
    end
    errorReport = [ errorReport sum(avgError)/2 ];
    epoch = epoch + 1;
    
    
    [x1 x2] = size(testInput);
    innerGenError = [];
    for i = 1 : x1
        datum = testInput(i,:);
        output = netFeedFwd(network,datum);
        if strcmp(type,'classification')
            if output >= 0
                output = 2;
            else
                output = 1;
            end
        end
        innerGenError = [ innerGenError (output - testTarget(i,:))^2 ];
    end
    
    genErrorReport = [genErrorReport sum(innerGenError)/2];
    
    
    if plotError | plotFunc | plotDB
        if plotError
            subplot(2,2,1);
            plot(errorReport);
            subplot(2,2,2);
            plot(genErrorReport);
        end
        if plotFunc
            subplot(2,2,3);
            cla;
            hold on;
            plot(dataInput,dataTarget,'xr');
            iterOut = [];
            for i = 1 : row
                output = netFeedFwd(network, dataInput(i,:));
                if strcmp(type,'classification')
                    if output >= 0
                        output = 2;
                    else
                        output = 1;
                    end
                end
                iterOut = [iterOut output];
            end
            if ~strcmp(type,'classification')
                plot(dataInput,iterOut,'*g');
            end
            hold off;
        end
        if plotDB
            subplot(2,2,4);
            if strcmp(type,'classification')
                axes('XLim',limits,'YLim',limits);
                [m n] = size(dataInput);
                hold on;
                for i = 1 : m
                    text(dataInput(i,1),dataInput(i,2),int2str(round(iterOut(i))));
                end
                if network.out == 0 && network.hid == 1
                    points = [];
                    for i = 1 : 2
                        if network.weightsOne(1,:) ~= 0
                            points = [ points; ((-i*network.weightsOne(2,:)-network.biasHid)/network.weightsOne(1,:))];
                        end
                    end
                    plot(points,limits);
                end
                hold off;
            end
        end
        pause(0.001);
    end

end
if nargout > 1
    errLog = errorReport;
end

end

