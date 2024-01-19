figure;
varlbs = AttributeNames;
obslbs = BeerNames;
ThreedimPlotRotated = biplot(coefs_rotated(:,1:3),'scores',scores_rotated(:,1:3),'varlabels',varlbs,'obslabels',obslbs,'LineWidth',0.2);
xlabel(['Principal Component 1 (' num2str(percent_explained_rotated(1),'%.1f') '%)']);
ylabel(['Principal Component 2 (' num2str(percent_explained_rotated(2),'%.1f') '%)']);
zlabel(['Principal Component 3 (' num2str(percent_explained_rotated(3),'%.1f') '%)'])
axis([-0.5 0.5 -0.5 0.5]);

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


% Run a loop for a while
for ii = 1:800
   
    % Draw our plots
    drawnow;
    view(gca,[ii/2, 30]);

    
end
hold off
