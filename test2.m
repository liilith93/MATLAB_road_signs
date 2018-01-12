function test2
%%wczytaj katalog znakow
f = 'D:\matlab_znaki\v2\';
t1 = dir('D:\matlab_znaki\v2\*.png');
%disp(t1(1).date);

for i = 1:length(t1)
    
%% wczytaj scene
I1=imread( strcat(f,t1(i).name) );
%figure;imshow(I1);title('obiekt');
I2=imread('D:\matlab_znaki\obrazy\80-1.jpg');
%figure;imshow(I2);title('scena');

%% wykrywanie cech
points1=detectSURFFeatures(rgb2gray(I1));
points2=detectSURFFeatures(rgb2gray(I2));

%% wyodrêbnianie cech
[feats1,validpts1]=extractFeatures(rgb2gray(I1),points1);
[feats2,validpts2]=extractFeatures(rgb2gray(I2),points2);
%imshow(I2)
%hold on
%validpts2 = validpts2.selectStrongest(10);
%feats2 = feats2.selectStrongest(10);
%strongestPoints.plot('showOrientation',true);

%wyœwietla cechy
%figure;imshow(I1);hold on;plot(validpts1,'showorientation',true);
%title('wykryte obiekty');

%% dopasowuje cechy
index_pairs=matchFeatures(feats1,feats2,...
    'Prenormalized',true);
matched_pts1=validpts1(index_pairs(:, 1));
matched_pts2=validpts2(index_pairs(:, 2));
%figure;showMatchedFeatures(I1,I2,matched_pts1,matched_pts2,'montage');
%title('initial matches');

%% czyszczenie rozpoznañ
[tform, inlieroints1, inlierPoints2, status]...
    =estimateGeometricTransform(matched_pts1,matched_pts2,'affine');
%figure;showMatchedFeatures(I1,I2,inlieroints1,...
 %   inlierPoints2,'montage');title('filtred');

if status == 0
  disp(strcat(t1(i).name,' pasuje')); 
%% box
boxPolygon = [1, 1;...                     % gora-lewo
        size(I1, 2), 1;...                 % gora-prawo
        size(I1, 2), size(I1, 1);...       %dol-prawo
        1, size(I1, 1);...                 % dol-lewo
        1, 1];                             % gora-lewo jeszcze raz aby zamknac prostokat

%% lokalizacja 
newBoxPolygon = transformPointsForward(tform, boxPolygon);
figure; 
imshow(I2);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'g', 'LineWidth', 3);
title('rozpoznany obiekt' );
    
else
  disp(strcat(t1(i).name,' nie pasuje'));       
end
    
end
 