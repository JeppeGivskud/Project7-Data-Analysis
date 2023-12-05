%% Outline
% Principal component analysis for Beer sensory analysis
% This program loads a file called RawDataCombined.csv. 
% The beernames are picked from column two only appending when a name is unique. 
% The attributes names are picked from row 1 column 3 till end 

clear all
close all
clc
%%
[BeerData,delimiterOut,headerlinesOut]=importdata("RawDataCombined.csv",',',1);

% Takes unique data from columns or rows and converts that array to string
Participants=string(unique(BeerData.textdata(2:end,1),'stable'));
BeerNames=string(unique(BeerData.textdata(2:end,2),'stable'));
AttributeNames=string(BeerData.textdata(1,3:end));
IDs=string(unique(BeerData.textdata(1:end,2),'stable'));


%% - Means,StandardDeviations and ConfidensIntervals
AllMeans=[];
AllSD=[];
AllCI=[];

% Loop through the data as many times as there are unique beer names
% Each time find mean,standard deviation and confidence interval for
% every data point connected to that beer and put it in an array
for i = 1:size(BeerNames)

    Indexes=find(BeerData.textdata(1:end,2)==BeerNames(i));

    BeerValues=BeerData.data(Indexes-1,1:end);
    BeerValuesMean=mean(BeerValues);
    BeerValuesSD=std(BeerValues);
 % we calculate the confidence interval for each attribute in each sample 
 % by finding the Standard Error of the Mean (SEM) and multiplying that by 
 % the critical value to get the margin of error. 
 % The confindence interval is the mean +- the margin of error 
 % 2*(Margin of error)
 % 2*(Critical value*(Standard error of the mean))
 % 2*(Critical value*(Standard Deviation/sqrt(Sample Size)))
 % 2*(1.9600*(SD/sqrt(SampleSize)))
 % The actual interval is not calculated as only the size is important
    BeerValuesCI=2*(1.96*(BeerValuesSD/sqrt(size(Indexes,1))));

    AllMeans = cat(1,AllMeans,BeerValuesMean);
    AllSD    = cat(1,AllSD,BeerValuesSD);
    AllCI    = cat(1,AllCI,BeerValuesCI);
    
end

%% - Tables - Prints some tables
Means   =   array2table(AllMeans,'RowNames',BeerNames,'VariableNames',AttributeNames)
Standard_deviations  = array2table(AllSD,'RowNames',BeerNames,'VariableNames',AttributeNames)
Confidence_intervals = array2table(AllCI,'RowNames',BeerNames,'VariableNames',AttributeNames)

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

%% - PCA
PCA

%% - Factor analysis
