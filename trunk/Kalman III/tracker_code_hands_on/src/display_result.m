function [] = display_result(fig_data, tt, image, objects_map, positions, objects);

global C HEIGHT WIDTH;
RED_HUE = 128;

objects_hue_map = zeros(HEIGHT, WIDTH, C, 'uint8');
objects_hue_map(:, :, 1) = RED_HUE * (objects_map > 0);
objects_hued_image = uint8(image + objects_hue_map);

set(0, 'CurrentFigure', fig_data);
set(gcf, 'doublebuffer', 'on');

% Dibujado del fotograma actual
subplot(1, 2, 1);
set(gca, 'Units', 'normalized', 'Position', [0 0 0.495 1])
imagesc(image);
hold on; axis ij; axis off;
text(10, 10, sprintf('%04d', tt), 'Color', 'r', 'Fontsize', 15);
hold off;

%Dibujado del fotograma actual con los objetos detectados
subplot(1, 2, 2);
set(gca, 'Units', 'normalized', 'Position', [0.505 0 0.495 1])
imagesc(objects_hued_image);
hold on; axis ij; axis off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
% HANDS-ON: COMPLETAR VISUALIZACIN 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mostrar medida: representarla con +
% Mostrar estimado a posteriori: representarla con o 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nobjects = size(objects, 2);
for obj = 1:nobjects
     x_t(obj) = objects(obj).x_t(1,:);
     y_t(obj) = objects(obj).x_t(2,:);
end
plot(positions(1, :), positions(2,:), 'g+', x_t, y_t, 'ro');
xmax = size(image, 2);
ymax = size(image, 1);
axis([0,xmax,0,ymax])
xlabel('X');
ylabel('Y');
hold on; axis ij; %axis off;
% nobjects = size(objects, 2);
% figure(3)
% 
% for obj = 1:nobjects
% 	plot(obj,objects(obj).z_t,'b+',obj,objects(obj).x_t,'r+');
% 	
% 	%line(0:nobjects, x*ones(1,nobjects+1),'Color',[1,0,0]);%,label='truth value')
% 	legend('noisy measurements','a posteri estimate', 'truth value');
% 	xlabel('X');
% 	ylabel('Y');
% end

hold off;
drawnow;
