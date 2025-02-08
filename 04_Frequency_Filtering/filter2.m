clc;
clear all;
close all; 
I = imread("coins.png");
r = im2double(I); 
noise = imnoise(r, "gaussian", 0.1);
figure();
subplot(1,2,1);
imshow(I);
title("original Image");
subplot(1,2,2);
imshow(noise);
title("noised image");
[rows, cols] = size(noise);
noise_i = noise .* ((-1) .^ (meshgrid(1:cols, 1:rows) + meshgrid(1:rows, 1:cols).'));
padd_i = padarray(noise_i, [rows, cols], 0, 'post');
dft_mtx = fft2(padd_i);
D_values = [70, 90, 150];

function process_filter(filter, dft_mtx, I, rows, cols, D, n, subplot_idx)
    Guv = dft_mtx .* filter;
    idft_mtx = real(ifft2(Guv));
    idft_mtx = idft_mtx .* ((-1) .^ (meshgrid(1:2*cols, 1:2*rows) + meshgrid(1:2*rows, 1:2*cols).'));
    filter_img = idft_mtx(1:rows, 1:cols);
    mse = sum((double(filter_img(:)) - double(I(:))).^2) / (rows * cols);
    psnr = 10 * log10(255 * 255 / mse);
    subplot(3, 4, subplot_idx);
    imshow(filter_img);
    if n == 0
        title(sprintf(' D = %d \nMSE = %.4f\n PSNR = %.4f', D, mse, psnr));
    else
        title(sprintf('n = %d, D = %d \nMSE = %.4f\n PSNR = %.4f',n, D, mse, psnr));
    end
end
figure();
for k = 1:3
    D = D_values(k);
    ILP = zeros(2 * rows, 2 * cols);
    GLP = zeros(2 * rows, 2 * cols); 
    BLP1 = zeros(2 * rows, 2 * cols);
    BLP3 = zeros(2 * rows, 2 * cols);
    for i = 1:2 * rows
        for j = 1:2 * cols
            Duv = sqrt((i - rows)^2 + (j - cols)^2);
            ILP(i, j) = Duv <= 70;
            GLP(i, j) = exp((-1) * (Duv^2) / (2 * (D^2)));
            BLP1(i, j) = 1 / (1 + (Duv / D)^(2));
            BLP3(i, j) = 1 / (1 + (Duv / D)^(6));
        end
    end
    process_filter(ILP, dft_mtx, I, rows, cols, D, 0, 4 * (k - 1) + 1);
    process_filter(GLP, dft_mtx, I, rows, cols, D, 0, 4 * (k - 1) + 2);
    process_filter(BLP1, dft_mtx, I, rows, cols, D, 1, 4 * (k - 1) + 3);
    process_filter(BLP3, dft_mtx, I, rows, cols, D, 3, 4 * (k - 1) + 4);
end


I = imread("moon.tif");
r = im2double(I); 
[rows, cols] = size(I);

r = r .* ((-1) .^ (meshgrid(1:cols, 1:rows) + meshgrid(1:rows, 1:cols).'));  % Preprocessing the image
padd_i = padarray(r, [rows, cols], 0, 'post');
dft_mtx = fft2(padd_i);

function process_filter1(filter, dft_mtx, I, rows, cols, D, n, subplot_idx)
    Guv = dft_mtx .* filter;
    idft_mtx = real(ifft2(Guv));
    idft_mtx = idft_mtx .* ((-1) .^ (meshgrid(1:2*cols, 1:2*rows) + meshgrid(1:2*rows, 1:2*cols).'));
    filter_img = idft_mtx(1:rows, 1:cols);
    mse = sum((double(filter_img(:)) - double(I(:))).^2) / (rows * cols);
    psnr = 10 * log10(255 * 255 / mse);
    subplot(3, 4, subplot_idx);
    imshow(filter_img, []);
    if n == 0
        title(sprintf(' D = %d \nMSE = %.4f\n PSNR = %.4f', D, mse, psnr));
    else
        title(sprintf('n = %d, D = %d \nMSE = %.4f\n PSNR = %.4f',n, D, mse, psnr));
    end
end

function process_high_pass(filter, blurr_img, I, rows, cols, c)
    blurr_img = blurr_img .* ((-1) .^ (meshgrid(1:cols, 1:rows) + meshgrid(1:rows, 1:cols).'));
    padd_i = padarray(blurr_img, [rows, cols], 0, 'post');
    dft_mtx = fft2(padd_i);
    D_values = [70, 90, 150];
    for k = 1:3
        D = D_values(k);
        if c == 1
            process_filter1(filter, dft_mtx, I, rows, cols, D, 0, 4 * (k - 1) + 1);
        elseif c == 2
            process_filter1(filter, dft_mtx, I, rows, cols, D, 0, 4 * (k - 1) + 2);
        elseif c == 3
            process_filter1(filter, dft_mtx, I, rows, cols, D, 1, 4 * (k - 1) + 3);
        else 
            process_filter1(filter, dft_mtx, I, rows, cols, D, 3, 4 * (k - 1) + 4);
        end
    end
end

D = 70; % Low pass cutoff frequency
ILP = zeros(2 * rows, 2 * cols);
GLP = zeros(2 * rows, 2 * cols); 
BHP1 = zeros(2 * rows, 2 * cols);
BHP3 = zeros(2 * rows, 2 * cols);
IHP = ones(2*rows,2*cols);
GHP = ones(2*rows,2*cols);
BLP = zeros(2*rows,2*cols);
for i = 1:2 * rows
    for j = 1:2 * cols
        Duv = sqrt((i - rows)^2 + (j - cols)^2);
        ILP(i, j) = Duv <= D; % Ideal low pass
        GLP(i, j) = exp((-1) * (Duv^2) / (2 * (D^2))); % Gaussian low pass
        BLP(i, j) = 1 / (1 + (Duv / D)^(2));
        BHP1(i, j) = 1 / (1 + (D / Duv)^(2)); % Butterworth low pass (n=1)
        BHP3(i, j) = 1 / (1 + ( D/ Duv)^(6)); % Butterworth low pass (n=3)
    end
end
Guv = dft_mtx .* ILP;
idft_mtx = real(ifft2(Guv));
idft_mtx = idft_mtx .* ((-1) .^ (meshgrid(1:2*cols, 1:2*rows) + meshgrid(1:2*rows, 1:2*cols).'));
ideal_low = idft_mtx(1:rows, 1:cols);

Guv = dft_mtx .* GLP;
idft_mtx = real(ifft2(Guv));
idft_mtx = idft_mtx .* ((-1) .^ (meshgrid(1:2*cols, 1:2*rows) + meshgrid(1:2*rows, 1:2*cols).'));
Gaussian_low = idft_mtx(1:rows, 1:cols);

Guv = dft_mtx .* BLP;
idft_mtx = real(ifft2(Guv));
idft_mtx = idft_mtx .* ((-1) .^ (meshgrid(1:2*cols, 1:2*rows) + meshgrid(1:2*rows, 1:2*cols).'));
butter_low = idft_mtx(1:rows, 1:cols);
figure();
subplot(1,3,1);
imshow(ideal_low);
title("ILPF Image");
subplot(1,3,2);
imshow(Gaussian_low);
title("GLPF Image");
subplot(1,3,3);
imshow(butter_low);
title("BLPF Image");
GHP = GHP-GLP ;
IHP = IHP-ILP ;
figure();
process_high_pass(IHP, ideal_low, I, rows, cols,1);
process_high_pass(GHP, Gaussian_low, I, rows, cols,2);
process_high_pass(BHP1, butter_low, I, rows, cols,3);
process_high_pass(BHP3, butter_low, I, rows, cols,4);
