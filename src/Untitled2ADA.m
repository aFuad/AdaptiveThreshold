clc;


Q=imread('shapes5.jpg');
mainImage = Q;
Q=rgb2gray(Q);
D= imgaussfilt(Q, 1);

D=imbilatfilt(D);
D=medfilt2(D);

[row, column] = size(D);
newImg = D;
outImg= newImg;

%test4

for i=1 : row
    for j=1 : column
        
        if(i ==1)
            startI=1;
        else
            startI=i-1;
        end
        
        if(j ==1)
            
            startJ=1;
        else
            startJ=j-1;
        end
        
        if(i==row)
            endI = row;
        else
            endI=i+1;
        end
        
        if(j==column)
            
            endJ = column;
        else
            endJ=j+1;
        end
        
        
        
        
        
        
        
        
    max=D(startI, startJ);  
    min=D(startI, startJ);  
    for a=startI : endI
        for b=startJ : endJ
          if(i~=a && j~=b)
              if(D(a, b)>max)
                  max=D(a, b);
              end
              if(D(a, b)<min)
                  min=D(a, b);
              end
              
          end
        end
    end
    
    
    
    contrast = max-min;
    mean = (max+min)/2;
    tc = 20;
    if(contrast>= tc)
       thresh = mean;
    else
        thresh=0;
    end
    
    
    if D(i, j) >thresh
        outImg(i, j) =1;
    else 
        outImg(i, j) =0;
        
    end
    end
end

outImg= outImg <1;
%imshow(outImg);






BW = imfill(outImg, 'holes');


SE = strel("rectangle", [2 1]);
BW2 = imerode(BW, SE);


SE1 = strel("sphere", 1);
BW2 = imerode(BW2, SE1);

imshow(BW2)




P = BW2;


SE4 = strel("sphere",8);
P = imopen(P, SE4);

P = imsubtract(BW2, P);



SE6= strel("Rectangle", [3 3]);
P= imdilate(P, SE6);

%imshow(P);


[B,L] = bwboundaries(BW2); 


stats = regionprops(L, 'all');

W = bwlabel(P);


smls= regionprops(W, 'all');
%imshow(Q);
hold on;

for i=1 : length(stats)
    disp(stats(i));
    cnt=0;
    for j=1 : length(smls)
        if(stats(i).BoundingBox(1)-5<=smls(j).BoundingBox(1) && stats(i).BoundingBox(1)+ stats(i).BoundingBox(3)+5 >=smls(j).BoundingBox(1)+ smls(j).BoundingBox(3) && stats(i).BoundingBox(2)-5<= smls(j).BoundingBox(2) && stats(i).BoundingBox(2) + stats(i).BoundingBox(4)+5 >= smls(j).BoundingBox(2)+ smls(j).BoundingBox(4))
            cnt = cnt+1;
        end
    end
    disp("CNTTTTT              " + cnt);
    if(cnt==3)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Triangle', 'Color', 'r');
        disp("TRIANGLE");
    
    elseif(cnt==4 && stats(i).Eccentricity >0.75)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Rectangle', 'Color', 'r');
    elseif(cnt==4)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Square', 'Color', 'r');
    elseif(cnt==5 && stats(i).Solidity>0.5 && stats(i).Solidity <0.9)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Star*5', 'Color', 'r');
    elseif(cnt==6 && stats(i).Solidity>0.5 && stats(i).Solidity <0.9)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Star*6', 'Color', 'r');
    elseif(cnt==5 && (abs(stats(i).Area-(((stats(i).BoundingBox(3)/2)*stats(i).Perimeter)/2))<50))
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Pentagon', 'Color', 'r');
        disp("PENTAGON   "+ abs(stats(i).Area-(((stats(i).BoundingBox(3)/2)*stats(i).Perimeter)/2)));
    elseif(cnt==6)
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Hexagon', 'Color', 'r');
        disp("HEXAGON");
        disp(sqrt(((stats(i).MajorAxisLength/2)*(stats(i).MajorAxisLength/2) + (stats(i).MinorAxisLength/2)*(stats(i).MinorAxisLength/2))/2)*2*pi);
    else
        text(stats(i).BoundingBox(1),stats(i).BoundingBox(2),'Circle', 'Color', 'r');
        disp("CIRCLE "+  abs(stats(i).Area-(((stats(i).BoundingBox(3)/2)*stats(i).Perimeter)/2)));  
    end
    
    
end




