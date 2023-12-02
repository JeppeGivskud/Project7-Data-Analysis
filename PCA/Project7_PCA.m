%% Outline
% This program loads a file called MEGATABLE_WIDE. It reads attributes from
% line 3 till the end. If line 3 is not where your data starts you may
% change that value. The beernames could be defined from another thing
% goodbye
% Principal component analysis for Beer sensory analysis

clear all
close all
clc

[BeerData,delimiterOut,headerlinesOut]=importdata("MEGATABLE_WIDE.csv",',',1);
%[BeerData,delimiterOut,headerlinesOut]=importdata("MEGATABLE_WIDE_testdata.csv",',',1);

% Takes unique data from columns or rows and converts that array to string
Participants=string(unique(BeerData.textdata(2:end,1),'stable'));
BeerNames=string(unique(BeerData.textdata(2:end,2),'stable'));
AttributeNames=string(BeerData.textdata(1,3:end));


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
    
 %Finding the upper confidence interval with 95% interval with:
 %1.9600*(SD/sqrt(SampleSize))

    BeerValuesCI=1.96*(BeerValuesSD/sqrt(size(Indexes,1)));

    AllMeans = cat(1,AllMeans,BeerValuesMean);
    AllSD    = cat(1,AllSD,BeerValuesSD);
    AllCI    = cat(1,AllCI,BeerValuesCI);
    
end

%% - Tables - Prints some tables
Means   =   array2table(AllMeans,'RowNames',BeerNames,'VariableNames',AttributeNames)
Standard_deviations  = array2table(AllSD,'RowNames',BeerNames,'VariableNames',AttributeNames)
Confidence_intervals = array2table(AllCI,'RowNames',BeerNames,'VariableNames',AttributeNames)

%% - Confidence interval for confidance intervals
MeanCI=mean(AllCI);
SDCI=std(AllCI);
CICI=1.96*(SDCI/sqrt(size(AllCI,1)));

ConfidenceIntervalTable   =   array2table([MeanCI;SDCI;CICI],'RowNames',["MeanCI","SDCI","CICI"],'VariableNames',AttributeNames)

figure;
errorbar(1:40,MeanCI,CICI)
xlabel('Attributes');
ylabel('Confidence interval size');
set(gca,'xtick',1:size(AttributeNames,2));
set(gca,'XTickLabel',AttributeNames);
grid on

%% - Sort attribute order according to highest to lowest scores
%lastbeer=AllMeans(10,1:end)
%[lastbeerSorted,I] = sort(lastbeer);
%AttributesSorted = AttributeNames(I);
%sortedMeans=[];
%
%for i = 1:size(BeerNames)-1
 %   notsorted=AllMeans(i,1:end);
  %  sorted=notsorted(I);
%sortedMeans = cat(1,sortedMeans,sorted);
%
%end
%sortedMeans = cat(1,sortedMeans,lastbeerSorted);
%AllMeans=sortedMeans;
%AttributeNames=AttributesSorted;
% 
%% - Profile plot - Put all the mean data into a plot
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


%% - Three dimensional biplot

%% - LoadPictures
%% - Bi plot with pictures

%% - Big table with contribution to pca1,2 and 3 for each attribute

%% - Varimax rotation + two and three dimensional biplot






