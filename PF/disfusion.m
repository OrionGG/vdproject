function [ xkO ] = disfusion( xkI, withDifusion, ball_frame )
%DISFUSION Summary of this function goes here
%   Detailed explanation goes here

%%%hacerlo teniendo en cuenta la dinamica del sistema
%%% distribucion gausiana de la velocidad
N = length(xkI);
[HEIGHT WIDTH C]= size(ball_frame);

rx = randn(2, N) * withDifusion;
ry = randn(2, N) * withDifusion;

for k = 1:N
    x = xkI(1,k) + rx(1,k); 
    y = xkI(2,k) + ry(2,k);
    
    if(x < 1) x = 1; end;
    if(y < 1) y = 1; end;
    if(x > WIDTH) x = WIDTH; end;
    if(y > HEIGHT) y = HEIGHT; end;
    
    
    xkO(1,k) = x;
    xkO(2,k) = y;
end

xkO = round(xkO);

end

