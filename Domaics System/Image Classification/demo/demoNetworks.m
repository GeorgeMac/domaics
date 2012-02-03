function [  ] = demoNetworks(  )
%DEMONETWORKS Generate statistics of domaics network performance
%   Demonstration of the networks in the domaics system with common network
%   problems. Including mapping linear functions, sinusoidal functions,
%   2d classification problems.

%% Linear Function Approximation

% linear coefficients
linearCoeff = randn([1 2]);

% linear function
[linFuncIn linFuncOut] = practiceData('linear',[-2 2],0.1,0,linearCoeff);
% noisy linear function
[linNIn linNOut] = practiceData('linear',[-2 2],0.1,1,linearCoeff);

% 60% Training 40% Testing set split
[linNInTrain linNOutTrain linNInTest linNOutTest] = splitTrainTest(linNIn, linNOut, 0.6);

% mlp network with 1 input node and 1 output with 1 bias.
network = netCreate(1,1,0,@void,@void,1);
% train mlp with learning rate 0.2 for 20 iterations
trainingError = [];
generalisationError = [];
for iteration = 1 : 20
    [network,errlog] = mlpTrain(network,linNInTrain,linNOutTrain,0.2,1);
    trainingError = [ trainingError; errlog ];
    %Calculate Generlisation Error (Mean squared of the system)
    outputs = netBlkFeedFwd(network, linNInTest);
    genError = sum((linNOutTest - outputs).^2)./2;
    generalisationError = [ generalisationError; genError ];
end

%Plot statistics
figure(1)
set(1,'name',['Linear Function Approximation with linear coefficients: ' mat2str(linearCoeff)]);
set(1,'Units','normalized','Position',[0,0,1,1]);

% Function to approximate + noisey data
subplot(2,2,1)

hold on;
plot(linNIn,linNOut,'xr');
plot(linFuncIn,linFuncOut);
hold off;

% Function mapped by the neural network compared to noisey data +
% Generalisation error.
subplot(2,2,2)

hold on;
plot(linNIn,linNOut,'xr');
plot(linNInTrain,netBlkFeedFwd(network,linNInTrain));
plot(linNInTest,outputs,'og');
hold off;

% Average training error over each on-line iteration

subplot(2,2,3)

plot(trainingError);

% Average generalisation error over each on-line iteration

subplot(2,2,4)

plot(generalisationError);

saveas(1,'../figures/linearFuncApprox','jpg');

%% Sinusoidal Function Approximation

% Sin Coefficients
sinCoeff = [3.4546 5.345];
limits = [-3 3];
step = 0.05;

% Sin Function
[sinFuncIn sinFuncOut] = practiceData('sin',limits,step,0,sinCoeff);
% noisy sin function
[sinNIn sinNOut] = practiceData('sin',limits,step,1,sinCoeff);

%Split 60:40 training testing sets
[sinNInTrain sinNOutTrain sinNInTest sinNOutTest] = splitTrainTest(sinNIn,sinNOut,0.6);

% mlp network with 1 input node and 1 output with 1 bias.
network = netCreate(1,30,1,@tanh,@void);
% train mlp with learning rate 0.02 for 100 iterations
trainingError = [];
generalisationError = [];
for iteration = 1 : 100
    [network,errlog] = mlpTrain(network,sinNInTrain,sinNOutTrain,0.02,1);
    trainingError = [ trainingError; errlog ];
    %Calculate Generlisation Error (Mean squared of the system)
    outputs = netBlkFeedFwd(network, sinNInTest);
    genError = sum((sinNOutTest - outputs).^2)./2;
    generalisationError = [ generalisationError; genError ];
    if iteration > 10
        [t1 t2] = size(trainingError);
        if std(trainingError(t1-5:t1)) == 0
            break;
        end
    end
end

%Plot statistics
figure(2)
set(2,'name',['Sinusoidal Function Approximation with sin coefficients: ' mat2str(sinCoeff)]);
set(2,'Units','normalized','Position',[0,0,1,1]);
subplot(2,2,1)

hold on;
plot(sinNIn,sinNOut,'xr');
plot(sinFuncIn,sinFuncOut);
hold off;

subplot(2,2,2)

hold on;
plot(sinNIn,sinNOut,'xr');
plot(sinNInTrain,netBlkFeedFwd(network,sinNInTrain));
plot(sinNInTest,outputs,'og');
hold off;

subplot(2,2,3)
plot(trainingError);

subplot(2,2,4)
plot(generalisationError);

saveas(2,'../figures/sinFuncApprox','jpg');

end

