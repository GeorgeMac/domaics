function [ network ] = rbfTrain( network, dataInput, dataTarget, iter )
%RBFTRAIN Summary of this function goes here
%   Detailed explanation goes here
[row col] = size(dataInput);

epochs = 0;
    
prototypes = randn(network.hid,network.in,'double');
[m n] = size(prototypes);

backUpP = [];

assoc = [];

while epochs < iter && ~isequal(backUpP,prototypes)
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
            prototypes(i,:) = randn(1,2,'double');
        end
    end

    epochs = epochs + 1;
end

prots = struct('MU',[],'VAR',[]);
[p1 p2] = size(prototypes);
for i = 1 : p1
    prots(i).MU = prototypes(i,:);
end

for i = 1 : m
    maxDistance = 0;
    for j = 1 : row
        if assoc.centre(j) == i
            cityB = assoc.data(j,:) - prototypes(i,:);
            distance = norm(cityB);
            if distance > maxDistance
                maxDistance = cityB;
            end
        end
    end
    prots(i).VAR = abs(diag(maxDistance./2));
end
%% Begin network weight evaluation using Moore-Penrose pseudo inverse function pinv

[y,h] = rbfFeedFwd(network,dataInput,prots);

weightsTwo = pinv(h)*dataTarget;

[p1 p2] = size(prots);
p = [];
for i = 1 : p2
    p(i) = norm(prots(i).MU);
end
q = [];
for i = 1 : row
    q = [q;p];
end
weightsOne = pinv(dataInput)*q;

network.weightsOne = weightsOne;

network.weightsTwo = weightsTwo;

[y,h] = rbfFeedFwd(network,dataInput,prots);

end

