% There is not a lot of documentation in this code... sorry. 
% But its just some basic multidimensional scaling functions and som plot parameters
clear
clc

T = readtable("16Beers.xlsx");
Beernames=table2array(T(1:end,1));

T=T(1:end,2:end)
T = table2array(T)

%% Create a scree plot
A = [0 0 0 0 0 0];
for c = 1:6
    [Y1,stress1,eigvals1] = mdscale(T,c);
    A(c)=stress1;
end
fprintf('Stress for Test1: %.4f\n',A);
figure;
hold on

plot(A,'DisplayName','Collected Data')
xlabel('Dimensions')
ylabel('Stress')
title('Scree Plot')
set(gca, 'xtick', 0:1:10);
set(gca, 'ytick', 0:0.01:10);
lgd = legend;
hold off

%% - Multidimensional scaling plot

[Y1,stress1,eigvals1] = mdscale(T,3);
figure;
plot3(Y1(:,1),Y1(:,2),Y1(:,3),'o');
hold on
for i=1:length(Y1)
    top = [Y1(i,1) Y1(i,2) Y1(i,3)];
    bottom = [Y1(i,1) Y1(i,2) -15];
    together = [top ; bottom];
    plot3(together(:,1),together(:,2),together(:,3),'--oblack')
end
title("Multidimensional scaling of napping results");
text(Y1(:,1)+1,Y1(:,2),Y1(:,3),Beernames)
xlabel('Fruityness (Frugtighed) -->') %Dim1
ylabel('<-- Power (Kraftighed)') %Dim2
zlabel('Color (Farve)-->') %Dim3
grid on
axis([-30 30 -25 25 -15 20]);

% Run a loop for a while
for ii = 1:5000
   
    % Draw our plots
    drawnow;
    view(gca,[ii, 35]);

    
end
hold off



%% Shepards plot for testing if the model is off from the original data

Test1_vector=squareform(T);
% Calculate pairwise distances from original data

% and make a Shepard plot of the results.
[Y,stress,disparities] = mdscale(Test1_vector,3);
distances = pdist(Y);
[dum,ord] = sortrows([disparities(:) Test1_vector(:)]);
figure;
plot(Test1_vector,distances,'bo', ...
Test1_vector(ord),disparities(ord),'r.-');
xlabel('Dissimilarities'); ylabel('Distances/Disparities')
legend({'Distances' 'Disparities'},'Location','NW');

