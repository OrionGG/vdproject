function [objects_map, num_objects, object_sizes, object_positions] = foreground_objects(foreground_map, num, size_threshold)
% Calcula un mapa con las siluetas de los objetos utilizando un algoritmo
% de componentes conexas.
    % foreground_map: matriz binaria donde se presentan en blanco los
    %                 p�xeles que no pertenecen al fondo.
    % num:            n�mero de vecinos empleados en el c�lculo de las 
    %                 componentes conexas toma valor 4 (4-vecinos) u 8 (8-vecinos)
    % size_threshold: componentes cuyo n�mero de p�xeles sean inferior a
    %                 este valor se desprecian

% En el mapa de siluetas (objects_map), cada objeto se etiqueta con un
% valor entero diferente. Tambi�n se devuelve el n�mero de objetos
% (num_objects), su tama�o medido en n�mero de p�xeles (objects_sizes), y
% la posici�n de los p�xeles correspondientes a cada objeto (object_positions)

global HEIGHT WIDTH;

objects_map = zeros(size(foreground_map), 'int32');
object_sizes = [];
object_positions = [];

new_label = 1;
[label_map, num_labels] = bwlabel(foreground_map, num);

for label = 1:num_labels
  object = (label_map == label);
  object_size = sum(sum(object));
  if(object_size >= size_threshold)
    % Component is big enough, mark it
    objects_map = objects_map + int32(object * new_label);
    object_sizes(new_label) = object_size;

    [X, Y] = meshgrid(1:WIDTH, 1:HEIGHT);    
    object_x = X .* object;
    object_y = Y .* object;
    
    object_positions(:, new_label) = [sum(sum(object_x)) / object_size;
				      sum(sum(object_y)) / object_size];

    new_label = new_label + 1;
  end
end

num_objects = new_label - 1;
