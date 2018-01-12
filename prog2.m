function prog2
%%wczytaj katalog znakow
f = 'D:\matlab_znaki\v2\';
t1 = dir('D:\matlab_znaki\v2\*.png');
%disp(t1(1).date);

for i = 1:length(t1)
    
%% wczytaj scene
I1=imread( strcat(f,t1(i).name) );
%figure;imshow(I1);title('obiekt');
I=imread('D:\matlab_znaki\obrazy\U-1.jpg');
I2 = imresize(I,[400 NaN]);
%figure;imshow(I2);title('scena');

%% wykrywanie cech
boxPoints = detectSURFFeatures(rgb2gray(I1));
scenePoints = detectSURFFeatures(rgb2gray(I2));

%% wyodrêbnianie cech
[boxFeatures, boxPoints] = extractFeatures(rgb2gray(I1), boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(rgb2gray(I2), scenePoints);

%% dopasowuje cechy
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
%figure;
%showMatchedFeatures(I1, I2, matchedBoxPoints, ...
%    matchedScenePoints, 'montage');
%title('Putatively Matched Points (Including Outliers)');

%% czyszczenie rozpoznañ
[tform, inlierBoxPoints, inlierScenePoints, status] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'projective');

figure;
showMatchedFeatures(I1, I2, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Rozpoznane punkty');

if status == 0
  disp(strcat(t1(i).name,' pasuje')); 
  
  boxPolygon = [1, 1;...                           % top-left
        size(I1, 2), 1;...                 % top-right
        size(I1, 2), size(I1, 1);... % bottom-right
        1, size(I1, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
    newBoxPolygon = transformPointsForward(tform, boxPolygon);
    
    figure;
imshow(I2);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'g', 'LineWidth', 3);
title('Detected Box');
else
  disp(strcat(t1(i).name,' nie pasuje'));       
end
    
end
    