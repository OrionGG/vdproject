function [ u, v ] = LucasKanade1(blockSize)
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
u = [];
v = [];

    middle = floor(blockSize/2) ;
    maxRowBlock = (m/blockSize);
    for i=1:maxRowBlock
        startRow = ((i-1) * blockSize) + 1;
        endRow = min(startRow + blockSize - 1, n);
        
        maxColBlock = (n/blockSize);
        for j=1:maxColBlock
            startCol = ((j-1) * blockSize) + 1;
            endCol = min(startCol + blockSize - 1, n);
            
            subIx = Ix(startRow:endRow, startCol:endCol);
            subIy = Iy(startRow:endRow, startCol:endCol);
            subIt = It(startRow:endRow, startCol:endCol);
            
            subIx2 = subIx .* subIx;
            subIy2 = subIy .* subIy;
            subIxsubIy = subIx .* subIy;
            subIxsubIt = subIx .* subIt;
            subIysubIt = subIy .* subIt;
            
            
            spacialGrad = pinv([sum(subIx2(:)), sum(subIxsubIy(:)); sum(subIxsubIy(:)), sum(subIy2(:))]);
            temporalContr = [-sum(subIxsubIt(:));-sum(subIysubIt(:))];

            uv = spacialGrad * temporalContr;
            
            
            u = [u uv(1)];
            v = [v uv(2)];
            y = [y, startRow + middle];
            x = [x, startCol + middle];
            
        end;
        
    end;


    figure();
    imshow(frame1);
    hold on;
    
    u(isnan(u)) = 0;
    v(isnan(v)) = 0;
    quiver(x, y, u, v, middle, 'color', 'g', 'linewidth', 2);

end

