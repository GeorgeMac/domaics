function [ network, errLog ] = netTrain( network, dataInput, dataTarget, method )
%NETTRAIN Summary of this function goes here
%   Detailed explanation goes here
[row col] = size(dataInput);
[mx my] = size(method);

if strcmp(method(1),'BackProp')
    epoch = 0;
    errorReport = [];
    while epoch < cell2mat(method(3))
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
            network.weightsTwo = network.weightsTwo + (cell2mat(method(2))).*(transfer' * deltaO);
            % Update weights into hidden
            network.weightsOne = network.weightsOne + (cell2mat(method(2))).*((datum)' * deltaH);
        end
        errorReport = [ errorReport sum(avgError)/2 ];
        epoch = epoch + 1;
        
        if my > 3 && cell2mat(method(4))
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
        
    end
    if nargout > 1
        errLog = errorReport;
    end
elseif strcmp(method(1),'RBF')
    
    figure('name','Radial Basis Function Network')
    
    axes('XLim',[min(dataInput(:,1))-0.5 max(dataInput(:,1))+0.5],'YLim',[min(dataInput(:,2))-0.5 max(dataInput(:,2))+0.5]);
    
    epochs = 0;
    
    prototypes = randn(network.hid,network.in,'double');
    [m n] = size(prototypes);
    
    hold on;
    text(dataInput(:,1),dataInput(:,2),int2str(dataTarget(:,1)));
    plot(prototypes(:,1),prototypes(:,2),'xb');
    pause(0.2);
    hold off;
    
    backUpP = [];
    
    while epochs < cell2mat(method(2)) || backUpP ~= prototypes
        backUpP = prototypes;
        assoc = struct('data',dataInput,'centre',ones(row,1));
        
        for i = 2 : m
            for j = 1 : row
                currentC = norm(assoc.data(j,:) - prototypes(assoc.centre(j),:));
                newC = norm(assoc.data(j,:) - prototypes(i,:));
                if currentC > newC
                    assoc.centre(j) = i;
                end
            end
        end

        for i = 1 : m
            neighbours = [];
            tick = 0;
            for j = 1 : row
                datum = assoc.data(j,:);
                if assoc.centre(j) == i
                   neighbours = [ neighbours; datum ]; 
                   tick = tick + 1;
                end
            end
            
            if ~isempty(neighbours)
                prototypes(i,:) = mean(neighbours,1);
            else
                prototypes (1,:) = randn(1,2,'double');
            end
        end
        
        hold on;
        plot(prototypes(:,1),prototypes(:,2),'xr');
        pause(0.2);
        hold off;
        
        epochs = epochs + 1;
    end
end

end

