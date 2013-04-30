function [ u, v, diffunorm, diffvnorm ] = HornSchunk(lamda, Nit, blockSize)

files = dir(['./JPEGS/' '*.' 'jpg']);
frames_names = sort({files.name});
num_frames = size( sort({files.name}),2);

frame1 = imread (strcat('./JPEGS/',frames_names{1}));
frame2 = imread (strcat('./JPEGS/',frames_names{2}));

frame1 = double(frame1);
frame1 = frame1/255;
frame1 = rgb2gray(frame1);


frame2 = double(frame2);
frame2 = frame2/255;
frame2 = rgb2gray(frame2);

[m, n]=size(frame1);

u = zeros(m,n);
v = zeros(m,n);

    
I1_dt = [zeros(1,n); zeros(m-2,1), gsmooth1(frame1,  [3 3], 0.5), zeros(m-2,1);zeros(1,n)];
I2_dt = [zeros(1,n); zeros(m-2,1), gsmooth1(frame2,  [3 3], 0.5), zeros(m-2,1);zeros(1,n)];


        
It = I2_dt - I1_dt;

hx = 1;
hy = 1;

%Calculate x and y derivate for first image
frame1_xmas=[frame1(:,2:end)-frame1(:,1:end-1), zeros(m,1)]/hx;
frame1_ymas=[frame1(2:end,:)-frame1(1:end-1,:); zeros(1,n)]/hy;
    
%Calculate x and y derivate for second image
frame2_xmas=[frame2(:,2:end)-frame2(:,1:end-1), zeros(m,1)]/hx;
frame2_ymas=[frame2(2:end,:)-frame2(1:end-1,:); zeros(1,n)]/hy;
        
Ix = (frame1_xmas/2)+(frame2_xmas/2);
Iy = (frame1_ymas/2)+(frame2_ymas/2);

x = [];
y = [];
uAvg = [];
vAvg = [];
%uAvg = zeros(m,n)/0;
%vAvg = zeros(m,n)/0;
    
for k=1:Nit
    
    uprev = u;
    vprev = v;

    u = uprev - Ix .* ((Ix .* uprev + Iy .* vprev + It)./(lamda^2 + Ix.^2 + Iy.^2));
    v = vprev - Iy .* ((Ix .* uprev + Iy .* vprev + It)./(lamda^2 + Ix.^2 + Iy.^2));
   
    diffu = double(u-uprev);
    diffv = double(v-vprev);    
    
    diffunorm(k) = norm(diffu);
    diffvnorm(k) = norm(diffv);
    
end;  
    middle = max(floor(blockSize/2), 1) ;
    maxRowBlock = (m/blockSize);
    for i=1:maxRowBlock
        startRow = ((i-1) * blockSize) + 1;
        endRow = min(startRow + blockSize - 1, n);
        
        maxColBlock = (n/blockSize);
        for j=1:maxColBlock
            startCol = ((j-1) * blockSize) + 1;
            endCol = min(startCol + blockSize - 1, n);
            
            subu = u(startRow:endRow, startCol:endCol);
            subv = v(startRow:endRow, startCol:endCol);
            
            [uAvgValue, vAvgValue] = UVAvg(subu, subv);
            
            %uAvg(startRow + middle - 1, startCol + middle - 1) = uAvgValue;
            %vAvg(startRow + middle - 1, startCol + middle - 1) = vAvgValue;
            
            uAvg =[uAvg uAvgValue];
            vAvg =[vAvg vAvgValue];
            x = [x, startRow + middle];
            y = [y, startCol + middle];
        end;
    end;
    
    figure();
    imshow(frame1);
    hold on;
    
    uAvg(isnan(uAvg)) = 0;
    vAvg(isnan(vAvg)) = 0;
    %quiver(uAvg, vAvg, middle, 'color', 'g', 'linewidth', 2);
    quiver(y, x, uAvg, vAvg, middle, 'color', 'g', 'linewidth', 2);

end

function [uAvgValue, vAvgValue] = UVAvg(subu, subv)
    
    [m, n]=size(subu);
    uValue= 0;
    vValue = 0;
    
    for i=1:m
        for j=1:n
            uValue =uValue + subu(i, j);
            vValue =vValue + subv(i, j);
        end;
    end;
    uAvgValue = uValue / (m*n);
    vAvgValue = vValue / (m*n);
end

