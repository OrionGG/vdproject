function [objects] = kalman_prediction(objects, kalparam)

% Ecuaciones de prediccion
% Dado un array de objetos, se actualiza el estimador y la covarianza a priori
% de cada objeto. kalparam es una estructura con los parmetros del filtro
% (ver kalman_parameters.m)

nobjects = size(objects, 2);

for obj = 1:nobjects
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  % HANDS-ON: COMPLETAR ECUACIONES DE PREDICCIN  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  %
  %
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  objects(obj).x_t_minus = kalparam.A * objects(obj).x_t;
  objects(obj).P_t_minus = kalparam.A * objects(obj).P_t * kalparam.A + kalparam.Q;
  
  
  % Estimado a priori de la medida y su covarianza (necesario para la asociacin de datos)
  objects(obj).z_t_minus = kalparam.H * objects(obj).x_t_minus;
  objects(obj).P_zt_minus = kalparam.H * objects(obj).P_t_minus * kalparam.H' + kalparam.R;

  % Filtro de kalman ya inicializado
  objects(obj).new_kalman = 0;
  
end
