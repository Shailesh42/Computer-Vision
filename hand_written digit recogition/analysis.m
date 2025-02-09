% Load the trained model and data
load('digitRecognizerModel.mat', 'net');
trainData = readtable('train.csv');
testData = readtable('test.csv');

% Extract labels and features from train data
trainLabelsFull = trainData{:, 1}; % First column is the label
trainImagesFull = trainData{:, 2:end}; % Remaining columns are pixel values

% Split trainData into training and validation sets
cv = cvpartition(height(trainData), 'HoldOut', 0.2); % 80% training, 20% validation
idxTrain = training(cv);
idxVal = test(cv);

% Training data
trainImages = trainImagesFull(idxTrain, :);
trainLabels = trainLabelsFull(idxTrain, :);

% Validation data
valImages = trainImagesFull(idxVal, :);
valLabels = trainLabelsFull(idxVal, :);

% Test data
testImages = testData{:,:}; % Test images (without labels)

% Normalize and reshape data
trainImages = double(trainImages) / 255.0;
valImages = double(valImages) / 255.0;
testImages = double(testImages) / 255.0;

trainImages = reshape(trainImages', 28, 28, 1, []);
valImages = reshape(valImages', 28, 28, 1, []);
testImages = reshape(testImages', 28, 28, 1, []);

trainLabels = categorical(trainLabels);
valLabels = categorical(valLabels);

% Evaluate Training Accuracy
predictedTrainLabels = classify(net, trainImages);
trainAccuracy = sum(predictedTrainLabels == trainLabels) / numel(trainLabels);
fprintf('Training Accuracy: %.2f%%\n', trainAccuracy * 100);

% Evaluate Validation Accuracy
predictedValLabels = classify(net, valImages);
valAccuracy = sum(predictedValLabels == valLabels) / numel(valLabels);
fprintf('Validation Accuracy: %.2f%%\n', valAccuracy * 100);

% Predict on Test Data (Optional - For analysis purpose)
predictedTestLabels = classify(net, testImages);

% Generate Confusion Matrix for Validation Data
confMat = confusionmat(valLabels, predictedValLabels);
confMatChart = confusionchart(valLabels, predictedValLabels, ...
    'Title', 'Confusion Matrix - Validation Data', ...
    'ColumnSummary', 'column-normalized', ...
    'RowSummary', 'row-normalized');

% Calculate Precision, Recall, and F1-Score for Validation Data
classes = categories(valLabels);
precision = zeros(numel(classes), 1);
recall = zeros(numel(classes), 1);
f1Score = zeros(numel(classes), 1);

for i = 1:numel(classes)
    TP = confMat(i, i);
    FP = sum(confMat(:, i)) - TP;
    FN = sum(confMat(i, :)) - TP;
    precision(i) = TP / (TP + FP);
    recall(i) = TP / (TP + FN);
    f1Score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
end

% Display Metrics
fprintf('\nClass-wise Metrics (Validation Data):\n');
fprintf('Class\tPrecision\tRecall\t\tF1-Score\n');
for i = 1:numel(classes)
    fprintf('%s\t%.2f\t\t%.2f\t\t%.2f\n', classes{i}, precision(i), recall(i), f1Score(i));
end
