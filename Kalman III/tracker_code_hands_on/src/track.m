function track(kalparam, varargin) 

global HEIGHT WIDTH C 
%global debug_coord
%debug_coord = [-1, -1];
COMPONENT_THRESH = 15;


% Inicialmente no se esta ejecutando ningun filtro de kalman
nobjects = 0;
objects = struct([]);

% Creacin del canvas donde mostraremos el seguimiento
fig_data = figure(1);
%
set(gcf, 'Name', 'Data display', 'NumberTitle', 'off', 'Position', [23 444 620 240]);

% Carga de los fotogramas y sus correspondientes susbtracciones
files = dir(['./data/' '*.' 'png']);
frames_names = sort({files.name});
files = dir(['./foreground/' '*.' 'png']);
foregrounds_names = sort({files.name});
num_frames = size( sort({files.name}),2);

actual_frame = imread (strcat('./data/',frames_names{1}));
[HEIGHT WIDTH C]= size(actual_frame);

for tt = 1:num_frames
 
  actual_frame = imread (strcat('./data/',frames_names{tt}));
  foreground_map = imread (strcat('./foreground/',foregrounds_names{tt})); 
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Deteccin de objetos mediante clculo de componentes conexas
  % Componentes con tamao inferior a COMPONENT_THRESH se consideran ruido 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
  [objects_map, nobservations, object_sizes, pos_observed] = ...
                 foreground_objects(foreground_map, 8, COMPONENT_THRESH);

  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Filtro de Kalman (prediccin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if(nobjects > 0)
    % Cada filtro de kalman ejecuta su etapa de prediccin
    objects = kalman_prediction(objects, kalparam);

    % En cada fotograma se eliminan aquellos objetos cuyos filtros de kalman
    % han terminado. Por terminado entendemos:
    %  Filtros cuyas estimaciones se salen del rea de la imagen
    %  Filtros que no se han actualizado con una medida despues de un
    %  nmero de iteraciones estipulado
    
    ntimes_filter_propagated = cat(2, objects.ntimes_propagated);
    z_t_minus = cat(2, objects.z_t_minus);

    finished_objects = ...
	(~positions_within_window(z_t_minus(1:2, :), [1, WIDTH], [1, HEIGHT])) | ... 
	(ntimes_filter_propagated > kalparam.MAXPROPAGATE);

    % Se eliminan aquellos objetos cuyos filtros se entiende que han
    % terminado
    nobjects = sum(finished_objects == 0);
    objects = objects(find(~finished_objects));
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Asociacin de datos
  % Cada objeto queda emparejado con una medida (silueta), el resultado es 
  % una matriz assignments con tantas filas como objetos se tengan,
  % y tantas columnas como obsevaciones
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  assignments = zeros(nobjects, nobservations);

  if(nobservations > 0)
    [assignments, gate] = data_association(objects, pos_observed, object_sizes, kalparam);
    [assignments, objects, nobjects] = add_new_hypotheses(assignments, objects, ...
	objects_map, pos_observed, reshape(actual_frame, HEIGHT, WIDTH, C), kalparam.NEW_HYP_DUMMY_COST);
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Filtro de kalman (actualizacin)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  objects = update_kalman_filters(objects, kalparam, assignments, ...
				  objects_map, object_sizes, pos_observed);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Visualizacin                                        %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  display_result(fig_data, tt, reshape(actual_frame, HEIGHT, WIDTH, C), ...
  		   objects_map, pos_observed, objects);
    
end


