LoadData
CalculateMeans

%% - Tables - Prints some tables
BeerNamesthree = extractBefore(BeerNames,4)
BeerNamesthree(8,1)="Cla"
BeerNamesthree(10,1)="Nul"
Means   =   array2table(AllMeans,'RowNames',BeerNamesthree,'VariableNames',AttributeNames)
Standard_deviations  = array2table(AllSD,'RowNames',BeerNamesthree,'VariableNames',AttributeNames)
Confidence_intervals = array2table(AllCI,'RowNames',BeerNamesthree,'VariableNames',AttributeNames)


%% - Combine tables to get confidence interval
MeansplusConfidence = round(AllMeans,1)+"+-"+string(round(AllCI,1))
MeansplusConfidenceTable = array2table(MeansplusConfidence,'RowNames',BeerNamesthree,'VariableNames',AttributeNames)
writetable(MeansplusConfidenceTable,'MeansTables/MeansplusConfidenceTable.csv','WriteRowNames',true);

writetable(round(Means,1),'MeansTables/MeansAllBeers.csv','WriteRowNames',true);

%% - Confidence interval for confidance intervals
% As a way of condensing which attributes are good/bad for rating beers.
% The margin of error is calculated for each confidence interval for all 10 beers
% If an attribute has a small margin of error that attribute is easy to asses. 
% More precisely participants experience the attribute similarily.

MeanCI=mean(AllCI);
SDCI=std(AllCI);
CICI=2*(1.96*(SDCI/sqrt(size(AllCI,1))));

ConfidenceIntervalTable   =   array2table([MeanCI;SDCI;CICI],'RowNames',["MeanCI","SDCI","CICI"],'VariableNames',AttributeNames)

figure;
errorbar(1:40,MeanCI,CICI)
title("Mean of confidence interval sizes")
xlabel('Attribute');
ylabel('Confidence interval size');
set(gca,'xtick',1:size(AttributeNames,2));
set(gca,'XTickLabel',AttributeNames);
grid on

%% - Profile plot - Put all the mean data into a plot
% In order to understand the raw data a profile plot is created. 
% Combining this with the confidence interval of confidence intervals shows
% if an attribute can be asses confidently with participants.
colors =["r-o","g--o","b--o","g-o","b-o","c-o","m-o","y-o","k--o","k-o"];
figure;
hold on

for i = 1:size(BeerNames)
plot(AllMeans(i,1:end),colors(i),'linewidth',2)
end
title("Profile plot for all attributes")
xlabel('Attribute');
ylabel('Score (0-7)');
legend(BeerNames);
set(gca,'xtick',[1:size(AttributeNames,2)]);
set(gca,'XTickLabel',AttributeNames);
grid on

%% - Factor analysis
FactorAnalysis
%% - PCA
PCA

