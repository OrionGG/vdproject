function z = create_kalman_observation(positions, object_sizes, varargin)
% Genera una nueva medida utilizando la información de la silueta como su
% posición (positions) o tamaño (object_sizes).

% Si se encuentra disponible la medida empleada en el instante anterior,
% ésta puede utilizarse para calcular variables en la medida como la
% velocidad

global KALMAN_STATE_TYPE KALMAN_STATE_SIZE;

% Se comprueba si se dispone de la medida en el instante anterior
if(length(varargin) > 0)
  HAVE_PREVIOUS_STATES = 1;
  previous_states = varargin{1};
else
  HAVE_PREVIOUS_STATES = 0;
end

nobservations = size(positions, 2);

% z almacena la medida para el instante actual, algunas varibles tomaran
% valor cero por defecto
z = zeros(KALMAN_STATE_SIZE, nobservations);

% Las dos primeras entradas de la medida se corresponden con la posición
z(1:2, :) = positions;

% Si se dispone de informaciónd de la medida en el instante anterior es
% posible medir la velocidad
if(HAVE_PREVIOUS_STATES == 1)
    z(3:4, :) = positions - repmat(previous_states(1:2), 1, size(positions, 2)); 
end

z(5, :) = object_sizes;


