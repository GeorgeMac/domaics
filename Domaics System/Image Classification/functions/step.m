function [ output ] = step( input )
%STEP Heaviside activation function step
%   f(x) = 0 boundary

if input >= 0
    output = 1;
else
    output = -1;
end

end

