function [ wk, wkidx ] = evaluacion( xk, particleSize, ball_frame )
%EVALUACION Summary of this function goes here
%   Detailed explanation goes here
N = size(xk,2);
[HEIGHT WIDTH C]= size(ball_frame);

l = 1;
wkidx= 0; 
maxValue = 0;
for k = 1:N
    acumValues = 0;
    x0 = round(xk(1,k) - particleSize./2);
    y0 = round(xk(2,k) - particleSize./2);
    xf = round(xk(1,k) + particleSize./2);
    yf = round(xk(2,k) + particleSize./2);
    
    if(x0 < 1) x0 = 1; end;
    if(y0 < 1) y0 = 1; end;
    if(xf > WIDTH) xf = WIDTH; end;
    if(yf > HEIGHT) yf = HEIGHT; end;
    
    
    
    for i = y0:yf
        for j = x0:xf     
            acumValues = acumValues + ball_frame(i,j);
        end
    end
    
    wk(k) = acumValues;
    if (wk(k)> 0)
        wkidx(l) = k;        
        l = l+1;
    end 
end

end

