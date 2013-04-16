function [ xk ] = ParticleFilter( N, z, particlesSize )
%PARTICLEFILTER Summary of this function goes here
%   Detailed explanation goes here


files = dir(['./SecuenciaPF/kk/' '*.' 'jpeg']);
frames_names = sort({files.name});
num_frames = size( sort({files.name}),2);

actual_frame = imread (strcat('./SecuenciaPF/kk/',frames_names{1}));
[HEIGHT WIDTH C]= size(actual_frame);


xk = randn(2, N);
minxk = min(min(xk));
xk = xk - minxk;

maxxk = max(max(xk));
xk = xk/maxxk;

xk(1,:) = xk(1,:) * WIDTH;
xk(2,:) = xk(2,:) * HEIGHT;

xk = round(xk);

for tt = 1:num_frames
 
  actual_frame = imread (strcat('./SecuenciaPF/kk/',frames_names{tt}));
  ball_frame = actual_frame(:,:,1);
  ball_frame = im2bw(ball_frame, 175./255);
     
  imshow(ball_frame);

  [wk, wkidx] = evaluacion(xk, particlesSize, ball_frame);
  sumwk = sum(wk);
  wk = wk/sumwk;
  
  xk = estimacion(xk, wkidx);

end

