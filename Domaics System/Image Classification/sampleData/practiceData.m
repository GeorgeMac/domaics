function [ dataInputs targetOutputs func ] = practiceData( type, range, inputStep, noise, coeffs )
%PRACTICEDATA Summary of this function goes here
%   Detailed explanation goes here
dataInputs = range(1) : inputStep : range(2);

if strcmp(type,'linear')
    if nargin > 4
        m = coeffs(1);
        c = coeffs(2);
    else
        m = randi(10,1);
        c = randi(10,1);
    end
    
    targetOutputs = m .* dataInputs + c;
    
    if nargout > 2
        func = {'linear' m c};
    end
elseif strcmp(type, 'quad') || strcmp(type,'quadratic')
    if nargin > 4
        a = coeffs(1);
        b = coeffs(2);
        c = coeffs(3);
    else
        a = randi(10,1);
        b = randi(10,1);
        c = randi(10,1);
    end
    
    targetOutputs = a .* (dataInputs .^ 2) + b .* dataInputs + c;
    
    if nargout > 2
        func = {'quadratic' a b c};
    end
elseif strcmp(type, 'sin')
    if nargin > 4
        m = coeffs(1);
        c = coeffs(2);
    else
        m = randi(10,1);
        c = randi(10,1);
    end
    targetOutputs = m .* sin(dataInputs) + c;
    
    if nargout > 2
        func = {'sin' m c};
    end
else
    message = ['Unknown function type: ' type];
    error(message);
end

if noise
    [m n] = size(targetOutputs);
    mi = min(dataInputs);
    ma = max(dataInputs);
    targetOutputs = targetOutputs + (randn(1,n) .* (abs(mi-ma).*0.1));
end

dataInputs = dataInputs';

targetOutputs = targetOutputs';

end

