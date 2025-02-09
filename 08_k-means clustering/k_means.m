clc;
close all;
clear all;

% Load and preprocess the grayscale image
img = imread("cameraman.tif");
if size(img, 3) == 3
    img = rgb2gray(img); % Ensure it's grayscale
end
img = double(img);
[rows, cols] = size(img);
[x, y] = meshgrid(1:cols, 1:rows);
features = [x(:), y(:), img(:)];

% Parameters for K-Means Clustering
k = 3;
centroids = [100, 50, 128; 200, 150, 200; 50, 200, 64];
cluster_assignment = zeros(size(features, 1), 1);
iteration = 0;
max_row = rows;
max_col = cols;
max_intensity = 255;

% K-Means Clustering for Grayscale Image
while true
    iteration = iteration + 1;
    distances = zeros(size(features, 1), k);
    for i = 1:k
        diff_row = (features(:, 1) - centroids(i, 1)) / max_row;
        diff_col = (features(:, 2) - centroids(i, 2)) / max_col;
        diff_intensity = (features(:, 3) - centroids(i, 3)) / max_intensity;
        distances(:, i) = sqrt(diff_row.^2 + diff_col.^2 + diff_intensity.^2);
    end
    [~, cluster_assignment] = min(distances, [], 2);
    new_centroids = zeros(k, size(features, 2));
    for i = 1:k
        cluster_points = features(cluster_assignment == i, :);
        if ~isempty(cluster_points)
            new_centroids(i, :) = mean(cluster_points, 1);
        else
            new_centroids(i, :) = features(randi(size(features, 1)), :);
        end
    end
    if all(new_centroids == centroids)
        disp(['Converged after ', num2str(iteration), ' iterations']);
        break;
    end
    centroids = new_centroids;
end

% Generate and visualize results for Grayscale Image
labeled_img = reshape(cluster_assignment, [rows, cols]);
segmented_img = zeros(rows, cols);
intensities = linspace(0, 255, k);
for i = 1:k
    segmented_img(labeled_img == i) = intensities(i);
end
original_img_uint8 = uint8(img);
overlay_img = labeloverlay(original_img_uint8, labeled_img, 'Transparency', 0.5);

figure;
subplot(1, 3, 1);
imshow(uint8(img));
title('Original Grayscale Image');
subplot(1, 3, 2);
imshow(uint8(segmented_img));
title('Segmented Image with K-Means Clustering');
subplot(1, 3, 3);
imshow(overlay_img);
title('Label Overlay on Original Image');

% Load and preprocess the color image
img = imread("COLUR.png");
img = double(img);
[rows, cols, channels] = size(img);
[x, y] = meshgrid(1:cols, 1:rows);
red_channel = img(:, :, 1);
green_channel = img(:, :, 2);
blue_channel = img(:, :, 3);
features = [x(:), y(:), red_channel(:), green_channel(:), blue_channel(:)];

% Parameters for K-Means Clustering (Color Image)
k = 3;
random_indices = randperm(size(features, 1), k);
centroids = features(random_indices, :);
cluster_assignment = zeros(size(features, 1), 1);

iteration = 0;
while true
    iteration = iteration + 1;
    distances = zeros(size(features, 1), k);
    for i = 1:k
        diff_row = (features(:, 1) - centroids(i, 1)) / rows;
        diff_col = (features(:, 2) - centroids(i, 2)) / cols;
        diff_red = (features(:, 3) - centroids(i, 3)) / 255;
        diff_green = (features(:, 4) - centroids(i, 4)) / 255;
        diff_blue = (features(:, 5) - centroids(i, 5)) / 255;
        distances(:, i) = sqrt(diff_row.^2 + diff_col.^2 + diff_red.^2 + diff_green.^2 + diff_blue.^2);
    end
    [~, cluster_assignment] = min(distances, [], 2);
    new_centroids = zeros(k, size(features, 2));
    for i = 1:k
        cluster_points = features(cluster_assignment == i, :);
        if ~isempty(cluster_points)
            new_centroids(i, :) = mean(cluster_points, 1);
        else
            new_centroids(i, :) = features(randi(size(features, 1)), :);
        end
    end
    if all(new_centroids == centroids)
        disp(['Converged after ', num2str(iteration), ' iterations']);
        break;
    end
    centroids = new_centroids;
end

% Generate and visualize results for Color Image
labeled_img = reshape(cluster_assignment, [rows, cols]);
segmented_img = zeros(rows, cols);
intensities = [50, 150, 250];
for i = 1:k
    mask = labeled_img == i;
    segmented_img(mask) = intensities(i);
end
original_img_uint8 = uint8(img);
segmented_img_uint8 = uint8(segmented_img);
overlay_img = labeloverlay(original_img_uint8, labeled_img, 'Transparency', 0.5);

figure;
subplot(2, 2, 1);
imshow(original_img_uint8);
title('Original Color Image');
subplot(2, 2, 2);
imshow(segmented_img_uint8);
title('Segmented Grayscale Image');
subplot(2, 2, 3);
imshow(overlay_img);
title('Label Overlay on Original Image');
