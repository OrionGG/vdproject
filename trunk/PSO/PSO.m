function PSO( N, iterations, particlesSize )
%PSO Summary of this function goes here
%   Detailed explanation goes here
files = dir(['./SecuenciaPF/kk/' '*.' 'jpeg']);
frames_names = sort({files.name});
num_frames = size( sort({files.name}),2);

actual_frame = imread (strcat('./SecuenciaPF/kk/',frames_names{1}));
[HEIGHT WIDTH C]= size(actual_frame);

t = 1;

        xk = throwParticles(N, HEIGHT, WIDTH );
        vk = zeros(2,N);
        xBestArray.x = xk;
        xBestArray.Values = zeros(1,N);
        xBestPosition.Value = 0;
        xBestPosition.x(1,1) = -1;
        xBestPosition.x(2,1) = -1;
        
        drawRectangles(xk, particlesSize, actual_frame, 'g');

for tt = 1:num_frames
 
  actual_frame = imread (strcat('./SecuenciaPF/kk/',frames_names{tt}));
  
  ball_frame = actual_frame(:,:,1);
  ball_frame = im2bw(ball_frame, 175./255);
   
  imshow(ball_frame);
  
  for it = 1:iterations
  
      [wk, wkidx, maxIdx] = evaluacion(xk, particlesSize, ball_frame);
      if (wkidx ~= 0)
        xt = estimacion(xk, wkidx);
        x(1,tt) = xt(1, maxIdx);
        x(2,tt) = xt(2, maxIdx);
        drawRectangles(x(:,tt), particlesSize, actual_frame, 'b');
        
        xBestArray = update(xk, wk,xBestArray);                
      

        Idx = getBestPosition(xBestArray, N);
       
        if(xBestPosition.Value <= xBestArray.Values(Idx))
            xBestPosition.x(1,1) = xBestArray.x(1, Idx);
            xBestPosition.x(2,1) = xBestArray.x(2, Idx);
            xBestPosition.Value = xBestArray.Values(Idx);
        end;
        
        
            vk = updateVelocity(vk, xk, xBestArray, xBestPosition, N);
            xk = moveParticles(xk, vk);
      else
          
            xk = throwParticles(N, HEIGHT, WIDTH );
            xBestArray.x = xk;
            xBestArray.Values = zeros(1,N);
            xBestPosition.Value = 0;
            xBestPosition.x(1,1) = -1;
            xBestPosition.x(2,1) = -1;
      end;

       drawRectangles(xk, particlesSize, actual_frame, 'g');
  end;

  t = t+1;

end

