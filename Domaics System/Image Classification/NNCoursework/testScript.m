function [  ] = testScript(  )
%TESTSCRIPT Coursework experimentation
%   Question 1b 2a and 2b

%% 1b
%Range of data
x = 10;
%Mean of each cluster
MUC1 = [0,0];
MUC2 = [4,0];
%Replicate means for mvnrnd func
MUC1 = repmat(MUC1,x,1);
MUC2 = repmat(MUC2,x,1);
%Initial covariance matrix
SIG = [1 0;0 1];
%Replicate covariance for mvnrnd
SIGMAC1 = repmat(SIG,[1,1,x]);
SIGMAC2 = SIGMAC1;
%Generate random input vectors from multivariate normal probability
%distribution
C1 = mvnrnd(MUC1,SIGMAC1);
C2 = mvnrnd(MUC2,SIGMAC2);
%Generate target output vectors
C1T = ones(x,1);
C2T = -ones(x,1);
%Axis handling
minC = min(min([C1 C2]));
maxC = max(max([C1 C2]));
axes('XLIM',[minC-0.5 maxC+0.5],'YLIM',[minC-0.5 maxC+0.5]);
%Plot data
plot2DData(C1,C2);
%Create single layer perceptron using netCreate function with a heaviside
%activation function and 2 input nodes employing the adeline method for
%updating weight vectors
network = netCreate(2,1,0,@tanh,@void,1);
%Begin learning, while plotting the evolution of the decision boundary
epoch = 0;
limit = 100;
previousWeights = [];
currentWeights = [network.weightsOne; network.biasHid];
while epoch < limit && ~isequal(previousWeights,currentWeights);
    previousWeights = currentWeights;
    x2 = [-10 ; 10];
    [network,error] = mlpTrain(network,[C1;C2],[C1T;C2T],0.02,1);
    x1 = (-(x2 .* network.weightsOne(2,1)) - network.biasHid) ./ network.weightsOne(1,1);
    cla;
    hold on;
    plot(x1,x2);
    plot2DData(C1,C2);
    hold off;
    pause(0.1);
    currentWeights = [network.weightsOne; network.biasHid];
    epoch = epoch + 1;
end
figure(5)
plot(error);
fprintf(['Epochs ran: ' int2str(epoch) '\n']);

function [] = plot2DData(C1,C2)
    %hold on;
    text(C1(:,1),C1(:,2),'C1','HorizontalAlignment','center');
    text(C2(:,1),C2(:,2),'C2','HorizontalAlignment','center');
    %hold off;
end
    
%% 2a
%Create inputs
x = [1:2:200]';

range = 20;

%Generate Outputs from linear function y = 0.4*x + 3 + noise (delta)
[xi xj] = size(x);
y = (0.4 .* x) + 3 + (2.*range.*rand([xi xj])-range);

%Build single layer perceptron
network = netCreate(1,1,0,@void,@void,1);
%Train slp with eta 0.02 for iterations defined by the variable limit

epoch = 0;
limit = 100;
previousWeights = [];
currentWeights = [network.weightsOne; network.biasHid];
fprintf('Begin \n')
figure(2)
hold on;

while epoch < limit && ~isequal(previousWeights,currentWeights);
    previousWeights = currentWeights;
    [network,error] = mlpTrain(network,x,y,0.000001,1);
    currentWeights = [network.weightsOne; network.biasHid];
    %plot network output
    ynew = netBlkFeedFwd(network,x);
    cla;
    plot(x,y,'xr');
    plot(x,ynew,'Color',[0.1,0.56,epoch/limit]);
    pause(0.1);
    epoch = epoch + 1;
end
hold off;

fprintf(['Epochs ran: ' int2str(epoch) '\n'])
    
end

