function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 27-Sep-2017 12:28:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[a b]=uigetfile ({'*.jpg', 'All files'});
img=imread ([b a]);
imshow (img, 'Parent', handles.axes1);

%wczytaj obraz
%I1=imread('1a.jpg');
%figure;imshow(I1);title('obiekt');

%figure;imshow(I2);title('scena');

f = 'E:\studia\dyplom\znaki drogowe\v2\';
t1 = dir('E:\studia\dyplom\znaki drogowe\v2\*.png');
%disp(t1(1).date);
for i = 1:length(t1)
    
    %wczytaj obraz
I1=imread( strcat(f,t1(i).name) );
%figure;imshow(I1);title('obiekt');
I=img;
I2 = imresize(I,[500 NaN]);
%figure;imshow(I2);title('scena');

%Object Detection in a Cluttered Scene Using Point Feature Matching
%wykrywanie cech
points1=detectSURFFeatures(rgb2gray(I1));
points2=detectSURFFeatures(rgb2gray(I2));

%wyodrêbnianie cech
[feats1,validpts1]=extractFeatures(rgb2gray(I1),points1);
[feats2,validpts2]=extractFeatures(rgb2gray(I2),points2);

%wyœwietla cechy
%figure;imshow(I1);hold on;plot(validpts1,'showorientation',true);
%title('wykryte obiekty');

%dopasowuje cechy
index_pairs=matchFeatures(feats1,feats2,...
    'Prenormalized',true);
matched_pts1=validpts1(index_pairs(:, 1));
matched_pts2=validpts2(index_pairs(:, 2));
%figure;showMatchedFeatures(I1,I2,matched_pts1,matched_pts2,'montage');
%title('initial matches');

%czyszczenie rozpoznañ
[tform, inlieroints1, inlierPoints2, status]...
    =estimateGeometricTransform(matched_pts1,matched_pts2,'affine');
figure;showMatchedFeatures(I1,I2,inlieroints1,...
    inlierPoints2,'montage');title('filtred');

if status == 0
  disp(strcat(t1(i).name,' pasuje')); 
  %box
boxPolygon = [1, 1;...                     % gora-lewo
        size(I1, 2), 1;...                 % gora-prawo
        size(I1, 2), size(I1, 1);... %dol-prawo
        1, size(I1, 1);...                 % dol-lewo
        1, 1];                   % gora-lewo jeszcze raz aby zamknac prostokat

  %lokalizacja 
newBoxPolygon = transformPointsForward(tform, boxPolygon);
figure; imshow(I2);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'g', 'LineWidth', 5);
title('rozpoznany obiekt' );
     %break;
     %figure; imshow (t1(i));
else
  disp(strcat(t1(i).name,' nie pasuje'));       
end
    
end
 
