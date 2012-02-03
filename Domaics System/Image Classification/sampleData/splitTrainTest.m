function [ linNInTrain, linNOutTrain, linNInTest, linNOutTest ] = splitTrainTest( linNIn, linNOut, split )
%SPLITTRAINTEST split training and testing set
%   Detailed explanation goes here
% 

% Initialise training set
linNInTrain = linNIn;
linNOutTrain = linNOut;

%Calculate dataset size
[r c] = size(linNIn);

% Initialise testing set
linNInTest = [];
linNOutTest = [];

% Calculate random sample testing set from uniform distribution
threshold = floor((1-split)*r);

for i = 1 : threshold
    [r1 c1] = size(linNInTrain);
    pnt = randi(r1);
    
    dataIn = linNInTrain(pnt,:);
    dataOut = linNOutTrain(pnt,:);
    
    linNInTrain(pnt,:) = [];
    linNOutTrain(pnt,:) = [];
    
    linNInTest = [linNInTest; dataIn];
    linNOutTest = [linNOutTest; dataOut];
end

end

