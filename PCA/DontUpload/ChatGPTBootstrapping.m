% Example data (replace this with your own data)

[data,delimiterOut,headerlinesOut]=importdata("RawDataCombined.csv",',',1);
data = data.data;


% Perform the initial PCA
[coeff, score, latent] = pca(data);

% Bootstrapping parameters
numBootstraps = 1000;
bootstrapSize = size(data, 1);

% Initialize arrays to store bootstrapped results
bootstrapCoeff = zeros(size(coeff, 1), size(coeff, 2), numBootstraps);
bootstrapScore = zeros(size(score, 1), size(score, 2), numBootstraps);
bootstrapLatent = zeros(size(latent, 1), numBootstraps);

% Bootstrapping loop
for i = 1:numBootstraps
    % Generate a bootstrap sample
    bootstrapSample = datasample(data, bootstrapSize, 'Replace', true);

    % Perform PCA on the bootstrap sample
    [bootstrapCoeff(:, :, i), bootstrapScore(:, :, i), bootstrapLatent(:, i)] = pca(bootstrapSample);
end

% Plot histograms for the first principal component (PC1)
figure;
histogram(score(:, 1), 'Normalization', 'probability', 'DisplayName', 'Original Data');
hold on;

for i = 1:numBootstraps
    histogram(bootstrapScore(:, 1, i), 'Normalization', 'probability', 'DisplayStyle', 'stairs', 'DisplayName', 'Bootstrap Samples');
end

title('Distribution of PC1');
xlabel('PC1 Value');
ylabel('Probability');
legend;

% Calculate and plot confidence intervals for mean and standard deviation of PC1
meanPC1 = mean(score(:, 1));
stdPC1 = std(score(:, 1));

bootstrapMeanPC1 = mean(bootstrapScore(:, 1, :), 3);
bootstrapStdPC1 = std(bootstrapScore(:, 1, :), 0, 3);

confInterval = prctile(bootstrapMeanPC1, [2.5, 97.5]);

figure;
errorbar(1, meanPC1, stdPC1, 'o', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Original Data');
hold on;
errorbar(2, mean(bootstrapMeanPC1), std(bootstrapStdPC1), 'o', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Bootstrap Mean and Std');
plot([2, 2], confInterval, 'r-', 'LineWidth', 2, 'DisplayName', '95% Confidence Interval');
xticks([1, 2]);
xticklabels({'Original', 'Bootstrap'});
title('PC1 Mean and Std with 95% Confidence Interval');
ylabel('PC1 Value');
legend;
