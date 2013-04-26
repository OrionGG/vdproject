function [ xk ] = prediction( x, tt, xk )
%PREDICTION Summary of this function goes here
%   Detailed explanation goes here
NN = size(x,2);
ttprev = 0;

for i = (NN-1):-1:1
    if((x(1,i) ~=0) & (x(2,i) ~= 0)) 
        ttprev = i;
        break;
    end
end


vtt(1,1) = 0;
vtt(2,1) = 0;
    
if(size(x,2) > 1)
    xprev = 0;
    if(ttprev ~= 0)
       xprev = x(:,ttprev);
       vtt = (x(:,tt)-xprev)/(tt - ttprev);
    end
end

N = length(xk);
for k = 1:N
    xk(:,k) = xk(:,k) + vtt;
end
end

