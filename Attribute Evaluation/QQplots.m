
for i = 1:length(BeerNames)
    Indexes=find(BeerData.textdata(1:end,2)==BeerNames(i));
    BeerValues=BeerData.data(Indexes-1,1:end);
    figure
    t = tiledlayout(4,10);
    for j=1:length(AttributeNames)
        nexttile;
        qqplot(BeerValues(:,j))
        title(BeerNames(i)+AttributeNames(j))
    end

end
