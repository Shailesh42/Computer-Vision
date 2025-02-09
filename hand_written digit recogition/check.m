% Load the trained model
clc;
clear all;
close all;
load('digitRecognizerModel.mat'); % Ensure digitRecognizerModel.mat exists

% Load validation data if not already in the workspace
if ~exist('valImages', 'var') || ~exist('valLabels', 'var')
    % If validation data is not defined, create it from train data split
    disp('Validation data not found. Generating validation data from trainData.');
    trainData = readtable('train.csv'); % Load the train dataset

    % Split trainData into training and validation sets
    cv = cvpartition(height(trainData), 'HoldOut', 0.2); % 80% training, 20% validation
    idxTrain = training(cv);
    idxVal = test(cv);

    % Extract validation data
    valImages = trainData{idxVal, 2:end}; % Pixel values
    valLabels = trainData{idxVal, 1}; % Labels

    % Normalize and reshape
    valImages = double(valImages) / 255.0; % Normalize pixel values
    valImages = reshape(valImages', 28, 28, 1, []); % Reshape to 28x28x1

    % Convert labels to categorical
    valLabels = categorical(valLabels);
end

% Number of images to save and validate
numImagesToSave = 10;

% Select a subset of validation data for testing
selectedIdx = randperm(size(valImages, 4), numImagesToSave); % Randomly select indices
selectedImages = valImages(:, :, :, selectedIdx);
selectedLabels = valLabels(selectedIdx);

% Predict the labels using the trained model
predictedLabels = classify(net, selectedImages);

% Folder to save images
outputFolder = 'SavedValidationImages';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Save the images and compare actual vs predicted labels
figure('Name', 'Model Predictions', 'NumberTitle', 'off');
for i = 1:numImagesToSave
    % Save image as PNG
    imageFileName = fullfile(outputFolder, sprintf('image_%d.png', i));
    imwrite(squeeze(selectedImages(:, :, 1, i)), imageFileName);
    
    % Display the image with actual and predicted labels
    subplot(2, ceil(numImagesToSave / 2), i); % Arrange in a grid
    imshow(squeeze(selectedImages(:, :, 1, i)), 'InitialMagnification', 'fit');
    title(sprintf('Actual: %s, Predicted: %s', ...
        string(selectedLabels(i)), string(predictedLabels(i))));
    
    % Highlight mismatches
    if selectedLabels(i) ~= predictedLabels(i)
        rectangle('Position', [0, 0, 28, 28], 'EdgeColor', 'red', 'LineWidth', 2);
    end
end

% Save figure to file
saveas(gcf, fullfile(outputFolder, 'ModelPredictions.png'));

disp('Images saved in SavedValidationImages folder.');
disp('Red border indicates mismatched predictions.');
