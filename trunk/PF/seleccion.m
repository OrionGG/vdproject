function [xk, wk] = seleccion( xk, wk )
%SELECCION Summary of this function goes here
%   Detailed explanation goes here
N = length(wk);

rullete = rand(N,1);


for j = 1:N
    rullValue = rullete(j);
    wAcum = 0;
    kk(j) = 0;
    
    for k = 1:N
        wAcum = wAcum + wk(k);
        if(wAcum < rullValue)
            kk(j) = xk(k);
        else
            break;
        end
    end;
    
    
end

%Inicialización de una población de partículas
for i = 1:N
   w(i) = 1/N;
end

end

