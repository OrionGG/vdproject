function [kalparam] = kalman_parameters()
% [kalparam] = kalman_parameters()
% Funci�n que crea una estructura kalparam que almacena los par�metros
% necesarios para arrancar el filtro de kalman

% Constantes globales que se utilizaran en distintos ficheros
global KALMAN_STATE_TYPE KALMAN_STATE_SIZE; 

%representaci�n del estado que utiliza el filtro de kalman
KALMAN_STATE_TYPE = 'pos+vel+size';
KALMAN_STATE_SIZE = 5;
kalparam.A = [1 0 1 0 0;
		0 1 0 1 0;
		0 0 1 0 0;
		0 0 0 1 0;
		0 0 0 0 1];

kalparam.H = eye(KALMAN_STATE_SIZE); 
kalparam.Q = eye(KALMAN_STATE_SIZE); 
kalparam.R = eye(KALMAN_STATE_SIZE);

% El filtro podr� propagarse un m�ximos de 100 iteraciones
kalparam.MAXPROPAGATE = 100;

% Algoritmo y par�metros utilizados para la asociaci�n de datos 
kalparam.ASSOC_ALG_TYPE = 'LAP';
kalparam.ASSOC_COST_TYPE = 'kalman_expectation';
kalparam.ASSOC_DUMMY_COST = 2010;
kalparam.NEW_HYP_DUMMY_COST = 2;