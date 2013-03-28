function [u, v] = lucas_kanade_matlab(I1, I2, window_size)
% Calculate optical flow with the Lucas-Kanade algorithm
% lucas_kanade(files, window)
I1 = double(I1);
I1 = I1/255;
I1 = rgb2gray(I1);


I2 = double(I2);
I2 = I2/255;
I2 = rgb2gray(I2);

% Calculate derivates
fx = conv2(I1, 0.25 * [-1 1; -1 1]) + conv2(I2, 0.25 * [-1 1; -1 1]);
fy = conv2(I1, 0.25 * [-1 -1; 1 1]) + conv2(I2, 0.25 * [-1 -1; 1 1]);
ft = conv2(I1, 0.25 * ones(2)) + conv2(I2, -0.25 * ones(2));

% Calculate optical flow
window_center = floor(window_size / 2);
image_size = size(I1);
u = zeros(image_size);
v = zeros(image_size);
for i = window_center + 1:image_size(1) - window_center
  for j = window_center + 1:image_size(2) - window_center
    % Get values for current window
    fx_window = fx(i - window_center:i + window_center, j - window_center:j + window_center);
    fy_window = fy(i - window_center:i + window_center, j - window_center:j + window_center);
    ft_window = ft(i - window_center:i + window_center, j - window_center:j + window_center);

    fx_window = fx_window';
    fy_window = fy_window';
    ft_window = ft_window';

    A = [fx_window(:) fy_window(:)];

    U = pinv(A' * A) * A' * -ft_window(:);

    u(i, j) = U(1);
    v(i, j) = U(2);
  end
end
u(isnan(u))=0;
v(isnan(v))=0;
% Display the result
figure();
%axis equal
quiver(impyramid(impyramid(medfilt2(flipud(u), [5 5]), 'reduce'), 'reduce'), -impyramid(impyramid(medfilt2(flipud(v), [5 5]), 'reduce'), 'reduce'));

end