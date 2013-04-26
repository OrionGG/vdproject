function [ idx ] = getBestPosition( xBestArray, N )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
maxValue = 0;
idx = 0;
for i = 1:N
    
    if(maxValue < xBestArray.Values(i))
       idx = i;
       maxValue = xBestArray.Values(i);
    end
end

end

