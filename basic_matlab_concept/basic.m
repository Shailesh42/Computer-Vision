clc;
clear all;
close all;
figure();
% Read and display the original image
subplot(2,3,1);
x = imread("peacock.jpg");
imshow(x);
title('Original Image (imread)');

% Resize and display the image
subplot(2,3,2);
y = imresize(x, 0.5);
imshow(y);
title('Resized Image (imresize)');

% Crop and display a portion of the image
subplot(2,3,3);
c = imcrop(x, [20, 20, 30, 30]);
imshow(c);
title('Cropped Image (imcrop)');

% Convert to grayscale and display the image
subplot(2,3,4);
l = rgb2gray(x);
imshow(l);
title('Grayscale Image (rgb2gray)');

% Convert to binary and display the image
subplot(2,3,5);
m = im2bw(l); % Apply binary conversion on the grayscale image
imshow(m);
title('Binary Image (im2bw)');

% Display the image using the imtool function
subplot(2,3,6);
imshow(x); % You can't directly use imtool in a subplot
title('Displayed Image (imshow)');
imtool(x);

figure();
% Read and display the original image
subplot(2,3,1);
x = imread("coins.png");
imshow(x);
title('Original Image (imread)');

% Resize and display the image
subplot(2,3,2);
y = imresize(x, 0.5);
imshow(y);
title('Resized Image (imresize)');

% Crop and display a portion of the image
subplot(2,3,3);
c = imcrop(x, [20, 20, 30, 30]);
imshow(c);
title('Cropped Image (imcrop)');

% Convert to grayscale and display the image
subplot(2,3,4);
l = im2gray(x);
imshow(l);
title('Grayscale Image (rgb2gray)');

% Convert to binary and display the image
subplot(2,3,5);
m = im2bw(l); % Apply binary conversion on the grayscale image
imshow(m);
title('Binary Image (im2bw)');

% Display the image using the imtool function
subplot(2,3,6);
imshow(x); % You can't directly use imtool in a subplot
title('Displayed Image (imshow)');
imtool(x);


figure();

% Read and display the original image
subplot(2,3,1);
x = imread("peppers.png");
imshow(x);
title('Original Image (imread)');

% Resize and display the image
subplot(2,3,2);
y = imresize(x, 0.5);
imshow(y);
title('Resized Image (imresize)');

% Crop and display a portion of the image
subplot(2,3,3);
c = imcrop(x, [20, 20, 30, 30]);
imshow(c);
title('Cropped Image (imcrop)');

% Convert to grayscale and display the image
subplot(2,3,4);
l = rgb2gray(x);
imshow(l);
title('Grayscale Image (rgb2gray)');

% Convert to binary and display the image
subplot(2,3,5);
m = im2bw(l); % Apply binary conversion on the grayscale image
imshow(m);
title('Binary Image (im2bw)');

% Display the image using the imtool function
subplot(2,3,6);
imshow(x); % You can't directly use imtool in a subplot
title('Displayed Image (imshow)');
imtool(x);
    

a =[1 2 3 4 5];
n = length(a);
b = zeros(n,n);
disp(a);
for i = 1:n
    for j = i:n
        b(i, j) = a(j - i + 1);
    end
end
disp(a);
disp(b);
