function [ xk ] = throwParticles(N, HEIGHT, WIDTH )
%THROWPARTICLES Summary of this function goes here
%   Detailed explanation goes here
    xxk = randn(1, N);
    minxxk = min(min(xxk));
    xxk = xxk - minxxk;

    maxxxk = max(max(xxk));
    xxk = xxk/maxxxk;

    xyk = randn(1, N);
    minxyk = min(min(xyk));
    xyk = xyk - minxyk;

    maxxyk = max(max(xyk));
    xyk = xyk/maxxyk;

    xk(1,:) = xxk(1,:) * WIDTH;
    xk(2,:) = xyk(1,:) * HEIGHT;

    xk = round(xk);

end

