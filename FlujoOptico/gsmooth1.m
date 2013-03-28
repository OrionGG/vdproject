function im = gsmooth1(im, dim, sigma)
% Smooth an image IM along dimension DIM with a 1D Gaussian mask of
% parameter SIGMA

if sigma > 0
    mask = fspecial('gauss', dim, sigma);
    im = conv2(im, mask, 'valid');
end

end