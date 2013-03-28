function [ u, v ] = LucasKanade2( frame1, frame2, blockSize)
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
            
            subIx2 = subIx^2;
            subIy2 = subIy^2;
            subIxsubIy = subIx * subIy;
            subIxsubIt = subIx * subIt;
            subIysubIt = subIy * subIt;
            sumsubIx2 = sum(subIx2(:));
            sumsubIy2 = sum(subIy2(:));
            sumsubIxsubIy = sum(subIxsubIy(:));
            sumsubIxsubIt = sum(subIxsubIt(:));
            sumsubIysubIt = sum(subIysubIt(:));
            
            
            unum =(-(sumsubIy2*sumsubIxsubIt))+(sumsubIxsubIy*sumsubIysubIt);
            uden = (sumsubIx2*sumsubIy2)-(sumsubIxsubIy*sumsubIxsubIy);
            vnum =(sumsubIxsubIy*sumsubIxsubIt)-(sumsubIx2*sumsubIysubIt);
            vden = (sumsubIx2*sumsubIy2)-(sumsubIxsubIy*sumsubIxsubIy);
            
            uvalue = unum/uden;
            vvalue = vnum/vden;

            u = [u uvalue];
            v = [v vvalue];
            x = [x, startRow + middle];
            y = [y, startCol + middle];
        end;
        
    end;


    figure();
    imshow(frame1);
    hold on;
    u(isnan(u)) = 0;
    v(isnan(v)) = 0;
    u(isinf(u)) = 100;
    v(isinf(v)) = 100;
    quiver(y, x, u, v, 5, 'color', 'g', 'linewidth', 2);
    set(gca,'YDir','reverse');


end

