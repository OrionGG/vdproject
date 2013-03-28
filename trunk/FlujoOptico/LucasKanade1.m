function [ u, v ] = LucasKanade1( frame1, frame2, blockSize,windowSize)
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

% Calculate derivates
%Ix = conv2(frame1, 0.25 * [-1 1; -1 1]) + conv2(frame2, 0.25 * [-1 1; -1 1]);
%Iy = conv2(frame1, 0.25 * [-1 -1; 1 1]) + conv2(frame2, 0.25 * [-1 -1; 1 1]);
%It = conv2(frame1, 0.25 * ones(2)) + conv2(frame2, -0.25 * ones(2));

x = [];
y = [];
u = [];
v = [];


    figure();
    imshow(frame1);
    hold on;

    windowCenter = floor (windowSize/2);
    
    middle = floor(blockSize/2) ;
    maxRowBlock = (m/blockSize);
    for ii=1:maxRowBlock
        startRow = ((ii-1) * blockSize) + 1;
        endRow = min(startRow + blockSize - 1, n);
        
        maxColBlock = (n/blockSize);
        for jj=1:maxColBlock
            startCol = ((jj-1) * blockSize) + 1;
            endCol = min(startCol + blockSize - 1, n);
            x = [];
            y = [];
            u = [];
            v = [];
            for i = windowCenter + startRow:endRow - windowCenter
                for j = windowCenter + startCol:endCol - windowCenter

                    subIx = Ix(i - windowCenter:i + windowCenter, j - windowCenter:j + windowCenter);
                    subIy = Iy(i - windowCenter:i + windowCenter, j - windowCenter:j + windowCenter);
                    subIt = It(i - windowCenter:i + windowCenter, j - windowCenter:j + windowCenter);

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


                    spacialGrad = pinv([sumsubIx2, sumsubIxsubIy; sumsubIxsubIy, sumsubIy2]);
                    temporalContr = [-sumsubIxsubIt;-sumsubIysubIt];

                    uv = spacialGrad * temporalContr;


                    u = [u uv(1)];
                    v = [v uv(2)];
                    x = [x, i];
                    y = [y, j];
                end;
            end;
            u(isnan(u)) = 0;
            v(isnan(v)) = 0;
            quiver(y, x, u, v, 5, 'color', 'g', 'linewidth', 2);
            set(gca,'YDir','reverse');
        end;
    end;
    


    
    %u(isnan(u)) = 0;
    %v(isnan(v)) = 0;
    %quiver(y, x, u, v, 5, 'color', 'g', 'linewidth', 2);
    %set(gca,'YDir','reverse');
   

end

