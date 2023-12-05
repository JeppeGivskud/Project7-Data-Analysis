%Principal component analysis lecture

clear all
close all
clc

bread=importdata('breaddata_attributes.csv',',',1);
plot_bread_pictures=0;

%data contains all numerical values
%textdata contains all the text
%Skorpe,Krumme,Overflade,Kerner,Tungt,Taet,Saftigt,Maettende,Naerende,Fuldkorn,Fiber

%Extract data for each bread
bread1_idx=find(bread.data(:,3)==1);
bread1=bread.data(bread1_idx,5:end);
bread2_idx=find(bread.data(:,3)==2);
bread2=bread.data(bread2_idx,5:end);
bread3_idx=find(bread.data(:,3)==3);
bread3=bread.data(bread3_idx,5:end);
bread4_idx=find(bread.data(:,3)==4);
bread4=bread.data(bread4_idx,5:end);
bread5_idx=find(bread.data(:,3)==5);
bread5=bread.data(bread5_idx,5:end);
bread6_idx=find(bread.data(:,3)==6);
bread6=bread.data(bread6_idx,5:end);
bread7_idx=find(bread.data(:,3)==7);
bread7=bread.data(bread7_idx,5:end);
bread8_idx=find(bread.data(:,3)==8);
bread8=bread.data(bread8_idx,5:end);

%Calculating mean across test subjects for each bread
bread1_avg=mean(bread1,1);
bread2_avg=mean(bread2,1);
bread3_avg=mean(bread3,1);
bread4_avg=mean(bread4,1);
bread5_avg=mean(bread5,1);
bread6_avg=mean(bread6,1);
bread7_avg=mean(bread7,1);
bread8_avg=mean(bread8,1);
%%
%names=({'Sample1';'Sample2';'Sample3';'Sample4'});
names=({'Bread1';'Bread2';'Bread3';'Bread4';'Bread5';'Bread6';'Bread7';'Bread8'});

%Plotting a "profile" for each sample
figure;
plot([1:11],bread1_avg,'-or','linewidth',2)
hold on
plot([1:11],bread2_avg,'-ob','linewidth',2)
plot([1:11],bread3_avg,'-og','linewidth',2)
plot([1:11],bread4_avg,'-oc','linewidth',2)
plot([1:11],bread5_avg,'-sr','linewidth',2)
plot([1:11],bread6_avg,'-sb','linewidth',2)
plot([1:11],bread7_avg,'-sg','linewidth',2)
plot([1:11],bread8_avg,'-sc','linewidth',2)
axis([0 12 0 200])
xlabel('Attributes')
ylabel('Score')
legend('Bread 1','Bread 2','Bread 3','Bread 4','Bread 5','Bread 6','Bread 7','Bread 8','location','SouthWest')
set(gca,'xtick',[1:11])
%set(gca,'XTickLabel',['A';'B';'C';'D';'E';'F';'G';'H'])
set(gca,'XTickLabel',bread.textdata(5:end))
set(gca,'Plotboxaspectratio',[3 1 1])
grid on

%Arrange the input data
input_data=[bread1_avg;bread2_avg;bread3_avg;bread4_avg;bread5_avg;bread6_avg;bread7_avg;bread8_avg];

%Calling principal component analysis function
%[coefs,scores,variances] = princomp(input_data);    %This is the old matlab function (prior to Matlab r2012b)
[coefs_pca,scores_pca,latent_pca,tsquared_pca,explained_pca] = pca(input_data); %This is the new function. Note that it returns only data for the available dimensions
coefs=coefs_pca;
scores=scores_pca;
variances=latent_pca;
%Calculate explained variances in percent
percent_explained = 100*variances/sum(variances);

%Plot solution with PC1 and PC2
figure;
plot(scores(:,1),scores(:,2),'+')
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)'])
grid on
text(scores(1,1),scores(1,2),'bread1')
text(scores(2,1),scores(2,2),'bread2')
text(scores(3,1),scores(3,2),'bread3')
text(scores(4,1),scores(4,2),'bread4')
text(scores(5,1),scores(5,2),'bread5')
text(scores(6,1),scores(6,2),'bread6')
text(scores(7,1),scores(7,2),'bread7')
text(scores(8,1),scores(8,2),'bread8')

%Explained variance
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

%twodimensional biplot

figure

%varlbs = {'Att. A','Att. B','Att. C','Att. D','Att. E','Att. F','Att. G','Att. H'};
varlbs = bread.textdata(5:end)
obslbs = {'Bread 1','Bread 2','Bread 3','Bread 4','Bread 5','Bread 6','Bread 7','Bread 8'};
biplot(coefs(:,1:2),'scores',scores(:,1:2),'varlabels',varlbs,'obslabels',obslbs);
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)'])
zlabel(['Principal Component 3 (' num2str(percent_explained(3),'%.1f') '%)'])
%biplot(coefs(:,1:2),'scores',scores(:,1:2));
axis([-1 1 -1 1])
scaling_factor=115.1/0.41426;
text(scores(1,1)/scaling_factor,scores(1,2)/scaling_factor,'Bread1','color',[1 0 0])
text(scores(2,1)/scaling_factor,scores(2,2)/scaling_factor,'Bread2','color',[1 0 0])
text(scores(3,1)/scaling_factor,scores(3,2)/scaling_factor,'Bread3','color',[1 0 0])
text(scores(4,1)/scaling_factor,scores(4,2)/scaling_factor,'Bread4','color',[1 0 0])
text(scores(5,1)/scaling_factor,scores(5,2)/scaling_factor,'Bread5','color',[1 0 0])
text(scores(6,1)/scaling_factor,scores(6,2)/scaling_factor,'Bread6','color',[1 0 0])
text(scores(7,1)/scaling_factor,scores(7,2)/scaling_factor,'Bread7','color',[1 0 0])
text(scores(8,1)/scaling_factor,scores(8,2)/scaling_factor,'Bread8','color',[1 0 0])

%Threedimensional biplot
figure

biplot(coefs(:,1:3),'scores',scores(:,1:3),'varlabels',varlbs,'obslabels',obslbs);
%biplot(coefs(:,1:2),'scores',scores(:,1:2));
xlabel(['Principal Component 1 (' num2str(percent_explained(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (' num2str(percent_explained(2),'%.1f') '%)'])
zlabel(['Principal Component 3 (' num2str(percent_explained(3),'%.1f') '%)'])
axis([-1 1 -1 1 -1 1])

scaling_factor=115.1/0.53681;
text(scores(1,1)/scaling_factor,scores(1,2)/scaling_factor,scores(1,3)/scaling_factor,'Bread1','color',[1 0 0])
text(scores(2,1)/scaling_factor,scores(2,2)/scaling_factor,scores(2,3)/scaling_factor,'Bread2','color',[1 0 0])
text(scores(3,1)/scaling_factor,scores(3,2)/scaling_factor,scores(3,3)/scaling_factor,'Bread3','color',[1 0 0])
text(scores(4,1)/scaling_factor,scores(4,2)/scaling_factor,scores(4,3)/scaling_factor,'Bread4','color',[1 0 0])
text(scores(5,1)/scaling_factor,scores(5,2)/scaling_factor,scores(5,3)/scaling_factor,'Bread5','color',[1 0 0])
text(scores(6,1)/scaling_factor,scores(6,2)/scaling_factor,scores(6,3)/scaling_factor,'Bread6','color',[1 0 0])
text(scores(7,1)/scaling_factor,scores(7,2)/scaling_factor,scores(7,3)/scaling_factor,'Bread7','color',[1 0 0])
text(scores(8,1)/scaling_factor,scores(8,2)/scaling_factor,scores(8,3)/scaling_factor,'Bread8','color',[1 0 0])

if plot_bread_pictures
%% Place bread pictures in plot
imgscalefactor=0.1;
Opacy=0.9;
scaled_scores=scores./scaling_factor; %Scores scaled to biplot locations

img_b1 = imread('bread1.jpg');     % Load bread image
bread=1;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b1,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b1,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b1,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b2 = imread('bread2.jpg');     % Load bread image
bread=2;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
h=surf(xImage,yImage,zImage,'CData',img_b2,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b2,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b2,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b3 = imread('bread3.jpg');     % Load bread image
bread=3;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b3,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b3,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b3,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b4 = imread('bread4.jpg');     % Load bread image
bread=4;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b4,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b4,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b4,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b5 = imread('bread5.jpg');     % Load bread image
bread=5;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b5,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b5,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b5,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b6 = imread('bread6.jpg');     % Load bread image
bread=6;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b6,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b6,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b6,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b7 = imread('bread7.jpg');     % Load bread image
bread=7;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b7,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b7,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b7,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface

img_b8 = imread('bread8.jpg');     % Load bread image
bread=8;
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2) scaled_scores(bread,2); scaled_scores(bread,2) scaled_scores(bread,2)];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
hold on
surf(xImage,yImage,zImage,'CData',img_b8,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1) scaled_scores(bread,1); scaled_scores(bread,1) scaled_scores(bread,1)];   % The x data for the image corners
yImage = [scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)+imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3)+imgscalefactor scaled_scores(bread,3)+imgscalefactor; scaled_scores(bread,3)-imgscalefactor scaled_scores(bread,3)-imgscalefactor];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b8,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
xImage = [scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor; scaled_scores(bread,1)-imgscalefactor scaled_scores(bread,1)+imgscalefactor];   % The x data for the image corners
yImage = [scaled_scores(bread,2)+imgscalefactor scaled_scores(bread,2)+imgscalefactor; scaled_scores(bread,2)-imgscalefactor scaled_scores(bread,2)-imgscalefactor];             % The y data for the image corners
zImage = [scaled_scores(bread,3) scaled_scores(bread,3); scaled_scores(bread,3) scaled_scores(bread,3)];   % The z data for the image corners
surf(xImage,yImage,zImage,'CData',img_b8,'FaceColor','texturemap','EdgeColor','none','FaceAlpha',Opacy,'Clipping','off');   % Plot the surface
end

%Skorpe,Krumme,Overflade,Kerner,Tungt,Taet,Saftigt,Maettende,Naerende,Fuldkorn,Fiber
%Table of Principal component analysis and attribute loadings
disp('Principal component analysis')
disp('----------------------------      Loadings')
disp(sprintf('Attribute:                PC1(%.1f%%) PC2(%.1f%%) PC3(%.1f%%) ',percent_explained(1),percent_explained(2),percent_explained(3)))
disp(sprintf('Skorpe                      %.3f      %.3f      %.3f     ',coefs(1,1),coefs(1,2),coefs(1,3)))
disp(sprintf('Krumme                      %.3f      %.3f      %.3f     ',coefs(2,1),coefs(2,2),coefs(2,3)))
disp(sprintf('Overflade                   %.3f      %.3f      %.3f     ',coefs(3,1),coefs(3,2),coefs(3,3)))
disp(sprintf('Kerner                      %.3f      %.3f      %.3f     ',coefs(4,1),coefs(4,2),coefs(4,3)))
disp(sprintf('Tungt                       %.3f      %.3f      %.3f     ',coefs(5,1),coefs(5,2),coefs(5,3)))
disp(sprintf('Taet                        %.3f      %.3f      %.3f     ',coefs(6,1),coefs(6,2),coefs(6,3)))
disp(sprintf('Saftigt                     %.3f      %.3f      %.3f     ',coefs(7,1),coefs(7,2),coefs(7,3)))
disp(sprintf('Maettende                   %.3f      %.3f      %.3f     ',coefs(8,1),coefs(8,2),coefs(8,3)))
disp(sprintf('Naerende                    %.3f      %.3f      %.3f     ',coefs(9,1),coefs(9,2),coefs(9,3)))
disp(sprintf('Fuldkorn                    %.3f      %.3f      %.3f     ',coefs(10,1),coefs(10,2),coefs(10,3)))
disp(sprintf('Fiber                       %.3f      %.3f      %.3f     ',coefs(11,1),coefs(11,2),coefs(11,3)))

return

%rotate "factors/components"
[coefs_rotated,T] = rotatefactors(coefs(:,1:3));  %uses default VARIMAX. T contains the rotation matrix
%[coefs_rotated,T] = rotatefactors(coefs(:,1:3),'method','varimax','normalize','off'); %T contains the rotation matrix
%[coefs_rotated,T] = rotatefactors(coefs(:,1:3),'method','varimax','normalize','on');  %T contains the rotation matrix
%[coefs_rotated,T] = rotatefactors(coefs(:,1:3),'method','equamax','normalize','on');  %T contains the rotation matrix

scores_rotated=scores(:,1:3)*T;

%calculate variances of rotated scores
variances_rotated=var(scores_rotated,0,1);

%Calculate explained variances in percent from rotated
percent_explained_rotated = 100*variances_rotated/sum(variances);

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

%Plot solution with PC1 and PC2
figure;
plot(scores_rotated(:,1),scores_rotated(:,2),'+')
xlabel(['Principal Component 1 (Rotated) (' num2str(percent_explained_rotated(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (Rotated) (' num2str(percent_explained_rotated(2),'%.1f') '%)'])
grid on
text(scores_rotated(1,1),scores_rotated(1,2),'Bread1')
text(scores_rotated(2,1),scores_rotated(2,2),'Bread2')
text(scores_rotated(3,1),scores_rotated(3,2),'Bread3')
text(scores_rotated(4,1),scores_rotated(4,2),'Bread4')
text(scores_rotated(5,1),scores_rotated(5,2),'Bread5')
text(scores_rotated(6,1),scores_rotated(6,2),'Bread6')
text(scores_rotated(7,1),scores_rotated(7,2),'Bread7')
text(scores_rotated(8,1),scores_rotated(8,2),'Bread8')

%Table of Principal component analysis and attribute loadings
B=[coefs_rotated zeros(11,1)];%fill in zeros for PC4
%Skorpe,Krumme,Overflade,Kerner,Tungt,Taet,Saftigt,Maettende,Naerende,Fuldkorn,Fiber
disp('Principal component analysis - (rotated VARIMAX)')
disp('----------------------------      Loadings')
disp(sprintf('Attribute:                PC1(%.1f%%) PC2(%.1f%%) PC3(%.1f%%)',percent_explained_rotated(1),percent_explained_rotated(2),percent_explained_rotated(3)))
disp(sprintf('Skorpe                      %.3f      %.3f      %.3f     ',B(1,1),B(1,2),B(1,3)))
disp(sprintf('Krumme                      %.3f      %.3f      %.3f     ',B(2,1),B(2,2),B(2,3)))
disp(sprintf('Overflade                   %.3f      %.3f      %.3f     ',B(3,1),B(3,2),B(3,3)))
disp(sprintf('Kerner                      %.3f      %.3f      %.3f     ',B(4,1),B(4,2),B(4,3)))
disp(sprintf('Tungt                       %.3f      %.3f      %.3f     ',B(5,1),B(5,2),B(5,3)))
disp(sprintf('Taet                        %.3f      %.3f      %.3f     ',B(6,1),B(6,2),B(6,3)))
disp(sprintf('Saftigt                     %.3f      %.3f      %.3f     ',B(7,1),B(7,2),B(7,3)))
disp(sprintf('Maettende                   %.3f      %.3f      %.3f     ',B(8,1),B(8,2),B(8,3)))
disp(sprintf('Naerende                    %.3f      %.3f      %.3f     ',B(9,1),B(9,2),B(9,3)))
disp(sprintf('Fuldkorn                    %.3f      %.3f      %.3f     ',B(10,1),B(10,2),B(10,3)))
disp(sprintf('Fiber                       %.3f      %.3f      %.3f     ',B(11,1),B(11,2),B(11,3)))

%twodimensional biplot

figure

%varlbs = {'Att. A','Att. B','Att. C','Att. D','Att. E','Att. F','Att. G','Att. H'};
%obslbs = {'Stimulus 1','Stimulus 2','Stimulus 3','Stimulus 4'};
biplot(coefs_rotated(:,1:2),'scores',scores_rotated(:,1:2),'varlabels',varlbs,'obslabels',obslbs);
xlabel(['Principal Component 1 (Rotated) (' num2str(percent_explained_rotated(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (Rotated) (' num2str(percent_explained_rotated(2),'%.1f') '%)'])
zlabel(['Principal Component 3 (Rotated) (' num2str(percent_explained_rotated(3),'%.1f') '%)'])

axis([-1 1 -1 1])
scaling_factor=108.7/0.43819;
text(scores_rotated(1,1)/scaling_factor,-scores_rotated(1,2)/scaling_factor,'Bread1','color',[1 0 0])
text(scores_rotated(2,1)/scaling_factor,-scores_rotated(2,2)/scaling_factor,'Bread2','color',[1 0 0])
text(scores_rotated(3,1)/scaling_factor,-scores_rotated(3,2)/scaling_factor,'Bread3','color',[1 0 0])
text(scores_rotated(4,1)/scaling_factor,-scores_rotated(4,2)/scaling_factor,'Bread4','color',[1 0 0])
text(scores_rotated(5,1)/scaling_factor,-scores_rotated(5,2)/scaling_factor,'Bread5','color',[1 0 0])
text(scores_rotated(6,1)/scaling_factor,-scores_rotated(6,2)/scaling_factor,'Bread6','color',[1 0 0])
text(scores_rotated(7,1)/scaling_factor,-scores_rotated(7,2)/scaling_factor,'Bread7','color',[1 0 0])
text(scores_rotated(8,1)/scaling_factor,-scores_rotated(8,2)/scaling_factor,'Bread8','color',[1 0 0])

%Threedimensional biplot
figure

biplot(coefs_rotated,'scores',scores_rotated,'varlabels',varlbs,'obslabels',obslbs);

xlabel(['Principal Component 1 (rotated) (' num2str(percent_explained_rotated(1),'%.1f') '%)'])
ylabel(['Principal Component 2 (rotated) (' num2str(percent_explained_rotated(2),'%.1f') '%)'])
zlabel(['Principal Component 3 (rotated) (' num2str(percent_explained_rotated(3),'%.1f') '%)'])
axis([-1 1 -1 1 -1 1])

scaling_factor=108.7/0.57016;
text(scores_rotated(1,1)/scaling_factor,-scores_rotated(1,2)/scaling_factor,scores_rotated(1,3)/scaling_factor,'Bread1','color',[1 0 0])
text(scores_rotated(2,1)/scaling_factor,-scores_rotated(2,2)/scaling_factor,scores_rotated(2,3)/scaling_factor,'Bread2','color',[1 0 0])
text(scores_rotated(3,1)/scaling_factor,-scores_rotated(3,2)/scaling_factor,scores_rotated(3,3)/scaling_factor,'Bread3','color',[1 0 0])
text(scores_rotated(4,1)/scaling_factor,-scores_rotated(4,2)/scaling_factor,scores_rotated(4,3)/scaling_factor,'Bread4','color',[1 0 0])
text(scores_rotated(5,1)/scaling_factor,-scores_rotated(5,2)/scaling_factor,scores_rotated(5,3)/scaling_factor,'Bread5','color',[1 0 0])
text(scores_rotated(6,1)/scaling_factor,-scores_rotated(6,2)/scaling_factor,scores_rotated(6,3)/scaling_factor,'Bread6','color',[1 0 0])
text(scores_rotated(7,1)/scaling_factor,-scores_rotated(7,2)/scaling_factor,scores_rotated(7,3)/scaling_factor,'Bread7','color',[1 0 0])
text(scores_rotated(8,1)/scaling_factor,-scores_rotated(8,2)/scaling_factor,scores_rotated(8,3)/scaling_factor,'Bread8','color',[1 0 0])