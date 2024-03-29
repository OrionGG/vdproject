function [x_t_minus, P_t_plus_1_given_t] = ...
  kalman_time_update(x_t, P_t)
% [x_t_minus, P_t_plus_1_given_t] = ...
%  kalman_time_update(x_t, P_t)
% Do the time update for a Kalman filter. Takes the mean x and
% covariance P and returns updated versions of them. 

  global A G B Q R;

  % Time update
  % Estimate a new x and P
  x_t_minus = A * x_t;
  P_t_plus_1_given_t = A * P_t * A' + G * Q * G';
