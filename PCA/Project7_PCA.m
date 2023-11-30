%% Outline
% This program loads a file called MEGATABLE_WIDE. It reads attributes from
% line 3 till the end. If line 3 is not where your data starts you may
% change that value. The beernames could be defined from another thing
% goodbye



%Principal component analysis for Beer sensory analysis

clear all
close all
clc
%[A,delimiterOut,headerlinesOut]
[BeerData,delimiterOut,headerlinesOut]=importdata("MEGATABLE_WIDE.csv",',',1);

BeerNames = ["Aronia";"Alexander";"Brown Bella";"Angelina";"Amarillo";"Wiener Walzer";"Amigo";"Sebastian";"Tuborg Classic";"Tuborg Nul"];
AttributeNames=BeerData.textdata(1,3:end);
AllMeans=[];
AllSD=[];
AllCI=[];

%% - Means,StandardDeviations and ConfidensIntervals
for i = 1:size(BeerNames)
    Indexes=find(BeerData.textdata(:,2)==BeerNames(i));
    BeerNames(i);
    BeerValues=BeerData.data(Indexes-1,1:end);

    BeerValuesMean=mean(BeerValues);
    BeerValuesSD=std(BeerValues);
    BeerValuesCI=BeerValuesMean+0.05*(BeerValuesSD/sqrt(size(Indexes(),1)));

    AllMeans = cat(1,AllMeans,BeerValuesMean);
    AllSD = cat(1,AllSD,BeerValuesSD);
    AllCI = cat(1,AllCI,BeerValuesCI);
end

%% - Tables
Means   =   array2table(AllMeans,'RowNames',BeerNames,'VariableNames',AttributeNames)
Standard_deviations  = array2table(AllSD,'RowNames',BeerNames,'VariableNames',AttributeNames)
Confidence_intervals = array2table(AllCI,'RowNames',BeerNames,'VariableNames',AttributeNames)

%% - Profile plot
colors =["r-o","g--o","b--o","g-o","b-o","c-o","m-o","y-o","k--o","k-o"];
figure;
hold on

for i = 1:size(BeerNames)
plot(AllMeans(i,1:end),colors(i),'linewidth',2)
end
xlabel('Attributes');
ylabel('Score');
legend(BeerNames);
set(gca,'xtick',[1:size(AttributeNames,2)]);
set(gca,'XTickLabel',AttributeNames);
grid on

%% - PCA
[coefs_pca,scores_pca,latent_pca,tsquared_pca,explained_pca] = pca(AllMeans); %This is the new function. Note that it returns only data for the available dimensions
coefs=coefs_pca;
scores=scores_pca;
variances=latent_pca;
%Calculate explained variances in percent
percent_explained = 100*variances/sum(variances);

%% - How many dimensions?
figure;
cumulative_percent_explained=cumsum(percent_explained);
%pareto(percent_explained) %does not show the last 5 %
bar(percent_explained)
hold on
plot([0:length(cumulative_percent_explained)],[0 cumulative_percent_explained'])
axis([0 6 0 105])
xlabel('Principal Component')
ylabel('Variance Explained (%)')
set(gca,'Xtick',[1 2 3 4 5])

%% - Plot solution with PC1 and PC2
figure;
plot(scores(:,1),scores(:,2),'+')
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)'])
grid on
for i = 1:size(BeerNames)
    text(scores(i,1)+0.05,scores(i,2),BeerNames(i))
end

%% - twodimensional biplot
figure;
varlbs = AttributeNames;
obslbs = BeerNames;
biplot(coefs(:,1:2),'scores',scores(:,1:2),'varlabels',varlbs,'obslabels',obslbs);
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)']);
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)']);
axis([-1 1 -1 1]);

% Calculate scaling factor based on where a beer is in the basic pca plot
% and then in the new biplot. The original location is scores(1,1) for the
% first value.
OriginalValue=scores(1,1);
scaledDownValue=0.016974;
scaling_factor = OriginalValue/scaledDownValue;
%scaling_factor=115.1/0.41426;
for i = 1:size(BeerNames)
    text(scores(i,1)/scaling_factor,scores(i,2)/scaling_factor,BeerNames(i))
end












