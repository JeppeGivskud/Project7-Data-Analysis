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

%% - PCA - no rotation
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
TwodimPlot = biplot(coefs(:,1:2),'scores',scores(:,1:2),'varlabels',varlbs,'obslabels',obslbs);
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)']);
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)']);
%axis([-1 1 -1 1]);

% Calculate scaling factor based on where a beer is in the basic pca plot
% and then in the new biplot. The original location is scores(1,1) for the
% first value.
newvalue=TwodimPlot(size(TwodimPlot,1)-1,1).XData(1,1);
oldvalue=scores(size(scores,1),1);
scaling_factor = oldvalue/newvalue;

hold on;
for i = 1:size(BeerNames)
img = imread("BeerPictures/"+BeerNames(i)+".png");


size = 1/2;
width = 1/17  *size;
height = 2/10 *size;
xpos = scores(i,1)/scaling_factor - width/2;
ypos = scores(i,2)/scaling_factor - height/10;


image('CData',img,'XData',[xpos xpos+width],'YData',[ypos ypos-height]);

text(scores(i,1)/scaling_factor,scores(i,2)/scaling_factor,BeerNames(i));
end
hold off


%% - Three dimensional biplot is not necessary
%% - Big table with contribution to pca1,2 and 3 for each attribute
Columns={sprintf('PC1(%.1f%%)',percent_explained(1))  sprintf('PC1(%.1f%%)',percent_explained(2)),sprintf('PC1(%.1f%%)',percent_explained(3))};
Rows = AttributeNames;

Loadings = [];
for i= 1:length(AttributeNames)
row = {sprintf('%.1f%%',coefs(i,1)), sprintf('%.1f%%',coefs(i,2)), sprintf('%.1f%%',coefs(i,3))};
Loadings = cat(1,row,Loadings);
end

LoadingsTable   =   array2table(Loadings,'RowNames',Rows,'VariableNames',Columns)

%% - Varimax rotation + two and three dimensional biplot
[coefs_rotated,T] = rotatefactors(coefs(:,1:3));  %uses default VARIMAX. T contains the rotation matrix
scores_rotated=scores(:,1:3)*T;
variances_rotated=var(scores_rotated,0,1); %calculate variances of rotated scores
percent_explained_rotated = 100*variances_rotated/sum(variances); %Calculate explained variances in percent from rotated
percent_explained_rotated=[percent_explained_rotated 0];


%Explained variance
figure;

cumulative_percent_explained_rotated=cumsum(percent_explained_rotated);
%pareto(percent_explained_rotated) %does not show the last 5 %
bar(percent_explained_rotated)
hold on
plot([0:length(cumulative_percent_explained_rotated)],[0 cumulative_percent_explained_rotated])
axis([0 6 0 105])
xlabel('Principal Component (rotated)')
ylabel('Variance Explained (%)')
set(gca,'Xtick',[1 2 3 4 5])
title('Rotated')
% actually this solution is more blurred than the other one.







