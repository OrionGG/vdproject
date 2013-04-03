function KalmanII( input_args )
%KALMANII Summary of this function goes here
%   Detailed explanation goes here
KALMAN_STATE_SIZE = 5;
kalparam.A = [  1 0 1 0 0;
                0 1 0 1 0;
                0 0 1 0 0;
                0 0 0 1 0;
                0 0 0 0 1];

kalparam.H = eye(KALMAN_STATE_SIZE); 
kalparam.Q = eye(KALMAN_STATE_SIZE); 
kalparam.R = eye(KALMAN_STATE_SIZE);

objects = struct([]);

files = dir(['./data/' '*.' 'jpg']);
frames_names = sort({files.name});

num_frames = size( sort({files.name}),2);


background_frame = imread (strcat('./data/',frames_names{1}));
num = 8;
COMPONENT_THRESH = 500;
new_kalman = 1;
num_objects = 0;

for tt = 1:num_frames
       

    for obj = 1:num_objects
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Filtro de Kalman (prediccin)
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          objects(obj).x_t_minus = kalparam.A * objects(obj).x_t;
          objects(obj).P_t_minus = kalparam.A * objects(obj).P_t * kalparam.A + kalparam.Q;


          % Estimado a priori de la medida y su covarianza (necesario para la asociacin de datos)
          objects(obj).z_t_minus = kalparam.H * objects(obj).x_t_minus;
          objects(obj).P_zt_minus = kalparam.H * objects(obj).P_t_minus * kalparam.H' + kalparam.R;
            new_kalman = 0;
    end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Filtro de kalman (actualizacin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   actual_frame = imread (strcat('./data/',frames_names{tt}));
     foreground_map = actual_frame - background_frame;
     foreground_map = rgb2gray(foreground_map);
     
    
     foreground_map = im2bw(foreground_map, 40./255);
     imshow(foreground_map);
      
      
     [label_map, num_labels] = bwlabel(foreground_map, num);
    
    objects_map = zeros(size(foreground_map), 'int32');
    object_sizes = [];
    object_positions = [];
     new_label = 1;
    for label = 1:num_labels
      object = (label_map == label);
      imshow(label_map);
      object_size = sum(sum(object));
      if(object_size >= COMPONENT_THRESH)
        % Component is big enough, mark it
        objects_map = objects_map + int32(object * new_label);
        object_sizes(new_label) = object_size;

        width = size(foreground_map, 2);
        height = size(foreground_map, 1);
        
        [X, Y] = meshgrid(1:width, 1:height);    
        object_x = X .* object;
        object_y = Y .* object;

        object_positions(:, new_label) = [sum(sum(object_x)) / object_size;
                          sum(sum(object_y)) / object_size];
        new_label = new_label + 1;
      end
    end
    
    
    num_objects = new_label - 1;
    
    for obj = 1:num_objects
        if(new_kalman)
              % Se incializa un KF para ese objeto
              % Se extrae una medida z, a partir del modelo de medida asociado al
              % objeto (su silueta asociada). Si no se dispone de medidas en
              % instantes anteriores, la velocidad del objeto será cero.
              objects(obj).z_t = create_kalman_observation(object_positions(:, obj), ...
                                    object_sizes(obj));

              % Se inicializa el estimado a priori con la medida para ese instante 
              objects(obj).x_t_minus = objects(obj).z_t;

              % Y la covarianza de error a priori
              objects(obj).P_t_minus = eye(KALMAN_STATE_SIZE);

              % The expected mean observation for this state is the current observation
              objects(obj).z_t_minus = objects(obj).z_t;

            else
              % Ya se asoció un KF a este objeto, por lo que se dispone de medida
              % en el instante anterior. La velocidad se aproxima como la
              % diferencia entre posiciones en instante consecutivos

              objects(obj).z_t = create_kalman_observation(object_positions(:, obj), ...
                                        object_sizes(obj), ...
                                        objects(obj).z_t);
        end
        

       kalparam.K = (objects(obj).P_t_minus * kalparam.H') / (kalparam.H * objects(obj).P_t_minus * kalparam.H' + kalparam.R);
       if(sum(sum(isnan(kalparam.K )))>0)
           kalparam.K = eye(size(kalparam.K, 1), size(kalparam.K, 2));
       end
       objects(obj).x_t = objects(obj).x_t_minus + kalparam.K * (objects(obj).z_t - (kalparam.H * objects(obj).x_t_minus));
       objects(obj).P_t = (1-(kalparam.K * kalparam.H)) * objects(obj).P_t_minus;

    end
    
    hold on
    th = 0:pi/50:2*pi;
    nobjects = size(objects, 2);
    r = 16;
    r2 = r+2;

    imshow(actual_frame);
    for obj = 1:nobjects
        zx_t(obj) = objects(obj).z_t(1,:);
        zy_t(obj) = objects(obj).z_t(2,:);
        

        zxunit = r * cos(th) + zx_t(obj);
        zyunit = r * sin(th) + zy_t(obj);
        
        
        x_t(obj) = objects(obj).x_t(1,:);
        y_t(obj) = objects(obj).x_t(2,:);
        xunit = r2 * cos(th) + x_t(obj);
        yunit = r2 * sin(th) + y_t(obj);
        
        plot(zxunit, zyunit, 'r', xunit, yunit, 'g');
    end
    image =actual_frame;
    xmax = size(image, 2);
    ymax = size(image, 1);
    axis([0,xmax,0,ymax])
    xlabel('X');
    ylabel('Y');
    hold on; axis ij; %axis off;
    hold off;
    drawnow;
end
    

end

