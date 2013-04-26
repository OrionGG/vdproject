function [ vkOut ] = updateVelocity( vkIn, xk, xBestArray, xBestPosition, N )
%UPDATEVELOCITY Summary of this function goes here
%   Detailed explanation goes here
w = 0.33;
p1 = 0.33;
p2 = 0.33;

pg = [xBestPosition.x(1,1); xBestPosition.x(2,1)];
pgn(1,:) = ones(1,N).* pg(1);
pgn(2,:) = ones(1,N).* pg(2);

vkOut = w * vkIn + p1*(xBestArray.x - xk) + p2* (pgn-xk);

end

