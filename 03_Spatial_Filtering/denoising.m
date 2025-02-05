clc;
clear all;
close all;

r = imread("moon.tif");
[rows, cols] = size(r);
sp_noise       = imnoise(r, 'salt & pepper', 0.1);
gussian_noise  = imnoise(r, 'gaussian');
speckle_noise  = imnoise(r, 'speckle');

figure('Name',"noise Image");
subplot(1,3,1);   imshow(sp_noise); 
mse = sum((double(r(:))-double(sp_noise(:))).^2)/(rows*cols);
psnr = 10*log(255*255/mse);
title(sprintf('s&p noise\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
subplot(1,3,2);   imshow(gussian_noise); 
mse = sum((double(r(:))-double(gussian_noise(:))).^2)/(rows*cols);
psnr = 10*log(255*255/mse);
title(sprintf('Gussian noise\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
subplot(1,3,3);   imshow(speckle_noise); 
mse = sum((double(r(:))-double(speckle_noise(:))).^2)/(rows*cols);
psnr = 10*log(255*255/mse);
title(sprintf('Speckle noise Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));

filtered_min = zeros(rows, cols, 'uint8');
filtered_med = zeros(rows, cols, 'uint8');
filtered_max = zeros(rows, cols, 'uint8');
filtered_trim_4 = zeros(rows, cols, 'uint8');
filtered_trim_6 = zeros(rows, cols, 'uint8');
filtered_mid_point = zeros(rows, cols, 'uint8'); % for arithmetic filter

sp_pad       = padarray(sp_noise, [1, 1], 0, 'both');
gussian_pad  = padarray(gussian_noise, [1, 1], 0, 'both');
speckle_pad  = padarray(speckle_noise, [1, 1], 0, 'both');
noise_array = {sp_pad, gussian_pad, speckle_pad};

for k = 1:3
    current_noise_img = noise_array{k}; % Get the padded noisy image for current type
    for i = 2:rows+1
       for j = 2:cols+1
          submatrix = current_noise_img(i-1:i+1, j-1:j+1);
          filtered_min(i-1,j-1) = min(submatrix(:));    %minimum filter
          filtered_med(i-1,j-1) = median(submatrix(:)); %median filter
          filtered_max(i-1,j-1) = max(submatrix(:));    %maximum filter
          filtered_mid_point(i-1,j-1) = round((double(filtered_min(i-1,j-1) +filtered_max(i-1,j-1)))/2); %mid point filter
          vector_A = submatrix(:);
          sort_a = sort(vector_A);
          filtered_trim_4(i-1,j-1) = round((sum(sort_a(3:7))/5));
          filtered_trim_6(i-1,j-1) = round((sum(sort_a(4:6))/3));
       end
    end
    figure('Name',"for 3*3 kernal");
    subplot(2,3,1); imshow(filtered_min);
    mse = sum((double(r(:))-double(filtered_min(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('minimum Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3,2); imshow(filtered_med); 
    mse = sum((double(r(:))-double(filtered_med(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('median Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3,3); imshow(filtered_max);
    mse = sum((double(r(:))-double(filtered_max(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('maximum Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2,3,4); imshow(filtered_mid_point);
    mse = sum((double(r(:))-double(filtered_mid_point(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('mid-pont Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3, 5); imshow(filtered_trim_4); 
    mse = sum((double(r(:))-double(filtered_trim_4(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('4-trim Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3, 6); imshow(filtered_trim_6);
    mse = sum((double(r(:))-double(filtered_trim_6(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('6-trim Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));

end

filtered_min = zeros(rows, cols, 'uint8');
filtered_med = zeros(rows, cols, 'uint8');
filtered_max = zeros(rows, cols, 'uint8');
filtered_trim_4 = zeros(rows, cols, 'uint8');
filtered_trim_6 = zeros(rows, cols, 'uint8');
filtered_mid_point = zeros(rows, cols, 'uint8');

sp_pad       = padarray(sp_noise, [2, 2], 0, 'both');
gussian_pad  = padarray(gussian_noise, [2, 2], 0, 'both');
speckle_pad  = padarray(speckle_noise, [2, 2], 0, 'both');
noise_array = {sp_pad, gussian_pad, speckle_pad};

for k = 1:3
    current_noise_img = noise_array{k}; % Get the padded noisy image for current type
    for i = 3:rows+2
       for j = 3:cols+2
          submatrix = current_noise_img(i-2:i+2, j-2:j+2);
          filtered_min(i-2,j-2) = min(submatrix(:));    %minimum filter
          filtered_med(i-2,j-2) = median(submatrix(:)); %median filter
          filtered_max(i-2,j-2) = max(submatrix(:));    %maximum filter
          filtered_mid_point(i-2,j-2) = round((double(filtered_min(i-2,j-2) +filtered_max(i-2,j-2)))/2); %mid point filter
          vector_A = submatrix(:);  sort_a = sort(vector_A);
          filtered_trim_4(i-2,j-2) = round((sum(sort_a(7:19))/13)); % 12_trimmed filter
          filtered_trim_6(i-2,j-2) = round((sum(sort_a(10:16))/7)); % 18_trimmed filter
       end
    end
    figure('Name',"for 5*5 kernal");
    subplot(2,3,1); imshow(filtered_min);
    mse = sum((double(r(:))-double(filtered_min(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('minimum Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3,2); imshow(filtered_med); 
    mse = sum((double(r(:))-double(filtered_med(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('median Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3,3); imshow(filtered_max);
    mse = sum((double(r(:))-double(filtered_max(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('maximum Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2,3,4); imshow(filtered_mid_point);
    mse = sum((double(r(:))-double(filtered_mid_point(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('mid-pont Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3, 5); imshow(filtered_trim_4); 
    mse = sum((double(r(:))-double(filtered_trim_4(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('12-trim Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
    subplot(2, 3, 6); imshow(filtered_trim_6);
    mse = sum((double(r(:))-double(filtered_trim_6(:))).^2)/(rows*cols);
    psnr = 10*log(255*255/mse);
    title(sprintf('18-trim Filter\nMSE = %.4f\n PSNR=%0.4f', mse,psnr));
end
