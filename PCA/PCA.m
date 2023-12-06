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


%% - Plot solution with PC1 and PC2
figure;
plot(scores_rotated(:,1),scores_rotated(:,2),'+')
xlabel(['Principal Component 1 (' num2str(percent_explained_rotated(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained_rotated(2),'%.1f') '%)'])
grid on
for i = 1:length(BeerNames)
    text(scores_rotated(i,1)+0.05,scores_rotated(i,2),BeerNames(i))
end

%% - twodimensional biplot
figure;
varlbs = AttributeNames;
obslbs = BeerNames;
TwodimPlotRotated = biplot(coefs_rotated(:,1:2),'scores',scores_rotated(:,1:2),'varlabels',varlbs,'obslabels',obslbs);
xlabel(['Principal Component 1 (' num2str(percent_explained_rotated(1),'%.1f') '%)']);
ylabel(['Principal Component 2 (' num2str(percent_explained_rotated(2),'%.1f') '%)']);
%axis([-1 1 -1 1]);

% Calculate scaling factor based on where a beer is in the basic pca plot
% and then in the new biplot. The original location is scores(1,1) for the
% first value.
newvalue=TwodimPlotRotated(length(TwodimPlotRotated,1)-1,1).XData(1,1);
oldvalue=scores_rotated(size(scores_rotated,1),1);
scaling_factor = oldvalue/newvalue;

hold on;
for i = 1:size(BeerNames)
img = imread("BeerPictures/"+BeerNames(i)+".png");


size = 1/2;
width = 1/17  *size;
height = 2/10 *size;
xpos = scores_rotated(i,1)/scaling_factor - width/2;
ypos = scores_rotated(i,2)/scaling_factor - height/10;


image('CData',img,'XData',[xpos xpos+width],'YData',[ypos ypos-height]);

text(scores_rotated(i,1)/scaling_factor,scores_rotated(i,2)/scaling_factor,BeerNames(i));
end
hold off



