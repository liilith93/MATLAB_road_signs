clc
clear all
I2=imread('D:\matlab_znaki\obrazy\20-1.jpg');
I3 = im2bw(I2, 0.3);
I4 = rgb2gray(I2);
I5 = imadjust(I4);
I6 = im2bw(I5);
points = detectSURFFeatures(I3);
%[features, validPtsObj] = extractFeatures(I3, points);
imshow(I3); hold on;
%plot(points.selectStrongest(100));
centers = imfindcircles(I3,5);
