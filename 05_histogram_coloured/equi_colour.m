clc;
clear all;
close all;
I = imread('peppers.png');
[R, G, B] = imsplit(I);
figure;
display_image_with_histogram(R, 'Red Channel', 1);
display_image_with_histogram(G, 'Green Channel', 2);
display_image_with_histogram(B, 'Blue Channel', 3);
display_image_with_histogram(I, 'Coloured Image', 4);
equalized_R = histogram_equalization(R);
equalized_G = histogram_equalization(G);
equalized_B = histogram_equalization(B);
equalized_RGB = cat(3, equalized_R, equalized_G, equalized_B);
display_image_with_histogram(equalized_R, 'Equalized R', 5);
display_image_with_histogram(equalized_G, 'Equalized G', 6);
display_image_with_histogram(equalized_B, 'Equalized B', 7);
display_image_with_histogram(equalized_RGB, 'Equalized Coloured', 8);

HSV = rgb2hsv(I);
[h, s, v] = imsplit(HSV);
h_uint8 = uint8(h * 255),s_uint8 = uint8(s * 255),v_uint8 = uint8(v * 255);
equalized_v = histogram_equalization(v_uint8);
HSV_equalized = cat(3, h, s, double(equalized_v) / 255);
equalized_colored_image = hsv2rgb(HSV_equalized);
display_image_with_histogram(h_uint8, 'Hue (H Channel)',9);
display_image_with_histogram(s_uint8, 'Saturation (S Channel)', 10);
display_image_with_histogram(v_uint8, 'Intensity (V Channel)', 11);
display_image_with_histogram(equalized_v, 'Equalized Intensity', 12);
display_image_with_histogram(equalized_colored_image, 'Equalized Image (HSV)',13);
function display_image_with_histogram(image, title_text, position)
    subplot(4, 4, position), imshow(image), title(title_text);
end
figure;
subplot(2,3,1), imhist(I), title('Histogram of RGB-image');
subplot(2,3,4), imhist(equalized_RGB), title('Histogram of equi-RGB image');
subplot(2,3,2), imhist(v_uint8), title('Histogram of intensity-channel');
subplot(2,3,5), imhist(equalized_v), title('Histogram of equi-intensity-channel');
subplot(2,3,3), imhist(I), title('Histogram of RGB-image');
subplot(2,3,6), imhist(equalized_colored_image), title('Histogram of equi-channel(HSV)');

function equi_img = histogram_equalization(input_image)
    cdf = cumsum(imhist(input_image) / numel(input_image));
    sk = uint8(round(cdf * 255));
    equi_img = sk(double(input_image) + 1);
end
img = imread("peppers.png");
noise_types = {'salt & pepper', 'gaussian', 'speckle'};
noises = {imnoise(img, 'salt & pepper', 0.1), imnoise(img, 'gaussian'), imnoise(img, 'speckle')};
figure();
for k = 1:3
    subplot(1, 3, k); imshow(noises{k});
    [mse, psnr] = calculateMSE_PSNR(noises{k}, img);
    title(sprintf('%s \nMSE = %.4f\n PSNR = %.4f', noise_types{k}, mse, psnr));
end
arith_kernal_3x3 = ones(3, 3) / 9;
weight_kernal_3x3 = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 16;
arith_kernal_5x5 = ones(5, 5) / 25;
weight_kernal_5x5 = [1,1,2,1,1;1,2,4,2,1;2,4,8,4,2;1,2,4,2,1;1,1,2,1,1] / 52;
for k = 1:3
    noise_img = noises{k};
    hsv_img = rgb2hsv(noise_img);  % Convert to HSV for HSV-based filtering
    intensity_channel = hsv_img(:,:,3);  % Extract the V (intensity) channel
    [rows, cols, ~] = size(noise_img);
    filter_results_rgb_3x3 = zeros(rows, cols, 3, 5, 'double');
    filter_results_rgb_5x5 = zeros(rows, cols, 3, 5, 'double');
    filter_results_hsv_3x3 = zeros(rows, cols, 5, 'double');
    filter_results_hsv_5x5 = zeros(rows, cols, 5, 'double');
    for ch = 1:3
        channel = double(noise_img(:,:,ch));
        pad_3x3 = padarray(channel, [1, 1], 0, 'both');
        pad_5x5 = padarray(channel, [2, 2], 0, 'both');
        for i = 2 : rows + 1
            for j = 2 : cols + 1
                submatrix_3x3 = pad_3x3(i-1:i+1, j-1:j+1);
                vector_3x3 = sort(submatrix_3x3(:));
                filter_results_rgb_3x3(i-1, j-1, ch, 1) = sum(submatrix_3x3(:) .* arith_kernal_3x3(:));  % Arithmetic
                filter_results_rgb_3x3(i-1, j-1, ch, 2) = sum(submatrix_3x3(:) .* weight_kernal_3x3(:)); % Weighted
                filter_results_rgb_3x3(i-1, j-1, ch, 3) = median(vector_3x3);                            % Median
                filter_results_rgb_3x3(i-1, j-1, ch, 4) = mean(vector_3x3(3:7));                         % 4-trimmed
                filter_results_rgb_3x3(i-1, j-1, ch, 5) = mean(vector_3x3(4:6));                         % 6-trimmed
            end
        end
        for i = 3 : rows + 2
            for j = 3 : cols + 2
                submatrix_5x5 = pad_5x5(i-2:i+2, j-2:j+2);
                vector_5x5 = sort(submatrix_5x5(:));
                filter_results_rgb_5x5(i-2, j-2, ch, 1) = sum(submatrix_5x5(:) .* arith_kernal_5x5(:));  % Arithmetic
                filter_results_rgb_5x5(i-2, j-2, ch, 2) = sum(submatrix_5x5(:) .* weight_kernal_5x5(:)); % Weighted
                filter_results_rgb_5x5(i-2, j-2, ch, 3) = median(vector_5x5);                            % Median
                filter_results_rgb_5x5(i-2, j-2, ch, 4) = mean(vector_5x5(7:19));                        % 12-trimmed
                filter_results_rgb_5x5(i-2, j-2, ch, 5) = mean(vector_5x5(10:16));                       % 18-trimmed
            end
        end
    end
    pad_3x3 = padarray(intensity_channel, [1, 1], 0, 'both');
    pad_5x5 = padarray(intensity_channel, [2, 2], 0, 'both');
    for i = 2 : rows + 1
        for j = 2 : cols + 1
            submatrix_3x3 = pad_3x3(i-1:i+1, j-1:j+1);
            vector_3x3 = sort(submatrix_3x3(:));
            filter_results_hsv_3x3(i-1, j-1, 1) = sum(submatrix_3x3(:) .* arith_kernal_3x3(:));  % Arithmetic
            filter_results_hsv_3x3(i-1, j-1, 2) = sum(submatrix_3x3(:) .* weight_kernal_3x3(:)); % Weighted
            filter_results_hsv_3x3(i-1, j-1, 3) = median(vector_3x3);                            % Median
            filter_results_hsv_3x3(i-1, j-1, 4) = mean(vector_3x3(3:7));                         % 4-trimmed
            filter_results_hsv_3x3(i-1, j-1, 5) = mean(vector_3x3(4:6));                         % 6-trimmed
        end
    end
    for i = 3 : rows + 2
        for j = 3 : cols + 2
            submatrix_5x5 = pad_5x5(i-2:i+2, j-2:j+2);
            vector_5x5 = sort(submatrix_5x5(:));
            filter_results_hsv_5x5(i-2, j-2, 1) = sum(submatrix_5x5(:) .* arith_kernal_5x5(:));  % Arithmetic
            filter_results_hsv_5x5(i-2, j-2, 2) = sum(submatrix_5x5(:) .* weight_kernal_5x5(:)); % Weighted
            filter_results_hsv_5x5(i-2, j-2, 3) = median(vector_5x5);                            % Median
            filter_results_hsv_5x5(i-2, j-2, 4) = mean(vector_5x5(7:19));                        % 12-trimmed
            filter_results_hsv_5x5(i-2, j-2, 5) = mean(vector_5x5(10:16));                       % 18-trimmed
        end
    end
    figure('Name', ['Noise Type: ', noise_types{k}]);
    for f = 1:5
        filtered_img_rgb_3x3 = uint8(cat(3, filter_results_rgb_3x3(:,:,1,f), filter_results_rgb_3x3(:,:,2,f), filter_results_rgb_3x3(:,:,3,f)));
        filtered_img_rgb_5x5 = uint8(cat(3, filter_results_rgb_5x5(:,:,1,f), filter_results_rgb_5x5(:,:,2,f), filter_results_rgb_5x5(:,:,3,f)));
        [mse_3x3, psnr_3x3] = calculateMSE_PSNR(filtered_img_rgb_3x3, img);
        [mse_5x5, psnr_5x5] = calculateMSE_PSNR(filtered_img_rgb_5x5, img);
        hsv_img_3x3 = hsv_img;
        hsv_img_3x3(:,:,3) = filter_results_hsv_3x3(:,:,f);
        filtered_img_hsv_3x3 = hsv2rgb(hsv_img_3x3);
        [mse_hsv_3x3, psnr_hsv_3x3] = calculateMSE_PSNR(filtered_img_hsv_3x3, img);
      
        hsv_img_5x5 = hsv_img;
        hsv_img_5x5(:,:,3) = filter_results_hsv_5x5(:,:,f);
        filtered_img_hsv_5x5 = hsv2rgb(hsv_img_5x5);
        [mse_hsv_5x5, psnr_hsv_5x5] = calculateMSE_PSNR(filtered_img_hsv_5x5, img);
        subplot(4, 5, f); imshow(filtered_img_rgb_3x3);
        title(sprintf('RGB 3x3 Filter %d\nMSE = %.4f\nPSNR = %.4f', f, mse_3x3, psnr_3x3));
        subplot(4, 5, f + 5); imshow(filtered_img_hsv_3x3);
        title(sprintf('HSV 3x3 Filter %d\nMSE = %.4f\nPSNR = %.4f', f, mse_hsv_3x3, psnr_hsv_3x3));
        subplot(4, 5, f + 10); imshow(filtered_img_rgb_5x5);
        title(sprintf('RGB 5x5 Filter %d\nMSE = %.4f\nPSNR = %.4f', f, mse_5x5, psnr_5x5));        
        subplot(4, 5, f + 15); imshow(filtered_img_hsv_5x5);
        title(sprintf('HSV 5x5 Filter %d\nMSE = %.4f\nPSNR = %.4f', f, mse_hsv_5x5, psnr_hsv_5x5));
    end
end
function [mse, psnr] = calculateMSE_PSNR(filtered_img, original_img)
    mse = mean((double(filtered_img(:)) - double(original_img(:))).^2);
    psnr = 10 * log10(255^2 / mse);
end
