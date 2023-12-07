%LoadData
%CalculateMeans

%% - PCA - no rotation
[coefs_pca,scores_pca,latent_pca,tsquared_pca,explained_pca] = pca(AllMeans); %This is the new function. Note that it returns only data for the available dimensions
coefs=coefs_pca;
scores=scores_pca;
variances=latent_pca;
%Calculate explained variances in percent
percent_explained = 100*variances/sum(variances);
cumulative_percent_explained=cumsum(percent_explained);

%% - How many dimensions?
figure;
bar(percent_explained)
hold on
plot(0:length(cumulative_percent_explained),[0 cumulative_percent_explained'])
axis([0 6 0 105])
xlabel('Principal Component')
ylabel('Variance Explained (%)')
set(gca,'Xtick',1:1:5)
title("Scree plot PCA")

%% - Plot solution with PC1 and PC2
figure;
plot(scores(:,1),scores(:,2),'+')
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)'])
grid on
title("PCA plot with two dimensions")

for i = 1:size(BeerNames)
    text(scores(i,1)+0.05,scores(i,2),BeerNames(i))
end

%% - twodimensional biplot
varlbs = AttributeNames;
obslbs = BeerNames;figure;

TwodimPlot = biplot(coefs(:,1:2),'scores',scores(:,1:2),'varlabels',varlbs,'obslabels',obslbs);
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)']);
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)']);
%axis([-1 1 -1 1]);
title("Bi-plot with two dimensions")

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
Columns={sprintf('PC1(%.1f%%)',percent_explained(1))  sprintf('PC2(%.1f%%)',percent_explained(2))};
Rows = AttributeNames;

Loadings = [];
for i= 1:length(AttributeNames)
    row = [coefs(i,1) ,coefs(i,2)];
    Loadings = cat(1,row,Loadings);
end

LoadingsTable   =   array2table(Loadings,'RowNames',Rows,'VariableNames',Columns);








%% - Varimax rotation + two and three dimensional biplot
[coefs_rotated,T] = rotatefactors(coefs(:,1:3));  %uses default VARIMAX. T contains the rotation matrix
scores_rotated=scores(:,1:3)*T;

variances_rotated=var(scores_rotated,0,1); %calculate variances of rotated scores
percent_explained_rotated = 100*variances_rotated/sum(variances_rotated); %Calculate explained variances in percent from rotated


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
title("Scree plot rotated Varimax PCA");
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
title("Rotated PCA plot with two dimensions DONT USE");


%% - Threedimensional PCA plot

figure;

plot3(scores_rotated(:,1),scores_rotated(:,2),scores_rotated(:,3),'o')
xlabel(['Principal Component 1 (' num2str(percent_explained_rotated(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained_rotated(2),'%.1f') '%)'])
zlabel(['Principal Component 3 (' num2str(percent_explained_rotated(3),'%.1f') '%)'])
hold on

for i = 1:length(BeerNames)
    text(scores_rotated(i,1)+0.05,scores_rotated(i,2),scores_rotated(i,3),BeerNames(i))
    top = [scores_rotated(i,1) scores_rotated(i,2) scores_rotated(i,3)];
    bottom = [scores_rotated(i,1) scores_rotated(i,2) -6];
    together = [top ; bottom];
    plot3(together(:,1),together(:,2),together(:,3),'--oblack')
end
hold off
grid on
title("Rotated PCA plot with three dimensions");


%% - threedimensional biplot
figure;
varlbs = AttributeNames;
obslbs = BeerNames;
ThreedimPlotRotated = biplot(coefs_rotated(:,1:3),'scores',scores_rotated(:,1:3),'varlabels',varlbs,'obslabels',obslbs,'LineWidth',0.2);
xlabel(['Principal Component 1 (' num2str(percent_explained_rotated(1),'%.1f') '%)']);
ylabel(['Principal Component 2 (' num2str(percent_explained_rotated(2),'%.1f') '%)']);
zlabel(['Principal Component 3 (' num2str(percent_explained_rotated(3),'%.1f') '%)'])
%axis([-1 1 -1 1]);

% Calculate scaling factor based on where a beer is in the basic pca plot
% and then in the new biplot. The original location is scores(1,1) for the
% first value.
hold on

for i = 1:length(AttributeNames)
    top = [coefs_rotated(i,1) coefs_rotated(i,2) -coefs_rotated(i,3)];
    bottom = [coefs_rotated(i,1) coefs_rotated(i,2) -0.5];
    together = [top ; bottom];
    plot3(together(:,1),together(:,2),together(:,3),'--oblack')
end


NewObjectIndex=length(ThreedimPlotRotated(1:end,1))-1;
newvalue=ThreedimPlotRotated(NewObjectIndex,1).XData(1,1);

OldObjectIndex=length(scores_rotated(1:end,1));
oldvalue=scores_rotated(OldObjectIndex,1);
scaling_factor_Rotated = oldvalue/newvalue;

for i = 1:length(BeerNames)
text(scores_rotated(i,1)/scaling_factor_Rotated,scores_rotated(i,2)/scaling_factor_Rotated,-scores_rotated(i,3)/scaling_factor_Rotated,BeerNames(i));
end
title("Rotated bi-plot with three dimensions");
hold off

%% - Big table with contribution to pca1,2 and 3 for each attribute
Columns={sprintf('PC1(%.1f%%)',percent_explained_rotated(1))  sprintf('PC2(%.1f%%)',percent_explained_rotated(2)),sprintf('PC3(%.1f%%)',percent_explained_rotated(3))};
Rows = AttributeNames;

LoadingsRotated = [];
for i= 1:length(AttributeNames)
row = [coefs_rotated(i,1) ,coefs_rotated(i,2) ,coefs_rotated(i,3)];
LoadingsRotated = cat(1,row,LoadingsRotated);
end

LoadingsTableRotated   =   array2table(LoadingsRotated,'RowNames',fliplr(Rows),'VariableNames',Columns);


writetable(LoadingsTable,'Tables/LoadingTables/TablesLoadingsTable.csv','WriteRowNames',true);
writetable(LoadingsTableRotated,'Tables/LoadingTables/LoadingsTableRotated.csv','WriteRowNames',true);


