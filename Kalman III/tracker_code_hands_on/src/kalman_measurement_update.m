function [x_t_hat, P_t] = ...
  kalman_measurement_update(z_t, x_t_minus, ...
			    P_t_minus, kalparam)

% Esta funcin implementa las ecuaciones correspondientes a la etapa
% de actualizacin del filtro de kalman

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% HANDS-ON: COMPLETAR ECUACIONES DE CORRECCIN 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   kalparam.K = (P_t_minus * kalparam.H') / (kalparam.H * P_t_minus * kalparam.H' + kalparam.R);
   x_t_hat = x_t_minus + kalparam.K * (z_t - (kalparam.H * x_t_minus));
   P_t = (1-(kalparam.K * kalparam.H)) * P_t_minus;