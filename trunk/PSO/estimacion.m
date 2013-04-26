function [ xkO ] = estimacion( xkI, wkidx )
%ESTIMACION Summary of this function goes here
%   Detailed explanation goes here
N = length(wkidx);

for k = 1:N
    xkO(1,k) = xkI(1,wkidx(k));
    xkO(2,k) = xkI(2,wkidx(k));
end

end

