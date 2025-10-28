clc;
clear all;
close all;

img = imread('peppers.png');
img = im2double(img);
[rows, cols, ~] = size(img);
img_uint8 = im2uint8(img);

noise_types = {'Salt & Pepper', 'Gaussian', 'Speckle'};
noises = {
    imnoise(img, 'salt & pepper', 0.1), ...
    imnoise(img, 'gaussian', 0, 0.01), ...
    imnoise(img, 'speckle', 0.04)
};

figure('Name', 'Original and Noisy Images', 'NumberTitle', 'off');
subplot(1,4,1);
imshow(img);
title('Original Image');
for k = 1:3
    subplot(1,4,k+1);
    imshow(noises{k});
    title([noise_types{k}, ' Noise']);
end

D_values = [70, 90, 150];
tic;
disp('Starting denoising process...');

for nidx = 1:numel(noise_types)
    noiseType = noise_types{nidx};
    noisy_rgb = noises{nidx};

    for k = 1:numel(D_values)
        D = D_values(k);
        fprintf('\nProcessing %s noise with D = %d...\n', noiseType, D);

        figure('Name', sprintf('Denoising - %s Noise (D=%d)', noiseType, D), ...
               'NumberTitle', 'off', 'Position', [100 50 1400 900]);

        padded_rows = 2*rows;
        padded_cols = 2*cols;
        [U, V] = meshgrid(1:padded_cols, 1:padded_rows);
        center_u = padded_cols/2; 
        center_v = padded_rows/2;
        Duv = sqrt((U - center_u).^2 + (V - center_v).^2);

        ILP = double(Duv <= D);
        GLP = exp(-(Duv.^2) / (2 * (D^2)));
        BLP_n1 = 1 ./ (1 + (Duv ./ D).^(2));
        BLP_n2 = 1 ./ (1 + (Duv ./ D).^(4));

        filters = {ILP, GLP, BLP_n1, BLP_n2};
        filterNames = {'Ideal', 'Gaussian', 'Butterworth n=1', 'Butterworth n=2'};

        noisy_hsv = rgb2hsv(noisy_rgb);
        subplot_idx = 1;

        for f = 1:numel(filters)
            current_filter = filters{f};
            filter_label = filterNames{f};

            filter_tic = tic;
            out_rgb = zeros(rows, cols, 3);
            for ch = 1:3
                ch_data = im2double(noisy_rgb(:,:,ch));
                ch_shift = ch_data .* ((-1).^(meshgrid(1:cols,1:rows)+meshgrid(1:rows,1:cols).'));
                padd = padarray(ch_shift, [rows, cols], 0, 'post');
                DFT = fft2(padd);
                Guv = DFT .* current_filter;
                idft = real(ifft2(Guv));
                idft = idft .* ((-1).^(meshgrid(1:2*cols,1:2*rows)+meshgrid(1:2*rows,1:2*cols).'));
                out_rgb(:,:,ch) = mat2gray(idft(1:rows,1:cols));
            end
            out_uint8 = im2uint8(out_rgb);
            mse_val = mean((double(out_uint8(:)) - double(img_uint8(:))).^2);
            psnr_val = 10*log10((255^2)/mse_val);
            elapsed = toc(filter_tic);
            subplot(3,4,subplot_idx);
            imshow(out_rgb);
            title(sprintf('RGB | %s\nD=%d | MSE=%.2f | PSNR=%.2f\nTime=%.2fs', ...
                filter_label, D, mse_val, psnr_val, elapsed), 'FontSize',8);
            subplot_idx = subplot_idx + 1;

            filter_tic = tic;
            hsv_temp = noisy_hsv;
            v = hsv_temp(:,:,3);
            v_shift = v .* ((-1).^(meshgrid(1:cols,1:rows)+meshgrid(1:rows,1:cols).'));
            padd = padarray(v_shift, [rows, cols], 0, 'post');
            DFT = fft2(padd);
            Guv = DFT .* current_filter;
            idft = real(ifft2(Guv));
            idft = idft .* ((-1).^(meshgrid(1:2*cols,1:2*rows)+meshgrid(1:2*rows,1:2*cols).'));
            hsv_temp(:,:,3) = mat2gray(idft(1:rows,1:cols));
            hsv_to_rgb = hsv2rgb(hsv_temp);
            out_uint8 = im2uint8(hsv_to_rgb);
            mse_val = mean((double(out_uint8(:)) - double(img_uint8(:))).^2);
            psnr_val = 10*log10((255^2)/mse_val);
            elapsed = toc(filter_tic);
            subplot(3,4,subplot_idx);
            imshow(hsv_to_rgb);
            title(sprintf('HSV (V) | %s\nD=%d | MSE=%.2f | PSNR=%.2f\nTime=%.2fs', ...
                filter_label, D, mse_val, psnr_val, elapsed), 'FontSize',8);
            subplot_idx = subplot_idx + 1;

            filter_tic = tic;
            hsv_all_out = zeros(rows, cols, 3);
            for ch = 1:3
                ch_data = im2double(noisy_hsv(:,:,ch));
                ch_shift = ch_data .* ((-1).^(meshgrid(1:cols,1:rows)+meshgrid(1:rows,1:cols).'));
                padd = padarray(ch_shift, [rows, cols], 0, 'post');
                DFT = fft2(padd);
                Guv = DFT .* current_filter;
                idft = real(ifft2(Guv));
                idft = idft .* ((-1).^(meshgrid(1:2*cols,1:2*rows)+meshgrid(1:2*rows,1:2*cols).'));
                hsv_all_out(:,:,ch) = mat2gray(idft(1:rows,1:cols));
            end
            rgb_from_hsv_all = hsv2rgb(hsv_all_out);
            out_uint8 = im2uint8(rgb_from_hsv_all);
            mse_val = mean((double(out_uint8(:)) - double(img_uint8(:))).^2);
            psnr_val = 10*log10((255^2)/mse_val);
            elapsed = toc(filter_tic);
            subplot(3,4,subplot_idx);
            imshow(rgb_from_hsv_all);
            title(sprintf('HSV (All) | %s\nD=%d | MSE=%.2f | PSNR=%.2f\nTime=%.2fs', ...
                filter_label, D, mse_val, psnr_val, elapsed), 'FontSize',8);
            subplot_idx = subplot_idx + 1;
        end

        sgtitle(sprintf('Noise: %s | D=%d | Filters: Ideal, Gaussian, Butterworth(1,2)', ...
            noiseType, D), 'FontSize', 12);
        saveas(gcf, sprintf('Denoising_%s_D%d.png', strrep(noiseType, ' ', '_'), D));
    end
end

disp('All processing completed successfully!');
toc;
