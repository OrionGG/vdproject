function [ xbest ] = update(wk, xbest)
%UPDATE Summary of this function goes here
%   Detailed explanation goes here
if(xbest == 0)
    xbest = wk;
else
    N = size(wk, 2);
    for i = 1:N
        if(wk(i)>xbest(i))
            xbest(i) = wk(i);
        end
    end
end

end

