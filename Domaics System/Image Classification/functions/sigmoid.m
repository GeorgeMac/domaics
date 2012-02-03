function [ output ] = sigmoid( data )
%SIGMOID sigmoidal function between 0 and 1
%   [ output ] = sigmoid( data ) output is the set of outputs of the
%   sigmoid function and data is an m x n (usually a vector) of inputs

output = ((1/2).*tanh(data)+(1/2));

end

