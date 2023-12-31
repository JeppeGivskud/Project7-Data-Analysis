
% - Normality, Means,StandardDeviations and ConfidensIntervals
Normality=[];
AllMeans=[];
AllSD=[];
AllCI=[];

% Loop through the data as many times as there are unique beer names
% Each time find mean,standard deviation and confidence interval for
% every data point connected to that beer and put it in an array
for i = 1:size(BeerNames)

    Indexes=find(BeerData.textdata(1:end,2)==BeerNames(i));
    BeerValues=BeerData.data(Indexes-1,1:end);
    
    row = [];
    for j=1:length(AttributeNames)
        
        [H, pValue, W] = swtest(BeerValues(1:end,j));
        row = cat(2,row,pValue);
    end
    Normality = cat(1,Normality,row);

    
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

% for hver øltype
%for hver attribut
%shapiro
%10x40 matrix hvor der står 1 eller 0 i hver celle