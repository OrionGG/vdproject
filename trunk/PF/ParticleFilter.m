function [ xk ] = ParticleFilter( N, particlesSize, withDifusion )
%PARTICLEFILTER Summary of this function goes here
%   Detailed explanation goes here


files = dir(['./SecuenciaPF/kk/' '*.' 'jpeg']);
frames_names = sort({files.name});
num_frames = size( sort({files.name}),2);

actual_frame = imread (strcat('./SecuenciaPF/kk/',frames_names{1}));
[HEIGHT WIDTH C]= size(actual_frame);

t = 1;

xk = throwParticles(N, HEIGHT, WIDTH );

for tt = 1:num_frames
 
  actual_frame = imread (strcat('./SecuenciaPF/kk/',frames_names{tt}));
  
  ball_frame = actual_frame(:,:,1);
  ball_frame = im2bw(ball_frame, 175./255);
     
  imshow(ball_frame);

   drawRectangles(xk, particlesSize, actual_frame, 'g');
  [wk, wkidx] = evaluacion(xk, particlesSize, ball_frame);
  if (wkidx ~= 0)
    sumwk = sum(wk);
    wk = wk/sumwk;
  
    x = estimacion(xk, wkidx);
    drawRectangles(x, particlesSize, actual_frame, 'b');
  
  
    [xk, wk] = seleccion(xk, wk);
  
    xk = disfusion(xk, withDifusion, ball_frame);
  
  else
      
    xk = throwParticles(N, HEIGHT, WIDTH );
  end;
  
   drawRectangles(xk, particlesSize, actual_frame, 'g');

  t = t+1;
end

