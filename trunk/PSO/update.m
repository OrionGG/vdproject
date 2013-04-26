function [ xBestArrayOut ] = update(xk, wk, xBestArrayIn)
%UPDATE Summary of this function goes here
%   Detailed explanation goes here

    N = size(wk, 2);
    
    xBestArrayOut.x = xBestArrayIn.x;
    xBestArrayOut.Values = xBestArrayIn.Values;
    
    for i = 1:N
        if(wk(i) >= xBestArrayIn.Values(i))
            xBestArrayOut.x(:,i) = xk(:,i);
            xBestArrayOut.Values(i) = wk(i);
        end
    end


end

