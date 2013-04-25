function drawRectangles( xk, particlesSize, actual_frame, color)
%DRAWRECTANGLE Summary of this function goes here
%   Detailed explanation goes here

    
    [HEIGHT WIDTH C]= size(actual_frame);
  
    hold on
    th = 0:pi/50:2*pi;
    nparticles = size(xk, 2);
    r = 16;
    r2 = r+2;

    imshow(actual_frame);
    
    x_t = xk(1,:);
    y_t = xk(2,:);
    for obj = 1:nparticles
                
        
        x0 = round(x_t(obj) - particlesSize./2);
        y0 = round(y_t(obj) - particlesSize./2);
        xf = round(x_t(obj) + particlesSize./2);
        yf = round(y_t(obj) + particlesSize./2);
        if(x0 < 1) x0 = 1; end;
        if(y0 < 1) y0 = 1; end;
        if(xf > WIDTH) xf = WIDTH; end;
        if(yf > HEIGHT) yf = HEIGHT; end;
    
        x1unit = [x0:xf];
        y1unit = y0 * ones(1, size(x1unit,2));
        y2unit = [y0:yf];
        x2unit = xf * ones(1, size(y2unit,2));
        x3unit = [x0:xf];
        y3unit = yf * ones(1, size(x3unit,2));
        y4unit = [y0:yf];
        x4unit = x0 * ones(1, size(y4unit,2));
        
        %xunit = r2 * cos(th) + x_t(obj);
        %yunit = r2 * sin(th) + y_t(obj);
        
        plot(x1unit, y1unit, color, x2unit, y2unit, color, x3unit, y3unit, color, x4unit, y4unit, color);
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

