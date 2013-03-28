function [objects] = update_kalman_filters(objects, kalmanparam, assignments, ...
					   objects_map, object_sizes, pos_observed)

                   
% Actualiza un array de objetos seguidos con las nuevas medidas (siluetas).
% Los parámetros para la actualización de los filtros de kalman se
% especifican en la estructura kalmanparam. La asociación entre siluetas y
% objetos viene dada por la matriz assignments. La información sobre las
% medidas se puede extraer de objects_map, object_sizes y pos_observed.
 
global HEIGHT WIDTH KALMAN_STATE_SIZE

% Calculo de aquellos objetos que tienen matching con una medida.
% Aquellos que tengan match, su filtro será artificialmente propagado
% utilizando su propia predicción como medida
assigned_objects = sum(assignments, 2);


for obj = 1:size(objects, 2)

  objects(obj).traj_length = objects(obj).traj_length + 1;

  if(assigned_objects(obj)) % Si el objeto tiene medida asociada
    obj_observation = find(assignments(obj, :)); 
    
    if(objects(obj).new_kalman)
      % Se incializa un KF para ese objeto
      % Se extrae una medida z, a partir del modelo de medida asociado al
      % objeto (su silueta asociada). Si no se dispone de medidas en
      % instantes anteriores, la velocidad del objeto será cero.
      objects(obj).z_t = create_kalman_observation(pos_observed(:, obj_observation), ...
 	                        object_sizes(obj_observation));

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

      objects(obj).z_t = create_kalman_observation(pos_observed(:, obj_observation), ...
                                object_sizes(obj_observation), ...
                                objects(obj).z_t);
    end

    % El filtro se considera terminado cuando se propaga demasiadas veces. 
    % Se resetea este contador cuando se encuentra disponible una medida para
    % este filtro.
    objects(obj).ntimes_propagated = 0;

    % Cada vez que se encuentra medida se actualiza el contador de
    % actualizaciones. De esta manera, cuando el tracking termine se puede
    % determinar si la trayectoria del objeto es buena o mala.
    objects(obj).ntimes_updated = objects(obj).ntimes_updated + 1;

    % Calculo de las coordenadas del rectángulo que contiene la observación
    obs_indicator = (objects_map == obj_observation); 
    [X, Y] = meshgrid(1:WIDTH, 1:HEIGHT);
    X = X .* obs_indicator;
    Y = Y .* obs_indicator;

    objects(obj).bbox_x(1) = min(nonzeros(X(:)));
    objects(obj).bbox_x(2) = max(X(:));
    
    objects(obj).bbox_y(1) = min(nonzeros(Y(:)));
    objects(obj).bbox_y(2) = max(Y(:));
  
  else % Si no hay medida asociada a ese objeto
   
    % Se utiliza el estimado a priori como medida
    objects(obj).z_t = objects(obj).x_t_minus;

    % Se considera que un filtro termina cuando se propaga demasiadas veces
    % Propagar: no disponer de medida y utilizar la predicción
    objects(obj).ntimes_propagated = objects(obj).ntimes_propagated + 1;
  end
 
  % Actualizar cada filtro de kalman con su observación
  [objects(obj).x_t, objects(obj).P_t] = ...
      kalman_measurement_update(objects(obj).z_t, ...
      objects(obj).x_t_minus, objects(obj).P_t_minus, kalmanparam);
end 
