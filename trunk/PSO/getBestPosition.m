function [ idx ] = getBestPosition( xBest, N )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
maxValue = 0;
idx = 0;
for i = 1:N
    
    if(maxValue < xBest(i))
       idx = i;
       maxValue = xBest(i);
    end
end

end

