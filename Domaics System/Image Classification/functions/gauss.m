function [ out ] = gauss( mu, sig, input )
%GAUSS 1 Dimensional guassian distribution
%   [ out ] = gauss( mu, sig, input ) mu is the mean, sig is the variance
%   and input is the input or set of inputs to calculate the probability
%   distribution. Output is defined as out.
out = (1 / sig.*(sqrt(2 .* pi))).*exp((-(input-mu).^2)/(2.*(sig.^2)));

end

