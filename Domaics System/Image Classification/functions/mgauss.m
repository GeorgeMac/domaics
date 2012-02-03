function [ out ] = mgauss( input, mu, sig )
%MGAUSS Multivariate Gaussian Distribution Function
%   Performs the multivariate guaussian probability distribution
%   [ output ] = mgauss( mu, sig, input ) mu is the vector of means, sig is
%   the Covariance matrix and input is the distribution inputs matrix.
out = mvnpdf(input,mu,sig);

end

