function [ output_args ] = backPropTrain( network, dataInput, dataTarget, eta, iter )
%BACKPROPTRAIN Summary of this function goes here
%   Detailed explanation goes here
[row col] = size(dataInput);

epoch = 0;
errorReport = [];
while epoch < iter
    avgError = [];
    for pointer = 1 : row
        % Get each datum from the dataset
        datum = dataInput(pointer,:);
        % Calculate output
        output = netFeedFwd(network, datum);
        % Get target for datum
        target = dataTarget(pointer,:);
        % Get system error
        error = (target - output);
        avgError = [avgError error.^2];
        % Calculate delta for output layer nodes
        if strcmp(network.outputA,'void')
            deltaO = error;
        elseif strcmp(network.outputA,'sigmoid')
            transO = transFunc(network.outputA,output);
            deltaO = (transO .* (1 - transO)) .* error;
        end
        % Calculate delta for hidden layer nodes
        transfer = transFunc(network.hiddenA,(datum * network.weightsOne)+network.biasHid);
        if strcmp(network.hiddenA,'sigmoid')
            deltaH = transfer .* (1 - transfer) .* (deltaO * network.weightsTwo');
        elseif strcmp(network.hiddenA,'tanh')
            deltaH = sech((datum * network.weightsOne)+network.biasHid) .* (deltaO * network.weightsTwo');
        end
        % Update weights into output
        network.weightsTwo = network.weightsTwo + eta.*(transfer' * deltaO);
        network.biasOut = network.biasOut + eta .* (network.biasOut .* deltaO);
        % Update weights into hidden
        network.weightsOne = network.weightsOne + eta.*(datum' * deltaH);
        network.biasHid = network.biasOut + eta .* (network.biasHid .* deltaH);
    end
    errorReport = [ errorReport sum(avgError)/2 ];
    epoch = epoch + 1;
    
    subplot(1,2,1);
    plot(errorReport);
    subplot(1,2,2);
    cla;
    hold on;
    plot(dataInput,dataTarget,'xr');
    plot(dataInput,netFeedFwd(network, dataInput),'*g');
    hold off;
    pause(0.001);

end
if nargout > 1
    errLog = errorReport;
end

end

