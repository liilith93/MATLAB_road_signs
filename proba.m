f = 'D:\matlab_znaki\v2\';
t1 = dir('D:\matlab_znaki\v2\*.png');

I2=imread('D:\matlab_znaki\obrazy\30-2.jpg');
%figure;imshow(I2);title('scena');
%I2 = imcrop(I2)

for i = 1:length(t1)
    
%% wczytaj scene
I1=imread( strcat(f,t1(i).name) );
%figure;imshow(I1);title('obiekt');


%% wykrywanie cech
points1=detectSURFFeatures(rgb2gray(I1));
points2=detectSURFFeatures(rgb2gray(I2));

%% wyodrêbnianie cech
[feats1,validpts1]=extractFeatures(rgb2gray(I1),points1);
[feats2,validpts2]=extractFeatures(rgb2gray(I2),points2);
imshow(I2)
hold on
strongestPoints = validpts2.selectStrongest(1);
plot(strongestPoints)
end