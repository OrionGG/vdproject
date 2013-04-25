function [kk, wk] = seleccion( xk, wk )
%SELECCION Summary of this function goes here
%   Detailed explanation goes here
N = length(wk);

rullete = rand(N,1);


for j = 1:N
    rullValue = rullete(j);
    wAcum = 0;
    
    for k = 1:N
        wAcum = wAcum + wk(k);
        if(rullValue < wAcum)            
            kk(1,j) = xk(1,k);
            kk(2,j) = xk(2,k);
            break;
        end
    end;
    
    
end

%Inicialización de una población de partículas
for k = 1:N
   wk(k) = 1/N;
end

end

