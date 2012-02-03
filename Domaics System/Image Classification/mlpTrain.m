function [ network, errlog ] = mlpTrain( network, dataInput, dataTarget, eta, iterations )
%MLPTRAIN Train a Multi-Layered Perceptron using back-propagation and error
%gradient descent method. Application of the delta-rule / Adeline method
%is implemented.
%
%   [ network ] = mlpTrain( network, dataInput, dataTarget ) Trains a mlp
%   network on the training set dataInput with target vectors dataTarget.
%   It uses 0.02 learning rate(eta) over 100 iterations by default.
%   
%   [ network ] = mlpTrain( network, dataInput, dataTarget, eta ) Same as
%   before, however, user specified learning rate eta.
%   
%   [ network ] = mlpTrain( network, dataInput, dataTarget, eta, iterations
%   ) Again same as before, however, both the learning rate and training
%   iterations are specified as inputs to mlptrain.
%   
if nargin < 5
    iterations = 100;
    if nargin < 4
        eta = 0.02;
    end
end

[row col] = size(dataInput);
errorReport = [];

epoch = 0;
while epoch < iterations
    avgError = [];
    for pointer = 1 : row
        % Get each datum from the dataset
        datum = dataInput(pointer,:);
        % Calculate output
        if ~isempty(network.classes)
            [output, hidA] = netFeedFwd(network,datum,network.classes);
        else
            [output, hidA] = netFeedFwd(network, datum);
        end
        % Get target for datum
        target = dataTarget(pointer,:);
        % Get system error
        error = (output - target);
        avgError = [avgError error.^2];
        sosError = sum(error.^2)./2;
        % Calculate delta for output layer nodes
        if ~isequal(network.outputA,@sigmoid)
            deltaO = error;
        else
            transO = feval(network.outputA,output);
            deltaO = (transO .* (1 - transO)) .* error;
        end
        % Calculate delta for hidden layer nodes
        if isequal(network.hiddenA,@void) || isequal(network.hiddenA,@step)
            deltaH = error;
        elseif isequal(network.hiddenA,@sigmoid)
            if network.out ~= 0
                deltaH = hidA .* (1 - hidA) .* (deltaO * network.weightsTwo');
            else
                deltaH = hidA .* (1 - hidA) .* error;
            end
        elseif isequal(network.hiddenA,@tanh)
            if network.out ~= 0
                deltaH = sech((datum * network.weightsOne)+network.biasHid).^2 .* (deltaO * network.weightsTwo');
            else
                deltaH = sech((datum * network.weightsOne)+network.biasHid).^2 .* error;
            end
        end
        % Update weights into output
        if network.out > 0
            network.weightsTwo = network.weightsTwo - (eta.*(hidA' * deltaO));
            network.biasOut = network.biasOut - (eta .* (network.biasOut .* deltaO));
        end
        % Update weights into hidden
        network.weightsOne = network.weightsOne - (eta.*((datum)' * deltaH));
        network.biasHid = network.biasHid - (eta .* (network.biasHid .* deltaH));
    end
    errorReport = [ errorReport mean(avgError)];
    epoch = epoch + 1;
    
    if nargout > 1
        errlog = errorReport;
    end
end

end

