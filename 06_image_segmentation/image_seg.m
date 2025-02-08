clc;
clear all; 
close all;

image = imread("coins.png");
globalThresholdSegmentation(image);% figure(1)
noised_img = imnoise(image, "gaussian", 0, 0.01);
globalThresholdSegmentation(noised_img);% figure(2)
kernal = ones(5, 5) / 25;
filteredImage = imfilter(noised_img, kernal, "same");
globalThresholdSegmentation(filteredImage);% figure(3)
noised_img = imnoise(image, "gaussian", 0, 0.02);
globalThresholdSegmentation(noised_img);% figure(4)
filteredImage = imfilter(noised_img, kernal, "same");
globalThresholdSegmentation(filteredImage);% figure(5)
[rows, cols] = size(image);
ramp = repmat(linspace(0, 1, cols), rows, 1);
output_image = uint8(double(image) .* ramp);
globalThresholdSegmentation(output_image);% figure(6)

function globalThresholdSegmentation(image)
    image = double(image);
    threshold = mean(image(:));
    difference = 1;
    it = 0 ;
    while difference > 0.5
        lowerGroup = image(image <= threshold);
        upperGroup = image(image > threshold);
        meanLower = mean(lowerGroup(:));
        meanUpper = mean(upperGroup(:));
        newThreshold = (meanLower + meanUpper) / 2;
        difference = abs(newThreshold - threshold);
        threshold = newThreshold;
        it = it +1 ;
    end
    fprintf("%d \n",it);
    binaryImageGlobal = image > threshold;
    pixelCounts = imhist(uint8(image)); % Histogram of the image
    totalPixels = sum(pixelCounts); % Total number of pixels
    cumulativeSum = cumsum(pixelCounts); % Cumulative sum
    cumulativeMean = cumsum((0:255)' .* pixelCounts); % Cumulative mean
    globalMean = cumulativeMean(end) / totalPixels; % Global mean
    betweenClassVariance = zeros(256, 1);
    for t = 1:256
        wB = cumulativeSum(t);
        wF = totalPixels - wB;
        if wB == 0 || wF == 0
             continue;
        end
        mB = cumulativeMean(t) / wB;
        mF = (cumulativeMean(end) - cumulativeMean(t)) / wF;
        betweenClassVariance(t) = wB * wF * (mB - mF)^2;
    end
    [~, optimalThreshold] = max(betweenClassVariance);
    optimalThreshold = optimalThreshold - 1; % Otsu's optimal threshold
    binaryImageOtsu = image > optimalThreshold;
    figure;
    subplot(1, 3, 1);
    imshow(uint8(image));
    title('Original Grayscale Image');
    subplot(1, 3, 2);
    imshow(binaryImageGlobal);
    title(sprintf('Globalâ€™s Threshold: %0.2f, it: %d', threshold, it));
    subplot(1, 3, 3);
    imshow(binaryImageOtsu);
    title(['Otsuâ€™s Threshold: ', num2str(optimalThreshold), ')']);
end
